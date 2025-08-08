+++
title = "When Git Branches Diverge: A Troubleshooting Tale"
description = "How to troubleshoot, resolve and avoid Git branch divergences effectively."
date = 2025-01-03
categories = ["Git", "Git Branch", "Divergence", "Github", "Software Development"]
tags = ["git", "git-branch", "git-divergence", "github", "software-development"]
draft = false
+++

![AI generated image of a developer looking for clues in a (git) tree of
branches](featured.jpg)

While working on a project, one morning we came across a fun problem — the
`develop` branch had diverged. There was no local changes or commits, the last
command run was simply `git pull origin develop`, with a clean pull. So what
happened?

# The Investigation

Let’s break down what we saw:

```
$ git pull

You have divergent branches and need to specify how to reconcile them.
You can do so by running one of the following commands sometime before
your next pull:

  git config pull.rebase false  # merge
  git config pull.rebase true   # rebase
  git config pull.ff only       # fast-forward only

You can replace "git config" with "git config --global" to set a default
preference for all repositories. You can also pass --rebase, --no-rebase,
or --ff-only on the command line to override the configured default per
invocation.
fatal: Need to specify how to reconcile divergent branches.
```

Uh-oh, that looks bad. What does git status say,

```
$ git status

On branch develop
Your branch and 'origin/develop' have diverged,
and have 1 and 3 different commits each, respectively.
nothing to commit, working tree clean

```
Interesting, right? We had a clean working tree, yet Git is telling us our
branches diverged.

# Common Scenarios Where Divergence Happens

  * Someone pushed new commits to `origin/develop`

```
commit1 - commit2 - commit3 - commit4
          ^                   ^
          LOCAL               REMOTE
```
* We had local commits that weren’t pushed

```
commit1 - commit2 - commit3 - commit4
          ^                   ^
          LOCAL               REMOTE
          |
          --- localCommit1
              ^
              HEAD
```
* When we ran `git pull`, git automatically performed a merge

```
commit1 - commit2 - commit3 - commit4
          |                     |
          |                     |
          |                     |
          --- localCommit1   -  mergeCommit
              ^                 ^
              LOCAL             HEAD
```
* The rare stuff of nightmares — someone used force push to re-write history. Kids, do not do this at home.

```
commit1 - commit2 - commit3 - commit4
          ^                   ^
            LOCAL              REMOTE

commit1 - commit2 - commit3   ~~commit4~~
          ^         ^
            LOCAL    REMOTE
```
# How To Handle Divergences

The tricky thing in these scenarios is that there is no solution that fits
all, it depends.

## Option 1: The Careful Approach

Instead of git pull, be explicit. Fetch changes and rebase your local changes
on top.

 **NOTE** : Rebase is re-writing history. So pushing this up, requires `git
push --force`

```
git fetch origin develop
git rebase origin/develop

# If you hit conflicts
git status  # Check which files are conflicting
# Fix conflicts
git add .
git rebase --continue
```
## Option 2: The Pull With Rebase Approach

This is very similar to Option 1, this approach will try to rebase your local
changes on top of upstream, but with less granular control.

```
git pull --rebase origin develop

# If you hit conflicts
git status  # Check which files are conflicting
# Fix conflicts
git add .
git rebase --continue
```
## Option 3: The Merge Approach

This approach merges the upstream code with your local, making a new merge
commit.

```
git fetch origin develop
git merge origin/develop

# Or if you're sure about the merge
git pull --no-ff origin develop

```
## Option 4: The “I’m Sure Remote is Right” Approach

This approach basically kills any unsaved or local changes, assuming remote is
right. **Save any local work in a stash before doing this.**

```
git fetch origin
git reset --hard origin/develop
```
# What Actually Happened In Our Case

Original state

```
commit1 - commit2 - commit3 - badCommit
          ^                   ^
          LOCAL               REMOTE
```
Developer force-pushed to remove `badCommit`

```
commit1 - commit2 - commit3
          ^         ^
          LOCAL     REMOTE
```
Your local still has the old history, causing divergence

```
commit1 - commit2 - commit3 - badCommit
          ^         ^
          LOCAL     REMOTE
```
This is a particularly problematic scenario because:

  * It breaks the golden rule of Git: never rewrite public history
  * Other developers who pulled the bad commit will have diverged branches
  * It can cause confusion and inconsistencies across the team
  * Recovery can be complex if others based work on the removed commit

In our case, we used “Option 4”, to reset local to the current upstream remote
state, knowing that we did not have any local changes to save.

```
git fetch origin
git reset --hard origin/develop
```
If you do have local changes to save, either use a local branch or save them
to the stash.

 **Best practices to prevent this** :

  * Never force push to shared branches
  * Use`--force-with-lease` if force push is absolutely necessary
  * Use `git revert` to undo changes while preserving history
  * Establish team protocols for handling bad commits (prefer `git revert`)
  * Shared branches like `main` and `devlop` should be protected to prevent force pushes.

# The Takeaway

Git branch divergence isn’t scary — it’s a normal part of collaborative
development. The key is understanding why it happens and having the right
tools to handle it. Whether you choose to merge or rebase depends on your
team’s workflow and the specific situation.

Remember: Git is tracking history, not just code. Sometimes what looks like a
problem is just Git doing its job of maintaining a clear picture of how your
code evolved, that includes less than ideal commits that break things.

Next time you see that “branches have diverged” message, hopefully you’ll know
exactly what’s going on and how to handle it. Happy coding! 🎉

<hr>

 _I’m trying to get better about writing about things I do. Let me know if you
found this useful_ 🙂 _._

 _Connect with me on_ [_LinkedIn_](https://www.linkedin.com/in/ankitpatterson/) _._
