$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$SiteUrl = "https://www.kost-stav.cz"
$Company = "KOST STAV PRAHA s.r.o."
$Phone = "+420 777 977 571"
$PhoneHref = "tel:+420777977571"
$WhatsApp = "https://wa.me/420777977571"
$Email = "omitkykoststav@gmail.com"
$LastMod = (Get-Date -Format "yyyy-MM-dd")
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$DataPath = Join-Path $Root "data\realizace.json"
$RealizaceDir = Join-Path $Root "realizace"

$ServiceMeta = @{
  "Strojní sádrové omítky" = @{
    generic = "Strojní omítky"; lower = "strojní omítky"; h1 = "strojních omítek"; localitySlug = "strojni-omitky";
    benefits = @("rychlá aplikace na větších plochách", "velmi dobrá rovinnost stěn", "čisté rohy, špalety a napojení detailů", "povrch připravený pro malbu a další úpravy")
  }
  "Štukové omítky" = @{
    generic = "Štukové omítky"; lower = "štukové omítky"; h1 = "štukových omítek"; localitySlug = "stukove-omitky";
    benefits = @("klasický jemný povrch", "dobrá opravitelnost", "sjednocení starších i nových podkladů", "přirozený vzhled interiéru")
  }
  "Vápenocementové omítky" = @{
    generic = "Vápenocementové omítky"; lower = "vápenocementové omítky"; h1 = "vápenocementových omítek"; localitySlug = "vapenocementove-omitky";
    benefits = @("vyšší mechanická odolnost", "vhodnost do technických a vlhčích prostor", "pevný minerální podklad", "dobrá návaznost na obklady a další vrstvy")
  }
  "Zateplení fasády" = @{
    generic = "Zateplení fasády"; lower = "zateplení fasády"; h1 = "zateplení fasády"; localitySlug = "zatepleni-fasad";
    benefits = @("nižší tepelné ztráty", "lepší ochrana obvodového zdiva", "moderní vzhled domu", "správné řešení detailů kolem oken a soklu")
  }
  "Fasádní omítka" = @{
    generic = "Fasádní omítka"; lower = "fasádní omítka"; h1 = "fasádní omítky"; localitySlug = "fasadni-prace";
    benefits = @("sjednocený vzhled fasády", "ochrana povrchu před počasím", "čisté zakončení hran a detailů", "možnost navázání na opravy fasády")
  }
  "Oprava fasády" = @{
    generic = "Fasádní práce"; lower = "oprava fasády"; h1 = "opravy fasády"; localitySlug = "fasadni-prace";
    benefits = @("obnova poškozených míst", "sjednocení podkladu", "lepší ochrana povrchu", "navázání na finální fasádní omítku")
  }
  "Sokl fasády" = @{
    generic = "Fasádní práce"; lower = "sokl fasády"; h1 = "soklu fasády"; localitySlug = "fasadni-prace";
    benefits = @("odolné provedení namáhané části domu", "čistý detail u terénu", "lepší ochrana před vlhkostí", "vzhledové sjednocení fasády")
  }
  "Kombinace služeb" = @{
    generic = "Omítky a fasády"; lower = "omítky a fasády"; h1 = "omítek a fasád"; localitySlug = "strojni-omitky";
    benefits = @("jeden koordinovaný harmonogram", "lepší návaznost omítek a fasády", "jednodušší komunikace", "přehlednější kontrola kvality")
  }
}

