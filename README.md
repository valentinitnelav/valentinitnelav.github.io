# valentinitnelav.github.io

Source of my personal website, <https://valentinitnelav.github.io/>: who I am, current work,
R packages, selected publications, and an archive of older R tutorials and plotting scripts.

The site is plain HTML and one CSS file. There is no build step and there are no dependencies, so
there is nothing to update and no security alerts to chase.

## Layout

| Path | What it is |
| --- | --- |
| `index.html` | Landing page |
| `gallery/index.html` | Scripts & graph gallery page; the `.R` scripts and `.png` thumbnails sit next to it |
| `assets/` | Self-contained R Markdown tutorials (HTML + `.Rmd` source), linked from the gallery page |
| `css/site.css` | The only stylesheet (light and dark mode) |
| `img/` | Images used by the pages |
| `2018/`, `2019/`, `2020/`, `about/`, `license_snippets/` | Redirects from the URLs of the old Jekyll blog |
| `404.html` | "Page not found" page |
| `.nojekyll` | Tells GitHub Pages to serve the files as they are, without running Jekyll |

## Preview locally

```bash
python3 -m http.server 8000
# then open http://localhost:8000/
```

## Publishing

GitHub Pages serves the `master` branch from the repository root. A push to `master` updates the
site within a minute or two.

## License

The code in this repository (R scripts, R Markdown files, HTML and CSS) is licensed under the
[GNU Affero General Public License v3.0](LICENSE) (AGPL-3.0). Until October 2026 it was under the MIT
license; copies obtained before then keep that license.

Third-party JavaScript and CSS libraries embedded in the rendered tutorial pages under `assets/`
(for example jQuery, Bootstrap and plotly.js) keep their own licenses.
