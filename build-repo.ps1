# Assembles the Elevated Emerald Studio repository folder.
#
# The asset files are named by content hash where they sit now. This copies
# them into a clean structure with the names index.html expects.
#
# Run from PowerShell:
#   .\build-repo.ps1 -Source "<folder containing iso\, 3d\, bg\ and the json files>" -Dest "C:\path\to\your-repo"

param(
  [Parameter(Mandatory = $true)][string]$Source,
  [Parameter(Mandatory = $true)][string]$Dest
)

$ErrorActionPreference = "Stop"

function Need($path) {
  if (-not (Test-Path $path)) { throw "Missing: $path" }
}

Write-Host "Source: $Source"
Write-Host "Dest:   $Dest"

# --- folders -----------------------------------------------------------
foreach ($d in @("", "data", "iso", "3d", "bg")) {
  $p = Join-Path $Dest $d
  if (-not (Test-Path $p)) { New-Item -ItemType Directory -Path $p | Out-Null }
}

# --- the page ----------------------------------------------------------
Copy-Item (Join-Path $PSScriptRoot "index.html") (Join-Path $Dest "index.html") -Force
Write-Host "index.html"

# --- catalogues: flat file names -> data\ ------------------------------
$catalogues = @{
  "iso-selection-a.json"      = "data\selection-a.json"
  "iso-selection-b.json"      = "data\selection-b.json"
  "iso-airport.json"          = "data\airport.json"
  "iso-infrastructure-a.json" = "data\infrastructure-a.json"
  "iso-infrastructure-b.json" = "data\infrastructure-b.json"
  "iso-lifescience.json"      = "data\lifescience.json"
  "iso-manufacturing.json"    = "data\manufacturing.json"
  "iso-office.json"           = "data\office.json"
  "iso-ship.json"             = "data\ship.json"
  "iso-vehicle.json"          = "data\vehicle.json"
  "threed.json"               = "data\3d.json"
}
foreach ($k in $catalogues.Keys) {
  $from = Join-Path $Source $k
  Need $from
  Copy-Item $from (Join-Path $Dest $catalogues[$k]) -Force
}
Write-Host "$($catalogues.Count) catalogue files -> data\"

# --- isometric geometry: hash names are what the catalogues reference --
$isoFrom = Join-Path $Source "iso"
Need $isoFrom
$isoFiles = Get-ChildItem (Join-Path $isoFrom "*.svg")
Copy-Item (Join-Path $isoFrom "*.svg") (Join-Path $Dest "iso") -Force
Write-Host "$($isoFiles.Count) isometric SVGs -> iso\"

# --- 3-D meshes: hash -> building-N.txt --------------------------------
$models = @{
  "1b90345c675bf2c1093a3d1340e8d92a.txt" = "3d\building-1.txt"
  "785e36fa57c9f96b84baffd277d2bfd2.txt" = "3d\building-2.txt"
  "04dff055071e2c0a0c94037ba1719dd0.txt" = "3d\building-3.txt"
  "f0b912697e4e08b41e7f53fabadc26af.txt" = "3d\building-4.txt"
  "0b97e71bbb5c5fdd9795a1cdeb357909.txt" = "3d\building-5.txt"
}
foreach ($k in $models.Keys) {
  $from = Join-Path (Join-Path $Source "3d") $k
  Need $from
  Copy-Item $from (Join-Path $Dest $models[$k]) -Force
}
Write-Host "5 meshes -> 3d\"

# --- Colour Glaze backdrops: hash -> glaze-X.jpg -----------------------
$glazes = @{
  "3e9300eed456ba94417715858bde67a4.jpg" = "bg\glaze-a.jpg"
  "2a50e60e3a22a2d07afeb728b0ca4977.jpg" = "bg\glaze-b.jpg"
  "33d41ab2d8cfe0eae472984ab40bdaf9.jpg" = "bg\glaze-c.jpg"
  "764e1905a45df81aaa19b0631be34cfc.jpg" = "bg\glaze-d.jpg"
}
foreach ($k in $glazes.Keys) {
  $from = Join-Path (Join-Path $Source "bg") $k
  Need $from
  Copy-Item $from (Join-Path $Dest $glazes[$k]) -Force
}
Write-Host "4 glazes -> bg\"

Write-Host ""
Write-Host "Done. Serve it locally to check before pushing:"
Write-Host "  cd `"$Dest`"; python -m http.server 8000"
Write-Host "then open http://localhost:8000"
