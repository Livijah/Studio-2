# Fixing the missing isometric and 3-D graphics

## What was actually wrong

The banner on your site said *"No catalogue files found"* and named both paths
it had tried. That is conclusive: the deployed `index.html` was the right one,
and the only thing missing from the server was the eleven small catalogue JSON
files. The artwork itself had reached the deployment — I confirmed
`3d/building-1.txt` resolves on your domain.

So the page was working correctly. It had nothing to read.

## What I changed

**The catalogues are now built into `index.html`.** All eleven of them, about
200 KB, sit in the file as a `CATS` object. Nothing fetches them any more, so
there is no longer a copy step that can leave them behind. Only the artwork —
`iso/`, `3d/` and `bg/` — is still loaded from disk, and that part is already
proven to work on your server.

This removes the failure mode entirely rather than working around it.

## What to push

Unzip **`elevated-emerald-studio-site.zip`** (in your OneDrive folder) straight
into the root of your repository, overwriting when asked. It contains exactly
what the site needs and nothing else:

```
index.html          the page, catalogues included
iso/                58 isometric SVGs
3d/                 5 building meshes
bg/                 4 Colour Glaze backdrops
```

Then:

```bash
git add -A
git commit -m "Inline catalogues; add isometric, 3-D and backdrop assets"
git push
```

Vercel redeploys on push.

## Two things worth knowing

**You can delete the loose `iso-*.json` and `threed.json` files** from the
repository if any are there. They are no longer read.

**The zip carries 58 isometric files, not 128.** My working folder still held
102 orphans from the set you replaced earlier. Only the 58 your catalogues
actually reference are included, which is why the download is 2.4 MB rather
than 12 MB.

## If something is still missing after this

The page will now name the specific asset that failed rather than showing an
empty category, because the catalogue always loads. A tile that stays blank
means its SVG did not reach the server; the browser console (F12) will show
the exact URL.

## Why the odd filenames in `iso/`

They are content hashes — an artefact of the pipeline that extracted them, not
a design choice. The catalogues reference them by those exact names, so
renaming them would mean rewriting every entry. The meshes and backdrops did
get friendly names, since nothing depended on their originals.
