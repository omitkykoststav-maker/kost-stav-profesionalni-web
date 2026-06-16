$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$SiteUrl = "https://www.kost-stav.cz"
$LastMod = "2026-06-07"
$Company = "KOST STAV PRAHA s.r.o."
$Phone = "+420 777 977 571"
$PhoneHref = "tel:+420777977571"
$WhatsApp = "https://wa.me/420777977571"
$Email = "omitkykoststav@gmail.com"
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$Services = @"
slug|title|lower|acc|lead|material|process|result|related
strojni-omitky|Strojní omítky|strojní omítky|strojní omítky|rovné vnitřní povrchy, rychlou aplikaci a přesné napojení rohů, špalet i detailů|sádrové, štukové i vápenocementové směsi volené podle provozu místnosti|zaměření podkladu, ochranu stavebních otvorů, penetraci, osazení lišt a strojní nanesení směsi|hladký a připravený podklad pro malbu, obklady nebo finální povrchovou úpravu|sádrové omítky;štukové omítky;vápenocementové omítky;zateplení fasád;fasádní práce
sadrove-omitky|Sádrové omítky|sádrové omítky|sádrové omítky|velmi hladký povrch do obytných místností, kanceláří a moderních novostaveb|kvalitní sádrové směsi s příjemným vnitřním klimatem a dobrou paropropustností|kontrolu vlhkosti podkladu, penetraci, přesné založení rohů a uhlazení povrchu do finální roviny|čistý interiér s minimem dodatečného broušení a s povrchem připraveným na malování|strojní omítky;štukové omítky;vápenocementové omítky;fasádní práce
stukove-omitky|Štukové omítky|štukové omítky|štukové omítky|klasický pevný povrch pro novostavby, opravy starších zdí a sjednocení vnitřních ploch|jemné štukové směsi vhodné pro ruční úpravy, hladké napojení a finální vzhled stěn|sjednocení podkladu, doplnění nerovností, natažení štuku a pečlivé filcování povrchu|odolný a esteticky sjednocený povrch, který dobře navazuje na malbu|strojní omítky;sádrové omítky;vápenocementové omítky;zateplení fasád
vapenocementove-omitky|Vápenocementové omítky|vápenocementové omítky|vápenocementové omítky|odolné omítky do koupelen, technických místností, garáží, sklepů a více namáhaných prostor|pevné vápenocementové směsi s dobrou odolností proti vlhkosti a mechanickému zatížení|přípravu savosti podkladu, založení omítníků, strojní nebo ruční aplikaci a vyrovnání ploch|pevný minerální podklad vhodný pro obklady, malbu i další povrchové vrstvy|strojní omítky;sádrové omítky;štukové omítky;zateplení fasád;fasádní práce
zatepleni-fasad|Zateplení fasád|zateplení fasád|zateplení fasád|nižší tepelné ztráty, nový vzhled domu a správně vyřešené detaily kolem oken, soklu i střechy|kontaktní zateplovací systémy s izolantem, lepicí hmotou, armovací vrstvou a finální omítkou|zaměření fasády, návrh skladby, přípravu podkladu, kotvení, armování a finální povrchovou úpravu|čistou fasádu s lepší tepelnou ochranou a dlouhodobě stabilním provedením detailů|fasádní práce;vápenocementové omítky;štukové omítky;strojní omítky
fasadni-prace|Fasádní práce|fasádní práce|fasádní práce|opravy, sjednocení, finální omítky a povrchové úpravy fasád pro rodinné i bytové domy|fasádní penetrace, stěrky, armovací vrstvy, omítkoviny a doplňky pro čisté provedení detailů|posouzení stavu fasády, opravy podkladu, vyztužení kritických míst, nanesení vrstev a kontrolu detailů|sjednocenou fasádu s kvalitním povrchem, čistými hranami a lepší ochranou obvodového pláště|zateplení fasád;vápenocementové omítky;štukové omítky;strojní omítky
"@ | ConvertFrom-Csv -Delimiter "|"

$FeaturedLocalitySlugs = @(
  "praha", "praha-vychod", "praha-zapad", "kladno", "beroun", "benesov", "kolin", "kutna-hora",
  "nymburk", "mlada-boleslav", "melnik", "brandys-nad-labem", "cesky-brod", "ricany"
)

$DeprecatedPragueDistricts = @"
name|slug|prep|area|setting|note
Praha 1|praha-1|v Praze 1|v historickém centru Prahy|činžovní domy, kanceláře, provozovny a byty s náročnější logistikou|hlídáme ochranu společných prostor, časová okna pro zásobování a čisté předání v husté městské zástavbě
Praha 2|praha-2|v Praze 2|na Vinohradech, Novém Městě a v okolní městské zástavbě|byty ve starších domech, kancelářské prostory i menší rekonstrukce interiérů|počítáme s dopravou materiálu do pater, ochranou chodeb a přesnou domluvou se správcem domu
Praha 3|praha-3|v Praze 3|na Žižkově, Vinohradech a v navazujících částech města|rekonstrukce bytů, opravy omítek a modernizace domů s rozdílnou kvalitou podkladů|předem řešíme stav zdiva, savost původních vrstev a návaznosti na další řemesla
Praha 4|praha-4|v Praze 4|v rozsáhlé rezidenční i komerční části Prahy|rodinné domy, byty, kanceláře, provozovny a novostavby|dobře plánujeme etapy, aby práce navázaly na hrubé rozvody, okna, podlahy a další profese
Praha 5|praha-5|v Praze 5|na Smíchově, v Košířích, Jinonicích a okolních čtvrtích|městské byty, rodinné domy, fasády a rekonstrukce provozních prostor|dokážeme přizpůsobit postup jak starší zástavbě, tak novým projektům s přísným harmonogramem
Praha 6|praha-6|v Praze 6|v Dejvicích, Břevnově, Vokovicích a okolí|rodinné domy, vily, bytové jednotky a citlivé rekonstrukce starších objektů|klademe důraz na kvalitní detaily, ochranu hotových prvků a průběžnou komunikaci s investorem
Praha 7|praha-7|v Praze 7|v Holešovicích, Bubenči a širším okolí|byty, ateliéry, kanceláře, menší provozovny a rekonstrukce v městských domech|řešíme rychlý přesun materiálu, čistotu společných částí a návaznosti na provoz domu
Praha 8|praha-8|v Praze 8|v Karlíně, Libni, Kobylisích a okolních lokalitách|novostavby, rekonstrukce bytů, rodinné domy i komerční prostory|u každé zakázky nastavujeme postup podle stavu podkladu, přístupu na stavbu a požadovaného termínu
Praha 9|praha-9|v Praze 9|ve Vysočanech, Hloubětíně, Proseku a okolí|byty, domy, kanceláře a novostavby v rychle se měnící části Prahy|využíváme blízkost našeho zázemí, díky které umíme pružně řešit zaměření i následné práce
Praha 10|praha-10|v Praze 10|ve Vršovicích, Strašnicích, Záběhlicích a okolí|bytové domy, rodinné domy, rekonstrukce interiérů i fasádní práce|pomáháme sladit stavební práce s provozem domácnosti, sousedy i navazujícími dodavateli
"@ | ConvertFrom-Csv -Delimiter "|"

