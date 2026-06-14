$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

& (Join-Path $Root "generate-locality-pages.ps1")
& (Join-Path $Root "generate-realizace-pages.ps1")
& (Join-Path $Root "generate-blog-pages.ps1")
& (Join-Path $Root "generate-seo.ps1")

Write-Host "Build complete: content, sitemap, robots, metadata and structured data are ready."




