# Backlog

Deferred work. Each entry: what it is, why it's parked, and what pulls it forward. If it isn't here and isn't in flight, it doesn't exist. Delete an entry when it closes. Its record is the commit and the session log.

---

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