$Localities = @"
name|slug|prep|area|setting|note
Praha|praha|v Praze|v celé metropoli včetně vnitřního města, přilehlých čtvrtí a okrajových částí|rodinné domy, bytové jednotky, novostavby, činžovní domy, kanceláře i fasády|máme zkušenosti s pražskou logistikou, plánováním etap, koordinací s dalšími řemesly a rychlým dojezdem z Vysočan
Praha-východ|praha-vychod|v okrese Praha-východ|v rychle rostoucím příměstském pásu východně od Prahy|novostavby rodinných domů, developerské projekty a rekonstrukce starších objektů|počítáme s etapizací novostaveb, příjezdem techniky a koordinací s dalšími profesemi na stavbě
Praha-západ|praha-zapad|v okrese Praha-západ|v obcích západně a jihozápadně od Prahy|rodinné domy, vily, novostavby a rekonstrukce s vysokým důrazem na detail|předem řešíme termíny, skladování materiálu a návaznost fasád, omítek i interiérových prací
Kladno|kladno|v Kladně|v největším městě Středočeského kraje|bytové domy, rodinné domy, provozovny a rekonstrukce starší i nové zástavby|pracujeme s různými typy podkladů a umíme navrhnout postup pro rychlé i rozsáhlejší zakázky
Beroun|beroun|v Berouně|v Berouně a okolí Českého krasu|rodinné domy, fasády, rekonstrukce interiérů a menší komerční prostory|u starších domů pečlivě kontrolujeme vlhkost a soudržnost zdiva, aby nové vrstvy dlouhodobě fungovaly
Benešov|benesov|v Benešově|v Benešově a okolních obcích na jih od Prahy|rodinné domy, rekonstrukce, novostavby a dokončovací práce po hrubé stavbě|zakázky plánujeme tak, aby navazovaly na instalace, okna, topení a další stavební etapy
Kolín|kolin|v Kolíně|v Kolíně a okolí Polabí|byty, rodinné domy, provozní objekty i rekonstrukce městské zástavby|volíme technologii podle typu místnosti, vlhkosti a požadavků na odolnost povrchu
Kutná Hora|kutna-hora|v Kutné Hoře|v Kutné Hoře a blízkých obcích|starší domy, byty, fasády, rekonstrukce a objekty s různorodým podkladem|u historicky citlivějších objektů postup konzultujeme a respektujeme charakter původních konstrukcí
Nymburk|nymburk|v Nymburce|v Nymburce a polabských obcích|rodinné domy, bytové jednotky, rekonstrukce i moderní novostavby|soustředíme se na čistou organizaci stavby, rychlý průběh prací a přesné dokončení detailů
Mladá Boleslav|mlada-boleslav|v Mladé Boleslavi|v Mladé Boleslavi a okolních obcích|byty, rodinné domy, komerční prostory a rekonstrukce s tlakem na přesný termín|průběh prací plánujeme tak, aby byl pro investora přehledný a dobře kontrolovatelný
Mělník|melnik|v Mělníku|v Mělníku a okolí soutoku Labe s Vltavou|rodinné domy, bytové domy, fasády a rekonstrukce starších objektů|při návrhu postupu zohledňujeme stav zdiva, vlhkost a požadavky na dlouhodobou životnost
Brandýs nad Labem|brandys-nad-labem|v Brandýse nad Labem|v Brandýse nad Labem a Staré Boleslavi|novostavby, rekonstrukce rodinných domů, byty a fasádní práce|dokážeme pružně reagovat na zakázky v příměstské zástavbě i v hustějším centru města
Čelákovice|celakovice|v Čelákovicích|v Čelákovicích a okolí Labe|rodinné domy, byty, novostavby a menší rekonstrukce|před zahájením si ověřujeme přístup, ochranu okolních ploch a možnosti skladování materiálu
Lysá nad Labem|lysa-nad-labem|v Lysé nad Labem|v Lysé nad Labem a blízkém Polabí|novostavby, rekonstrukce domů, byty i fasádní úpravy|stavbu organizujeme tak, aby práce navazovaly na mokré procesy, zrání materiálů a finální úpravy
Milovice|milovice|v Milovicích|v Milovicích a okolních obcích|rodinné domy, řadové domy, byty a rekonstrukce rychle rostoucí zástavby|umíme pracovat v nových projektech, kde je důležitá koordinace s dalšími řemesly a termíny
Poděbrady|podebrady|v Poděbradech|v Poděbradech a lázeňském okolí|rodinné domy, bytové jednotky, rekonstrukce a objekty s důrazem na čistý vzhled|dbáme na precizní povrchy, ochranu okolí a klidný průběh prací v obydlených domech
Český Brod|cesky-brod|v Českém Brodě|v Českém Brodě a okolí východně od Prahy|rodinné domy, byty, rekonstrukce starších domů i menší novostavby|navrhujeme postup podle stavu zdiva, dostupnosti stavby a požadované rychlosti realizace
Říčany|ricany|v Říčanech|v Říčanech a okolí jihovýchodně od Prahy|rodinné domy, vily, novostavby a kvalitní rekonstrukce interiérů|pracujeme s důrazem na čistotu, přesné detaily a dobrou koordinaci v obydlených lokalitách
Jesenice|jesenice|v Jesenici|v Jesenici u Prahy a okolních obcích|novostavby rodinných domů, rekonstrukce a fasádní práce|u nových domů hlídáme návaznost na technologické přestávky, okna, podlahy a vytápění
Hostivice|hostivice|v Hostivici|v Hostivici a západním příměstském pásu Prahy|rodinné domy, byty, řadové domy a provozní prostory|práce plánujeme s ohledem na dostupnost stavby, skladování materiálu a provoz v okolí domu
Roztoky|roztoky|v Roztokách|v Roztokách u Prahy a okolí Vltavy|rodinné domy, byty, vily a rekonstrukce ve svažitější zástavbě|předem řešíme dopravu materiálu, ochranu hotových částí a přístup techniky na pozemek
Rudná|rudna|v Rudné|v Rudné a okolí západně od Prahy|rodinné domy, novostavby, menší provozovny a rekonstrukce|zakázky řešíme pružně podle fáze stavby a dostupnosti navazujících profesí
Dobříš|dobris|v Dobříši|v Dobříši a okolí Brd|rodinné domy, rekonstrukce, fasády a dokončovací práce|u starších domů věnujeme pozornost vlhkosti, pevnosti podkladu a vhodné skladbě materiálů
Příbram|pribram|v Příbrami|v Příbrami a širším okolí|byty, rodinné domy, fasády, rekonstrukce i technické prostory|umíme zvolit odolné řešení pro běžné bydlení i více zatížené části domu
Hořovice|horovice|v Hořovicích|v Hořovicích a okolí|rodinné domy, rekonstrukce starší zástavby a novostavby|před prací kontrolujeme podklad, navrhujeme vhodný materiál a držíme jasný harmonogram
Slaný|slany|ve Slaném|ve Slaném a okolních obcích|rodinné domy, městské byty, fasády a rekonstrukce objektů|postup přizpůsobujeme typu stavby, požadované odolnosti povrchu a možnostem přístupu
Kralupy nad Vltavou|kralupy-nad-vltavou|v Kralupech nad Vltavou|v Kralupech nad Vltavou a okolí|rodinné domy, byty, fasády a stavební úpravy provozních prostor|řešíme čisté napojení detailů a správnou volbu materiálu pro interiér i exteriér
Neratovice|neratovice|v Neratovicích|v Neratovicích a okolních obcích|byty, rodinné domy, rekonstrukce a dokončovací práce|zakázky plánujeme s důrazem na rychlou domluvu, přehlednou cenu a řádné předání
Mnichovo Hradiště|mnichovo-hradiste|v Mnichově Hradišti|v Mnichově Hradišti a okolí Českého ráje|rodinné domy, rekonstrukce, fasády a menší stavební úpravy|u každé stavby sledujeme kvalitu podkladu, detaily rohů a návaznost na další práce
Benátky nad Jizerou|benatky-nad-jizerou|v Benátkách nad Jizerou|v Benátkách nad Jizerou a okolí|rodinné domy, byty, novostavby a rekonstrukce v klidnější zástavbě|práci organizujeme tak, aby byla pro investora přehledná a bez zbytečných prostojů
Vlašim|vlasim|ve Vlašimi|ve Vlašimi a okolí Podblanicka|rodinné domy, rekonstrukce, fasádní práce a úpravy interiérů|zohledňujeme stav staršího zdiva, požadavky na životnost a rozumný rozpočet zakázky
Sedlčany|sedlcany|v Sedlčanech|v Sedlčanech a okolních obcích|rodinné domy, chalupy, rekonstrukce a dokončovací stavební práce|volíme praktická řešení pro trvale obývané domy i objekty, které prochází postupnou obnovou
Unhošť|unhost|v Unhošti|v Unhošti a okolí Kladenska|rodinné domy, novostavby, byty a menší stavební úpravy|důležitá je pro nás rychlá domluva, čistý průběh prací a dobře připravené detaily
Rakovník|rakovnik|v Rakovníku|v Rakovníku a okolí|rodinné domy, bytové domy, fasády a rekonstrukce starší zástavby|postup nastavujeme podle kvality podkladu, vlhkosti a požadavků na finální vzhled
"@ | ConvertFrom-Csv -Delimiter "|"

foreach ($Loc in $Localities) {
  foreach ($Prop in @("setting", "note")) {
    $Text = [string]$Loc.$Prop
    $Text = $Text.Replace("rekonstrukce bytů", "úpravy omítek")
    $Text = $Text.Replace("rekonstrukce domů", "fasádní úpravy domů")
    $Text = $Text.Replace("rekonstrukce interiérů", "omítkové úpravy interiérů")
    $Text = $Text.Replace("rekonstrukce provozních prostor", "omítkové úpravy provozních prostor")
    $Text = $Text.Replace("rekonstrukce starších objektů", "opravy omítek starších objektů")
    $Text = $Text.Replace("rekonstrukce starší i nové zástavby", "opravy omítek ve starší i nové zástavbě")
    $Text = $Text.Replace("rekonstrukce starší zástavby", "opravy omítek starší zástavby")
    $Text = $Text.Replace("rekonstrukce městské zástavby", "opravy omítek městské zástavby")
    $Text = $Text.Replace("rekonstrukce v městských domech", "omítkové úpravy v městských domech")
    $Text = $Text.Replace("rekonstrukce rychle rostoucí zástavby", "fasádní úpravy rychle rostoucí zástavby")
    $Text = $Text.Replace("rekonstrukce", "opravy omítek")
    $Text = $Text.Replace("dokončovací stavební práce", "finální povrchové úpravy")
    $Text = $Text.Replace("dokončovací práce", "finální povrchové úpravy")
    $Text = $Text.Replace("stavební práce", "omítkářské a fasádní práce")
    $Text = $Text.Replace("stavební etapy", "technologické etapy")
    $Loc.$Prop = $Text
  }
}

foreach ($Loc in $DeprecatedPragueDistricts) {
  foreach ($Prop in @("setting", "note")) {
    $Text = [string]$Loc.$Prop
    $Text = $Text.Replace("rekonstrukce bytů", "úpravy omítek")
    $Text = $Text.Replace("rekonstrukce domů", "fasádní úpravy domů")
    $Text = $Text.Replace("rekonstrukce interiérů", "omítkové úpravy interiérů")
    $Text = $Text.Replace("rekonstrukce provozních prostor", "omítkové úpravy provozních prostor")
    $Text = $Text.Replace("rekonstrukce starších objektů", "opravy omítek starších objektů")
    $Text = $Text.Replace("rekonstrukce starší i nové zástavby", "opravy omítek ve starší i nové zástavbě")
    $Text = $Text.Replace("rekonstrukce starší zástavby", "opravy omítek starší zástavby")
    $Text = $Text.Replace("rekonstrukce městské zástavby", "opravy omítek městské zástavby")
    $Text = $Text.Replace("rekonstrukce v městských domech", "omítkové úpravy v městských domech")
    $Text = $Text.Replace("rekonstrukce rychle rostoucí zástavby", "fasádní úpravy rychle rostoucí zástavby")
    $Text = $Text.Replace("rekonstrukce", "opravy omítek")
    $Text = $Text.Replace("dokončovací stavební práce", "finální povrchové úpravy")
    $Text = $Text.Replace("dokončovací práce", "finální povrchové úpravy")
    $Text = $Text.Replace("stavební práce", "omítkářské a fasádní práce")
    $Text = $Text.Replace("stavební etapy", "technologické etapy")
    $Loc.$Prop = $Text
  }
}

