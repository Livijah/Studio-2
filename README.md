# Elevated Emerald Studio

A browser-based asset library for the CBRE Elevated Emerald toolkit. Browse flat
illustrations, isometric illustrations and 3-D building models; recolour them
against the brand palette; compose them on a slide-sized workspace; export.

No build step, no dependencies to install. It is one HTML file plus data.

## Layout

```
index.html              the whole application
data/*.json             catalogues: names, tags, material and stylesheet data
iso/*.svg               isometric geometry, one file per illustration
3d/building-*.txt       Wavefront OBJ meshes (.txt so any static host serves them)
bg/glaze-*.jpg          Colour Glaze backdrops
```

The flat illustrations are embedded in `index.html`. Everything else loads on
demand, so the page opens quickly and only fetches what you look at.

## Running it

It must be served over HTTP — opening `index.html` from the filesystem will
fail, because the browser blocks `fetch` on `file://` URLs and no artwork will
appear.

```bash
python -m http.server 8000     # or: npx serve
```

Then open <http://localhost:8000>.

## GitHub Pages

1. Push this folder to a repository
2. Settings → Pages → Source: *Deploy from a branch*
3. Branch `main`, folder `/ (root)`, Save

The site appears at `https://<user>.github.io/<repo>/` within a minute or two.
Nothing here needs a server, so Pages is enough.

## Vercel

Import the repository and deploy — there is no framework to configure, so the
defaults are right. Two things catch people out:

- **The asset folders must be committed.** `index.html` carries only the flat
  illustrations; the isometrics and 3-D models load from `data/`, `iso/` and
  `3d/`. If those are missing, the flat set appears and nothing else does. The
  page says so in a banner at the top rather than failing silently.
- **Deployment Protection** is on by default for some accounts, which puts the
  whole site behind a Vercel login. Colleagues without Vercel access will see a
  login page instead of the studio. Turn it off under
  Project → Settings → Deployment Protection if the library is meant to be
  shared.

The page tolerates either file layout: the tidy one produced by
`build-repo.ps1`, or the raw export where catalogues sit beside `index.html` as
`iso-*.json` and meshes and glazes keep their hashed filenames. Every lookup
tries the tidy path first and falls back to the raw one.

## What it does

**Three sets.** Flat Graphics, Isometric Graphics (eight folders) and 3-D
Graphics, each with its own subcategories.

**Recolouring.** The three brand swatches drive colour *roles* rather than
literal hex values, because the flat and isometric sets ship slightly different
greens — isometric celadon is `#548184` where the flat one is `#538184`. Each
swatch moves its equivalent in every set, and lighter tints follow their anchor
proportionally so shading survives. Individual colours are editable per
illustration.

**The workspace** is 33.87 × 19.05 cm — a 16:9 PowerPoint slide. Drag artwork to
place it, scroll to scale. The Slide export renders 2934 × 1650 px at 220 DPI
and writes that density into the JPEG, so PowerPoint places it at exactly the
right physical size instead of guessing.

**3-D models** orbit on drag, pan on shift-drag, and switch between perspective
and orthographic projection. Export as GLB (single file, colours included) or
OBJ + MTL. PowerPoint reads both via Insert → 3D Models.

## How the isometric rendering works

Worth knowing before editing anything here. Each isometric SVG keeps its palette
in a `<style>` block of class-to-fill rules. That stylesheet is stored in the
catalogue JSON rather than the SVG, and stitched back on at load time. It exists
because the original hosting stripped `<style>` from served SVGs — but it turned
out to be the better design anyway: recolouring becomes a string substitution on
a small stylesheet instead of a rewrite of every path, and opacity, blend modes
and clip paths pass through untouched.

Consequences:

- The files in `iso/` render black on their own. They are geometry only.
- Editing an illustration's colours means editing `css` in its catalogue entry.
- Adding an illustration means adding geometry *and* a catalogue entry with its
  stylesheet, viewBox dimensions and a `local` filename.

Per-instance id namespacing at load time keeps clip paths and gradients from
colliding when several illustrations are on screen at once.

## Names and keywords

Editable in the inspector and stored in this browser's `localStorage`. They do
not travel with the repository. To make a rename permanent for everyone, edit
`name` and `tags` in the catalogue JSON and commit it.

## Known limits

- **3-D needs an internet connection**, for Three.js from cdnjs. Everything else
  works offline once served.
- **Gradient fills** — in parts of the Maintenance set and some Colour Glazes —
  shade smoothly and do not respond to the recolour controls. Flat fills do.
- **Building 3 and 5** carry 1.7 MB and 1.4 MB of geometry and take a moment to
  appear the first time. Decimating them in Blender before export would help.
- Two illustrations were withdrawn from the flat set and are filtered out by id;
  their markup is still present in `index.html`.

## Credits

Artwork: CBRE Elevated Emerald toolkit. Colour values follow the CBRE brand
palette; the isometric artwork uses the published secondary tints.
