$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$SiteUrl = "https://www.kost-stav.cz"
$Company = "KOST STAV PRAHA s.r.o."
$Phone = "+420 777 977 571"
$PhoneCompact = "+420777977571"
$Email = "omitkykoststav@gmail.com"
$FormAction = "/api/contact"
$Street = "K Žižkovu 809/7"
$Locality = "Praha 9 - Vysočany"
$Country = "CZ"
$DefaultImage = "$SiteUrl/assets/images/moderni-exterier-rodinneho-domu.jpg"
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$Today = Get-Date -Format "yyyy-MM-dd"

$IndexExcluded = @("admin.html", "404.html", "dekujeme.html", "google5af87f4a2f557a6d.html")
$ServiceKeywords = @{
  "strojni-omitky" = "Strojní omítky"
  "sadrove-omitky" = "Sádrové omítky"
  "stukove-omitky" = "Štukové omítky"
  "vapenocementove-omitky" = "Vápenocementové omítky"
  "zatepleni-fasad" = "Zateplení fasád"
  "fasadni-prace" = "Fasádní práce"
  "omitky" = "Omítky"
  "fasady" = "Fasády"
}
$ServiceKeywordOrder = @(
  "vapenocementove-omitky",
  "zatepleni-fasad",
  "fasadni-prace",
  "strojni-omitky",
  "sadrove-omitky",
  "stukove-omitky",
  "omitky",
  "fasady"
)
$ServedAreas = @(
  "Praha", "Praha-východ", "Praha-západ", "Kladno", "Beroun", "Benešov", "Kolín", "Kutná Hora", "Nymburk", "Mladá Boleslav",
  "Mělník", "Brandýs nad Labem", "Čelákovice", "Lysá nad Labem", "Milovice", "Poděbrady", "Český Brod", "Říčany",
  "Jesenice", "Hostivice", "Roztoky", "Rudná", "Dobříš", "Příbram", "Hořovice", "Slaný", "Kralupy nad Vltavou",
  "Neratovice", "Mnichovo Hradiště", "Benátky nad Jizerou", "Vlašim", "Sedlčany", "Unhošť", "Rakovník"
)

function Is-DeprecatedPragueDistrict($RelativePath) {
  return $RelativePath -match '^lokality/.+-praha-(?:[1-9]|10)\.html$'
}

function Get-DeprecatedCanonical($RelativePath, $DefaultCanonical) {
  if ($RelativePath -match '^lokality/(.+)-praha-(?:[1-9]|10)\.html$') {
    return "$SiteUrl/lokality/$($Matches[1])-praha.html"
  }
  return $DefaultCanonical
}

function Write-Utf8File($Path, $Content) {
  try {
    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
  } catch {
    Set-Content -LiteralPath $Path -Encoding UTF8 -NoNewline -Value $Content
  }
}

function Html-Decode($Text) {
  [System.Net.WebUtility]::HtmlDecode([string]$Text)
}

function Html-Attr($Text) {
  [System.Net.WebUtility]::HtmlEncode((Html-Decode $Text).Trim())
}

function Strip-Html($Text) {
  $Decoded = Html-Decode $Text
  $Plain = $Decoded -replace "(?is)<script.*?</script>", " " -replace "(?is)<style.*?</style>", " " -replace "<[^>]+>", " "
  $Plain = $Plain -replace "\s+", " "
  return $Plain.Trim()
}

function Get-FirstMatch($Text, $Pattern) {
  $Match = [regex]::Match($Text, $Pattern, "IgnoreCase,Singleline")
  if ($Match.Success) { return $Match.Groups[1].Value.Trim() }
  return ""
}

