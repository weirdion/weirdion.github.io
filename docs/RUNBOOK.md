## Runbook (Hugo + Blowfish)

This runbook describes how to build, serve, and deploy the site, how the repository is structured post-Jekyll migration, and where to tweak configuration.

Quick facts
- Static site generator: Hugo (extended)
- Theme: Blowfish (git submodule in `themes/blowfish`)
- Production deploy: GitHub Pages via GitHub Actions
- Primary configs: `hugo.toml` and files under `config/_default/`

Links to key config
- Hugo root config: [`hugo.toml`](../hugo.toml)
- Language/site metadata: [`config/_default/languages.en.toml`](../config/_default/languages.en.toml)
- Theme and site params: [`config/_default/params.toml`](../config/_default/params.toml)
- Menus (main/footer): [`config/_default/menus.en.toml`](../config/_default/menus.en.toml)
- Markup/rendering: [`config/_default/markup.toml`](../config/_default/markup.toml)
- Theme submodule: [`.gitmodules`](../.gitmodules) and [`themes/blowfish`](../themes/blowfish)
- CI/CD workflow: [`.github/workflows/deploy-gh-pages.yml`](../.github/workflows/deploy-gh-pages.yml)
- Favicons override: [`layouts/partials/favicons.html`](../layouts/partials/favicons.html) and static icons under [`static/`](../static)


## Repository structure (high-level)

