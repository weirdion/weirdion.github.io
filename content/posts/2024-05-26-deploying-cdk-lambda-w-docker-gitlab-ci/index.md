+++
title = "Deploying CDK Lambda with Docker and Gitlab CI"
description = "A guide on deploying AWS CDK Lambda functions using Docker and GitLab CI."
date = 2024-05-26
categories = ["AWS", "AWS CDK", "Lambda", "Docker", "GitLab CI"]
tags = ["aws", "cdk", "lambda", "docker", "gitlab-ci"]
layout = "simple"
draft = false
+++

![Image showing Gitlab Docker and Lambda icons](featured.jpg)

**Disclaimer:** _This is not meant to be start from basics tutorial. The
following assumes that you are familiar with CDK and Gitlab-CI concepts.
Consider this Level 200 in AWS guidance terms._

# The Why 🤔

Deploying AWS Lambda with [CDK](https://docs.aws.amazon.com/cdk/v2/guide/home.html) is pretty
straightforward and uses zip files, not Docker for simple code base. However,
as soon as you get past the basic handler use-case, like setting up
[poetry](https://python-poetry.org/) for your Python dependencies, you have to
switch from using
[aws_lambda](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_lambda-readme.html)
to using language specific module like [aws-
lambda-python](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-lambda-python-alpha-readme.html),
which rely on Docker packaging to deploy the Lambda.

Now this is all great, and works for local dev environments but a lot of CI
platforms like [Gitlab CI](https://docs.gitlab.com/ee/ci/) runs the jobs in a
docker container. So now what? We build docker image inside a docker container? Yes!
This feature is called [Docker-in-Docker](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html),
which allows us to use a base image with the right dependencies to build a docker image.

# The How 🏗

Talk is cheap, show me the code!

{{< subscribe >}}

# Basic Lambda (non-Docker)

OK, enough background, let’s get started with a basic Python Lambda with CDK
and `gitlab-ci.yml`.

CDK stack

```
import * as cdk from 'aws-cdk-lib';
import { AssetCode, Function, Runtime } from 'aws-cdk-lib/aws-lambda';
import { Construct } from 'constructs';

export class CdkPythonLambdaExampleStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    const testingLambda = new Function(this, 'TestLambda', {
      functionName: 'TestLambda',
      runtime: Runtime.PYTHON_3_11,
      code: new AssetCode('resources/lambdas/testing-lambda'),
      handler: 'index.handler',
      environment: {
        "LOG_LEVEL": "INFO"
      }
    });
  }
}
```
Python Lambda

```
import logging
import os

logger = logging.getLogger("MyTestLambda")
logger.setLevel(os.getenv("LOG_LEVEL", "INFO"))
def handler(event, context):
    logging.info(f"Starting lambda with event: {event}")
    return {
        "result": "Yay, we deployed a lambda!"
    }
```
.gitlab-ci.yml

```
---
variables:
  BUILD_IMAGE: node:lts-alpine
stages:
  - aws-cdk-diff
  - aws-cdk-deploy
.setup:
  script:
    - node --version  # Print out nodejs version for debugging
    - apk add --no-cache aws-cli  # install aws-cli
    - npm install -g aws-cdk  # install aws-cdk
    - npm install  # install project dependencies
.assume:
  # Use the web-identity to fetch temporary credentials
  script:
    - >
      export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s"
      $(aws sts assume-role-with-web-identity
      --role-arn ${AWS_ROLE_ARN}
      --role-session-name "GitLabRunner-${CI_PROJECT_ID}-${CI_PIPELINE_ID}"
      --web-identity-token $CI_JOB_JWT_V2
      --duration-seconds 900
      --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]'
      --output text))
aws-cdk-diff:
  image: $BUILD_IMAGE
  stage: aws-cdk-diff
  script:
    - !reference [.setup, script]
    - !reference [.assume, script]
    - cdk diff
aws-cdk-deploy:
  image: $BUILD_IMAGE
  stage: aws-cdk-deploy
  script:
    - !reference [.setup, script]
    - !reference [.assume, script]
    - cdk bootstrap
    - cdk deploy --require-approval never

```
Most of this is pretty standard but let me highlight the AWS credential bit.
It’s bad practice to use long-lived credentials anywhere, so we are using
OpenID Connect to retrieve temporary AWS credentials — see [Gitlab Docs](https://docs.gitlab.com/ee/ci/cloud_services/aws/).

```
.assume:
  # Use the web-identity to fetch temporary credentials
  script:
    - >
      export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s"
      $(aws sts assume-role-with-web-identity
      --role-arn ${AWS_ROLE_ARN}
      --role-session-name "GitLabRunner-${CI_PROJECT_ID}-${CI_PIPELINE_ID}"
      --web-identity-token $CI_JOB_JWT_V2
      --duration-seconds 900
      --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]'
      --output text))
```
The gitlab runner assumes `AWS_ROLE_ARN` (stored in Variables) to retrieve the
credentials and export them as variables.

For full code for basic Lambda deployment: [cdk-python-lambda-example/-/tree/basic-lambda](https://gitlab.com/weirdion/cdk-python-lambda-example/-/tree/basic-lambda).

# Docker Lambda

Let’s make the required changes, start with adding poetry…

```
├── index.py
├── poetry.lock
└── pyproject.toml

```
We are going to add [aws-lambda-powertools](https://awslabs.github.io/aws-lambda-powertools-python/)
as poetry dependency we need. While this is available as Lambda Layer, we are going to use it as a installed dependency
for this exercise.

```
[tool.poetry.dependencies]
python = "^3.11"
aws-lambda-powertools = "^2.14.1"

```
Now let’s update the CDK to handle poetry.

```
import { PythonFunction } from '@aws-cdk/aws-lambda-python-alpha';
import * as cdk from 'aws-cdk-lib';
import { Runtime } from 'aws-cdk-lib/aws-lambda';
import { Construct } from 'constructs';

export class CdkPythonLambdaExampleStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    const testingLambda = new PythonFunction(this, 'TestLambda', {
      functionName: 'TestLambda',
      runtime: Runtime.PYTHON_3_9,
      entry: 'resources/lambdas/testing-lambda',
      index: 'index.py',
      handler: 'handler',
      environment: {
        LOG_LEVEL: 'INFO',
        POWERTOOLS_SERVICE_NAME: 'TestLambda',
      }
    });
  }
}

```
If you push this as is, without changing the `.gitlab-ci.yml`, the runner will
exit with the following error -

```
Error: spawnSync docker ENOENT
  ... {
  errno: -2,
  code: 'ENOENT',
  syscall: 'spawnSync docker',
  path: 'docker',
  spawnargs: [
    'build',
    '-t',
    'cdk-1234567890',
    '--platform',
    'linux/amd64',
    '--build-arg',
    'IMAGE=public.ecr.aws/sam/build-python3.10',
    '/builds/user/cdk-python-lambda-example/node_modules/@aws-cdk/aws-lambda-python-alpha/lib'
  ]
}
Subprocess exited with error 1

```
Now, let’s plug in the right parts to support building docker images.

```
---
image: docker:dind

services:
  - docker:dind
stages:
  - aws-cdk-diff
  - aws-cdk-deploy
cache:
  # Caching 'node_modules' directory based on package-lock.json
  key:
    files:
      - package-lock.json
  paths:
    - node_modules/
.setup:
  script:
    - apk add --no-cache aws-cli nodejs npm
    - node --version  # Print version for debugging
    - npm install -g aws-cdk
    - npm install  # install project dependencies
.assume:
  # Use the web-identity to fetch temporary credentials
  script:
    - >
      export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s"
      $(aws sts assume-role-with-web-identity
      --role-arn ${AWS_ROLE_ARN}
      --role-session-name "GitLabRunner-${CI_PROJECT_ID}-${CI_PIPELINE_ID}"
      --web-identity-token $CI_JOB_JWT_V2
      --duration-seconds 900
      --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]'
      --output text))
aws-cdk-diff:
  stage: aws-cdk-diff
  script:
    - !reference [.setup, script]
    - !reference [.assume, script]
    - cdk diff
aws-cdk-deploy:
  stage: aws-cdk-deploy
  script:
    - !reference [.setup, script]
    - !reference [.assume, script]
    - cdk bootstrap
    - cdk deploy --require-approval never
```
Here, the image `docker:dind` points to the docker image that is created
specifically for Docker-in-Docker purpose.
The [services](https://docs.gitlab.com/ee/ci/services/) \- `docker:dind` part
links the `dind` service to all the jobs in the yaml and enables CDK to build
our Lambda image.

```
✅  CdkPythonLambdaExampleStack
✨  Deployment time: 34.83s
```
This works!
Full code for this working example can be found here —
[cdk-python-lambda-example](https://gitlab.com/weirdion/cdk-python-lambda-example/-/tree/main).

# Future Improvements ⏩

Since we are using a base docker images, our setup script is still a bit big.
One of the improvements here could be to pull the base image into it’s own
Dockerfile that extends with our dependencies pre-packaged.

A downside of this setup is a known issue of using Docker-in-Docker is there’s
no caching since each environment is new —
[reference](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html#known-issues-with-docker-in-docker).
This makes the CDK diff and deploy re-create
all docker layers on each execution, increasing our build times.
If we can leverage `--cache-from` build argument in CDK image building, we can
reduce those times down.

{{< subscribe >}}
