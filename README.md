# The Tinkering Mind

[![Deploy Hugo site to GitHub Pages](https://github.com/weirdion/weirdion.github.io/actions/workflows/deploy-gh-pages.yml/badge.svg)](https://github.com/weirdion/weirdion.github.io/actions/workflows/deploy-gh-pages.yml)

Personal blog

- Live site: https://weirdion.com
- Theme: [`themes/blowfish`](./themes/blowfish) (git submodule)
- Built with [Hugo](https://gohugo.io/), and the [Blowfish](https://blowfish.page/) theme.
- Site uses [Umami](https://umami.is/) hosted in the US.
- Email newsletter is generated with [Email Octopus](https://emailoctopus.com/).

## Quick start

- Install Hugo Extended (match CI if possible: 0.148.2)
- Serve locally with drafts:

```sh
make serve
```

- Build static site:

```sh
make build
```

- Clean generated output:

```sh
make clean
```

## Content

Posts are page bundles under `content/posts/YYYY-MM-DD-slug/index.md`. Use the default archetype (draft by default).

## Configuration

- Root Hugo config: [`hugo.toml`](./hugo.toml)
- Site/language metadata: [`config/_default/languages.en.toml`](./config/_default/languages.en.toml)
- Theme/site params: [`config/_default/params.toml`](./config/_default/params.toml)
- Menus: [`config/_default/menus.en.toml`](./config/_default/menus.en.toml)
- Markup & highlighting: [`config/_default/markup.toml`](./config/_default/markup.toml)

## Deploy

Deployed via GitHub Actions to GitHub Pages:
- Workflow: [`.github/workflows/deploy-gh-pages.yml`](./.github/workflows/deploy-gh-pages.yml)

## Runbook

See the detailed operations guide: [`docs/RUNBOOK.md`](./docs/RUNBOOK.md)
