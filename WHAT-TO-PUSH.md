# Fixing the missing isometric and 3-D graphics

`index.html` contains only the **flat** illustrations. The isometrics and the
3-D models are loaded at runtime from separate files. Those files are not in the
repository yet, which is why those two categories come up empty.

Nothing is wrong with the page. It just has nothing to load.

## What to copy

From my working folder — the same place `index.html` came from — copy these
into the **root of your repository**, beside `index.html`:

| Copy | What it is |
|---|---|
| the `iso` folder | 128 isometric SVGs |
| the `3d` folder | 5 building meshes |
| the `bg` folder | 4 Colour Glaze backdrops |
| `iso-airport.json` | Airport catalogue |
| `iso-infrastructure-a.json` | Infrastructure, part 1 |
| `iso-infrastructure-b.json` | Infrastructure, part 2 |
| `iso-lifescience.json` | Life Science catalogue |
| `iso-manufacturing.json` | Manufacturing catalogue |
| `iso-office.json` | Office catalogue |
| `iso-selection-a.json` | Elevated Emerald Selection, part 1 |
| `iso-selection-b.json` | Elevated Emerald Selection, part 2 |
| `iso-ship.json` | Ship catalogue |
| `iso-vehicle.json` | Vehicle catalogue |
| `threed.json` | 3-D catalogue |

Do **not** rename anything. Replace `index.html` with the one next to this file
at the same time — the copy currently deployed does not know how to read the
un-renamed layout.

Ignore any other `iso-*.json` files you see (`construction`, `maintenance`,
`office-a`, `office-b`, `lifescience-a`, `lifescience-b`). They are leftovers
from before the isometric set was replaced and are not used.

## Then

```bash
git add .
git commit -m "Add isometric and 3-D assets"
git push
```

Vercel redeploys on push. All three categories should appear.

## The result should be

```
index.html
iso-airport.json  …  threed.json      (11 catalogue files)
iso/    128 .svg
3d/     5 .txt
bg/     4 .jpg
```

## If they still do not appear

The page now tells you why instead of showing an empty category. Look for an
amber banner across the top — it names the exact paths it tried. Failing that,
open this in a browser tab:

`https://your-site/iso-airport.json`

JSON means the files are deployed and something else is wrong — send me the
browser console output (F12 → Console). A 404 means the copy did not reach the
deployment.

## Why the odd filenames

The files in `iso/`, `3d/` and `bg/` are named by content hash. That is not
deliberate design — it is how they came out of the pipeline that extracted them,
and the catalogues reference the isometrics by those exact names. Renaming the
`iso/` files would mean rewriting every catalogue entry, so they stay as they
are. `index.html` accepts either these raw names or the tidier ones, so there is
nothing to fix.