$LocationPhrases = @{
  "Praha 1" = "v Praze 1"; "Praha 2" = "v Praze 2"; "Praha 3" = "v Praze 3"; "Praha 4" = "v Praze 4"; "Praha 5" = "v Praze 5"; "Praha 6" = "v Praze 6"; "Praha 7" = "v Praze 7"; "Praha 8" = "v Praze 8"; "Praha 9" = "v Praze 9"; "Praha 10" = "v Praze 10";
  "Kladno" = "v Kladně"; "Beroun" = "v Berouně"; "Benešov" = "v Benešově"; "Kolín" = "v Kolíně"; "Kutná Hora" = "v Kutné Hoře"; "Nymburk" = "v Nymburce"; "Mladá Boleslav" = "v Mladé Boleslavi"; "Mělník" = "v Mělníku"; "Brandýs nad Labem" = "v Brandýse nad Labem"; "Čelákovice" = "v Čelákovicích"; "Lysá nad Labem" = "v Lysé nad Labem"; "Milovice" = "v Milovicích"; "Poděbrady" = "v Poděbradech"; "Český Brod" = "v Českém Brodě"; "Říčany" = "v Říčanech"; "Jesenice" = "v Jesenici"; "Hostivice" = "v Hostivici"; "Roztoky" = "v Roztokách"; "Rudná" = "v Rudné"; "Dobříš" = "v Dobříši"; "Příbram" = "v Příbrami"; "Hořovice" = "v Hořovicích"; "Slaný" = "ve Slaném"; "Kralupy nad Vltavou" = "v Kralupech nad Vltavou"; "Neratovice" = "v Neratovicích"; "Mnichovo Hradiště" = "v Mnichově Hradišti"; "Benátky nad Jizerou" = "v Benátkách nad Jizerou"; "Vlašim" = "ve Vlašimi"; "Sedlčany" = "v Sedlčanech"; "Unhošť" = "v Unhošti"; "Rakovník" = "v Rakovníku";
  "Praha-východ" = "v okrese Praha-východ"; "Praha-západ" = "v okrese Praha-západ"
}

function Location-Phrase($City) {
  if ($LocationPhrases.ContainsKey([string]$City)) { return $LocationPhrases[[string]$City] }
  return "v lokalitě $City"
}

