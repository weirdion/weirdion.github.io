# Session log

Live state, newest first. Read the top entry first and write it last. If a later session proves an entry wrong, mark it superseded instead of deleting it.

---

## 2026-11-12 — Adopted agent-steer

**Done:**
- `.agents/prompt.md` is now the boot doc (steer pointer, read order, index, local rules). The old content moved to `.agents/writing-style.md`, which now also holds the SEO and formatting rules from `.template/context.md`. The agent-conduct bits the steer already covers were removed.
- New: `decisions.md` (seeded only with decisions whose reasons are known), `backlog.md` (maintenance items found during assessment, plus the Substack embed and dependency automation), this log, and a root `CLAUDE.md` pointer.
- Post scaffold moved to `archetypes/posts.md`. Verified that `hugo new content posts/2099-01-01-archetype-smoke-test/index.md` gives the right title, date and `draft = true`; the test bundle was then deleted. `.template/` was removed (it was never tracked).
- Site build checked with local Hugo 0.169.0: 332 pages, no errors. Theme-compat and deprecation warnings are still there and tracked in the backlog.

- Compared against the old machine-local blogging desk (`.agent-blog`, now retired). Pulled in the parts that belong to this repo:
  - into `writing-style.md`: dead-ends-are-the-value (from PR #34, since closed), the featured-image-embed convention (checked: 13 of 14 posts), the anchor and non-prescriptive rules for opinion posts, and the drafting workflow;
  - into `prompt.md`: the PR-flow / no-history-rewrite rule (the #33 scar);
  - in `archetypes/posts.md`: the image embed moved to the top.
- Corrected an earlier backlog entry: the "inconsistent feature image naming" isn't a bug. Blowfish matches `*feature*` filenames and ignores the `feature =` key.

- Closed PR #34 as superseded: its writing-guide content was already folded in, and its `.gitignore` change (ignore `.idea/` and `.vscode/settings.json`) is applied here.
- Moved the Substack/Medium playbook from the desk into `.agents/syndication.md` (conditional read when cross-posting), leaving out another project's specifics.
- Retired the desk: the alembix series plan moved to `backlog.md`, and the build-repo kinds and log-dead-ends-where-you-build rules moved to `writing-style.md`. The operator is deleting or trimming the desk; the alembix naming decision belongs in that repo's own decisions log.
- Added the public-repo review rule to `prompt.md`, then applied it to this change: home-relative paths were removed, and an unneeded operator detail came out of decisions.md.

**State:** committed on branch `agent-steer-adoption`; PR open.

**Next:** merge the PR. Then work through the backlog, starting with the Hugo + Blowfish bump.