function Get-RelativePath($FullName) {
  return $FullName.Substring($Root.Length).TrimStart("\", "/") -replace "\\", "/"
}

function Get-CanonicalPath($RelativePath) {
  if ($RelativePath -eq "index.html") { return "/" }
  if ($RelativePath -match "/index\.html$") { return "/" + ($RelativePath -replace "/index\.html$", "/") }
  return "/" + $RelativePath
}

function Get-CanonicalUrl($RelativePath) {
  $Path = Get-CanonicalPath $RelativePath
  return "$SiteUrl$Path"
}

function Get-PageType($RelativePath) {
  if ($RelativePath -eq "index.html") { return "website" }
  if ($RelativePath -like "blog/*") { return "article" }
  return "website"
}

function Get-ServiceName($RelativePath, $Title, $H1) {
  $Haystack = "$RelativePath $Title $H1".ToLowerInvariant()
  foreach ($Key in $ServiceKeywordOrder) {
    if ($Haystack -like "*$Key*") { return $ServiceKeywords[$Key] }
  }
  if ($Haystack -match "stroj") { return "Strojní omítky" }
  if ($Haystack -match "s[aá]drov") { return "Sádrové omítky" }
  if ($Haystack -match "[sš]tuk") { return "Štukové omítky" }
  if ($Haystack -match "v[aá]penocement") { return "Vápenocementové omítky" }
  if ($Haystack -match "zateplen") { return "Zateplení fasád" }
  if ($Haystack -match "fas[aá]d") { return "Fasádní práce" }
  return ""
}

function Get-FirstImage($Html, $CanonicalUrl) {
  $Src = Get-FirstMatch $Html '<img[^>]+src\s*=\s*"([^"]+)"'
  if ([string]::IsNullOrWhiteSpace($Src)) { return $DefaultImage }
  if ($Src -match "^https?://") { return $Src }
  try {
    return ([System.Uri]::new([System.Uri]$CanonicalUrl, $Src)).AbsoluteUri
  } catch {
    if ($Src.StartsWith("/")) { return "$SiteUrl$Src" }
    return "$SiteUrl/$Src"
  }
}

function Get-BreadcrumbItems($RelativePath, $Title, $CanonicalUrl) {
  $Items = New-Object System.Collections.Generic.List[object]
  $Items.Add([ordered]@{ "@type" = "ListItem"; position = 1; name = "Domů"; item = "$SiteUrl/" })

  if ($RelativePath -eq "index.html") { return $Items }

  if ($RelativePath -like "blog/*") {
    $Items.Add([ordered]@{ "@type" = "ListItem"; position = 2; name = "Blog"; item = "$SiteUrl/blog.html" })
    $Items.Add([ordered]@{ "@type" = "ListItem"; position = 3; name = $Title; item = $CanonicalUrl })
    return $Items
  }
  if ($RelativePath -like "lokality/*") {
    $Items.Add([ordered]@{ "@type" = "ListItem"; position = 2; name = "Lokality"; item = "$SiteUrl/lokality.html" })
    $Items.Add([ordered]@{ "@type" = "ListItem"; position = 3; name = $Title; item = $CanonicalUrl })
    return $Items
  }
  if ($RelativePath -like "realizace/*") {
    $Items.Add([ordered]@{ "@type" = "ListItem"; position = 2; name = "Realizace"; item = "$SiteUrl/realizace.html" })
    $Items.Add([ordered]@{ "@type" = "ListItem"; position = 3; name = $Title; item = $CanonicalUrl })
    return $Items
  }

  $Items.Add([ordered]@{ "@type" = "ListItem"; position = 2; name = $Title; item = $CanonicalUrl })
  return $Items
}

function Get-FaqItems($Html) {
  $Items = New-Object System.Collections.Generic.List[object]
  $Matches = [regex]::Matches($Html, "(?is)<details[^>]*>\s*<summary[^>]*>(.*?)</summary>(.*?)</details>")
  foreach ($Match in $Matches) {
    $Question = Strip-Html $Match.Groups[1].Value
    $Answer = Strip-Html $Match.Groups[2].Value
    if ($Question.Length -gt 3 -and $Answer.Length -gt 10) {
      $Items.Add([ordered]@{
        "@type" = "Question"
        name = $Question
        acceptedAnswer = [ordered]@{ "@type" = "Answer"; text = $Answer }
      })
    }
  }
  return $Items
}

function Get-ReviewItems($Html, $CanonicalUrl) {
  $Items = New-Object System.Collections.Generic.List[object]
  $Matches = [regex]::Matches($Html, "(?is)<div[^>]*class\s*=\s*""[^""]*\breview\b[^""]*""[^>]*>(.*?)</div>")
  $Position = 1
  foreach ($Match in $Matches) {
    $Inner = $Match.Groups[1].Value
    $Author = Strip-Html (Get-FirstMatch $Inner "<strong[^>]*>(.*?)</strong>")
    $Body = Strip-Html ($Inner -replace "(?is)<strong[^>]*>.*?</strong>", "")
    $Body = $Body.Trim().Trim('"')
    if ($Body.Length -gt 20) {
      if ([string]::IsNullOrWhiteSpace($Author)) { $Author = "Zákazník KOST STAV PRAHA" }
      $Items.Add([ordered]@{
        "@type" = "Review"
        "@id" = "$CanonicalUrl#review-$Position"
        itemReviewed = [ordered]@{ "@id" = "$SiteUrl/#localbusiness" }
        reviewBody = $Body
        author = [ordered]@{ "@type" = "Person"; name = $Author }
        reviewRating = [ordered]@{ "@type" = "Rating"; ratingValue = "5"; bestRating = "5"; worstRating = "1" }
      })
      $Position++
    }
    if ($Items.Count -ge 3) { break }
  }
  return $Items
}

function Build-JsonLd($RelativePath, $Title, $Description, $CanonicalUrl, $Html) {
  $Graph = New-Object System.Collections.Generic.List[object]
  $Image = Get-FirstImage $Html $CanonicalUrl
  $ServiceName = Get-ServiceName $RelativePath $Title (Strip-Html (Get-FirstMatch $Html "<h1[^>]*>(.*?)</h1>"))
  $FaqItems = @(Get-FaqItems $Html)
  $ReviewItems = @(Get-ReviewItems $Html $CanonicalUrl)
  $BreadcrumbItems = @(Get-BreadcrumbItems $RelativePath $Title $CanonicalUrl)

  $Graph.Add([ordered]@{
    "@type" = "WebSite"
    "@id" = "$SiteUrl/#website"
    url = "$SiteUrl/"
    name = $Company
    inLanguage = "cs-CZ"
    publisher = [ordered]@{ "@id" = "$SiteUrl/#localbusiness" }
  })

  $Graph.Add([ordered]@{
    "@type" = "LocalBusiness"
    "@id" = "$SiteUrl/#localbusiness"
    name = $Company
    url = "$SiteUrl/"
    image = @($DefaultImage)
    telephone = $PhoneCompact
    email = $Email
    priceRange = ('$' + '$')
    address = [ordered]@{
      "@type" = "PostalAddress"
      streetAddress = $Street
      addressLocality = $Locality
      addressCountry = $Country
    }
    areaServed = @($ServedAreas | ForEach-Object { [ordered]@{ "@type" = "Place"; name = $_ } })
    knowsAbout = @("strojní omítky Praha", "sádrové omítky Praha", "štukové omítky Praha", "vápenocementové omítky Praha", "zateplení fasád Praha", "fasádní práce Praha")
    sameAs = @("$SiteUrl/")
  })

  $Graph.Add([ordered]@{
    "@type" = "ImageObject"
    "@id" = "$CanonicalUrl#primaryimage"
    url = $Image
    contentUrl = $Image
    caption = "$Company - omítky a fasády"
  })

  $Graph.Add([ordered]@{
    "@type" = "WebPage"
    "@id" = "$CanonicalUrl#webpage"
    url = $CanonicalUrl
    name = $Title
    description = $Description
    inLanguage = "cs-CZ"
    isPartOf = [ordered]@{ "@id" = "$SiteUrl/#website" }
    about = [ordered]@{ "@id" = "$SiteUrl/#localbusiness" }
    primaryImageOfPage = [ordered]@{ "@id" = "$CanonicalUrl#primaryimage" }
    breadcrumb = [ordered]@{ "@id" = "$CanonicalUrl#breadcrumb" }
  })

  $Graph.Add([ordered]@{
    "@type" = "BreadcrumbList"
    "@id" = "$CanonicalUrl#breadcrumb"
    itemListElement = @($BreadcrumbItems)
  })

  if (![string]::IsNullOrWhiteSpace($ServiceName)) {
    $Graph.Add([ordered]@{
      "@type" = "Service"
      "@id" = "$CanonicalUrl#service"
      name = "$ServiceName | $Company"
      serviceType = $ServiceName
      url = $CanonicalUrl
      provider = [ordered]@{ "@id" = "$SiteUrl/#localbusiness" }
      areaServed = @($ServedAreas | Select-Object -First 12 | ForEach-Object { [ordered]@{ "@type" = "Place"; name = $_ } })
      description = $Description
    })
  }

  if ($FaqItems.Count -gt 0) {
    $Graph.Add([ordered]@{
      "@type" = "FAQPage"
      "@id" = "$CanonicalUrl#faq"
      mainEntity = @($FaqItems)
    })
  }

  foreach ($Review in $ReviewItems) {
    $Graph.Add($Review)
  }

  $Json = [ordered]@{
    "@context" = "https://schema.org"
    "@graph" = @($Graph.ToArray())
  } | ConvertTo-Json -Depth 30 -Compress

  return "<script type=""application/ld+json"">$Json</script>"
}

function Build-SeoHead($RelativePath, $Title, $Description, $CanonicalUrl, $Html, $Indexable) {
  $Image = Get-FirstImage $Html $CanonicalUrl
  $Type = Get-PageType $RelativePath
  $Robots = if ($Indexable) { "index,follow,max-image-preview:large" } else { "noindex,follow" }
  $JsonLd = if ($Indexable) { Build-JsonLd $RelativePath $Title $Description $CanonicalUrl $Html } else { "" }
@"
<meta name="robots" content="$Robots">
<link rel="canonical" href="$CanonicalUrl">
<meta property="og:type" content="$Type">
<meta property="og:locale" content="cs_CZ">
<meta property="og:site_name" content="$Company">
<meta property="og:title" content="$(Html-Attr $Title)">
<meta property="og:description" content="$(Html-Attr $Description)">
<meta property="og:url" content="$CanonicalUrl">
<meta property="og:image" content="$(Html-Attr $Image)">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="$(Html-Attr $Title)">
<meta name="twitter:description" content="$(Html-Attr $Description)">
<meta name="twitter:image" content="$(Html-Attr $Image)">
<link rel="preconnect" href="https://www.google.com">
<link rel="dns-prefetch" href="//www.google.com">
$JsonLd
"@
}

function Normalize-Head($Html, $RelativePath) {
  $Indexable = -not ($IndexExcluded -contains $RelativePath)
  $Title = Strip-Html (Get-FirstMatch $Html "<title[^>]*>(.*?)</title>")
  if ([string]::IsNullOrWhiteSpace($Title)) { $Title = Strip-Html (Get-FirstMatch $Html "<h1[^>]*>(.*?)</h1>") }
  if ([string]::IsNullOrWhiteSpace($Title)) { $Title = "$Company | Omítky a fasády Praha" }

  $Description = Html-Decode (Get-FirstMatch $Html '<meta\s+name="description"\s+content="([^"]*)"')
  if ([string]::IsNullOrWhiteSpace($Description)) {
    $Description = "KOST STAV PRAHA s.r.o. realizuje omítky, zateplení fasád a fasádní práce v Praze a Středočeském kraji."
  }
  if ($Description.Length -gt 165) { $Description = $Description.Substring(0, 162).TrimEnd() + "..." }

  $CanonicalUrl = Get-CanonicalUrl $RelativePath
  if (Is-DeprecatedPragueDistrict $RelativePath) {
    $Indexable = $false
    $CanonicalUrl = Get-DeprecatedCanonical $RelativePath $CanonicalUrl
  }
  $SeoHead = Build-SeoHead $RelativePath $Title $Description $CanonicalUrl $Html $Indexable

  $Html = [regex]::Replace($Html, '(?is)<meta\s+name="robots"[^>]*>\s*', '')
  $Html = [regex]::Replace($Html, '(?is)<link\s+rel="canonical"[^>]*>\s*', '')
  $Html = [regex]::Replace($Html, '(?is)<meta\s+property="og:[^"]+"[^>]*>\s*', '')
  $Html = [regex]::Replace($Html, '(?is)<meta\s+name="twitter:[^"]+"[^>]*>\s*', '')
  $Html = [regex]::Replace($Html, '(?is)<link\s+rel="preconnect"[^>]*>\s*', '')
  $Html = [regex]::Replace($Html, '(?is)<link\s+rel="dns-prefetch"[^>]*>\s*', '')
  $Html = [regex]::Replace($Html, '(?is)<script\s+type="application/ld\+json"[^>]*>.*?</script>\s*', '')

  $DescriptionMatch = [regex]::Match($Html, '(?is)<meta\s+name="description"[^>]*>\s*')
  if ($DescriptionMatch.Success) {
    $Html = $Html.Insert($DescriptionMatch.Index + $DescriptionMatch.Length, "$SeoHead`r`n")
  }
  if ($Html -notmatch 'property="og:title"') {
    $Html = $Html.Replace("</head>", "$SeoHead`r`n</head>")
  }
  return $Html
}

function Ensure-ContactLocalSeo($Html) {
  if ($Html -match 'google\.com/maps') { return $Html }
  $Section = @"
<section class="section-soft">
  <div class="container split">
    <div class="contactbox">
      <h2>Obsluhované lokality</h2>
      <p class="muted">Realizujeme strojní omítky, sádrové omítky, štukové omítky, vápenocementové omítky, zateplení fasád a fasádní práce v Praze a Středočeském kraji.</p>
      <div class="mini-links"><span>Praha</span><span>Praha-východ</span><span>Praha-západ</span><span>Kladno</span><span>Kolín</span><span>Beroun</span><span>Příbram</span><span>Mladá Boleslav</span></div>
    </div>
    <div class="map-card">
      <iframe title="Mapa KOST STAV PRAHA s.r.o." src="https://www.google.com/maps?q=K%20%C5%BDi%C5%BEkovu%20809%2F7%2C%20Praha%209%20Vyso%C4%8Dany&output=embed" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
    </div>
  </div>
</section>
"@
  return $Html -replace '(?is)</main>', "$Section`r`n</main>"
}

function Remove-LocalityAnchor($Block) {
  $Block = [regex]::Replace($Block, '(?is)<a\s+href="[^"]*lokality\.html"\s*>Lokality</a>\s*<br\s*/?>\s*', '')
  $Block = [regex]::Replace($Block, '(?is)<br\s*/?>\s*<a\s+href="[^"]*lokality\.html"\s*>Lokality</a>', '')
  $Block = [regex]::Replace($Block, '(?is)<a\s+href="[^"]*lokality\.html"\s*>Lokality</a>', '')
  return $Block
}

function Hide-VisibleLocalityNavigation($Html, $RelativePath) {
  $Html = [regex]::Replace($Html, '(?is)<div class="mini-links">.*?</div>', [System.Text.RegularExpressions.MatchEvaluator]{
    param($Match)
    [regex]::Replace($Match.Value, '(?is)<a\s+href="[^"]*lokality\.html"\s*>(.*?)</a>', '<span>$1</span>')
  })
  $Html = $Html.Replace('<a class="btn alt" href="lokality.html">Vybrat lokalitu</a>', '<a class="btn alt" href="poptavka.html">Nezávazná poptávka</a>')
  $Html = $Html.Replace('<a class="text-link" href="lokality.html">Vybrat lokalitu</a>', '<a class="text-link" href="poptavka.html">Nezávazná poptávka</a>')
  $Html = [regex]::Replace($Html, '(?is)<nav class="menu">.*?</nav>', [System.Text.RegularExpressions.MatchEvaluator]{
    param($Match)
    Remove-LocalityAnchor $Match.Value
  })
  $Html = [regex]::Replace($Html, '(?is)<footer class="footer">.*?</footer>', [System.Text.RegularExpressions.MatchEvaluator]{
    param($Match)
    Remove-LocalityAnchor $Match.Value
  })
  if ($RelativePath -ne "lokality.html" -and $RelativePath -notlike "lokality/*") {
    $Html = [regex]::Replace($Html, '(?is)<a([^>]*)href="[^"]*(?:lokality\.html|/?lokality/[^"]*)"([^>]*)>.*?</a>', '<a$1href="poptavka.html"$2>Nezávazná poptávka</a>')
  }
  return $Html
}

function Ensure-QuoteFormDelivery($Html) {
  $FormOpenPattern = '(?is)<form class="quote-form" data-poptavka-form(?:\s+action="[^"]*")?\s+method="POST"\s+enctype="[^"]*">\s*(?:<input type="hidden" name="_(?:subject|template|captcha|next)"[^>]*>\s*)*'
  $FormOpen = "<form class=""quote-form"" data-poptavka-form action=""$FormAction"" method=""POST"" enctype=""multipart/form-data"">`r`n"
  return [regex]::Replace($Html, $FormOpenPattern, $FormOpen)
}

function Remove-MailtoLinks($Html) {
  $MailPattern = '<a href="mai' + 'lto:[^"]*">([^<]+)</a>'
  return [regex]::Replace($Html, $MailPattern, '<span>$1</span>', "IgnoreCase")
}

function Ensure-ImagePerformance($Html) {
  $ImgIndex = 0
  $Html = [regex]::Replace($Html, '<img\b([^>]*)>', {
    param($Match)
    $Tag = $Match.Value
    $ImgIndex++
    if ($Tag -notmatch '\bdecoding=') { $Tag = $Tag -replace '<img\b', '<img decoding="async"' }
    if ($ImgIndex -eq 1 -and $Tag -notmatch '\bfetchpriority=') { $Tag = $Tag -replace '<img\b', '<img fetchpriority="high"' }
    if ($ImgIndex -gt 1 -and $Tag -notmatch '\bloading=') { $Tag = $Tag -replace '<img\b', '<img loading="lazy"' }
    if ($Tag -match 'images\.unsplash\.com' -and $Tag -notmatch 'fm=webp') {
      $Tag = $Tag -replace '(\?[^"]*)"', '$1&fm=webp"'
    }
    return $Tag
  }, "IgnoreCase")
  $Html = [regex]::Replace($Html, '<iframe\b([^>]*)>', {
    param($Match)
    $Tag = $Match.Value
    if ($Tag -notmatch '\bloading=') { $Tag = $Tag -replace '<iframe\b', '<iframe loading="lazy"' }
    return $Tag
  }, "IgnoreCase")
  return $Html
}

function Write-Sitemap($Pages) {
  $Entries = foreach ($Page in $Pages | Sort-Object Canonical) {
@"
  <url>
    <loc>$($Page.Canonical)</loc>
    <lastmod>$Today</lastmod>
    <changefreq>$($Page.ChangeFreq)</changefreq>
    <priority>$($Page.Priority)</priority>
  </url>
"@
  }
  $Xml = @"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
$($Entries -join "`r`n")
</urlset>
"@
  Write-Utf8File (Join-Path $Root "sitemap.xml") $Xml
}

function Write-Robots {
  $Robots = @"
User-agent: *
Allow: /
Disallow: /admin.html
Disallow: /404.html

Sitemap: $SiteUrl/sitemap.xml
"@
  try {
    Set-Content -LiteralPath (Join-Path $Root "robots.txt") -Encoding UTF8 -NoNewline -Value $Robots
  } catch {
    Write-Warning "robots.txt could not be updated automatically. Keeping the existing file."
  }
}

$HtmlFiles = Get-ChildItem -Path $Root -Recurse -Filter *.html | Where-Object {
  $RelativePath = Get-RelativePath $_.FullName
  $_.FullName -notmatch "\\\.agents\\" -and
    $_.FullName -notmatch "\\\.codex\\" -and
    $RelativePath -notlike "google*.html"
}

$SitemapPages = New-Object System.Collections.Generic.List[object]

foreach ($File in $HtmlFiles) {
  $RelativePath = Get-RelativePath $File.FullName
  $Html = [System.IO.File]::ReadAllText($File.FullName, [System.Text.Encoding]::UTF8)

  if ($RelativePath -eq "kontakt.html") { $Html = Ensure-ContactLocalSeo $Html }
  $Html = Hide-VisibleLocalityNavigation $Html $RelativePath
  $Html = Ensure-QuoteFormDelivery $Html
  $Html = Remove-MailtoLinks $Html
  $Html = Ensure-ImagePerformance $Html
  $Html = Normalize-Head $Html $RelativePath
  Write-Utf8File $File.FullName $Html

  if ($IndexExcluded -notcontains $RelativePath -and -not (Is-DeprecatedPragueDistrict $RelativePath)) {
    $Priority = "0.7"
    $ChangeFreq = "monthly"
    if ($RelativePath -eq "index.html") { $Priority = "1.0"; $ChangeFreq = "weekly" }
    elseif ($RelativePath -in @("omitky.html", "fasady.html", "sluzby.html", "poptavka.html", "kontakt.html", "lokality.html")) { $Priority = "0.9"; $ChangeFreq = "weekly" }
    elseif ($RelativePath -eq "lokality/strojni-omitky-praha.html") { $Priority = "0.95"; $ChangeFreq = "weekly" }
    elseif ($RelativePath -like "lokality/*") { $Priority = "0.8"; $ChangeFreq = "monthly" }
    elseif ($RelativePath -like "blog/*") { $Priority = "0.75"; $ChangeFreq = "monthly" }
    elseif ($RelativePath -like "realizace/*") { $Priority = "0.75"; $ChangeFreq = "monthly" }
    $SitemapPages.Add([pscustomobject]@{
      Relative = $RelativePath
      Canonical = Get-CanonicalUrl $RelativePath
      Priority = $Priority
      ChangeFreq = $ChangeFreq
    })
  }
}

Write-Sitemap $SitemapPages
Write-Robots

Write-Host "SEO build complete. HTML pages processed: $($HtmlFiles.Count). Sitemap URLs: $($SitemapPages.Count)."