- [`content/`](../content): Markdown content (page bundles for posts)
- [`config/_default/`](../config/_default): Site params, menus, languages, markup
- [`hugo.toml`](../hugo.toml): Root Hugo configuration (baseURL, outputs, sitemap, taxonomies, related)
- [`themes/blowfish`](../themes/blowfish): Theme (git submodule)
- [`assets/`](../assets): Pipeline assets (CSS/images). Example: [`assets/css/custom.css`](../assets/css/custom.css)
- [`static/`](../static): Static files copied as-is (favicons, webmanifest)
- [`layouts/`](../layouts): Theme overrides (partials, etc.)
- [`archetypes/`](../archetypes): Content blueprints. Default at [`archetypes/default.md`](../archetypes/default.md)
- [`resources/_gen/`](../resources/_gen): Generated resources from Hugo Pipes
- [`public/`](../public): Build output (artifact). Can be cleaned and not required to commit
- [`.github/workflows/`](../.github/workflows): CI (GitHu

---

## Local development

Prerequisites
- Hugo Extended (match CI when possible).

Common commands (Makefile)
- Build: `make build` → runs `hugo` (see [`Makefile`](../Makefile))
- Serve: `make serve` → runs `hugo serve -D` (includes drafts)
- Clean: `make clean` → removes `public/`

FYI
- Drafts: served locally via `-D`; not built in CI (see `buildDrafts = false` in [`hugo.toml`](../hugo.toml)).
- Future-dated posts: not built in CI (`buildFuture = false` in [`hugo.toml`](../hugo.toml)). To preview local futures add `-F`: `hugo serve -D -F`.
- Base URL: CI passes `--baseURL` dynamically; local serve ignores `baseURL` for the dev server.

## Content model

- Content lives in [`content/`](../content). Posts are page bundles at `content/posts/YYYY-MM-DD-slug/index.md`.
- New post: uses the default archetype.
  - Archetype: [`archetypes/default.md`](../archetypes/default.md) (sets `draft = true` and title from slug)
  - Create: `hugo new posts/2025-08-08-your-title/index.md`
- Taxonomies: defined in [`hugo.toml`](../hugo.toml) under `[taxonomies]` (tags, categories). Tag landing page index at [`content/tags/_index.md`](../content/tags/_index.md).

## Theme and styling

- Theme: Blowfish via git submodule under [`themes/blowfish`](../themes/blowfish). Submodule declared in [`.gitmodules`](../.gitmodules).
  - After fresh clone: `git submodule update --init --recursive`
  - Update theme: `git submodule update --remote --merge`
- Theme/site params: toggle features in [`config/_default/params.toml`](../config/_default/params.toml)
- Custom CSS: [`assets/css/custom.css`](../assets/css/custom.css) is bundled via Hugo Pipes.
- Icons & favicons: see partial override [`layouts/partials/favicons.html`](../layouts/partials/favicons.html) and icon files under [`static/`](../static/).

## Analytics
- Umami is set up for collecting privacy-friendly analytics to understand user traffic.
- The config is set up in [`config/_default/params.toml`](../config/_default/params.toml)
- The tracking script is included in the theme header, no custom overrides.

## Email subscribe and newsletter
- Email newsletter is managed with [Email Octopus](https://emailoctopus.com/).
- The subscribe form is embedded using the script provided by Email Octopus.
- The form is included in the sidebar via the shortcode in [`layouts/shortcodes/subscribe.html`](../layouts/shortcodes/subscribe.html).
- To include the subscribe form in posts, use the shortcode `{{< subscribe >}}` in the post content.


## Menus and metadata

- Site title/author: [`config/_default/languages.en.toml`](../config/_default/languages.en.toml)
- Menus: main and footer menus configured in [`config/_default/menus.en.toml`](../config/_default/menus.en.toml)
- Output formats, sitemap, pagination: see [`hugo.toml`](../hugo.toml)
- Markup/rendering: Goldmark, code highlighting, ToC in [`config/_default/markup.toml`](../config/_default/markup.toml)

## Build and outputs

- Build output directory: `public/` (see `make build`). Typically treated as build artifact; CI uploads it. `make clean` removes it.
- Hugo resource cache: `resources/_gen/` (generated assets from Hugo Pipes). Safe to delete; will regenerate.

## CI/CD (GitHub Pages)

Workflow: [deploy-gh-pages.yml](../.github/workflows/deploy-gh-pages.yml)
- Triggers: on push to `main` and manual dispatch.
- Environment vars: `HUGO_VERSION=0.148.2`, `HUGO_ENVIRONMENT=production`, `TZ=America/Indiana/Indianapolis`, `DART_SASS_VERSION=1.90.0`.
- Steps (build job):
  - Install Hugo Extended and Dart Sass.
  - Checkout with submodules (`submodules: recursive`) and `git submodule update --init --recursive`.
  - Configure GitHub Pages and restore a runner-temp cache for Hugo (`--cacheDir`).
  - Build with: `hugo --gc --minify --baseURL "${{ steps.pages.outputs.base_url }}/" --cacheDir "$RUNNER_TEMP/hugo_cache"`
    - Note: `--baseURL` overrides [`hugo.toml`](../hugo.toml) `baseURL` at build time so links point to the Pages URL.
  - Upload `./public` as the Pages artifact.
- Deploy job: uses `actions/deploy-pages@v4` to publish the artifact to GitHub Pages (environment `github-pages`).

Operations
- To publish: merge/push to `main`. CI will build and deploy automatically.
- To bump Hugo version: edit `HUGO_VERSION` in the workflow file and validate locally with the same version.
- To invalidate bad cache: change the cache key or clear the `hugo_cache` path usage in the workflow.

## Troubleshooting

- 404s or wrong absolute links: ensure `baseURL` is correct in production. CI already injects the Pages URL; avoid hard-coded absolute URLs in content.
- Missing theme/styles on CI: ensure submodules are initialized. Locally run `git submodule update --init --recursive`.
- Styling not applied: check `assets/css/custom.css` and ensure the theme is configured to pick it up (Blowfish does by default).
- Draft or future posts not visible in prod: set `draft = false` and ensure `date` is not in the future.
b Pages deploy)

## Maintenance checklist

- Keep Hugo and the theme updated (submodule + workflow `HUGO_VERSION`).
- Review `params.toml` toggles for features you need (search, TOC, reading time, etc.).
- Verify menus after adding new top-level sections (`menus.en.toml`).
- Periodically clean generated folders: `make clean` and remove `resources/_gen/` if needed.
