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

## 2026-11-12 — Hugo and Blowfish move together; Hugo stays inside the theme's range

**Decision:** Blowfish v2.89.0 → v3.9.0, Hugo 0.148.2 → 0.167.0. CI's `HUGO_VERSION` stays within the theme's `module.hugoVersion` range (v3.9.0: 0.164.0–0.167.0), even though newer Hugo exists (0.169.0).

**Why:** Blowfish v3 tracks a rolling window of the latest four Hugo versions. Running above the max produces a "not compatible" warning, and the theme is untested there. v3.10.0 was skipped because it was one day old (two-week rule). The v2 → v3 upgrade is opt-in for new features; the one regression found (header sizes from `custom.css`) was fixed in the same change.

## 2026-11-12 — CI supply-chain hardening

**Decision:** Actions are pinned to commit SHAs with the release tag in a trailing comment. The Hugo `.deb` is verified against the release's published SHA-256 checksums before `dpkg -i`. The Dart Sass install and the npm install steps were removed.

**Why:** tags are mutable, so a SHA pin means an upstream retag can't change what runs. The checksum check means a tampered or corrupted download fails the build instead of shipping. Dart Sass and npm were boilerplate from Hugo's sample workflow: nothing in this repo or the theme compiles SCSS, and there is no `package-lock.json`. Removing them takes out two unpinned downloads.

## 2026-11-12 — Dependabot for GitHub Actions only; Hugo/Blowfish stay manual

**Decision:** `.github/dependabot.yml` covers the `github-actions` ecosystem only: monthly, grouped into one PR, with a `cooldown` of `default-days: 14`. Hugo and the Blowfish submodule are bumped by hand, together, following `docs/RUNBOOK.md`. Renovate was not adopted. The untracked `scripts/update-gh-actions-versions.sh` was retired.

**Why:** the Actions are the one part automation handles well. They're SHA-pinned, they run with Pages deploy permissions, and they drift unnoticed. Hugo and Blowfish are the opposite: CI's Hugo version must stay inside the theme's supported range, Dependabot can't update the `HUGO_VERSION` env var, it would bump the submodule to a branch commit rather than a release tag, and theme bumps need a visual check (the v2 → v3 header regression would have passed an automated PR). Renovate could regex-manage `HUGO_VERSION`, but installing an app and maintaining extra config isn't worth it for five dependencies. The retired script resolved the newest Hugo release, which broke both the two-week age rule and the theme range.

