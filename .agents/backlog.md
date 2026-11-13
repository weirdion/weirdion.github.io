# Backlog

Deferred work. Each entry: what it is, why it's parked, and what pulls it forward. If it isn't here and isn't in flight, it doesn't exist. Delete an entry when it closes. Its record is the commit and the session log.

---

## Fix or drop `scripts/update-gh-actions-versions.sh`

**What:** untracked script that resolves the *newest* Hugo release (and Dart Sass, which CI no longer uses) and writes it into the workflow. That breaks two rules: the two-week dependency age, and keeping Hugo inside the theme's `module.hugoVersion` range (newest Hugo is often above the theme's max). The name is also misleading. Either rewrite it to pick the newest Hugo release that is at least two weeks old *and* within the theme's range, or delete it in favor of dependency automation (below).
**Why parked:** depends on the dependency-automation choice.
**Pull forward:** with the dependency automation item.

## Dependency automation (Dependabot or Renovate)

**What:** re-add automated update PRs for GitHub Actions (now pinned to commit SHAs with a version comment; Dependabot and Renovate both update that format) and possibly the theme submodule. Configure a minimum-age cooldown so it respects the two-week rule. Theme bumps still need the manual header/post/mobile comparison (see `docs/RUNBOOK.md`), so automation should open PRs, not auto-merge.
**Why parked:** the earlier Dependabot was reverted by accident, not on purpose (see decisions.md). It was never revisited.
**Pull forward:** with the script decision above.

## Clean up Jekyll-era leftovers

**What:** `.gitignore` is still Jekyll/Ruby/RubyMotion boilerplate; replace it with a Hugo-focused one (keep `/public/`, `/resources/`, `.DS_Store`, `.hugo_build.lock`; decide on `.idea/` and `.vscode/`). Remove the stale local dirs `_site/` and `.bundle/`, plus the empty `weirdion/assets/` and `data/`.
**Why parked:** cosmetic; needs a pass to confirm nothing still reads them.
**Pull forward:** any maintenance session.

## Fix garbled line in `docs/RUNBOOK.md`

**What:** the repo-structure bullet is cut off at "CI (GitHu", and "b Pages deploy)" ended up after the Troubleshooting section.
**Why parked:** found during adoption; out of scope for that change.
**Pull forward:** next edit to the runbook.

## Leftover `subscribe.html`

**What:** untracked `layouts/partials/subscribe.html`, the EmailOctopus form left over from the reverted #27. Delete it unless the Substack embed reuses the slot. (`.idea/` and `.vscode/settings.json` are now gitignored.)
**Why parked:** waiting on the Substack embed decision.
**Pull forward:** with the Substack embed item below.

## Embed Substack subscribe on the site

**What:** a native Substack embed (or subscribe link block) on posts or in the footer, so readers can subscribe to weirdion.substack.com without leaving the site. Would replace the reverted EmailOctopus form.
**Why parked:** Substack embeds used to feel bolted-on. Worth revisiting now that Substack has matured.
**Pull forward:** when the operator wants to grow the newsletter. The theme is now on v3, so build against that.

## Vestigial `feature =` frontmatter key

**What:** every post sets `feature = "featured.jpg|png"`, but Blowfish never reads that key. It picks the card, social, and RSS image by matching bundle filenames against `*feature*` (`themes/blowfish/layouts/partials/head.html:150`). That's why `2025-11-07-querying-dynamodb-with-athena` works with a file named `feature.png` even though its frontmatter says `featured.png`. Either drop the key from the archetype and posts, or keep it as documentation.
**Why parked:** harmless; nothing renders wrong.
**Pull forward:** any post-frontmatter cleanup. Confirmed on Blowfish v3.9.0 (2026-11-12): still matched by filename glob.

## Planned series: alembix (AgentCore Runtime + Harness SDK)

**What:** a multi-post series following the build of [alembix](https://github.com/weirdion/alembix), an end-to-end agentic solution on AgentCore Runtime + Harness SDK (the successor to Strands). It pairs with the 2025-07-16 Strands post: same "ship it, not a hype demo" thesis, platform rather than SDK. The repo is the shared linked artifact (publish-target). Likely outline:
1. Why a proving ground; SDK vs platform (Strands vs AgentCore). Series opener.
2. The architecture spike: options weighed for the Runtime + Gateway + Observability slice.
3. Building the foundation (IaC, agent on Runtime, tools via Gateway/MCP, Observability wiring), with the differences from the Lambda/Strands path as the honest content.
4. Test it out: an end-to-end invocation with traces visible.
5. Later milestones (Memory, then Identity), one post each.

Cost and security run through every post. Dead ends and snippet moments are logged in alembix's own agent docs during the build; pull them from there when drafting.
**Why parked:** the build is still at the architecture-spike stage; posts follow working code.
**Pull forward:** when the spike lands a working slice, draft post 1 (and 2 if the spike produced enough).

## Home page meta description is the theme default

**What:** `https://weirdion.com/` serves `<meta name="description" content="This page was built using the Blowfish theme for Hugo.">`, which is what search results show for the home page. Set a real site description (likely `description` in `config/_default/languages.en.toml` params). The site has been live with this since before 2026-11-12.
**Why parked:** found during the v3 comparison; content/SEO, not part of the dependency bump.
**Pull forward:** next SEO or config pass. It's a one-line fix.