$FeaturedLocalities = @($Localities | Where-Object { $FeaturedLocalitySlugs -contains $_.slug })

$FaqPool = @(
  @("Jak rychle můžete přijet na zaměření?", "Ve většině lokalit Prahy a Středočeského kraje se snažíme domluvit prohlídku v nejbližším možném termínu. U větších zakázek je dobré poslat fotografie a orientační výměry předem, abychom zaměření připravili přesněji."),
  @("Je cenová nabídka opravdu zdarma?", "Ano, nezávaznou cenovou nabídku připravujeme zdarma. Aby byla férová, potřebujeme znát rozsah prací, stav podkladu, přístup na stavbu a očekávaný termín realizace."),
  @("Umíte pracovat i v obydleném domě?", "Ano, jen je nutné lépe naplánovat ochranu prostor, přesun materiálu, prašnost a průběžný úklid. Předem domluvíme, které místnosti budou přístupné a jak budou práce navazovat."),
  @("Pomůžete s výběrem správného materiálu?", "Ano. Doporučíme materiál podle vlhkosti, zatížení, typu podkladu a očekávaného výsledku. Jinou skladbu volíme do koupelny, jinou do obytného pokoje a jinou na fasádu."),
  @("Provádíte i navazující povrchové úpravy?", "Ano, kromě hlavní služby umíme zajistit zapravení detailů, lokální opravy, stěrky, přípravu pro malbu a sjednocení povrchů podle dohody."),
  @("Jak poznám, že je podklad připravený?", "Podklad musí být pevný, soudržný, přiměřeně suchý a bez prachu nebo mastnoty. Pokud připravený není, navrhneme penetraci, vysprávky nebo jiný postup před zahájením hlavních prací."),
  @("Lze zakázku rozdělit do etap?", "Ano, etapizace dává smysl hlavně u větších ploch, fasád a objektů s více místnostmi. Předem nastavíme pořadí prací tak, aby jednotlivé vrstvy správně navazovaly."),
  @("Jak dlouho trvá realizace?", "Délka závisí na rozsahu, technologických přestávkách a připravenosti stavby. Po zaměření vám řekneme realistický harmonogram a upozorníme na místa, která mohou termín ovlivnit.")
)

$ReviewBodies = @(
  "Domluva byla rychlá, práce proběhla podle plánu a po dokončení zůstalo staveniště uklizené. Oceňujeme hlavně jasnou komunikaci během celé realizace.",
  "Potřebovali jsme poradit s vhodným postupem a dostali jsme konkrétní doporučení bez zbytečného natahování rozpočtu. Výsledek odpovídá dohodě.",
  "Řemeslníci dorazili včas, chránili okolní prostory a detaily byly provedené pečlivě. Nabídku jsme měli přehlednou a termín byl dodržen.",
  "Zakázka navazovala na další povrchové úpravy a oceňujeme, že vše bylo dobře zkoordinované. Povrchy jsou rovné a připravené na malování.",
  "Komunikace byla věcná, cena srozumitelná a průběh bez zbytečných komplikací. Firmu bychom doporučili pro omítky i fasády.",
  "Líbilo se nám, že firma předem upozornila na slabší místa podkladu a navrhla řešení. Díky tomu nevznikaly nepříjemné změny uprostřed prací."
)

$RealizationGalleryImages = @(
  "IMG-20260616-WA0000.jpg",
  "IMG-20260616-WA0001.jpg",
  "IMG-20260616-WA0002.jpg",
  "IMG-20260616-WA0003.jpg",
  "IMG-20260616-WA0004.jpg",
  "IMG-20260616-WA0005.jpg",
  "IMG-20260616-WA0006.jpg",
  "IMG-20260616-WA0007.jpg",
  "IMG-20260616-WA0008.jpg",
  "IMG-20260616-WA0009.jpg",
  "IMG-20260616-WA0010.jpg",
  "IMG-20260616-WA0011.jpg",
  "IMG-20260616-WA0012.jpg",
  "IMG-20260616-WA0013.jpg",
  "IMG-20260616-WA0014.jpg",
  "IMG-20260616-WA0015.jpg",
  "IMG-20260616-WA0016.jpg",
  "IMG-20260616-WA0017.jpg",
  "IMG-20260616-WA0018.jpg",
  "IMG-20260616-WA0019.jpg",
  "IMG-20260616-WA0020.jpg",
  "IMG-20260616-WA0021.jpg",
  "IMG-20260616-WA0022.jpg",
  "IMG-20260616-WA0023.jpg",
  "IMG-20260616-WA0024.jpg",
  "IMG-20260616-WA0025.jpg",
  "IMG-20260616-WA0026.jpg",
  "IMG-20260616-WA0027.jpg",
  "IMG-20260616-WA0028.jpg",
  "IMG-20260616-WA0029.jpg",
  "IMG-20260616-WA0030.jpg",
  "IMG-20260616-WA0031.jpg",
  "IMG_20260615_084156.jpg",
  "IMG_20260615_084204.jpg",
  "IMG_20260615_084214.jpg",
  "IMG_20260615_084219.jpg",
  "IMG_20260615_084755.jpg",
  "IMG_20260615_084803.jpg",
  "IMG_20260615_084814.jpg",
  "IMG_20260615_110123.jpg"
)

$RealizationGalleryNewImages = @($RealizationGalleryImages | Where-Object { $_ -match "20260616" })
$PrahaLatestGalleryServices = @("strojni-omitky", "fasadni-prace", "zatepleni-fasad")

function Write-Utf8File($Path, $Content) {
  try {
    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
  } catch {
    try {
      Set-Content -LiteralPath $Path -Encoding UTF8 -NoNewline -Value $Content
    } catch {
      Write-Warning "Soubor $Path se nepodařilo automaticky přepsat. Ponechávám existující verzi."
    }
  }
}

function Escape-Html($Text) {
  [System.Net.WebUtility]::HtmlEncode([string]$Text)
}

function Gallery-Service-Label($Service) {
  switch ($Service.slug) {
    "zatepleni-fasad" { "Zateplení fasád" }
    default { $Service.title }
  }
}

function Gallery-Hash($Text) {
  $Hash = 0
  foreach ($Char in ([string]$Text).ToCharArray()) {
    $Hash = (($Hash * 31) + [int][char]$Char) % 2147483647
  }
  return [int]$Hash
}

function Gallery-Page-Order($LocIndex, $ServiceIndex) {
  if ($LocIndex -ge 100) {
    return ($Localities.Count * $Services.Count) + (($LocIndex - 100) * $Services.Count) + $ServiceIndex
  }
  return ($LocIndex * $Services.Count) + $ServiceIndex
}

function Gallery-Image-Selection($Service, $Loc, $LocIndex, $ServiceIndex) {
  $PoolCount = $RealizationGalleryImages.Count
  if ($PoolCount -eq 0) { return @() }

  if ($Loc.slug -eq "praha" -and $PrahaLatestGalleryServices -contains $Service.slug -and $RealizationGalleryNewImages.Count -ge 20) {
    return @($RealizationGalleryNewImages)
  }

  $Seed = Gallery-Hash "$($Service.slug)-$($Loc.slug)"
  $Count = [Math]::Min($PoolCount, 3 + ($Seed % 4))
  $Start = (Gallery-Page-Order $LocIndex $ServiceIndex) % $PoolCount
  $Steps = @(3, 7, 9, 11, 13, 17, 19, 21, 23, 27, 29, 31, 33, 37)
  $Step = $Steps[$Seed % $Steps.Count]
  $Selected = New-Object System.Collections.Generic.List[string]

  for ($Index = 0; $Selected.Count -lt $Count -and $Index -lt ($PoolCount * 2); $Index++) {
    $Image = $RealizationGalleryImages[($Start + ($Index * $Step)) % $PoolCount]
    if (-not $Selected.Contains($Image)) {
      [void]$Selected.Add($Image)
    }
  }

  $FallbackIndex = 0
  while ($Selected.Count -lt $Count) {
    $Image = $RealizationGalleryImages[$FallbackIndex % $PoolCount]
    if (-not $Selected.Contains($Image)) {
      [void]$Selected.Add($Image)
    }
    $FallbackIndex++
  }

  if ($RealizationGalleryNewImages.Count -gt 0 -and -not ($Selected | Where-Object { $_ -match "20260616" })) {
    $Replacement = $RealizationGalleryNewImages[$Seed % $RealizationGalleryNewImages.Count]
    if (-not $Selected.Contains($Replacement)) {
      $Selected[$Selected.Count - 1] = $Replacement
    }
  }

  return @($Selected)
}

