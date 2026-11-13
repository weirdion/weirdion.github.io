# Backlog

Deferred work. Each entry: what it is, why it's parked, and what pulls it forward. If it isn't here and isn't in flight, it doesn't exist. Delete an entry when it closes. Its record is the commit and the session log.

---

## Bump Hugo and Blowfish together

**What:** CI pins Hugo 0.148.2 (`.github/workflows/deploy-gh-pages.yml`); local Homebrew is 0.169.0. Blowfish v2.89.0 declares 0.141.0–0.148.2 support, so newer Hugo warns `Module "blowfish" is not compatible`. Newer Hugo also flags deprecated keys: `languageCode` → `locale` (`hugo.toml`, `languages.en.toml`), `languageName` → `label`. Move theme and Hugo together, picking releases at least two weeks old, and update CI, README, and RUNBOOK versions in the same change.
**Why parked:** the build still succeeds; adoption came first.
**Pull forward:** next maintenance item. Sooner if a Hugo release removes the deprecated keys.

## Fix or drop `scripts/update-gh-actions-versions.sh`

**What:** untracked script. It resolves the *newest* Hugo and Dart Sass releases, which breaks the steer's two-week dependency-age rule. Its name is also misleading: it bumps Hugo and Sass, not Actions. Either make it pick the newest release at least two weeks old and rename it, or delete it in favor of dependency automation (below).
**Why parked:** depends on the dependency-automation choice.
**Pull forward:** when doing the Hugo/Blowfish bump or setting up dependency automation.

## Dependency automation (Dependabot or Renovate)

**What:** re-add automated update PRs for GitHub Actions (currently pinned to major tags like `@v4`) and possibly the theme submodule. Configure a minimum-age cooldown so it respects the two-week rule.
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
**Pull forward:** when the operator wants to grow the newsletter, or after the Hugo/Blowfish bump, so it's built against the current theme.

## Vestigial `feature =` frontmatter key

**What:** every post sets `feature = "featured.jpg|png"`, but Blowfish never reads that key. It picks the card, social, and RSS image by matching bundle filenames against `*feature*` (`themes/blowfish/layouts/partials/head.html:150`). That's why `2025-11-07-querying-dynamodb-with-athena` works with a file named `feature.png` even though its frontmatter says `featured.png`. Either drop the key from the archetype and posts, or keep it as documentation.
**Why parked:** harmless; nothing renders wrong.
**Pull forward:** during the theme bump. Re-check whether the new Blowfish version still uses the glob.

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
