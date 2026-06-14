param(
  [int]$Port = 8088,
  [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path)
)

$ErrorActionPreference = "Stop"
$RootPath = [System.IO.Path]::GetFullPath($Root)
$Address = [System.Net.IPAddress]::Parse("127.0.0.1")
$Listener = [System.Net.Sockets.TcpListener]::new($Address, $Port)

function Send-Response($Stream, $Status, $ContentType, [byte[]]$Body) {
  $Reason = switch ($Status) {
    200 { "OK" }
    403 { "Forbidden" }
    404 { "Not Found" }
    default { "OK" }
  }
  $Header = "HTTP/1.1 $Status $Reason`r`nContent-Type: $ContentType`r`nContent-Length: $($Body.Length)`r`nConnection: close`r`n`r`n"
  $HeaderBytes = [System.Text.Encoding]::ASCII.GetBytes($Header)
  $Stream.Write($HeaderBytes, 0, $HeaderBytes.Length)
  $Stream.Write($Body, 0, $Body.Length)
}

function Get-ContentType($Path) {
  switch ([System.IO.Path]::GetExtension($Path).ToLowerInvariant()) {
    ".html" { "text/html; charset=utf-8" }
    ".css" { "text/css; charset=utf-8" }
    ".js" { "application/javascript; charset=utf-8" }
    ".json" { "application/json; charset=utf-8" }
    ".xml" { "application/xml; charset=utf-8" }
    ".txt" { "text/plain; charset=utf-8" }
    ".jpg" { "image/jpeg" }
    ".jpeg" { "image/jpeg" }
    ".png" { "image/png" }
    ".webp" { "image/webp" }
    default { "application/octet-stream" }
  }
}

$Listener.Start()

while ($true) {
  $Client = $Listener.AcceptTcpClient()
  try {
    $Stream = $Client.GetStream()
    $Reader = [System.IO.StreamReader]::new($Stream, [System.Text.Encoding]::ASCII, $false, 1024, $true)
    $RequestLine = $Reader.ReadLine()
    if ([string]::IsNullOrWhiteSpace($RequestLine)) { continue }

    while ($true) {
      $Line = $Reader.ReadLine()
      if ($null -eq $Line -or $Line -eq "") { break }
    }

    $Parts = $RequestLine.Split(" ")
    $RawPath = ($Parts[1] -split "\?")[0]
    $RelativePath = [System.Uri]::UnescapeDataString($RawPath.TrimStart("/")).Replace("/", [System.IO.Path]::DirectorySeparatorChar)
    if ([string]::IsNullOrWhiteSpace($RelativePath)) { $RelativePath = "index.html" }

    $Candidate = [System.IO.Path]::GetFullPath((Join-Path $RootPath $RelativePath))
    if (!$Candidate.StartsWith($RootPath, [System.StringComparison]::OrdinalIgnoreCase)) {
      Send-Response $Stream 403 "text/plain; charset=utf-8" ([System.Text.Encoding]::UTF8.GetBytes("Forbidden"))
      continue
    }

    if (Test-Path $Candidate -PathType Container) {
      $Candidate = Join-Path $Candidate "index.html"
    }

    if (Test-Path $Candidate -PathType Leaf) {
      $Bytes = [System.IO.File]::ReadAllBytes($Candidate)
      Send-Response $Stream 200 (Get-ContentType $Candidate) $Bytes
    } else {
      Send-Response $Stream 404 "text/plain; charset=utf-8" ([System.Text.Encoding]::UTF8.GetBytes("Not Found"))
    }
  } catch {
    try {
      Send-Response $Stream 404 "text/plain; charset=utf-8" ([System.Text.Encoding]::UTF8.GetBytes("Not Found"))
    } catch {}
  } finally {
    $Client.Close()
  }
}




