# weirdion.github.io — agent boot

Personal blog ("The Tinkering Mind") at https://weirdion.com. Hugo + Blowfish theme (git submodule), deployed to GitHub Pages by GitHub Actions on push to `main`.

**This repo is public.** Every commit, including `.agents/`, commit messages, PR bodies, and draft posts pushed on a branch, is world-readable. See the public-repo rule under Local rules.

## Read first

0. **STEER** — read `agent-steer/INDEX.md` (a sibling checkout at `../agent-steer`, or public at https://github.com/weirdion/agent-steer), load the spine, pull ways-of-working / preferences on relevance. The files below state only what is local to this repo.
1. **[session-log.md](session-log.md)** — read the top entry: where things stand and the next step.
2. **[decisions.md](decisions.md)** — settled choices; don't re-litigate.
3. **[backlog.md](backlog.md)** — deferred work; check before scoping anything new.
4. **How it's built** — [`README.md`](../README.md) (overview, quick start) and [`docs/RUNBOOK.md`](../docs/RUNBOOK.md) (structure, config, CI/CD, troubleshooting). Pull the runbook when the task touches config, theme, or CI.
5. **Conditional: [writing-style.md](writing-style.md)** — only when the task touches `content/` (drafting, editing, or reviewing posts).
6. **Conditional: [syndication.md](syndication.md)** — only when cross-posting a published post to Substack or Medium.

## Index

| File | Purpose | When |
|---|---|---|
| [prompt.md](prompt.md) | Boot sequence (this file) | Always |
| [session-log.md](session-log.md) | Live state, newest first | Always (top entry) |
| [decisions.md](decisions.md) | Decisions with date and why; append-only | Always |
| [backlog.md](backlog.md) | Deferred work, each with why parked and what pulls it forward | Always |
| [writing-style.md](writing-style.md) | Voice, post structure, frontmatter, SEO | Task touches `content/` |
| [syndication.md](syndication.md) | Cross-posting to Substack and Medium | Cross-posting a published post |
| [`docs/RUNBOOK.md`](../docs/RUNBOOK.md) | Build, config, theme, CI/CD | Task touches config, theme, or CI |

## Local rules

- LOCAL: **public-repo review before every commit.** Read the staged diff (`git diff --cached`) *and* the commit message as a stranger would, and remove:
  - secrets, tokens, and keys (including in config and screenshots);
  - absolute machine paths and usernames;
  - names or details of private projects, employers' internal systems, or other people;
  - operator identity detail beyond what the published posts already say.

  Agent docs carry how-to-operate, agreements, and context, not who the operator is. Drafts are public the moment they're pushed, even with `draft = true`. — why: everything in git history stays public even after a later delete, so the only reliable fix is not committing it.

- LOCAL: verify with a real build — `hugo --gc --destination <scratch dir>` — before calling a site change done, and read the warnings, not just the exit code. CI pins its own Hugo version in `.github/workflows/deploy-gh-pages.yml`, which may differ from local; a local pass on a different version is not proof CI passes. — why: Hugo deprecations and theme-compat warnings show up as WARN lines on an otherwise green build.
- LOCAL: ship through a branch → PR → merge. A push to `main` deploys to the live site. Never amend, rebase, or force-push a commit that's already pushed; fix forward with a new commit. — why: an early `git commit --amend` on the agent-steer post rewrote an already-public commit; the correct fix was a new PR on top (#33).
- LOCAL: the backlog lives in [backlog.md](backlog.md), not GitHub issues. — why: tracked in-repo alongside the work (see decisions.md, 2026-11-12).
- LOCAL: post scaffolds come from the Hugo archetype at [`archetypes/posts.md`](../archetypes/posts.md), not a separate template dir. — why: one home per fact; `hugo new` already knows where to look.

## Session end

Add one entry to the top of [session-log.md](session-log.md): what changed, where it stands, the next step. Deferrals go into [backlog.md](backlog.md) when they happen, and decisions into [decisions.md](decisions.md).
