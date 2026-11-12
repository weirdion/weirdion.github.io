# Syndication — cross-posting to Substack and Medium

How to cross-post a published post to Substack (weirdion.substack.com, also the newsletter channel; see decisions.md) and Medium. **Read before cross-posting.** The mechanics were non-obvious, and working them out took real time on the first cross-post (the 2026-07-20 agent-steer post).

**Ground rules:**
- **weirdion.com stays the source of truth.** Cross-post only after the post is live on the site.
- **Stop at draft.** Never click publish or "Send to everyone now". That's outward-facing and irreversible, so it's the operator's call.

## Setup

- Cross-posting drives the editors through browser automation (Playwright MCP). The browser profile is per agent and per session: the operator logs in to each platform once in the launched browser, and the agent never handles credentials.

## Getting the post body in

Both editors need **`text/html` on the clipboard**. Pasting markdown produces nothing useful.

1. Convert the post markdown to clean HTML using only `<h2> <h3> <p> <ul> <ol> <li> <blockquote> <pre> <code> <strong> <em> <a>`. Strip Hugo frontmatter and shortcodes.
2. Write it to the clipboard from the page: `navigator.clipboard.write([new ClipboardItem({'text/html': new Blob([html], {type: 'text/html'})})])`. Pass the HTML **as an argument** to the evaluate call to avoid escaping problems. `fs`, `require`, and dynamic `import` are blocked in the Playwright sandbox, so the HTML can't be read from disk there and has to be inlined into the call.
3. Click into the editor body, press `Meta+v`, and wait about 3 seconds.
4. **Verify the paste:** count the rendered `h2`/`h3`/`li`/`pre`/`a` elements and compare them with the source. Don't trust a paste you haven't checked.

ASCII trees and diagrams come through as `<pre>` blocks on both platforms. They're the most likely thing to get mangled, and the main reason HTML paste is worth the effort.

## Platform quirks

**Substack**
- Title and subtitle are separate inline fields (`[data-testid="post-title"]` and "Add a subtitle…"), set apart from the body.
- A "File Settings" side drawer can cover the editor. Click the title field directly to dismiss it.
- This is a personal blog post, not a newsletter issue. Don't apply newsletter-specific section, tag, or cover conventions from other publications.

**Medium**
- One contenteditable `article`. The first line is the title: type it, press Enter to move into the body, then paste.
- Medium has only two heading sizes, so `<h2>` and `<h3>` render the same. Bump section headers by hand if the hierarchy matters.
- External links get wrapped in `medium.com/r/?url=…`. That's expected; the links still work.

## Operator does by hand on each draft

The agent can't do these:
- **Upload the cover/featured image.** It's a local file and can't come through the HTML paste.
- **Set the canonical URL** to the weirdion.com post, so search engines treat the site as the original. A footer line saying "originally published at…" is a backup signal, not a replacement.
- Publish.