function Realization-Gallery($Service, $Loc, $LocIndex, $ServiceIndex) {
  $Alt = Escape-Html "$(Gallery-Service-Label $Service) $($Loc.name) – realizace"
  $Heading = $Alt
  $ImageDir = "lokality"
  if ($Loc.slug -eq "praha" -and $PrahaLatestGalleryServices -contains $Service.slug -and $RealizationGalleryNewImages.Count -ge 20) {
    $ImageDir = "realizace"
  }
  $Figures = (Gallery-Image-Selection $Service $Loc $LocIndex $ServiceIndex | ForEach-Object {
    "        <figure><img src=`"../assets/images/$ImageDir/$_`" loading=`"lazy`" decoding=`"async`" alt=`"$Alt`"></figure>"
  }) -join "`r`n"
@"
  <section class="locality-realization-gallery">
    <div class="container">
      <div class="section-head"><h2>$Heading</h2><p>Ukázky dokončených omítek a fasád z našich realizací.</p></div>
      <div class="gallery">
$Figures
      </div>
    </div>
  </section>
"@
}

function Cap($Text) {
  if ([string]::IsNullOrWhiteSpace($Text)) { return "" }
  return $Text.Substring(0, 1).ToUpper() + $Text.Substring(1)
}

function Header-Html($Prefix) {
@"
<header class="top"><div class="container nav"><a class="logo" href="${Prefix}index.html">$Company<span>omítky a fasády Praha a Středočeský kraj</span></a><nav class="menu"><a href="${Prefix}index.html">Domů</a><a href="${Prefix}o-nas.html">O nás</a><a href="${Prefix}sluzby.html">Služby</a><a href="${Prefix}realizace.html">Realizace</a><a href="${Prefix}blog.html">Blog</a><a href="${Prefix}reference.html">Reference</a><a href="${Prefix}galerie.html">Galerie realizací</a><a href="${Prefix}kontakt.html">Kontakt</a><a class="btn" href="$PhoneHref">Zavolat</a></nav></div></header>
"@
}

function Cta-Html($Prefix) {
@"
<section class="cta"><div class="container box"><h2>Zavolejte nám ještě dnes a získejte nezávaznou cenovou nabídku zdarma.</h2><p class="muted">Rádi posoudíme váš projekt, doporučíme vhodné řešení a připravíme férovou cenovou nabídku.</p><div class="actions" style="justify-content:center"><a class="btn" href="$PhoneHref">$Phone</a><a class="btn alt" href="${Prefix}kontakt.html">Odeslat poptávku</a></div></div></section>
"@
}

function Footer-Html($Prefix) {
@"
<a class="whatsapp" href="$WhatsApp">WhatsApp</a><footer class="footer"><div class="container footgrid"><div><h3>$Company</h3><p class="muted">Poctivé strojní omítky, sádrové omítky, štukové omítky, vápenocementové omítky, zateplení fasád a fasádní práce v Praze a Středočeském kraji.</p></div><div><h3>Rychlé odkazy</h3><p><a href="${Prefix}sluzby.html">Služby</a><br><a href="${Prefix}realizace.html">Realizace</a><br><a href="${Prefix}blog.html">Blog</a><br><a href="${Prefix}reference.html">Reference</a><br><a href="${Prefix}kontakt.html">Kontakt</a></p></div><div><h3>Kontakt</h3><p>K Žižkovu 809/7, Praha 9 – Vysočany<br><a href="$PhoneHref">$Phone</a><br><span>$Email</span></p></div></div><div class="container"><p class="muted">© 2026 $Company Všechna práva vyhrazena.</p></div></footer><script src="${Prefix}ui.js" defer></script>
"@
}

function Opening-Text($Service, $Loc, $Index) {
  switch ($Index % 4) {
    0 { return "Když řešíte $($Service.acc) $($Loc.prep), potřebujete řemeslníky, kteří přijedou v domluvený čas, jasně vysvětlí postup a dodrží kvalitu detailů. $Company pomáhá investorům, majitelům domů i správcům bytových objektů s realizací od prvního zaměření po finální předání. V lokalitě $($Loc.name) se často setkáváme s kombinací různých podkladů, omezeného přístupu a požadavku na rychlé dokončení, proto vždy začínáme pečlivou prohlídkou stavby." }
    1 { return "$($Service.title) $($Loc.name) děláme tak, aby výsledek dobře fungoval nejen na první pohled, ale i po letech běžného užívání. Při poptávce si ověřujeme typ objektu, stav podkladu, připravenost navazujících profesí a rozsah prací. Díky tomu můžeme doporučit rozumný materiál, reálný termín a férovou cenovou nabídku zdarma. $(Cap $Loc.note)." }
    2 { return "Pro zákazníky, kteří hledají $($Service.acc) $($Loc.name), je důležitá kombinace rychlosti, čisté práce a srozumitelné komunikace. Naše parta se zaměřuje na strojní omítky, sádrové omítky, štukové omítky, vápenocementové omítky, zateplení fasád a fasádní práce v Praze i Středočeském kraji. $($Loc.name) pro nás znamená $($Loc.setting), a proto postup nikdy nekopírujeme naslepo z jiné zakázky." }
    default { return "Každá stavba $($Loc.prep) má trochu jiné podmínky. Někde rozhoduje rychlé dokončení před nastěhováním, jinde přesné zapravení detailů ve starším domě nebo správná příprava fasády před zateplením. Pokud poptáváte $($Service.acc), připravíme vám návrh postupu, který respektuje technický stav objektu, rozpočet i požadovaný termín realizace." }
  }
}

function Detail-Text($Service, $Loc, $Index) {
  switch ($Index % 4) {
    0 { return "Při realizaci se soustředíme hlavně na přípravu. U služby $($Service.lower) nestačí přivézt materiál a začít nanášet první vrstvu. Nejdříve kontrolujeme rovinnost, savost a pevnost podkladu, řešíme zakrytí oken, dveří, podlah a okolních částí stavby. Poté navrhujeme technologii, která odpovídá provozu místnosti, typu konstrukce a plánovanému dokončení. Jiný postup volíme pro novostavbu, jiný pro starší zdivo a jiný pro fasádu vystavenou počasí." }
    1 { return "Důležitá je také organizace zakázky. $(Cap $Loc.area) často rozhodují drobnosti: možnost příjezdu, skladování materiálu, koordinace s elektrikáři, instalatéry nebo montáží oken. Proto předem stanovíme, co má být připraveno, kdy má být prostor volný a jak dlouho musí jednotlivé vrstvy zrát. Tím se snižuje riziko zdržení a investor má jasnější přehled o průběhu prací." }
    2 { return "Na stavbě používáme ověřené postupy a materiály. Pro $($Service.lower) volíme $($Service.material). Zákazníkovi vysvětlíme rozdíl mezi variantami, upozorníme na omezení podkladu a doporučíme řešení, které má smysl pro konkrétní dům nebo byt. Nejde nám o nejdražší variantu za každou cenu, ale o poměr ceny, životnosti a výsledného vzhledu." }
    default { return "Výsledkem má být $($Service.result). Právě proto kontrolujeme rohy, napojení u oken, přechody mezi místnostmi, průběžnou rovinnost a čistotu detailů. U starších podkladů navíc počítáme s tím, že se během práce mohou objevit skryté vady. V takové chvíli s investorem situaci rychle projdeme, navrhneme další postup a pokračujeme tak, aby výsledek zůstal technicky správný." }
  }
}

function Service-Cards($Loc, $CurrentService) {
  (($Services | ForEach-Object {
    $active = if ($_.slug -eq $CurrentService.slug) { " service-card-active" } else { "" }
@"
<article class="card service-card$active"><h3><a href="$($_.slug)-$($Loc.slug).html">$($_.title) $($Loc.name)</a></h3><a class="text-link" href="$($_.slug)-$($Loc.slug).html">Detail služby</a></article>
"@
  }) -join "")
}

function Benefit-Cards($Service, $Loc) {
  $Benefits = @(
    "Bezplatné zaměření a cenová nabídka pro $($Loc.name)",
    "Dlouholeté zkušenosti s pracemi jako $($Service.lower), omítky i fasády",
    "Kvalitní materiály a postup odpovídající podkladu, vlhkosti a provozu místnosti",
    "Dodržování termínů, průběžná komunikace a jasně domluvený rozsah prací"
  )
  (($Benefits | ForEach-Object { "<div>$_</div>" }) -join "")
}

function Faq-Items($Service, $Loc, $LocIndex, $ServiceIndex) {
  $Specific = @(
    @("Řešíte $($Service.lower) přímo $($Loc.prep)?", "Ano, zakázky realizujeme $($Loc.prep) i v okolí. Pošlete nám orientační rozsah, fotografie a termín, který potřebujete dodržet. Navrhneme postup pro $($Loc.setting) a připravíme cenovou nabídku zdarma."),
    @("Co je potřeba připravit před službou $($Service.title.ToLower())?", "Ideální je mít vyklizený prostor, dokončené hrubé rozvody a vyřešené stavební otvory. Pokud něco připravené není, řekneme vám to při zaměření a doporučíme, co udělat před nástupem."),
    @("Umíte spojit $($Service.lower) s dalšími omítkářskými nebo fasádními pracemi?", "Ano, podle potřeby navážeme na strojní omítky, sádrové omítky, štukové omítky, vápenocementové omítky, zateplení fasád nebo fasádní práce. Výhodou je lepší návaznost a méně komunikace s několika dodavateli.")
  )
  $Picked = @(
    $Specific[($LocIndex + $ServiceIndex) % $Specific.Count],
    $FaqPool[($LocIndex + $ServiceIndex) % $FaqPool.Count],
    $FaqPool[($LocIndex + $ServiceIndex + 3) % $FaqPool.Count]
  )
  (($Picked | ForEach-Object { "<details><summary>$($_[0])</summary><p>$($_[1])</p></details>" }) -join "")
}

function Review-Html($Service, $Loc, $LocIndex, $ServiceIndex) {
  $Items = for ($Offset = 0; $Offset -lt 2; $Offset++) {
    $Body = $ReviewBodies[($LocIndex * 2 + $ServiceIndex + $Offset) % $ReviewBodies.Count]
    $Label = if ($Offset -eq 0) { $Service.title } else { $Services[($ServiceIndex + $Offset) % $Services.Count].title }
@"
<div class="review">„$Body“<strong>$Label, $($Loc.name)</strong></div>
"@
  }
  ($Items -join "")
}

function Contact-Form($Service, $Loc) {
  $Message = [uri]::EscapeDataString("Dobrý den, mám zájem o $($Service.lower) $($Loc.prep). Prosím o nezávaznou cenovou nabídku.")
  $IsFacade = $Service.slug -in @("zatepleni-fasad", "fasadni-prace")
  $OmitkyChecked = if ($IsFacade) { "" } else { " checked" }
  $FasadyChecked = if ($IsFacade) { " checked" } else { "" }
  $OmitkyHidden = if ($IsFacade) { " hidden" } else { "" }
  $FasadyHidden = if ($IsFacade) { "" } else { " hidden" }
  $OmitkyDisabled = if ($IsFacade) { " disabled" } else { "" }
  $FasadyDisabled = if ($IsFacade) { "" } else { " disabled" }
  $StrojniSadroveChecked = if ($Service.slug -eq "sadrove-omitky" -or $Service.slug -eq "strojni-omitky") { " checked" } else { "" }
  $StukoveChecked = if ($Service.slug -eq "stukove-omitky") { " checked" } else { "" }
  $VapenocementoveChecked = if ($Service.slug -eq "vapenocementove-omitky") { " checked" } else { "" }
  $ZatepleniChecked = if ($Service.slug -eq "zatepleni-fasad") { " checked" } else { "" }
  $FasadniOmitkaChecked = if ($Service.slug -eq "fasadni-prace") { " checked" } else { "" }
@"
<div class="contactbox"><h2>Nezávazná poptávka pro $($Loc.name)</h2><p class="quote-intro">Rádi Vám spočítáme nezávaznou cenovou nabídku na omítky nebo fasádu. Vyplňte prosím krátký formulář a my se Vám co nejdříve ozveme.</p><p class="quote-help">Pro přesnější kalkulaci nám prosím pošlete plochu v m², fotky stavby, případně projektovou dokumentaci.</p><form class="quote-form" data-poptavka-form action="/api/contact" method="POST" enctype="multipart/form-data"><div class="form-section"><h3>Kontaktní údaje</h3><div class="form-grid"><div class="form-field"><label>Jméno a příjmení<input name="jmeno" autocomplete="name" required></label></div><div class="form-field"><label>Telefon<input name="telefon" type="tel" autocomplete="tel" required></label></div><div class="form-field"><label>E-mail<input name="email" type="email" autocomplete="email"></label></div><div class="form-field"><label>Adresa stavby / obec<input name="adresa_stavby" value="$($Loc.name)" autocomplete="street-address" required></label></div></div></div><div class="form-section"><h3>Typ práce</h3><p class="form-note">Vyberte hlavní kategorii poptávky.</p><div class="choice-grid"><label class="choice-pill"><input type="radio" name="typ_prace" value="omitky"$OmitkyChecked> Omítky</label><label class="choice-pill"><input type="radio" name="typ_prace" value="fasady"$FasadyChecked> Fasády</label></div><div data-specific-group="omitky"$OmitkyHidden><p class="form-label">Konkrétní typ omítky</p><div class="choice-grid"><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Strojní sádrové omítky"$StrojniSadroveChecked$OmitkyDisabled> Strojní sádrové omítky</label><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Štukové omítky"$StukoveChecked$OmitkyDisabled> Štukové omítky</label><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Vápenocementové omítky"$VapenocementoveChecked$OmitkyDisabled> Vápenocementové omítky</label><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Jádrové omítky"$OmitkyDisabled> Jádrové omítky</label><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Gletované sádrové omítky"$OmitkyDisabled> Gletované sádrové omítky</label><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Točené sádrové omítky"$OmitkyDisabled> Točené sádrové omítky</label><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Vnitřní omítky"$OmitkyDisabled> Vnitřní omítky</label><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Vnější omítky"$OmitkyDisabled> Vnější omítky</label></div></div><div data-specific-group="fasady"$FasadyHidden><p class="form-label">Konkrétní typ fasády</p><div class="choice-grid"><label class="choice-pill"><input type="checkbox" name="typ_fasady[]" value="Zateplení fasády"$ZatepleniChecked$FasadyDisabled> Zateplení fasády</label><label class="choice-pill"><input type="checkbox" name="typ_fasady[]" value="Fasádní omítka"$FasadniOmitkaChecked$FasadyDisabled> Fasádní omítka</label><label class="choice-pill"><input type="checkbox" name="typ_fasady[]" value="Finální fasádní omítka"$FasadyDisabled> Finální fasádní omítka</label><label class="choice-pill"><input type="checkbox" name="typ_fasady[]" value="Oprava fasády"$FasadyDisabled> Oprava fasády</label><label class="choice-pill"><input type="checkbox" name="typ_fasady[]" value="Kontaktní zateplovací systém"$FasadyDisabled> Kontaktní zateplovací systém</label><label class="choice-pill"><input type="checkbox" name="typ_fasady[]" value="Sokl fasády"$FasadyDisabled> Sokl fasády</label></div></div></div><div class="form-section"><h3>Parametry zakázky</h3><div class="choice-grid"><label class="choice-pill"><input type="radio" name="stav_objektu" value="Novostavba" required> Novostavba</label><label class="choice-pill"><input type="radio" name="stav_objektu" value="Rekonstrukce" required> Rekonstrukce</label></div><div class="form-grid"><div class="form-field"><label>Přibližná plocha v m²<input name="plocha" type="number" min="1" step="1" placeholder="např. 180"></label></div><div class="form-field"><label>Požadovaný termín realizace<input name="termin" placeholder="např. březen 2026"></label></div></div><div class="form-field"><label>Popis zakázky<textarea name="popis" placeholder="Popište prosím rozsah, stav podkladu a další důležité informace."></textarea></label></div><div class="form-field"><label>Nahrání souborů / fotek / projektové dokumentace<input class="file-input" name="prilohy[]" type="file" multiple accept="image/*,.pdf,.dwg,.dxf"></label></div></div><label class="muted consent"><input type="checkbox" name="souhlas" required> Souhlasím se zpracováním osobních údajů pro vyřízení poptávky.</label><div class="form-alert" data-form-alert role="status" aria-live="polite"></div><button class="btn" type="submit">Odeslat poptávku</button></form></div><div class="contactbox"><h2>Telefon a WhatsApp</h2><p><b>Telefon</b><br><a href="$PhoneHref">$Phone</a></p><p><b>E-mail</b><br><span>$Email</span></p><p><b>Působnost</b><br>$Company realizuje $($Service.lower) $($Loc.prep), v Praze a ve Středočeském kraji.</p><div class="actions"><a class="btn" href="$PhoneHref">Zavolat</a><a class="btn alt" href="${WhatsApp}?text=$Message">WhatsApp</a></div></div>
"@
}

function Praha-Strojni-Pillar-Page($Service, $Loc, $LocIndex, $ServiceIndex) {
  $FileName = "$($Service.slug)-$($Loc.slug).html"
  $Canonical = "$SiteUrl/lokality/$FileName"
  $Title = "Strojní omítky Praha | Sádrové, štukové a vápenocementové omítky"
  $Description = "Provádíme strojní omítky v Praze a Středočeském kraji. Sádrové, štukové a vápenocementové omítky pro novostavby i rekonstrukce. Rychlá nezávazná poptávka."
  $Keywords = "strojní omítky Praha, strojní omítky Praha-východ, strojní omítky Praha-západ, sádrové omítky Praha, štukové omítky Praha, vápenocementové omítky Praha, vnitřní omítky Praha, omítky a fasády Praha"
  $Header = Header-Html "../"
  $Cta = Cta-Html "../"
  $Footer = Footer-Html "../"
  $Cards = Service-Cards $Loc $Service
  $Benefits = Benefit-Cards $Service $Loc
  $Form = Contact-Form $Service $Loc
  $Gallery = Realization-Gallery $Service $Loc $LocIndex $ServiceIndex

@"
<!doctype html>
<html lang="cs">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>$(Escape-Html $Title)</title>
  <meta name="description" content="$(Escape-Html $Description)">
  <meta name="keywords" content="$(Escape-Html $Keywords)">
  <link rel="canonical" href="$Canonical">
  <link rel="stylesheet" href="../styles.css">
  <script src="../poptavka.js" defer></script>
  <script src="../realizace-lokality.js" defer></script>
</head>
<body>
$Header
<main>
  <section class="pagehead seo-head">
    <div class="container">
      <p class="breadcrumb"><a href="../index.html">Domů</a> / <a href="../lokality.html">Lokality</a> / Strojní omítky Praha</p>
      <h1>Strojní omítky Praha</h1>
      <p class="muted">$Company zajišťuje strojní omítky v celé Praze a Středočeském kraji. Přijedeme na zaměření, doporučíme vhodný postup a připravíme nezávaznou cenovou nabídku zdarma.</p>
      <div class="actions"><a class="btn" href="$PhoneHref">Zavolat $Phone</a><a class="btn alt" href="$WhatsApp">WhatsApp poptávka</a></div>
    </div>
  </section>
$Gallery
  <section>
    <div class="container seo-layout">
      <article class="seo-article">
        <h2>Strojní omítky v Praze – spolehlivý partner pro novostavby i rekonstrukce</h2>
        <p>Hledáte firmu, která vám v Praze kvalitně a v domluveném termínu provede strojní omítky? KOST STAV PRAHA s.r.o. se specializuje na strojní sádrové omítky, sádrové omítky, štukové omítky a vápenocementové omítky pro rodinné domy, bytové jednotky, novostavby i komerční prostory. Naše sídlo ve Vysočanech nám umožňuje rychlý dojezd do všech pražských městských částí i do okolí – Praha-východ, Praha-západ, Kladno, Beroun, Kolín a další lokality Středočeského kraje.</p>
        <p>Strojní omítky Praha je pro nás klíčová služba, kterou realizujeme od prvního zaměření až po finální předání povrchu připraveného na malbu nebo obklady. V Praze se setkáváme s velmi různorodými podklady – od porobetonu a ytongu v novostavbách až po starší cihlové zdivo v historických domech. Každá zakázka proto začíná pečlivou prohlídkou, při které posoudíme stav zdi, vlhkost, rovinnost a požadavky investora na finální vzhled.</p>
        <p>Na rozdíl od desítek slabých stránek rozdělených po jednotlivých městských částech jsme pro Prahu vytvořili jednu ucelenou informační stránku. Chceme vám nabídnout skutečně užitečný obsah, ne duplicitní texty pro Prahu 1 až Praha 10. Pokud stavíte nebo rekonstruujete kdekoli v metropoli, tato stránka vám pomůže pochopit, jak strojní omítky probíhají, kolik orientačně stojí a proč se vyplatí svěřit je zkušené partě.</p>

        <h2>Co pro vás v Praze zajišťujeme</h2>
        <p>Jako omítkářská a fasádní firma pokrýváme kompletní spektrum vnitřních i venkovních omítkářských prací. Naše hlavní služby zahrnují:</p>
        <ul>
          <li><strong>Strojní sádrové omítky</strong> – rychlá aplikace strojem pro rovné stěny v bytech, domech a kancelářích</li>
          <li><strong>Sádrové omítky Praha</strong> – velmi hladké povrchy do obytných místností s minimem dodatečného broušení</li>
          <li><strong>Štukové omítky Praha</strong> – pevné a estetické povrchy pro novostavby i opravy starších zdí</li>
          <li><strong>Vápenocementové omítky Praha</strong> – odolné řešení do koupelen, technických místností, garáží a soklů</li>
          <li><strong>Vnitřní omítky Praha</strong> – kompletní vnitřní omítkování bytů a rodinných domů</li>
          <li><strong>Omítky a fasády Praha</strong> – včetně zateplení fasád a fasádních prací v jednom harmonogramu</li>
        </ul>
        <p>Kromě samotné aplikace omítek zajišťujeme také penetraci podkladu, osazení rohových a dilatačních lišt, zapravení detailů kolem oken a dveří, lokální opravy zdiva a přípravu povrchu pro finální malbu. Pokud plánujete kompletní rekonstrukci, umíme omítkářské práce sladit s elektrikáři, instalatéry, podlaháři i malíři.</p>
        <p>Pro každou poptávku připravíme nezávaznou cenovou nabídku zdarma. Stačí zavolat, napsat přes WhatsApp nebo vyplnit formulář na této stránce. Ideálně pošlete fotografie stavby, orientační plochu v m² a požadovaný termín – díky tomu dokážeme nabídku připravit rychleji a přesněji.</p>

        <h2>Druhy omítek, které v Praze nejčastěji provádíme</h2>
        <h3>Strojní sádrové omítky</h3>
        <p>Strojní omítky jsou nejrychlejší cesta k rovným stěnám. Směs se aplikuje strojem omítkomítačkou, což umožňuje pokrýt velké plochy v kratším čase než ruční omítání. Výsledkem je rovný podklad vhodný pro gletování, malbu nebo tapetování. Strojní sádrové omítky volíme zejména do novostaveb, kde je důležitá rychlost a rovinnost.</p>
        <h3>Sádrové omítky</h3>
        <p>Sádrové omítky Praha jsou ideální pro obytné místnosti, kde oceníte hladký povrch a příjemné vnitřní klima. Sádra dobře paropropustí a vytváří zdravé prostředí. Používáme kvalitní sádrové směsi renomovaných výrobců a dbáme na správnou tloušťku vrstvy podle typu podkladu.</p>
        <h3>Štukové omítky</h3>
        <p>Štukové omítky jsou tradiční a velmi pevné. Hodí se na cihlové zdivo, do prostor s vyšším zatížením a tam, kde potřebujete odolný minerální povrch. Štukové omítky Praha realizujeme jak ve starších domech, tak v novostavbách, kde investor preferuje klasický materiál.</p>
        <h3>Vápenocementové omítky</h3>
        <p>Do vlhkých a technicky náročných prostor volíme vápenocementové omítky. Tyto omítky jsou pevné, odolné vůči vlhkosti a vhodné do koupelen (pod obklady), sklepů, garáží, soklů a průchozích chodeb. Vápenocementové omítky Praha doporučujeme tam, kde sádrové omítky nejsou vhodné.</p>
        <h3>Vnitřní a vnější omítky</h3>
        <p>Vnitřní omítky Praha řešíme pro byty, rodinné domy, kanceláře i provozovny. Vnější omítky a fasády zajišťujeme včetně zateplení kontaktním zateplovacím systémem. Umíme tedy pokrýt celý obvodový plášť i všechny vnitřní stěny v rámci jedné zakázky.</p>

        <h2>Jak probíhá realizace strojních omítek v Praze</h2>
        <p>Každá zakázka má jasně daný postup, který minimalizuje zdržení a překvapení během prací:</p>
        <ol>
          <li><strong>Poptávka a konzultace</strong> – zavoláte nebo pošlete formulář, probereme rozsah, typ objektu a termín</li>
          <li><strong>Zaměření na stavbě</strong> – přijedeme do vaší lokality v Praze nebo okolí, prohlédneme podklady a změříme plochy</li>
          <li><strong>Návrh postupu a materiálu</strong> – doporučíme vhodný typ omítky podle vlhkosti, zatížení a požadovaného výsledku</li>
          <li><strong>Cenová nabídka zdarma</strong> – obdržíte přehlednou nabídku s rozpisem prací a orientační cenou</li>
          <li><strong>Příprava stavby</strong> – ochrana oken, podlah a okolních ploch, penetrace podkladu, osazení lišt</li>
          <li><strong>Strojní aplikace omítky</strong> – nanesení směsi strojem, vyrovnání a kontrola rovinnosti</li>
          <li><strong>Technologická přestávka</strong> – zrání omítky podle pokynů výrobce materiálu</li>
          <li><strong>Finální úpravy a předání</strong> – zapravení detailů, kontrola kvality, úklid a předání hotového povrchu</li>
        </ol>
        <p>V Praze často řešíme specifické podmínky – omezený příjezd do centra, nutnost koordinace se správcem domu, práce v obydleném bytě nebo noční provoz v kancelářských budovách. Všechny tyto faktory zohledňujeme už při plánování, abyste přesně věděli, co vás čeká.</p>

        <h2>Orientační cena strojních omítek v Praze</h2>
        <p>Cena strojních omítek závisí na několika faktorech: typu omítky, stavu podkladu, celkové ploše, přístupu na stavbu a požadovaném finálním povrchu. Orientačně platí:</p>
        <ul>
          <li>Strojní sádrové omítky: od 250 Kč/m² (standardní podklad, bez složitých detailů)</li>
          <li>Sádrové omítky s finálním gletem: od 350 Kč/m²</li>
          <li>Štukové omítky: od 300 Kč/m²</li>
          <li>Vápenocementové omítky: od 280 Kč/m²</li>
          <li>Lokální opravy a vysprávky podkladu: dle rozsahu, obvykle od 150 Kč/m²</li>
        </ul>
        <p>Uvedené ceny jsou orientační a slouží pro první odhad. Přesnou cenu stanovíme až po zaměření na stavbě, kdy vidíme skutečný stav podkladu, rozsah prací a přístupové podmínky. U větších zakázek (nad 200 m²) nebo při kompletní omítkování rodinného domu nabízíme výhodnější metr čtvereční. Nezávaznou cenovou nabídku připravíme vždy zdarma.</p>

        <h2>Praha a okolí – kde působíme</h2>
        <p>Hlavní oblastí naší působnosti je Praha jako celek – včetně všech městských částí od centra po periferii. Kromě toho pravidelně jezdíme do:</p>
        <ul>
          <li><strong>Praha-východ</strong> – Říčany, Český Brod, Brandýs nad Labem, Kolín a okolí</li>
          <li><strong>Praha-západ</strong> – Jesenice, Hostivice, Roztoky, Rudná, Beroun a okolí</li>
          <li><strong>Středočeský kraj</strong> – Kladno, Mladá Boleslav, Mělník, Nymburk, Kutná Hora, Benešov, Beroun</li>
        </ul>
        <p>Strojní omítky Praha-východ a strojní omítky Praha-západ patří mezi naše nejčastější zakázky mimo samotnou metropoli. Díky zázemí v Praze 9 – Vysočany dokážeme rychle reagovat na poptávky z celého regionu. Pokud stavíte rodinný dům v okolí Prahy, rádi vám pomůžeme s omítkami od hrubé stěny až po finální povrch.</p>

        <h2>Proč zvolit KOST STAV PRAHA s.r.o.</h2>
        <p>Na trhu omítkářských firem v Praze existuje mnoho nabídek. My se odlišujeme především těmito body:</p>
        <ul>
          <li><strong>Zkušenosti s pražskými stavbami</strong> – známe specifika městské zástavby, logistiku i požadavky investorů</li>
          <li><strong>Komplexní služby</strong> – strojní omítky, sádrové omítky, štukové omítky, vápenocementové omítky, zateplení fasád i fasádní práce pod jednou střechou</li>
          <li><strong>Nezávazná nabídka zdarma</strong> – přijedeme na zaměření a připravíme cenovou kalkulaci bez poplatku</li>
          <li><strong>Průhledná komunikace</strong> – vždy víte, co se děje na stavbě, jaký je další krok a kdy bude hotovo</li>
          <li><strong>Kvalitní materiály</strong> – pracujeme s ověřenými směsmi, které odpovídají typu podkladu a provozu místnosti</li>
          <li><strong>Dodržování termínů</strong> – plánujeme etapy tak, aby navazovaly na další řemesla bez zbytečného čekání</li>
          <li><strong>Čisté předání</strong> – po dokončení prací uklidíme a předáme povrch připravený pro navazující profese</li>
        </ul>
        <p>Naše realizace najdete v sekci reference a realizace – včetně projektů v Praze 9 (Vysočany), Kladně, Kolíně, Berouně a dalších lokalit. Reference od zákazníků potvrzují, že oceňují především rychlou domluvu, férovou cenu a kvalitu detailů.</p>

        <h2>Časté otázky (FAQ)</h2>
        <div class="faq">
          <details><summary>Provádíte strojní omítky v celé Praze?</summary><p>Ano, jezdíme do všech pražských městských částí. Nemusíte hledat samostatné stránky pro Prahu 1 až Praha 10 – pokrýváme celou metropoli z jednoho místa. Přijedeme na zaměření, posoudíme podklady a připravíme nabídku.</p></details>
          <details><summary>Jaký je rozdíl mezi strojními a ručními omítkami?</summary><p>Strojní omítky se aplikují strojem omítkomítačkou, což je rychlejší a vhodné pro větší plochy. Ruční omítky se používají u menších ploch, složitých detailů nebo tam, kde stroj nemá přístup. Doporučíme vám vhodný postup podle konkrétní stavby.</p></details>
          <details><summary>Jak dlouho trvá zrání omítek před malováním?</summary><p>Záleží na typu omítky a podmínkách na stavbě. Sádrové omítky obvykle zrají 7–14 dní, vápenocementové déle. Přesný termín sdělíme v nabídce a během realizace vás informujeme, kdy bude povrch připraven pro malíře.</p></details>
          <details><summary>Je možné omítky provádět v obydleném bytě?</summary><p>Ano, pracujeme i v obydlených bytech. Domluvíme ochranu nábytku, postup po místnostech a minimalizaci prašnosti. Důležitá je dobrá komunikace a plán, aby pracovníci mohli efektivně pracovat.</p></details>
          <details><summary>Poskytujete záruku na omítky?</summary><p>Ano, na provedené omítkářské práce poskytujeme záruku dle smlouvy. Záruční podmínky a rozsah jsou součástí cenové nabídky a smlouvy o dílo.</p></details>
          <details><summary>Umíte zajistit i zateplení fasády spolu s omítkami?</summary><p>Ano, kromě vnitřních omítek zajišťujeme i zateplení fasád a fasádní práce. Vše můžeme sladit v jednom harmonogramu, což šetří čas i náklady na koordinaci více dodavatelů.</p></details>
        </div>

        <h2>Nezávazná poptávka na strojní omítky v Praze</h2>
        <p>Potřebujete strojní omítky v Praze nebo okolí? Zavolejte nám na <a href="$PhoneHref">$Phone</a>, napište přes WhatsApp nebo vyplňte formulář níže. Připravíme nezávaznou cenovou nabídku zdarma a domluvíme termín zaměření. Pošlete nám ideálně fotografie stavby, orientační plochu v m² a požadovaný termín realizace – díky tomu dokážeme reagovat rychleji a přesněji.</p>
      </article>
      <aside class="contactbox seo-sidebox">
        <h2>Rychlá nabídka</h2>
        <p class="muted">Pošlete nám lokalitu, fotky a přibližný rozsah. Ozveme se s dalším postupem.</p>
        <div class="actions"><a class="btn" href="$PhoneHref">Zavolat</a><a class="btn alt" href="$WhatsApp">WhatsApp</a></div>
        <p><b>$Phone</b><br><span>$Email</span></p>
      </aside>
    </div>
  </section>
  <section class="section-soft">
    <div class="container">
      <div class="section-head"><h2>Omítky a fasády v Praze</h2><p>Vyberte si související službu pro omítky, zateplení fasád nebo fasádní práce v Praze.</p></div>
      <div class="grid service-grid">$Cards</div>
    </div>
  </section>
  <section class="section-soft" data-realizace-lokality data-service="strojni-omitky" data-city="praha" data-city-name="Praha" hidden>
    <div class="container">
      <div class="section-head"><h2 data-realizace-heading>Realizace v Praze</h2><p>Ukázky dokončených omítek a fasád v Praze a okolí.</p></div>
      <div class="grid" data-realizace-list></div>
    </div>
  </section>
  <section>
    <div class="container split">
      <div>
        <h2>Výhody spolupráce s $Company</h2>
        <p class="muted">Stavíme na poctivém přístupu, kvalitních materiálech a srozumitelné komunikaci.</p>
        <div class="list">$Benefits</div>
      </div>
      <div class="contactbox">
        <h2>Proč řešit poptávku včas</h2>
        <p>Včasná poptávka pomáhá sladit materiál, přípravu podkladu a termín pro navazující řemesla.</p>
        <p>Stačí zavolat nebo poslat fotografie a krátký popis projektu.</p>
      </div>
    </div>
  </section>
  <section class="section-soft">
    <div class="container split">$Form</div>
  </section>
  $Cta
</main>
$Footer
</body>
</html>
"@
}

function Locality-Page($Service, $Loc, $LocIndex, $ServiceIndex) {
  $FileName = "$($Service.slug)-$($Loc.slug).html"
  $Canonical = "$SiteUrl/lokality/$FileName"
  $Title = "$(Escape-Html "$($Service.title) $($Loc.name) | $Company")"
  $Description = "$(Escape-Html "$($Service.title) $($Loc.name): kvalitní realizace, zaměření a nezávazná cenová nabídka zdarma. Omítky, zateplení fasád a fasádní práce pro Prahu a Středočeský kraj.")"
  $Keywords = "$(Escape-Html "$($Service.lower) $($Loc.name), strojní omítky Praha, strojní omítky Středočeský kraj, sádrové omítky Praha, štukové omítky Praha, vápenocementové omítky Praha, zateplení fasád Praha, zateplení fasád Středočeský kraj, fasádní práce Praha, fasádní práce Středočeský kraj")"
  $Opening = Opening-Text $Service $Loc ($LocIndex + $ServiceIndex)
  $Detail1 = Detail-Text $Service $Loc ($ServiceIndex + 1)
  $Detail3 = Detail-Text $Service $Loc ($ServiceIndex + 3)
  $Related = (($Service.related -split ";") | ForEach-Object { "<li>$_</li>" }) -join ""
  $Schema = @{
    "@context" = "https://schema.org"
    "@type" = "Service"
    name = "$($Service.title) $($Loc.name)"
    description = "$Company zajišťuje $($Service.lower) $($Loc.prep), v Praze a Středočeském kraji."
    serviceType = $Service.title
    areaServed = @{ "@type" = "Place"; name = $Loc.name }
    provider = @{
      "@type" = "LocalBusiness"
      name = $Company
      telephone = $Phone
      email = $Email
      address = @{
        "@type" = "PostalAddress"
        streetAddress = "K Žižkovu 809/7"
        addressLocality = "Praha 9 - Vysočany"
        addressCountry = "CZ"
      }
      url = $SiteUrl
    }
    url = $Canonical
  } | ConvertTo-Json -Depth 8 -Compress
  $Header = Header-Html "../"
  $Cta = Cta-Html "../"
  $Footer = Footer-Html "../"
  $Cards = Service-Cards $Loc $Service
  $Benefits = Benefit-Cards $Service $Loc
  $Reviews = Review-Html $Service $Loc $LocIndex $ServiceIndex
  $Faq = Faq-Items $Service $Loc $LocIndex $ServiceIndex
  $Form = Contact-Form $Service $Loc
  $Gallery = Realization-Gallery $Service $Loc $LocIndex $ServiceIndex

@"
<!doctype html>
<html lang="cs">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>$Title</title>
  <meta name="description" content="$Description">
  <meta name="keywords" content="$Keywords">
  <link rel="canonical" href="$Canonical">
  <link rel="stylesheet" href="../styles.css">
  <script src="../poptavka.js" defer></script>
  <script src="../realizace-lokality.js" defer></script>
  <script type="application/ld+json">$Schema</script>
</head>
<body>
$Header
<main>
  <section class="pagehead seo-head">
    <div class="container">
      <p class="breadcrumb"><a href="../index.html">Domů</a> / <a href="../lokality.html">Lokality</a> / $($Service.title) $($Loc.name)</p>
      <h1>$($Service.title) $($Loc.name)</h1>
      <p class="muted">$Company zajišťuje $($Service.lower) $($Loc.prep). Přijedeme na zaměření, doporučíme vhodný postup a připravíme nezávaznou cenovou nabídku zdarma.</p>
      <div class="actions"><a class="btn" href="$PhoneHref">Zavolat $Phone</a><a class="btn alt" href="$WhatsApp">WhatsApp poptávka</a></div>
    </div>
  </section>
$Gallery
  <section>
    <div class="container seo-layout">
      <article class="seo-article">
        <h2>$($Service.title) $($Loc.name) s důrazem na kvalitu a termín</h2>
        <p>$Opening</p>
        <p>$Detail1</p>
        <h2>Jak probíhá realizace $($Loc.prep)</h2>
        <p>Typický postup zahrnuje $($Service.process). Před zahájením si společně potvrdíme rozsah, přístup na stavbu, ochranu okolních ploch a návaznost na další omítkářské nebo fasádní kroky. Díky tomu zákazník přesně ví, kdy práce začnou, co má být připravené a jak bude vypadat předání.</p>
        <p>$Detail3</p>
        <p>$($Loc.name) je lokalita, kde řešíme hlavně $($Loc.setting). Proto se neptáme jen na metry čtvereční, ale také na typ objektu, vlhkost, stav původních vrstev, požadovanou odolnost a finální vzhled. Tato zdánlivá drobnost často rozhoduje o tom, zda bude výsledek spolehlivý a bez pozdějších oprav.</p>
        <h2>Související omítkářské a fasádní služby</h2>
        <p>Na jednu zakázku často navazují další povrchové vrstvy. Pokud při realizaci vyjde najevo, že je vhodné doplnit opravy podkladu, stěrky, zateplení fasády nebo finální fasádní omítku, umíme vše sladit v jednom harmonogramu. Nejčastěji se službou $($Service.lower) souvisí:</p>
        <ul>$Related</ul>
      </article>
      <aside class="contactbox seo-sidebox">
        <h2>Rychlá nabídka</h2>
        <p class="muted">Pošlete nám lokalitu, fotky a přibližný rozsah. Ozveme se s dalším postupem.</p>
        <div class="actions"><a class="btn" href="$PhoneHref">Zavolat</a><a class="btn alt" href="$WhatsApp">WhatsApp</a></div>
        <p><b>$Phone</b><br><span>$Email</span></p>
      </aside>
    </div>
  </section>
  <section class="section-soft">
    <div class="container">
      <div class="section-head"><h2>Omítky a fasády v lokalitě $($Loc.name)</h2><p>Vyberte si službu pro omítky, zateplení fasád nebo fasádní práce v lokalitě $($Loc.name). Všechny stránky obsahují konkrétní informace, interní odkazy a možnost rychlé poptávky.</p></div>
      <div class="grid service-grid">$Cards</div>
    </div>
  </section>
  <section class="section-soft" data-realizace-lokality data-service="$($Service.slug)" data-city="$($Loc.slug)" data-city-name="$($Loc.name)" hidden>
    <div class="container">
      <div class="section-head"><h2 data-realizace-heading>Realizace v lokalitě $($Loc.name)</h2><p>Ukázky dokončených omítek a fasád se stejnou službou v této lokalitě. Každá realizace odkazuje na detail projektu, službu a město.</p></div>
      <div class="grid" data-realizace-list></div>
    </div>
  </section>
  <section>
    <div class="container split">
      <div>
        <h2>Výhody spolupráce s $Company</h2>
        <p class="muted">Stavíme na poctivém přístupu, kvalitních materiálech a srozumitelné komunikaci. Nejdůležitější je pro nás dobrý výsledek, rovný povrch a čistý detail omítek nebo fasády.</p>
        <div class="list">$Benefits</div>
      </div>
      <div class="contactbox">
        <h2>Proč řešit poptávku včas</h2>
        <p>Včasná poptávka pomáhá sladit materiál, přípravu podkladu, technologické přestávky a termín pro navazující řemesla bez zbytečného čekání.</p>
        <p>Stačí zavolat nebo poslat fotografie a krátký popis projektu.</p>
      </div>
    </div>
  </section>
  <section class="section-soft">
    <div class="container">
      <div class="section-head"><h2>Recenze zákazníků</h2><p>Zákazníci oceňují rychlou domluvu, čistý průběh a férové jednání.</p></div>
      <div class="reviews">$Reviews</div>
    </div>
  </section>
  <section>
    <div class="container">
      <div class="section-head"><h2>FAQ: $($Service.title) $($Loc.name)</h2><p>Nejčastější dotazy před zaměřením a realizací.</p></div>
      <div class="faq">$Faq</div>
    </div>
  </section>
  <section class="section-soft">
    <div class="container split">$Form</div>
  </section>
  $Cta
</main>
$Footer
</body>
</html>
"@
}

function Overview-Page {
  $ServiceBlocks = (($Services | ForEach-Object {
    $Service = $_
    $CityLinks = (($FeaturedLocalities | ForEach-Object {
@"
<a href="lokality/$($Service.slug)-$($_.slug).html">$($_.name)</a>
"@
    }) -join "")
@"
<article class="card locality-card service-location-block"><h2>$($Service.title)</h2><p>$($Service.lead). Vyberte lokalitu a otevřete konkrétní stránku služby.</p><div class="mini-links">$CityLinks</div></article>
"@
  }) -join "")
  $CityCards = (($FeaturedLocalities | ForEach-Object {
    $Loc = $_
    $Links = (($Services | ForEach-Object {
@"
<a href="lokality/$($_.slug)-$($Loc.slug).html">$($_.title)</a>
"@
    }) -join "")
@"
<article class="card locality-card"><h2>$($Loc.name)</h2><p>$(Cap $Loc.area) realizujeme strojní omítky, sádrové omítky, štukové omítky, vápenocementové omítky, zateplení fasád a fasádní práce.</p><div class="mini-links">$Links</div></article>
"@
  }) -join "")
  $Header = Header-Html ""
  $Cta = Cta-Html ""
  $Footer = Footer-Html ""
@"
<!doctype html>
<html lang="cs">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Lokality | Omítky a fasádní práce Praha a Středočeský kraj</title>
  <meta name="description" content="Přehled lokalit KOST STAV PRAHA s.r.o. Strojní omítky, sádrové omítky, štukové omítky, vápenocementové omítky, zateplení fasád a fasádní práce.">
  <link rel="canonical" href="$SiteUrl/lokality.html">
  <link rel="stylesheet" href="styles.css">
</head>
<body>
$Header
<main>
  <section class="pagehead">
    <div class="container">
      <h1>Lokality pro omítky a fasády</h1>
      <p class="muted">$Company působí v Praze a ve Středočeském kraji. Vyberte službu a město, pro které hledáte nezávaznou cenovou nabídku.</p>
      <div class="actions"><a class="btn" href="$PhoneHref">Zavolat $Phone</a><a class="btn alt" href="kontakt.html">Odeslat poptávku</a></div>
    </div>
  </section>
  <section>
    <div class="container">
      <div class="section-head"><h2>Rozdělení podle služeb</h2><p>Každá služba má samostatné stránky pro hlavní lokality v Praze a Středočeském kraji.</p></div>
      <div class="locality-grid service-location-grid">$ServiceBlocks</div>
    </div>
  </section>
  <section>
    <div class="container">
      <div class="section-head"><h2>Rozdělení podle měst</h2><p>V každé lokalitě najdete odkazy na strojní omítky, sádrové omítky, štukové omítky, vápenocementové omítky, zateplení fasád a fasádní práce.</p></div>
      <div class="locality-grid">$CityCards</div>
    </div>
  </section>
  $Cta
</main>
$Footer
</body>
</html>
"@
}

function Sitemap-Html($PageFiles) {
  $StaticPages = @("index.html", "o-nas.html", "sluzby.html", "reference.html", "galerie.html", "kontakt.html", "lokality.html")
  $Urls = @($StaticPages + ($PageFiles | ForEach-Object { "lokality/$_" }))
  $Items = (($Urls | ForEach-Object {
    $Change = if ($_.StartsWith("lokality/")) { "monthly" } else { "weekly" }
    $Priority = if ($_ -eq "index.html") { "1.0" } elseif ($_ -eq "lokality.html") { "0.9" } elseif ($_.StartsWith("lokality/")) { "0.8" } else { "0.7" }
@"
  <url>
    <loc>$SiteUrl/$_</loc>
    <lastmod>$LastMod</lastmod>
    <changefreq>$Change</changefreq>
    <priority>$Priority</priority>
  </url>
"@
  }) -join "`n")
@"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
$Items
</urlset>
"@
}

function Robots-Txt {
@"
User-agent: *
Allow: /
Disallow: /admin.html
Disallow: /404.html

Sitemap: $SiteUrl/sitemap.xml
"@
}

function Update-RootNavigation {
  $Files = @("index.html", "o-nas.html", "sluzby.html", "reference.html", "galerie.html", "kontakt.html")
  foreach ($File in $Files) {
    $Path = Join-Path $Root $File
    if (!(Test-Path $Path)) { continue }
    $Html = [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
    $Html = $Html.Replace('<a href="lokality.html">Lokality</a>', '')
    $Html = $Html.Replace('<br><a href="lokality.html">Lokality</a>', '')
    $Html = $Html.Replace('<a href="lokality.html">Lokality</a><br>', '')
    Write-Utf8File $Path $Html
  }
}

function Count-Words($Html) {
  $Text = $Html -replace "(?is)<script.*?</script>", " " -replace "(?is)<style.*?</style>", " " -replace "<[^>]+>", " " -replace "&[a-z0-9#]+;", " "
  return ([regex]::Matches($Text, "[0-9A-Za-zÁ-ž]+(?:[-–][0-9A-Za-zÁ-ž]+)*")).Count
}

$LocalityDir = Join-Path $Root "lokality"
New-Item -ItemType Directory -Force -Path $LocalityDir | Out-Null
Get-ChildItem -Path $LocalityDir -Filter "*.html" -File | Remove-Item -Force

$PageFiles = New-Object System.Collections.Generic.List[string]
$WordCounts = @()

for ($LocIndex = 0; $LocIndex -lt $Localities.Count; $LocIndex++) {
  $Loc = $Localities[$LocIndex]
  for ($ServiceIndex = 0; $ServiceIndex -lt $Services.Count; $ServiceIndex++) {
    $Service = $Services[$ServiceIndex]
    $FileName = "$($Service.slug)-$($Loc.slug).html"
    if ($Service.slug -eq "strojni-omitky" -and $Loc.slug -eq "praha") {
      $Html = Praha-Strojni-Pillar-Page $Service $Loc $LocIndex $ServiceIndex
    } else {
      $Html = Locality-Page $Service $Loc $LocIndex $ServiceIndex
    }
    Write-Utf8File (Join-Path $LocalityDir $FileName) $Html
    $PageFiles.Add($FileName)
    $WordCounts += [pscustomobject]@{ File = $FileName; Words = Count-Words $Html }
  }
}

for ($LocIndex = 0; $LocIndex -lt $DeprecatedPragueDistricts.Count; $LocIndex++) {
  $Loc = $DeprecatedPragueDistricts[$LocIndex]
  for ($ServiceIndex = 0; $ServiceIndex -lt $Services.Count; $ServiceIndex++) {
    $Service = $Services[$ServiceIndex]
    $FileName = "$($Service.slug)-$($Loc.slug).html"
    $Html = Locality-Page $Service $Loc ($LocIndex + 100) $ServiceIndex
    Write-Utf8File (Join-Path $LocalityDir $FileName) $Html
    $PageFiles.Add($FileName)
  }
}

Write-Utf8File (Join-Path $Root "lokality.html") (Overview-Page)
Write-Utf8File (Join-Path $Root "sitemap.xml") (Sitemap-Html $PageFiles)
Write-Utf8File (Join-Path $Root "robots.txt") (Robots-Txt)
Update-RootNavigation

$Min = $WordCounts | Sort-Object Words | Select-Object -First 1
$Max = $WordCounts | Sort-Object Words -Descending | Select-Object -First 1
$Short = @($WordCounts | Where-Object { $_.Words -lt 700 })

Write-Host "Generated $($PageFiles.Count) locality service pages."
Write-Host "Word count range: $($Min.Words) ($($Min.File)) - $($Max.Words) ($($Max.File))."
Write-Host "Pages below 700 words: $($Short.Count)."

$SeoBuild = Join-Path $Root "generate-seo.ps1"
if (Test-Path $SeoBuild) {
  & $SeoBuild
}













