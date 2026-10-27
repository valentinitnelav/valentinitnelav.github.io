# Notes for AI coding agents

Personal website of Valentin Ștefan, served by GitHub Pages at <https://valentinitnelav.github.io/>.
The owner uses it for job applications (academia and industry), so the tone stays calm, warm and factual.

## Rules

- Never `git push` (any branch, any form) without the owner's explicit approval of that push.
  Pushing to `master` publishes the site immediately.
- Commit messages carry no credit or co-author lines.
- Keep it plain HTML + `css/site.css`. Do not add a Gemfile, `package.json`, a static-site generator,
  web fonts from third-party servers (Google Fonts), analytics or other trackers. The old Jekyll setup
  was removed because its unused dependencies caused years of Dependabot alerts.
- The repo's code is AGPL-3.0 (`LICENSE`, since October 2026; MIT before). Keep the footer license line
  in `index.html` and `gallery/index.html` in sync with it.
- Keep `.nojekyll`. Without it GitHub runs Jekyll and turns stray `.md` files into pages.
- `private/` is git-ignored and holds the owner's own notes (maintenance guide, link checker). Never
  commit it or force-add files from it.
- Keep these paths stable, because other sites link to them: everything under `assets/` and `gallery/`,
  and the redirect stubs in `2018/`, `2019/`, `2020/`, `about/`, `license_snippets/`.
- Never create top-level folders named `plotbiomes/`, `bootstrapnet/` or `satellite-image-classification-r/`.
  Those URLs belong to the GitHub Pages sites of the repositories with those names.
- Facts about the owner (roles, dates, publications) must come from a source (ORCID, Crossref, the
  owner). Never invent them. The owner reviews every new sentence about themselves.

## Working on the site

- Preview: `python3 -m http.server 8000` from the repo root, then open `http://localhost:8000/`.
- Both pages share the same nav and footer markup; change them in `index.html`, `gallery/index.html`
  and `404.html` together.
- Gallery images have spaces in their file names, so URL-encode them in `src`/`href`
  (`python3 -c "import urllib.parse; print(urllib.parse.quote('name.png'))"`).
- Before proposing a push, check every link on every page (internal links and images resolve; external
  links return 2xx/3xx) and look at the pages at phone width and in dark mode.
