# Session log

Live state, newest first. Read the top entry first and write it last. If a later session proves an entry wrong, mark it superseded instead of deleting it.

---

## 2026-11-12 — Dependency bump: Hugo 0.167.0, Blowfish v3.9.0, Actions SHA-pinned

**Done (branch `deps-hugo-blowfish-actions`):**
- Theme submodule v2.89.0 → v3.9.0 (`ebe683e`); CI Hugo 0.148.2 → 0.167.0 (theme range 0.164–0.167; see decisions.md).
- Workflow: Actions bumped to current majors and SHA-pinned (checkout v7.0.1, configure-pages v6.0.0, cache v6.1.0, upload-pages-artifact v5.0.0, deploy-pages v5.0.1); Hugo download is checksum-verified; Dart Sass and npm steps removed. The checksum step was simulated locally: it passes on the real `.deb` and fails on a tampered one.
- Config deprecations fixed (`languageCode` → `locale`, `languageName` → `label`). The `sharing-links.html` override moved to `hugo.Data`, matching upstream; upstream's `safeURL` was not adopted because live share URLs render correctly without it.
- `custom.css`: v3 changed header classes, so the nav labels and accessibility/appearance buttons had shrunk. The selectors were extended to keep the v2 sizes.
- `Makefile`: `HUGO ?= hugo` override; `build` now uses `--gc --minify` like CI. `.gitignore`: `.playwright-mcp/`.
- Verified with Hugo 0.167.0 (official pkg, checksum-checked, scratch copy): zero WARN lines, 332 pages. Compared against live weirdion.com with Playwright: 12 paths (home, lists, 3 posts, RSS 14 items, sitemap 16, search index 171, favicon, manifest, 404). Titles, descriptions, og:image, canonical, favicons, and share links all match. Umami is present on all 14 posts in the production build. No console errors.

**Visible v3 changes kept (operator to confirm):** post images render at natural width instead of stretched to the content width; the sticky header gets a tinted glass background on scroll; on mobile, the accessibility button moved into the hamburger menu and the appearance button is slightly smaller; list cards show thumbnails.

**Ruled out:** "Umami missing" was a false alarm. I'd read `public/` after the dev server overwrote it; analytics are production-only by design. "Blank thumbnails" were lazy-loaded images in a non-scrolling full-page screenshot; all 11 load after scrolling.

**Next:** operator reviews the visible changes; then PR → merge → re-run the live comparison against the deployed site.