function Write-Utf8File($Path, $Content) {
  $Dir = Split-Path -Parent $Path
  if ($Dir -and !(Test-Path $Dir)) { New-Item -ItemType Directory -Force -Path $Dir | Out-Null }
  [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

function Escape-Html($Text) {
  [System.Net.WebUtility]::HtmlEncode([string]$Text)
}

function Image-Path($Src, $Prefix) {
  $Value = [string]$Src
  if ([string]::IsNullOrWhiteSpace($Value)) { return "" }
  if ($Value -match "^https?://" -or $Value.StartsWith("/")) { return $Value }
  return "$Prefix$Value"
}

function Image-Url($Src) {
  $Value = [string]$Src
  if ([string]::IsNullOrWhiteSpace($Value)) { return "$SiteUrl/assets/images/moderni-exterier-rodinneho-domu.jpg" }
  if ($Value -match "^https?://") { return $Value }
  if ($Value.StartsWith("/")) { return "$SiteUrl$Value" }
  return "$SiteUrl/$Value"
}

function Get-Array($Value) {
  if ($null -eq $Value) { return @() }
  if ($Value -is [System.Array]) { return @($Value) }
  return @($Value)
}

function Slugify($Text) {
  $Normalized = ([string]$Text).Normalize([System.Text.NormalizationForm]::FormD)
  $Builder = New-Object System.Text.StringBuilder
  foreach ($Char in $Normalized.ToCharArray()) {
    if ([System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($Char) -ne [System.Globalization.UnicodeCategory]::NonSpacingMark) {
      [void]$Builder.Append($Char)
    }
  }
  $Ascii = $Builder.ToString().ToLowerInvariant()
  $Ascii = $Ascii -replace "[^a-z0-9]+", "-"
  $Ascii = $Ascii.Trim("-")
  if ([string]::IsNullOrWhiteSpace($Ascii)) { return "realizace" }
  return $Ascii
}

function Get-PrimaryMeta($Project) {
  $Priority = @("Strojní sádrové omítky", "Zateplení fasády", "Fasádní omítka", "Vápenocementové omítky", "Štukové omítky", "Oprava fasády", "Sokl fasády", "Kombinace služeb")
  $Services = Get-Array $Project.services
  foreach ($Name in $Priority) {
    if ($Services -contains $Name -and $ServiceMeta.ContainsKey($Name)) { return [pscustomobject]$ServiceMeta[$Name] }
  }
  return [pscustomobject]$ServiceMeta["Strojní sádrové omítky"]
}

function Build-Faq($Project, $Meta) {
  @(
    [pscustomobject]@{ question = "Jaký typ prací byl realizován v lokalitě $($Project.city)?"; answer = "Realizace zahrnovala $($Meta.lower) a související omítkářské nebo fasádní práce podle rozsahu zakázky." },
    [pscustomobject]@{ question = "Jaká byla přibližná plocha realizace?"; answer = "Přibližná plocha projektu byla $($Project.area) m². Přesná cena se vždy odvíjí od stavu podkladu, členitosti a dostupnosti stavby." },
    [pscustomobject]@{ question = "Kdy byla realizace dokončena?"; answer = "Projekt byl veden jako realizace roku $($Project.year). Termín u podobných zakázek stanovujeme po zaměření a kontrole připravenosti stavby." },
    [pscustomobject]@{ question = "Umíte připravit podobnou realizaci v okolí?"; answer = "$Company realizuje omítky a fasády v Praze, ve Středočeském kraji i v okolních městech." },
    [pscustomobject]@{ question = "Co poslat pro rychlou cenovou nabídku?"; answer = "Nejlepší je poslat město, přibližnou plochu v m², fotografie stavby, požadovaný termín a případně projektovou dokumentaci." }
  )
}

function Build-SeoText($Project, $Meta) {
  $Services = (Get-Array $Project.services) -join ", "
  $Materials = (Get-Array $Project.materials) -join ", "
  if ([string]::IsNullOrWhiteSpace($Materials)) { $Materials = "ověřené omítkové a fasádní materiály" }
@"
Realizace v lokalitě $($Project.city) patří mezi ukázky práce, kde je důležitá dobrá příprava, přesné zaměření a pečlivé dokončení detailů. V roce $($Project.year) jsme zde řešili projekt typu $($Project.realizationType) o přibližné ploše $($Project.area) m². Zakázka zahrnovala služby $Services a byla navržena tak, aby výsledný povrch dobře fungoval při běžném užívání domu i při navazujících dokončovacích pracích.

Před zahájením jsme posoudili stav podkladu, přístup na stavbu, návaznost dalších profesí a požadovaný termín dokončení. U realizací omítek a fasád se vyplatí nepodcenit přípravu, protože právě ta rozhoduje o rovinnosti, soudržnosti vrstev, čistotě rohů, špalet, soklů a detailů kolem oken. Díky tomu lze předejít zbytečným opravám a investor má jasnou představu o průběhu prací.

Pro projekt v lokalitě $($Project.city) jsme zvolili materiály odpovídající rozsahu a technickým požadavkům stavby. Použité materiály zahrnovaly $Materials. Důležitá byla také ochrana okolních ploch, průběžná kontrola napojení a dodržení technologických přestávek. U omítek sledujeme především savost a pevnost podkladu, u fasád správnou skladbu systému, kotvení, armovací vrstvu a finální povrch.

Hlavní výhodou řešení jako $($Meta.lower) je spolehlivý výsledek, dobrá návaznost na další práce a přehledný průběh realizace. U zákazníků v Praze a Středočeském kraji se často setkáváme s tím, že chtějí rychlou realizaci, ale zároveň potřebují kvalitní výsledek bez kompromisů. Proto vždy vysvětlujeme, které kroky lze urychlit a kde je naopak nutné dodržet technologický postup.

Během realizace jsme průběžně kontrolovali rovinnost, kvalitu detailů a návaznost na další povrchové úpravy. U větších ploch je důležité rozdělit práci do logických etap, aby materiál správně vyzrál a aby se na stavbě zbytečně nekřížily profese. Investor tak má přehled o tom, kdy je možné pokračovat malbou, montáží zařizovacích prvků nebo dalšími pracemi na fasádě.

Při plánování podobné zakázky se vyplatí připravit co nejvíce informací už před prvním zaměřením. Pomáhá orientační výměra, fotografie aktuálního stavu, informace o typu zdiva, dokončených rozvodech a požadovaném termínu. Díky tomu lze rychleji určit vhodný materiál, předpokládanou délku realizace a místa, která mohou cenu nebo harmonogram ovlivnit.

Kvalita realizace se nepozná jen podle velké plochy stěny nebo fasády. Rozhodují také rohy, přechody mezi materiály, špalety, dilatační místa, sokl, ostění a návaznost na okna nebo dveře. Právě těmto detailům věnujeme pozornost, protože bývají nejvíce vidět a zároveň mají velký vliv na životnost výsledného povrchu.

U omítek i fasád je důležité dodržet technologické přestávky a nepřekrývat vrstvy dříve, než je podklad připravený. Rychlost práce proto vždy vyvažujeme správným postupem. Cílem není pouze dokončit zakázku rychle, ale předat povrch, který bude stabilní, rovný, čistý a připravený na běžné užívání bez zbytečných dodatečných oprav.

Realizace v lokalitě $($Project.city) zároveň dobře ukazuje, proč je vhodné řešit omítky a fasádní práce s firmou, která umí navrhnout celý postup v souvislostech. Pokud se na stavbě kombinuje více typů prací, například vnitřní omítky, opravy podkladu, zateplení fasády nebo finální omítka, pomáhá jeden koordinovaný harmonogram a jasná odpovědnost za výsledek.

Výsledkem je realizace, která odpovídá požadavkům na poctivé omítky a fasádní práce v lokalitě $($Project.city). $Company zajišťuje podobné zakázky v okrese $($Project.district), v celé Praze a ve Středočeském kraji. Pokud řešíte podobný rozsah, pošlete nám město, přibližnou plochu v m², fotografie stavby a případně projektovou dokumentaci. Připravíme nezávaznou cenovou nabídku a doporučíme vhodný postup.
"@
}

function Ensure-Seo($Project) {
  $Meta = Get-PrimaryMeta $Project
  $Seo = if ($Project.PSObject.Properties.Name -contains "seo" -and $null -ne $Project.seo) { $Project.seo } else { [pscustomobject]@{} }
  $Title = if ($Seo.PSObject.Properties.Name -contains "title" -and ![string]::IsNullOrWhiteSpace($Seo.title)) { $Seo.title } else { "$($Meta.generic) $($Project.city) | Realizace $($Project.year) | KOST STAV PRAHA" }
  $Desc = if ($Seo.PSObject.Properties.Name -contains "description" -and ![string]::IsNullOrWhiteSpace($Seo.description)) { $Seo.description } else { "Provedli jsme $($Meta.lower) v lokalitě $($Project.city). Plocha $($Project.area) m². Kvalitní realizace omítek a fasád v Praze a Středočeském kraji." }
  $H1 = if ($Seo.PSObject.Properties.Name -contains "h1" -and ![string]::IsNullOrWhiteSpace($Seo.h1)) { $Seo.h1 } else { "Realizace $($Meta.h1) $(Location-Phrase $Project.city)" }
  $Text = if ($Seo.PSObject.Properties.Name -contains "text" -and ![string]::IsNullOrWhiteSpace($Seo.text)) { $Seo.text } else { Build-SeoText $Project $Meta }
  $Faq = if ($Seo.PSObject.Properties.Name -contains "faq" -and (Get-Array $Seo.faq).Count -gt 0) { Get-Array $Seo.faq } else { Build-Faq $Project $Meta }
  [pscustomobject]@{ title = $Title; description = $Desc; h1 = $H1; text = $Text; faq = $Faq; meta = $Meta }
}

function Header-Html($Prefix) {
@"
<header class="top"><div class="container nav"><a class="logo" href="${Prefix}index.html">$Company<span>omítky a fasády Praha a Středočeský kraj</span></a><nav class="menu"><a href="${Prefix}index.html">Domů</a><a href="${Prefix}o-nas.html">O nás</a><a href="${Prefix}sluzby.html">Služby</a><a href="${Prefix}realizace.html">Realizace</a><a href="${Prefix}blog.html">Blog</a><a href="${Prefix}reference.html">Reference</a><a href="${Prefix}kontakt.html">Kontakt</a><a class="btn" href="$PhoneHref">Zavolat</a></nav></div></header>
"@
}

function Footer-Html($Prefix) {
@"
<a class="whatsapp" href="$WhatsApp">WhatsApp</a><footer class="footer"><div class="container footgrid"><div><h3>$Company</h3><p class="muted">Poctivé strojní omítky, sádrové omítky, štukové omítky, vápenocementové omítky, zateplení fasád a fasádní práce v Praze a Středočeském kraji.</p></div><div><h3>Rychlé odkazy</h3><p><a href="${Prefix}sluzby.html">Služby</a><br><a href="${Prefix}realizace.html">Realizace</a><br><a href="${Prefix}blog.html">Blog</a><br><a href="${Prefix}kontakt.html">Kontakt</a></p></div><div><h3>Kontakt</h3><p>K Žižkovu 809/7, Praha 9 – Vysočany<br><a href="$PhoneHref">$Phone</a><br><span>$Email</span></p></div></div><div class="container"><p class="muted">© 2026 $Company Všechna práva vyhrazena.</p></div></footer><script src="${Prefix}ui.js" defer></script>
"@
}

function Cta-Html($Prefix) {
@"
<section class="cta"><div class="container box"><h2>Zavolejte nám ještě dnes a získejte nezávaznou cenovou nabídku zdarma.</h2><p class="muted">Pošlete nám lokalitu, plochu v m², fotografie stavby nebo projektovou dokumentaci.</p><div class="actions" style="justify-content:center"><a class="btn" href="$PhoneHref">$Phone</a><a class="btn alt" href="${Prefix}kontakt.html">Odeslat poptávku</a></div></div></section>
"@
}

function Service-Links($Project, $Prefix) {
  $Links = foreach ($Service in (Get-Array $Project.services)) {
    $Meta = if ($ServiceMeta.ContainsKey($Service)) { [pscustomobject]$ServiceMeta[$Service] } else { Get-PrimaryMeta $Project }
    $Href = if ($Meta.localitySlug -in @("zatepleni-fasad", "fasadni-prace")) { "${Prefix}fasady.html" } else { "${Prefix}omitky.html" }
    "<a href=""$Href"">$([System.Net.WebUtility]::HtmlEncode($Meta.generic))</a>"
  }
  if (!$Links) { return "<a href=""${Prefix}sluzby.html"">Služby omítek a fasád</a>" }
  return ($Links -join "")
}

function Gallery-Html($Project, $Prefix) {
  $Images = @()
  if (![string]::IsNullOrWhiteSpace($Project.mainPhoto)) { $Images += $Project.mainPhoto }
  $Images += Get-Array $Project.gallery
  $Images = $Images | Where-Object { ![string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique
  if (!$Images) { return "<p class=""muted"">Fotogalerie bude doplněna.</p>" }
  (($Images | ForEach-Object { "<img src=""$(Escape-Html (Image-Path $_ $Prefix))"" loading=""lazy"" decoding=""async"" alt=""Realizace $([System.Net.WebUtility]::HtmlEncode($Project.title))"">" }) -join "")
}

function Materials-Html($Project) {
  $Materials = Get-Array $Project.materials
  if (!$Materials) { $Materials = @("omítkové a fasádní materiály podle stavu podkladu", "penetrace a příprava povrchu", "profily, výztužné a ochranné prvky") }
  (($Materials | ForEach-Object { "<li>$(Escape-Html $_)</li>" }) -join "")
}

function Benefits-Html($Meta) {
  (($Meta.benefits | ForEach-Object { "<div>$(Escape-Html $_)</div>" }) -join "")
}

function Similar-Html($Project, $AllProjects, $Prefix) {
  $ProjectServices = Get-Array $Project.services
  $Similar = @($AllProjects | Where-Object {
    $_.slug -ne $Project.slug -and $_.status -ne "draft" -and (
      $_.city -eq $Project.city -or @((Get-Array $_.services) | Where-Object { $ProjectServices -contains $_ }).Count -gt 0
    )
  } | Select-Object -First 3)
  if (!$Similar.Count) { return "<p class=""muted"">Další podobné realizace budou doplněny.</p>" }
  (($Similar | ForEach-Object {
    $Thumb = Image-Path $_.mainPhoto $Prefix
@"
<article class="card realization-card"><a class="realization-thumb" href="../$($_.slug)/" style="background-image:url('$(Escape-Html $Thumb)')"></a><h3><a href="../$($_.slug)/">$(Escape-Html $_.title)</a></h3><p>$(Escape-Html $_.city) · $(Escape-Html $_.year) · $(Escape-Html $_.area) m²</p><a class="text-link" href="../$($_.slug)/">Detail realizace</a></article>
"@
  }) -join "")
}

function Faq-Html($FaqItems) {
  (($FaqItems | ForEach-Object { "<details><summary>$(Escape-Html $_.question)</summary><p>$(Escape-Html $_.answer)</p></details>" }) -join "")
}

function Quote-Form($Project, $Meta) {
  $IsFacade = $Meta.localitySlug -in @("zatepleni-fasad", "fasadni-prace")
  $OmitkyChecked = if ($IsFacade) { "" } else { " checked" }
  $FasadyChecked = if ($IsFacade) { " checked" } else { "" }
  $OmitkyHidden = if ($IsFacade) { " hidden" } else { "" }
  $FasadyHidden = if ($IsFacade) { "" } else { " hidden" }
  $OmitkyDisabled = if ($IsFacade) { " disabled" } else { "" }
  $FasadyDisabled = if ($IsFacade) { "" } else { " disabled" }
  $Services = Get-Array $Project.services
  $Strojni = if ($Services -contains "Strojní sádrové omítky") { " checked" } else { "" }
  $Stuk = if ($Services -contains "Štukové omítky") { " checked" } else { "" }
  $Vapen = if ($Services -contains "Vápenocementové omítky") { " checked" } else { "" }
  $Zatepleni = if ($Services -contains "Zateplení fasády") { " checked" } else { "" }
  $Fasada = if ($Services -contains "Fasádní omítka") { " checked" } else { "" }
@"
<form class="quote-form" data-poptavka-form method="POST" enctype="multipart/form-data">
  <div class="form-section"><h3>Kontakt</h3><div class="form-grid"><div class="form-field"><label>Jméno a příjmení<input name="jmeno" autocomplete="name" required></label></div><div class="form-field"><label>Telefon<input name="telefon" type="tel" autocomplete="tel" required></label></div><div class="form-field"><label>E-mail<input name="email" type="email" autocomplete="email"></label></div><div class="form-field"><label>Adresa stavby / obec<input name="adresa_stavby" value="$(Escape-Html $Project.city)" required></label></div></div></div>
  <div class="form-section"><h3>Typ práce</h3><div class="choice-grid"><label class="choice-pill"><input type="radio" name="typ_prace" value="omitky"$OmitkyChecked> Omítky</label><label class="choice-pill"><input type="radio" name="typ_prace" value="fasady"$FasadyChecked> Fasády</label></div><div data-specific-group="omitky"$OmitkyHidden><p class="form-label">Konkrétní typ omítky</p><div class="choice-grid"><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Strojní sádrové omítky"$Strojni$OmitkyDisabled> Strojní sádrové omítky</label><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Štukové omítky"$Stuk$OmitkyDisabled> Štukové omítky</label><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Vápenocementové omítky"$Vapen$OmitkyDisabled> Vápenocementové omítky</label></div></div><div data-specific-group="fasady"$FasadyHidden><p class="form-label">Konkrétní typ fasády</p><div class="choice-grid"><label class="choice-pill"><input type="checkbox" name="typ_fasady[]" value="Zateplení fasády"$Zatepleni$FasadyDisabled> Zateplení fasády</label><label class="choice-pill"><input type="checkbox" name="typ_fasady[]" value="Fasádní omítka"$Fasada$FasadyDisabled> Fasádní omítka</label><label class="choice-pill"><input type="checkbox" name="typ_fasady[]" value="Sokl fasády"$FasadyDisabled> Sokl fasády</label></div></div></div>
  <div class="form-section"><h3>Parametry</h3><p class="form-label">Novostavba nebo rekonstrukce</p><div class="choice-grid"><label class="choice-pill"><input type="radio" name="stav_objektu" value="Novostavba" required> Novostavba</label><label class="choice-pill"><input type="radio" name="stav_objektu" value="Rekonstrukce" required> Rekonstrukce</label></div><div class="form-grid"><div class="form-field"><label>Přibližná plocha v m²<input name="plocha" type="number" min="1" value="$(Escape-Html $Project.area)"></label></div><div class="form-field"><label>Požadovaný termín realizace<input name="termin" placeholder="např. jaro 2026"></label></div></div><div class="form-field"><label>Popis zakázky<textarea name="popis">Mám zájem o podobnou realizaci jako $(Escape-Html $Project.title).</textarea></label></div><div class="form-field"><label>Nahrání souborů / fotek / projektové dokumentace<input class="file-input" name="prilohy[]" type="file" multiple accept="image/*,.pdf,.dwg,.dxf"></label></div></div>
  <label class="muted consent"><input type="checkbox" name="souhlas" required> Souhlasím se zpracováním osobních údajů pro vyřízení poptávky.</label><div class="form-alert" data-form-alert role="status" aria-live="polite"></div><button class="btn" type="submit">Odeslat poptávku</button>
</form>
"@
}

function Project-Page($Project, $AllProjects) {
  $Seo = Ensure-Seo $Project
  $Meta = $Seo.meta
  $Canonical = "$SiteUrl/realizace/$($Project.slug)/"
  $Header = Header-Html "../../"
  $Footer = Footer-Html "../../"
  $Cta = Cta-Html "../../"
  $Gallery = Gallery-Html $Project "../../"
  $Materials = Materials-Html $Project
  $Benefits = Benefits-Html $Meta
  $Faq = Faq-Html $Seo.faq
  $Similar = Similar-Html $Project $AllProjects "../../"
  $Links = Service-Links $Project "../../"
  $Form = Quote-Form $Project $Meta
  $MainPhoto = Image-Path $Project.mainPhoto "../../"
  $SeoTextHtml = (($Seo.text -split "(\r?\n){2,}" | Where-Object { ![string]::IsNullOrWhiteSpace($_) }) | ForEach-Object { "<p>$(Escape-Html $_)</p>" }) -join ""
  $Schema = @{
    "@context" = "https://schema.org"
    "@type" = "CreativeWork"
    name = $Project.title
    headline = $Seo.h1
    description = $Seo.description
    url = $Canonical
    image = Image-Url $Project.mainPhoto
    about = Get-Array $Project.services
    spatialCoverage = $Project.city
    dateCreated = "$($Project.year)-01-01"
    creator = @{ "@type" = "Organization"; name = $Company; url = $SiteUrl }
  } | ConvertTo-Json -Depth 8 -Compress
@"
<!doctype html>
<html lang="cs">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>$(Escape-Html $Seo.title)</title>
  <meta name="description" content="$(Escape-Html $Seo.description)">
  <link rel="canonical" href="$Canonical">
  <link rel="stylesheet" href="../../styles.css">
  <script src="../../poptavka.js" defer></script>
  <script type="application/ld+json">$Schema</script>
</head>
<body>
$Header
<main>
  <section class="project-hero" style="background-image:linear-gradient(90deg,rgba(9,13,20,.88),rgba(9,13,20,.52)),url('$(Escape-Html $MainPhoto)')">
    <div class="container">
      <p class="breadcrumb"><a href="../../index.html">Domů</a> / <a href="../../realizace.html">Realizace</a> / $(Escape-Html $Project.city)</p>
      <h1>$(Escape-Html $Seo.h1)</h1>
      <p>$(Escape-Html $Seo.description)</p>
      <div class="actions"><a class="btn" href="$PhoneHref">Zavolat $Phone</a><a class="btn alt" href="$WhatsApp">WhatsApp poptávka</a></div>
    </div>
  </section>
  <section>
    <div class="container seo-layout">
      <article class="seo-article">
        <h2>Popis projektu</h2>
        <p>$(Escape-Html $Project.description)</p>
        $SeoTextHtml
        <h2>Použité materiály</h2>
        <ul>$Materials</ul>
        <h2>Výhody realizace</h2>
        <div class="list">$Benefits</div>
      </article>
      <aside class="contactbox seo-sidebox">
        <h2>Parametry realizace</h2>
        <dl class="project-params">
          <dt>Město</dt><dd>$(Escape-Html $Project.city)</dd>
          <dt>Okres</dt><dd>$(Escape-Html $Project.district)</dd>
          <dt>Rok</dt><dd>$(Escape-Html $Project.year)</dd>
          <dt>Plocha</dt><dd>$(Escape-Html $Project.area) m²</dd>
          <dt>Typ</dt><dd>$(Escape-Html $Project.realizationType)</dd>
        </dl>
        <h3>Interní odkazy</h3>
        <div class="mini-links">$Links</div>
      </aside>
    </div>
  </section>
  <section class="section-soft">
    <div class="container">
      <div class="section-head"><h2>Fotogalerie</h2><p>Ukázky průběhu a výsledku realizace.</p></div>
      <div class="project-gallery">$Gallery</div>
    </div>
  </section>
  <section>
    <div class="container">
      <div class="section-head"><h2>FAQ</h2><p>Nejčastější otázky k podobné realizaci.</p></div>
      <div class="faq">$Faq</div>
    </div>
  </section>
  <section class="section-soft">
    <div class="container">
      <div class="section-head"><h2>Další podobné realizace</h2><p>Interní prolinkování podle služby a města.</p></div>
      <div class="grid">$Similar</div>
    </div>
  </section>
  <section>
    <div class="container split">
      <div>
        <h2>Chcete podobnou realizaci?</h2>
        <p class="quote-intro">Rádi Vám spočítáme nezávaznou cenovou nabídku na omítky nebo fasádu. Vyplňte prosím krátký formulář a my se Vám co nejdříve ozveme.</p>
        <p class="quote-help">Pro přesnější kalkulaci nám prosím pošlete plochu v m², fotky stavby, případně projektovou dokumentaci.</p>
      </div>
      <div class="contactbox">$Form</div>
    </div>
  </section>
  $Cta
</main>
$Footer
</body>
</html>
"@
}

function Listing-Page($Projects) {
  $Header = Header-Html ""
  $Footer = Footer-Html ""
  $Cards = (($Projects | ForEach-Object {
    $Services = (Get-Array $_.services | Select-Object -First 3) -join ", "
    $Thumb = Image-Path $_.mainPhoto ""
@"
<article class="card realization-card"><a class="realization-thumb" href="realizace/$($_.slug)/" style="background-image:url('$(Escape-Html $Thumb)')"></a><h3><a href="realizace/$($_.slug)/">$(Escape-Html $_.title)</a></h3><p>$(Escape-Html $_.city) · $(Escape-Html $_.year) · $(Escape-Html $_.area) m²</p><p>$(Escape-Html $Services)</p><a class="text-link" href="realizace/$($_.slug)/">Detail realizace</a></article>
"@
  }) -join "")
@"
<!doctype html>
<html lang="cs">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Realizace omítek a fasád | KOST STAV PRAHA s.r.o.</title>
  <meta name="description" content="Realizace strojních omítek, štukových omítek, vápenocementových omítek, zateplení fasád a fasádních prací v Praze a Středočeském kraji.">
  <link rel="canonical" href="$SiteUrl/realizace.html">
  <link rel="stylesheet" href="styles.css">
</head>
<body>
$Header
<main>
  <section class="pagehead">
    <div class="container">
      <p class="breadcrumb"><a href="index.html">Domů</a> / Realizace</p>
      <h1>Realizace omítek a fasád</h1>
      <p class="muted">Přehled dokončených projektů KOST STAV PRAHA s.r.o. Každá realizace obsahuje fotogalerii, parametry, materiály, SEO text, FAQ a interní odkazy na služby i lokality.</p>
    </div>
  </section>
  <section>
    <div class="container">
      <div class="grid">$Cards</div>
    </div>
  </section>
</main>
$Footer
</body>
</html>
"@
}

function Update-Sitemap {
  $Entries = @()
  $HtmlFiles = Get-ChildItem -Path $Root -Recurse -Filter *.html | Where-Object {
    $Rel = $_.FullName.Substring($Root.Length).TrimStart("\", "/") -replace "\\", "/"
    $Rel -ne "admin.html" -and $Rel -notlike "google*.html"
  }

  foreach ($File in ($HtmlFiles | Sort-Object FullName)) {
    $Rel = $File.FullName.Substring($Root.Length).TrimStart("\", "/") -replace "\\", "/"
    if ($Rel -match "^realizace/([^/]+)/index\.html$") {
      $Loc = "$SiteUrl/realizace/$($Matches[1])/"
      $Priority = "0.8"
    } else {
      $Loc = "$SiteUrl/$Rel"
      $Priority = if ($Rel -eq "index.html") { "1.0" } elseif ($Rel -eq "realizace.html") { "0.8" } elseif ($Rel.StartsWith("lokality/")) { "0.7" } else { "0.7" }
    }
    $Entries += "  <url>`n    <loc>$Loc</loc>`n    <lastmod>$LastMod</lastmod>`n    <changefreq>weekly</changefreq>`n    <priority>$Priority</priority>`n  </url>"
  }

  $Xml = "<?xml version=""1.0"" encoding=""UTF-8""?>`n<urlset xmlns=""http://www.sitemaps.org/schemas/sitemap/0.9"">`n$($Entries -join "`n")`n</urlset>`n"
  Write-Utf8File (Join-Path $Root "sitemap.xml") $Xml
}

if (!(Test-Path $DataPath)) {
  throw "Soubor data/realizace.json neexistuje."
}

if (!(Test-Path $RealizaceDir)) {
  New-Item -ItemType Directory -Force -Path $RealizaceDir | Out-Null
}

$Projects = Get-Content -Raw -Encoding UTF8 -Path $DataPath | ConvertFrom-Json
$Published = @($Projects | Where-Object { $_.status -ne "draft" } | Sort-Object year -Descending)

foreach ($Project in $Published) {
  if ([string]::IsNullOrWhiteSpace($Project.slug)) {
    $Project.slug = Slugify "$($Project.title) $($Project.city) $($Project.year)"
  }
  $ProjectDir = Join-Path $RealizaceDir $Project.slug
  Write-Utf8File (Join-Path $ProjectDir "index.html") (Project-Page $Project $Published)
}

Write-Utf8File (Join-Path $Root "realizace.html") (Listing-Page $Published)
Update-Sitemap

Write-Host "Generated $($Published.Count) realization pages."
Write-Host "Updated realizace.html and sitemap.xml."

$SeoBuild = Join-Path $Root "generate-seo.ps1"
if (Test-Path $SeoBuild) {
  & $SeoBuild
}








