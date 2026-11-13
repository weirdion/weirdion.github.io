# Session log

Live state, newest first. Read the top entry first and write it last. If a later session proves an entry wrong, mark it superseded instead of deleting it.

---

## 2026-11-12 — #37 shipped; Dependabot for Actions; X cards investigated

- #37 merged and deployed. The new home description was verified on live weirdion.com.
- Branch `dependabot-actions`: `.github/dependabot.yml` (Actions only, monthly, grouped, 14-day cooldown). The repo already has Dependabot alerts and security updates enabled. `scripts/update-gh-actions-versions.sh` retired (it was never tracked; moved out of the repo to a session scratch backup). Decision recorded.
- X/Twitter: the operator wants no X support. Share buttons and links already exclude it; the remaining `twitter:*` meta tags can't be disabled by config or a small override (tested; details in backlog.md). Waiting on the operator's choice between overriding all of `head.html` and stripping after the build.

**Next:** merge the Dependabot PR; confirm its first PR updates SHA pins and version comments correctly; then the X decision.

