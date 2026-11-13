# Decisions

Settled choices for this repo, with date and why. Append-only: a decision stands until a later dated entry revisits it. Only decisions whose reason is actually known are recorded. Older choices visible in git history but without a recorded why (Jekyll → Hugo migration, pinning Blowfish at v2.89.0, `layout = "simple"`) are left out rather than guessed at.

---

## 2026-11-12 — Adopt agent-steer; one agent context

**Decision:** The repo boots from `.agents/prompt.md`, which points at agent-steer and then lists only local files. One agent context covers both site maintenance and writing; the writing style guide is a conditional read rather than a separate track. `CLAUDE.md` is a thin pointer to the boot doc.

**Why:** small, tightly-coupled repo. Splitting engineering and writing into separate tracks would be ceremony with no payoff. Existing docs (`README.md`, `docs/RUNBOOK.md`) already cover how the site is built, so the boot points at them instead of copying them.

## 2026-11-12 — Backlog in-repo, not GitHub issues

**Decision:** Deferred work is tracked in `.agents/backlog.md`. Historical GitHub issues (#2–#28, all closed) stay as they are.

**Why:** the operator wants the backlog tracked in-repo, next to the work and the decisions it relates to.

## 2026-11-12 — Post scaffold is a Hugo archetype; `.template/` retired

**Decision:** The post scaffold lives at `archetypes/posts.md` (used automatically by `hugo new content posts/...`). The SEO and formatting guidance from `.template/context.md` was merged into `.agents/writing-style.md`. `.template/` was removed.

**Why:** `.template/context.md` duplicated `writing-style.md` (two homes for the same facts drift apart), and `.template/post.md` was never tracked and had become corrupted. Archetypes are Hugo's native home for scaffolds.

## 2025-08-15 (recorded 2026-11-12) — No on-site email subscribe form

**Decision:** The EmailOctopus subscribe form (#27, PR #30) was reverted (PR #31). Email subscriptions go through the Substack at weirdion.substack.com instead.

**Why:** a second newsletter channel on the site duplicated Substack. Embedding Substack natively is a separate idea, parked in `backlog.md`.

## Dependabot revert — not a decision

Dependabot was added and then reverted ("Revert 'Add dependabot'"). It was **not** a deliberate rejection: it was missed at the wrong time and never revisited. Re-adding dependency automation is in `backlog.md`.
