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
$BlogDir = Join-Path $Root "blog"

$Articles = @"
no|slug|title|category|keyword|service|serviceSlug|summary|audience|focus|challenge|result|price|prep|warning|decision
1|strojni-omitky-praha|Strojní omítky Praha – kdy se vyplatí a jak probíhá realizace|Omítky|strojní omítky Praha|strojní omítky|strojni-omitky|Praktický průvodce pro investory, kteří chtějí rychlé, rovné a dobře naplánované omítky v Praze.|majitele rodinných domů, investory novostaveb a menší developerské projekty|rychlost realizace, rovinnost a dobrá návaznost na další profese|špatně připravený podklad, nedokončené rozvody a podceněné technologické přestávky|hladké stěny připravené pro malbu a čisté napojení detailů|cenu ovlivňuje plocha, členitost stavby, výška stěn, typ směsi a připravenost objektu|dokončené instalace, vyklizené místnosti, zakrytá okna a jasný přístup pro materiál|nejčastější chybou je začít bez kontroly vlhkosti, savosti a pevnosti podkladu|volba dává smysl u větších ploch, kde je důležitá rychlost a jednotný výsledek
2|sadrove-omitky-praha|Sádrové omítky Praha – moderní řešení pro novostavby a rekonstrukce|Omítky|sádrové omítky Praha|sádrové omítky|sadrove-omitky|Vysvětlení výhod sádrových omítek pro moderní interiéry, hladký povrch a příjemné vnitřní klima.|zákazníky, kteří chtějí hladký interiér v novém domě nebo při obnově bytu|hladkost povrchu, rychlé dokončení a příjemný vzhled obytných místností|nevhodné použití ve vlhkých prostorách a nedostatečné větrání při schnutí|čistý interiér s minimem broušení a povrchem připraveným na malbu|cenu ovlivňuje typ směsi, tloušťka vrstvy, přesnost podkladu a počet detailů|suchý a soudržný podklad, dokončené rozvody a stabilní teplota v objektu|sádrové omítky se nemají volit automaticky do každého prostoru bez posouzení vlhkosti|jsou ideální pro obytné místnosti, ložnice, chodby a kanceláře
3|stukove-omitky-praha|Štukové omítky Praha – klasická kvalita pro hladké stěny|Omítky|štukové omítky Praha|štukové omítky|stukove-omitky|Článek popisuje, kdy jsou štukové omítky správnou volbou a proč stále patří mezi oblíbené povrchové úpravy.|majitele starších domů, bytů a zákazníky, kteří chtějí klasický jemný povrch|sjednocení povrchů, opravy podkladu a finální vzhled stěn|nedostatečné odstranění nesoudržných vrstev a špatně zvolená penetrace|pevný jemný povrch vhodný pro malbu a lokální opravy|cenu určuje stav původních omítek, rozsah vysprávek a požadovaná kvalita finálního povrchu|očištěný podklad, odstranění volných částí a domluvený rozsah oprav|štuk nemá překrývat problémy podkladu, které je potřeba nejdříve vyřešit|vyplatí se tam, kde zákazník chce klasický vzhled a možnost dobrých lokálních oprav
4|vapenocementove-omitky-praha|Vápenocementové omítky Praha – odolné řešení pro náročné prostory|Omítky|vápenocementové omítky Praha|vápenocementové omítky|vapenocementove-omitky|Průvodce odolnými omítkami do koupelen, technických místností, garáží a namáhaných prostor.|zákazníky, kteří řeší odolné povrchy mimo běžné obytné místnosti|odolnost proti vlhkosti, pevnost a vhodnost pro zatížené části domu|záměna za méně odolný materiál a špatné posouzení vlhkosti zdiva|pevný minerální podklad připravený pro obklady, malbu nebo další vrstvy|cenu ovlivňuje tloušťka vrstvy, stav zdiva, vlhkost a členitost místností|kontrola vlhkosti, pevnosti podkladu a připravené prostupy instalací|nevyplatí se uspěchat zrání, protože pevnost a vysychání jsou pro výsledek zásadní|správná volba pro koupelny, garáže, sklepy, technické místnosti a soklové části
5|zatepleni-fasad-praha|Zateplení fasád Praha – jak snížit náklady na vytápění|Fasády|zateplení fasád Praha|zateplení fasád|zatepleni-fasad|Odborný článek o tom, jak správně navržené zateplení fasády pomáhá s úsporou energie a ochranou domu.|majitele rodinných a bytových domů, kteří řeší náklady na vytápění a stav obvodového pláště|tepelná ochrana, skladba systému a dlouhodobá životnost detailů|špatně zvolená tloušťka izolantu, podceněné kotvení a nekvalitní detaily kolem oken|nižší tepelné ztráty, nový vzhled fasády a lepší ochrana zdiva|cenu určuje typ izolantu, plocha fasády, členitost domu, lešení a stav podkladu|zaměření fasády, kontrola podkladu a vyřešení detailů kolem oken, soklu a střechy|největší riziko je levná skladba bez respektu k systému a technologii výrobce|vyplatí se u domů s vyššími tepelnými ztrátami nebo starší fasádou
6|fasadni-prace-praha|Fasádní práce Praha – co vše zahrnuje profesionální realizace|Fasády|fasádní práce Praha|fasádní práce|fasadni-prace|Přehled fasádních prací od opravy podkladu přes finální omítku až po sokl a detaily.|majitele domů, kteří potřebují obnovit vzhled fasády nebo dokončit povrch po zateplení|opravy, penetrace, armovací vrstvy, finální omítka a soklové detaily|podcenění přípravy podkladu a špatné počasí při aplikaci finálních vrstev|sjednocená fasáda s čistými hranami a dlouhodobě stabilním povrchem|cenu ovlivňuje rozsah oprav, členitost fasády, přístup a typ finální omítky|zajištění přístupu, kontrola soudržnosti fasády a naplánování vhodného počasí|fasádní práce nelze dělat kvalitně bez respektu k teplotě, větru a vlhkosti|jsou vhodné při obnově vzhledu domu, opravě trhlin nebo dokončení zateplovacího systému
7|jak-vybrat-spravny-typ-omitky-pro-rodinny-dum-v-praze|Jak vybrat správný typ omítky pro rodinný dům v Praze|Omítky|omítky Praha|omítky|strojni-omitky|Srovnání sádrových, štukových a vápenocementových omítek podle místnosti, podkladu a očekávaného výsledku.|majitele rodinných domů, kteří nechtějí vybírat materiál jen podle nejnižší ceny|správná volba podle vlhkosti, zatížení, vzhledu a navazujících prací|jedna univerzální volba pro celý dům bez ohledu na provoz místností|povrchy odpovídající funkci každé části domu a rozumný harmonogram prací|cenu ovlivňuje kombinace materiálů, počet místností a připravenost stavby|připravit půdorys, orientační plochy, fotografie a informaci o provozu místností|chyba je rozhodovat jen podle názvu omítky bez posouzení podkladu|správný typ se vybírá podle místnosti, vlhkosti a požadované odolnosti
8|strojni-vs-rucni-omitky-rozdily-vyhody-cena|Strojní vs. ruční omítky – rozdíly, výhody a cena|Omítky|strojní omítky Praha|strojní omítky|strojni-omitky|Srozumitelné porovnání strojních a ručních omítek pro zákazníky, kteří řeší rychlost, cenu a kvalitu.|investory, kteří zvažují technologii aplikace a chtějí férové srovnání|rychlost, přesnost, plocha a vhodnost technologie pro danou zakázku|špatný výběr technologie podle tradice místo podle rozsahu a podkladu|efektivní realizace s odpovídajícím poměrem ceny a kvality|cenu ovlivňuje plocha, logistika materiálu, náročnost detailů a rozsah ručních dooprav|jasně zakreslený rozsah, přístup pro techniku a domluvená ochrana okolí|ruční postup není automaticky lepší a strojní postup není vhodný pro každou drobnou opravu|strojní omítky se vyplatí hlavně u větších a souvislých ploch
9|nejcastejsi-chyby-pri-realizaci-omitek|Nejčastější chyby při realizaci omítek|Omítky|omítky Praha|omítky|strojni-omitky|Přehled chyb, které prodražují omítky a zhoršují výslednou kvalitu povrchu.|zákazníky, kteří chtějí předejít opravám, zdržení a zbytečným vícepracím|příprava podkladu, koordinace profesí a kontrola technologických pravidel|zahájení prací na vlhkém, nesoudržném nebo zaprášeném podkladu|rovné, soudržné a dobře vysychající omítky bez zbytečných oprav|cenu navyšují dodatečné vysprávky, špatná logistika a přerušování prací|vyklizená stavba, dokončené rozvody a jasné zadání před nástupem firmy|nejdražší chyba bývá snaha ušetřit na přípravě podkladu|kvalitní firma chyby aktivně hledá před začátkem prací
10|kolik-stoji-strojni-omitky-v-praze|Kolik stojí strojní omítky v Praze|Omítky|strojní omítky Praha cena|strojní omítky|strojni-omitky|Článek vysvětluje, z čeho se skládá cena strojních omítek a proč nelze odpovědět jen jednou částkou za metr.|zákazníky, kteří chtějí rozumět cenové nabídce a porovnat ji férově|plocha, typ omítky, podklad, doprava materiálu a náročnost detailů|porovnávání nabídek bez stejného rozsahu a bez kontroly zahrnutých položek|přehledná kalkulace s jasným rozsahem a bez překvapení na stavbě|cenu ovlivňuje metrů čtverečních, typ směsi, tloušťka, lišty, ochrana a příprava|poslat výměry, fotografie, projekt a informaci o připravenosti stavby|pozor na nabídky, které neuvádějí přípravu, dopravu nebo dokončení detailů|dobrá cena musí odpovídat rozsahu, materiálu a kvalitě provedení
11|kolik-stoji-zatepleni-fasady-v-praze|Kolik stojí zateplení fasády v Praze|Fasády|zateplení fasády Praha cena|zateplení fasády|zatepleni-fasad|Praktický rozbor ceny zateplení fasády v Praze včetně materiálu, lešení, detailů a přípravy.|majitele domů, kteří chtějí realisticky plánovat rozpočet fasády|skladba systému, izolant, lešení, kotvení a finální omítka|porovnání cen bez znalosti tloušťky izolantu a rozsahu fasádních detailů|zateplení s dobrou životností, funkčními detaily a jasnou cenou|cenu určuje plocha, izolant, členitost domu, výška, lešení a stav původní fasády|připravit fotografie, rozměry domu, informaci o oknech a stavu podkladu|největší riziko je podhodnocený rozpočet bez soklu, ostění a detailů|kvalitní nabídka popisuje systém, materiály i postup realizace
12|kdy-zvolit-sadrove-omitky-a-kdy-vapenocementove|Kdy zvolit sádrové omítky a kdy vápenocementové|Omítky|sádrové omítky Praha|sádrové omítky|sadrove-omitky|Srovnání dvou oblíbených typů omítek podle vlhkosti, provozu místnosti a požadovaného povrchu.|zákazníky, kteří vybírají materiál do různých místností domu|vlhkost, odolnost, hladkost a návaznost na obklady nebo malbu|použití sádry do příliš vlhkých prostor nebo zbytečně robustní řešení v obytných pokojích|správně rozdělené materiály podle funkce místností|cenu ovlivňuje kombinace omítek, rozsah a požadovaná kvalita finálního povrchu|znát účel místností, plánované obklady a očekávanou vlhkost|chyba je volit jeden materiál pro celý dům bez technického důvodu|sádrové jsou vhodné do obytných částí, vápenocementové do zatížených prostor
13|omitky-pro-novostavby-kompletni-pruvodce|Omítky pro novostavby – kompletní průvodce|Omítky|omítky pro novostavby Praha|omítky|strojni-omitky|Kompletní průvodce plánováním omítek v novostavbě od rozvodů až po schnutí a navazující práce.|stavebníky nových rodinných domů v Praze a okolí|správné pořadí prací, příprava stavby a technologické přestávky|nástup omítkářů před dokončením hrubých rozvodů nebo bez kontroly oken|rovné povrchy a dobře sladěný harmonogram dokončení domu|cenu ovlivňuje plocha domu, výška stropů, typ směsi a připravenost novostavby|dokončit rozvody, osadit okna, vyčistit podklady a vyřešit větrání|novostavba často vypadá připraveně dříve, než je technicky připravená|dobré plánování zabrání čekání dalších profesí
14|omitky-pri-rekonstrukci-domu-na-co-si-dat-pozor|Omítky při rekonstrukci domu – na co si dát pozor|Omítky|omítky při rekonstrukci Praha|omítky|stukove-omitky|Odborný návod pro omítky ve starších domech, kde rozhoduje stav původních vrstev a vlhkost.|majitele starších domů, bytů a objektů s nejasným stavem podkladu|posouzení původních omítek, vlhkosti, trhlin a soudržnosti zdiva|překrytí starých problémů novou vrstvou bez opravy příčiny|sjednocený povrch s funkčním podkladem a menším rizikem pozdějších vad|cenu ovlivňuje rozsah odstranění starých vrstev, vysprávky a materiál|odstranit volné části, umožnit kontrolu zdiva a připravit přístup|u starších domů je největší riziko vlhkost a nesoudržný podklad|správný postup začíná diagnostikou, ne okamžitým natažením nové vrstvy
15|zatepleni-fasady-krok-za-krokem|Zateplení fasády krok za krokem|Fasády|zateplení fasády Praha|zateplení fasády|zatepleni-fasad|Popis jednotlivých kroků kvalitního zateplení fasády od zaměření přes armování až po finální omítku.|zákazníky, kteří chtějí vědět, co se na fasádě bude dít a proč|technologický postup, kontrola podkladu a návaznost detailů|přeskakování kroků a nahrazování systémových detailů improvizací|funkční zateplovací systém s dlouhodobou životností|cenu ovlivňuje plocha, izolant, lešení, počet detailů a stav podkladu|vyřešit přístup, klempířské prvky, ostění, sokl a návaznost střechy|u fasády se nevyplatí šetřit na armovací vrstvě a detailech|krokový postup pomáhá zákazníkovi kontrolovat kvalitu prací
16|jak-dlouho-schnou-omitky-a-kdy-pokracovat|Jak dlouho schnou omítky a kdy pokračovat s dalšími pracemi|Omítky|jak dlouho schnou omítky|omítky|strojni-omitky|Článek vysvětluje schnutí omítek, větrání, vytápění a bezpečný termín pro další práce.|investory, kteří potřebují naplánovat malbu, podlahy nebo montáže po omítkách|vlhkost, větrání, teplota a tloušťka omítkové vrstvy|uspěchané malování, zaklopení vlhkosti a špatné větrání stavby|stabilní a vyzrálý povrch připravený pro další úpravy|cenu nepřímo ovlivní zdržení harmonogramu a opravy po uspěchaném postupu|zajistit větrání, stabilní teplotu a měření vlhkosti před navazujícími pracemi|nejčastější chybou je řídit se jen kalendářem místo skutečné vlhkosti|pokračovat má smysl až ve chvíli, kdy je povrch technicky připravený
17|jak-pripravit-stavbu-pred-strojnimi-omitkami|Jak připravit stavbu před strojními omítkami|Omítky|strojní omítky Praha|strojní omítky|strojni-omitky|Checklist pro přípravu stavby před strojními omítkami, aby práce proběhly rychle a bez zdržení.|stavebníky, kteří chtějí mít stavbu připravenou před nástupem firmy|rozvody, otvory, podklady, přístup, voda, elektřina a ochrana okolí|nástup bez vyklizení, bez dokončených instalací nebo s nevyřešenými detaily|rychlá realizace bez prostojů a zbytečných víceprací|cenu ovlivní hlavně připravenost, počet oprav podkladu a logistika materiálu|dokončit instalace, vyklidit místnosti, zajistit přístup a vyčistit podklad|každá dodatečná úprava během omítek zdržuje celý harmonogram|dobrá příprava je nejjednodušší způsob, jak udržet cenu i termín
18|nejlepsi-omitky-do-koupelny-garaze-technicke-mistnosti|Nejlepší omítky do koupelny, garáže a technické místnosti|Omítky|vápenocementové omítky Praha|vápenocementové omítky|vapenocementove-omitky|Praktický výběr omítek pro vlhčí a více zatížené prostory rodinného domu.|majitele domů, kteří řeší koupelny, garáže, sklepy a technické místnosti|odolnost, vlhkost, mechanické zatížení a návaznost na obklady|volba příliš jemného materiálu do místností s vyšší zátěží|pevný povrch vhodný pro obklady, malbu i provozně náročnější využití|cenu ovlivní stav podkladu, vlhkost, tloušťka vrstev a rozsah obkladů|zkontrolovat vlhkost, připravit prostupy a určit plochy pro obklady|do zatížených místností nepatří automaticky stejná omítka jako do ložnice|vápenocementové omítky bývají nejbezpečnější volbou pro náročné prostory
19|proc-se-vyplati-profesionalni-firma-na-omitky|Proč se vyplatí profesionální stavební firma na omítky|Omítky|firma na omítky Praha|omítky|strojni-omitky|Článek vysvětluje, proč kvalifikovaná firma šetří čas, snižuje rizika a zlepšuje výsledek omítek.|zákazníky, kteří porovnávají svépomoc, levné nabídky a profesionální realizaci|organizace, zkušenosti, kvalita materiálů a odpovědnost za výsledek|nejasná nabídka, slabá příprava podkladu a chybějící kontrola detailů|přehledný průběh, rovné povrchy a menší riziko oprav|cenu je potřeba hodnotit podle rozsahu, ne jen podle nejnižší částky|připravit zadání, rozsah, fotografie a očekávaný termín|nejlevnější nabídka často neobsahuje vše, co zákazník skutečně potřebuje|profesionální firma má jasný postup a umí upozornit na rizika předem
20|fasadni-omitka-druhy-zivotnost-spravny-vyber|Fasádní omítka – druhy, životnost a správný výběr|Fasády|fasádní omítka Praha|fasádní omítka|fasadni-prace|Přehled druhů fasádních omítek a doporučení, jak vybírat podle domu, okolí a životnosti.|majitele domů, kteří řeší finální vzhled a ochranu fasády|typ omítky, zrnitost, barva, nasákavost a údržba|volba jen podle odstínu bez ohledu na systém a prostředí domu|odolný a vzhledově sjednocený povrch fasády|cenu ovlivňuje druh omítky, zrnitost, plocha, členitost a příprava podkladu|vybrat barevnost, zkontrolovat podklad a naplánovat vhodné počasí|špatně zvolená finální omítka může zkrátit životnost celé fasády|správný výběr kombinuje technické parametry i estetiku
21|zatepleni-domu-v-praze-nejcastejsi-otazky-zakazniku|Zateplení domu v Praze – nejčastější otázky zákazníků|Fasády|zateplení domu Praha|zateplení fasády|zatepleni-fasad|Odpovědi na nejčastější dotazy k zateplení domu v Praze, ceně, termínům a přípravě.|majitele domů, kteří chtějí před poptávkou vědět, co je čeká|cena, příprava, tloušťka izolantu, termín a detaily systému|nejistota zákazníků a nedostatek konkrétních informací před zaměřením|jasnější rozhodování a přesnější cenová nabídka|cenu ovlivňuje rozsah prací, lešení, typ izolantu a stav fasády|připravit rozměry domu, fotografie, informace o oknech a požadovaný termín|nepřesné zadání vede k nepřesné nabídce a zbytečným změnám|čím lepší podklady zákazník pošle, tím přesnější kalkulaci dostane
22|omitky-praha-vychod-kvalitni-realizace-rodinne-domy|Omítky Praha-východ – kvalitní realizace pro rodinné domy|Omítky|omítky Praha-východ|omítky|strojni-omitky|Lokální článek pro rodinné domy v okrese Praha-východ se zaměřením na strojní a sádrové omítky.|majitele novostaveb a domů v příměstských obcích východně od Prahy|rychlá dostupnost, koordinace novostaveb a volba správného typu omítky|podceněné plánování v rychle rostoucí příměstské zástavbě|kvalitní omítky sladěné s harmonogramem stavby|cenu ovlivňuje dojezd, rozsah, připravenost stavby a typ omítek|připravit projekt, plochy, fotografie a informaci o fázi stavby|u novostaveb v okolí Prahy bývá největší problém koordinace profesí|lokální firma může rychleji reagovat na zaměření a změny termínu
23|omitky-praha-zapad-strojni-sadrove-omitky|Omítky Praha-západ – strojní a sádrové omítky|Omítky|omítky Praha-západ|sádrové omítky|sadrove-omitky|Lokální průvodce omítkami pro obce západně od Prahy, kde se často řeší novostavby i náročnější detaily.|majitele domů, vil a novostaveb v lokalitě Praha-západ|strojní a sádrové omítky, hladký interiér a kvalitní detail|kombinace vyšších nároků na detail a nejasný harmonogram prací|hladké povrchy připravené pro moderní interiér|cenu ovlivňuje rozsah domu, kvalita podkladu, detaily a přístup na stavbu|připravit výměry, dokončit rozvody a vyřešit návaznosti u oken|u domů s vyšším standardem je potřeba věnovat pozornost každému detailu|správná volba firmy pomáhá udržet termín i kvalitu provedení
24|zatepleni-fasad-praha-vychod-profesionalni-realizace|Zateplení fasád Praha-východ – profesionální realizace|Fasády|zateplení fasád Praha-východ|zateplení fasády|zatepleni-fasad|Lokální článek o zateplení fasád rodinných domů v okrese Praha-východ.|majitele domů v obcích východně od Prahy, kteří řeší úsporu a vzhled domu|správná skladba zateplení, detaily a dlouhodobá ochrana zdiva|rychlé cenové nabídky bez kontroly stavu podkladu a členitosti domu|zateplená fasáda s nižšími tepelnými ztrátami a čistým vzhledem|cenu ovlivňuje plocha, izolant, lešení, sokl a detaily kolem oken|připravit fotografie fasády, orientační rozměry a informaci o stavu soklu|u fasád v příměstských lokalitách je důležitá dobrá logistika materiálu|profesionální realizace drží technologii systému od lepení po finální omítku
25|zatepleni-fasad-praha-zapad-uspora-energie-novy-vzhled|Zateplení fasád Praha-západ – úspora energie a nový vzhled domu|Fasády|zateplení fasád Praha-západ|zateplení fasády|zatepleni-fasad|Článek pro zákazníky z Prahy-západ, kteří chtějí spojit energetickou úsporu s estetickou obnovou domu.|majitele rodinných domů, vil a starších objektů západně od Prahy|úspora energie, čistý vzhled, sokl a kvalitní ostění|podcenění detailů u členitých fasád a špatné napojení na střechu|fasáda s lepší tepelnou ochranou a reprezentativním vzhledem|cenu ovlivňuje členitost domu, výška, izolant, lešení a finální omítka|připravit zaměření fasády, fotky detailů a požadavky na barevnost|náročnější domy potřebují přesnější přípravu a jasné řešení detailů|zateplení se vyplatí plánovat jako technické i vzhledové zlepšení domu
26|jak-poznat-kvalitne-provedene-omitky|Jak poznat kvalitně provedené omítky|Omítky|kvalitní omítky Praha|omítky|strojni-omitky|Návod, podle čeho poznat kvalitní omítky před předáním i při běžné kontrole stavby.|zákazníky, kteří chtějí rozumět předání omítkářských prací|rovinnost, rohy, špalety, soudržnost a čistota provedení|převzetí práce bez kontroly detailů a bez domluvených kritérií|povrch, který je připravený pro další úpravy a nemá skryté vady|cenu kvality ovlivňuje příprava, materiál, zkušenost týmu a čas na kontrolu|předem domluvit standard provedení a způsob předání prací|kvalitu nelze hodnotit jen z dálky a za špatného světla|dobrá realizace obstojí v detailech i při navazujících pracích
27|kdy-je-nejlepsi-obdobi-pro-fasadni-prace|Kdy je nejlepší období pro fasádní práce|Fasády|fasádní práce Praha|fasádní práce|fasadni-prace|Článek vysvětluje sezónnost fasádních prací, vhodné teploty, počasí a plánování termínu.|majitele domů, kteří chtějí správně načasovat opravu nebo zateplení fasády|teplota, déšť, vítr, slunce a technologické přestávky|snaha realizovat fasádu v nevhodných podmínkách kvůli tlaku na termín|fasádní práce provedené v počasí, které neohrozí kvalitu vrstev|cenu může ovlivnit sezóna, dostupnost lešení a náročnost ochrany fasády|naplánovat termín dopředu a počítat s rezervou na počasí|u fasád se nevyplatí ignorovat teplotu a vlhkost vzduchu|nejlepší období je takové, kdy lze dodržet technologii a bezpečně pracovat
28|nejcastejsi-dotazy-k-omitkam-a-fasadam|Nejčastější dotazy k omítkám a fasádám|Omítky|omítky a fasády Praha|omítky a fasády|strojni-omitky|Souhrnný článek odpovídající na dotazy zákazníků před poptávkou omítek nebo fasády.|zákazníky, kteří chtějí rychlou orientaci před telefonátem nebo odesláním poptávky|termíny, cena, příprava, typy materiálů a návaznosti prací|nejasné zadání a nedostatek informací pro přesnou cenovou nabídku|rychlejší domluva a konkrétnější návrh postupu|cenu ovlivňuje rozsah, materiál, stav podkladu, přístup a termín|připravit město, plochu, fotografie, popis stavu a požadovaný termín|největší zdržení vzniká, když zákazník nemá základní informace o rozsahu|dobrá poptávka zrychlí zaměření i cenovou nabídku
29|proc-si-vybrat-firmu-na-omitky-z-prahy-a-stredoceskeho-kraje|Proč si vybrat firmu na omítky z Prahy a Středočeského kraje|Omítky|firma na omítky Praha|omítky|strojni-omitky|Článek o výhodách lokální firmy pro omítky a fasády v Praze a Středočeském kraji.|zákazníky, kteří chtějí spolehlivou firmu s dostupností v regionu|rychlá komunikace, znalost lokalit, logistika a návaznost na regionální zakázky|výběr firmy bez ověření zkušeností, kapacity a skutečné dostupnosti|lepší koordinace, rychlejší zaměření a přehlednější průběh prací|cenu ovlivňuje rozsah, lokalita, dostupnost stavby a typ prací|poslat lokalitu, fotografie a očekávaný termín realizace|lokální působnost sama nestačí bez kvality, referencí a jasného postupu|správná firma umí spojit dostupnost s profesionálním provedením
30|omitky-a-fasady-praha-kompletni-pruvodce|Omítky a fasády Praha – kompletní průvodce pro zákazníky|Omítky|omítky a fasády Praha|omítky a fasády|strojni-omitky|Kompletní průvodce pro zákazníky, kteří řeší omítky, zateplení fasády nebo fasádní práce v Praze.|majitele domů, bytů a investory, kteří chtějí celý postup pochopit v souvislostech|výběr služby, plánování, cena, příprava a návaznost omítek a fasád|oddělené řešení prací bez koordinace a bez jasného harmonogramu|přehledný postup od první poptávky po finální předání|cenu ovlivňuje kombinace služeb, rozsah, stav podkladu a požadovaný výsledek|připravit fotografie, plochy, projekt a informace o cíli realizace|největší riziko je začít bez technického posouzení a jasného zadání|kompletní přístup šetří čas a snižuje riziko chyb mezi profesemi
"@ | ConvertFrom-Csv -Delimiter "|"

function Write-Utf8File($Path, $Content) {
  $Dir = Split-Path -Parent $Path
  if ($Dir -and !(Test-Path $Dir)) { New-Item -ItemType Directory -Force -Path $Dir | Out-Null }
  [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

function Escape-Html($Text) {
  [System.Net.WebUtility]::HtmlEncode([string]$Text)
}

function Header-Html($Prefix) {
@"
<header class="top"><div class="container nav"><a class="logo" href="${Prefix}index.html">$Company<span>omítky a fasády Praha a Středočeský kraj</span></a><nav class="menu"><a href="${Prefix}index.html">Domů</a><a href="${Prefix}o-nas.html">O nás</a><a href="${Prefix}sluzby.html">Služby</a><a href="${Prefix}realizace.html">Realizace</a><a href="${Prefix}blog.html">Blog</a><a href="${Prefix}kontakt.html">Kontakt</a><a class="btn" href="$PhoneHref">Zavolat</a></nav></div></header>
"@
}

function Footer-Html($Prefix) {
@"
<a class="whatsapp" href="$WhatsApp">WhatsApp</a><footer class="footer"><div class="container footgrid"><div><h3>$Company</h3><p class="muted">Poctivé strojní omítky, sádrové omítky, štukové omítky, vápenocementové omítky, zateplení fasád a fasádní práce v Praze a Středočeském kraji.</p></div><div><h3>Rychlé odkazy</h3><p><a href="${Prefix}omitky.html">Omítky</a><br><a href="${Prefix}fasady.html">Fasády</a><br><a href="${Prefix}blog.html">Blog</a><br><a href="${Prefix}poptavka.html">Poptávka</a></p></div><div><h3>Kontakt</h3><p>K Žižkovu 809/7, Praha 9 – Vysočany<br><a href="$PhoneHref">$Phone</a><br><span>$Email</span></p></div></div><div class="container"><p class="muted">© 2026 $Company Všechna práva vyhrazena.</p></div></footer><script src="${Prefix}ui.js" defer></script>
"@
}

function Service-Link-Html($Article) {
@"
<div class="article-links">
  <a href="/omitky.html">Omítky</a>
  <a href="/fasady.html">Fasády</a>
  <a href="/kontakt.html">Kontakt</a>
  <a href="/poptavka.html">Poptávka</a>
</div>
"@
}

function Faq-Html($Article) {
  $Items = @(
    @("Jak rychle získám nabídku na $($Article.service) v Praze?", "Nejrychlejší je poslat město, přibližnou plochu v m², fotografie stavby a požadovaný termín. Podle těchto údajů připravíme orientační postup a domluvíme zaměření."),
    @("Co nejvíce ovlivňuje cenu?", "$($Article.price). Proto je důležité porovnávat nabídky podle stejného rozsahu, materiálů a přípravných prací."),
    @("Co musí být připravené před zahájením?", "$($Article.prep). Pokud si nejste jistí, při zaměření řekneme, co je potřeba doplnit před nástupem."),
    @("Na co si dát pozor?", "$($Article.warning). Kvalitní výsledek závisí na podkladu, technologii a kontrole detailů."),
    @("Realizujete práce i mimo centrum Prahy?", "Ano, pracujeme v Praze, v lokalitách Praha-východ, Praha-západ a ve Středočeském kraji. Stačí nám poslat obec, rozsah prací a ideálně fotografie stavby.")
  )
  (($Items | ForEach-Object { "<details><summary>$(Escape-Html $_[0])</summary><p>$(Escape-Html $_[1])</p></details>" }) -join "`n")
}

function Article-Paragraphs($Article) {
  $CategoryIntro = if ($Article.category -eq "Fasády") {
    "U fasád je důležité spojit technické řešení s dlouhodobou ochranou domu. Nestačí vybrat barvu nebo nejlevnější materiál. Rozhoduje stav podkladu, skladba systému, počasí při aplikaci, napojení detailů a schopnost firmy udržet kvalitu od první přípravy až po finální omítku."
  } else {
    "U omítek je kvalita vidět každý den. Rovinnost stěn, čisté rohy, správně zapravené špalety a dobrá návaznost na další práce rozhodují o tom, zda bude interiér působit hotově a profesionálně. Proto se vyplatí řešit omítky s firmou, která rozumí podkladu, materiálům i harmonogramu."
  }

  @"
<p><strong>$($Article.keyword)</strong> patří mezi dotazy, které zákazníci hledají ve chvíli, kdy už nechtějí obecné informace, ale konkrétní rozhodnutí. Často řeší termín, cenu, vhodný materiál, připravenost stavby a to, zda je lepší objednat specializovanou firmu nebo jednotlivé práce skládat z více dodavatelů. Tento článek vysvětluje téma prakticky, bez zbytečných frází a s důrazem na situace, které se na stavbách v Praze a okolí opravdu řeší.</p>
<p>$($Article.summary) Text je určen hlavně pro $($Article.audience). Pokud připravujete poptávku, doporučujeme číst článek společně s poznámkami ke stavbě, protože mnoho odpovědí závisí na ploše, stavu podkladu, přístupu a požadovaném termínu.</p>
<p>$CategoryIntro KOST STAV PRAHA s.r.o. se zaměřuje pouze na omítky a fasády, takže dokážeme doporučit řešení podle skutečných technických podmínek. Zákazník tak dostane srozumitelný návrh, ne seznam prázdných slibů.</p>

<h2>Kdy dává služba $($Article.service) smysl</h2>
<p>$($Article.decision). V praxi nejde jen o název služby, ale o vhodnost pro konkrétní objekt. Jinak se posuzuje novostavba rodinného domu, jinak starší zdivo v bytovém domě a jinak technická místnost, garáž nebo fasáda vystavená počasí. Správná volba šetří čas, omezuje riziko oprav a pomáhá udržet rozpočet pod kontrolou.</p>
<p>Pro Prahu a okolí je typická různorodost staveb. V jedné zakázce může být nové zdivo, starší podklad, členité ostění, horší přístup nebo nutnost sladit práce se sousedy a správcem domu. Proto je důležité neřešit pouze cenu za metr čtvereční, ale i organizaci, logistiku materiálu a návaznost na další profese.</p>

<h3>Jak poznat vhodný postup</h3>
<p>Vhodný postup začíná kontrolou podkladu. Sleduje se pevnost, savost, vlhkost, prach, zbytky starých vrstev a připravenost stavebních detailů. U služby $($Article.service) je hlavní téma $($Article.focus). Pokud se tyto věci podcení, výsledek může vypadat dobře jen krátce, ale později se projeví praskliny, nerovnosti nebo horší návaznost na finální vrstvy.</p>
<p>Profesionální firma by měla zákazníkovi jasně říct, co je zahrnuté v ceně, co je potřeba připravit a kde mohou vzniknout vícepráce. Férová nabídka není nejkratší věta s cenou, ale konkrétní popis rozsahu, materiálu a postupu. Právě to odlišuje odbornou realizaci od rychlé improvizace.</p>

<h2>Jak probíhá realizace krok za krokem</h2>
<p>První krok je zaměření a technická konzultace. Firma si ověří rozsah, přístup na stavbu, stav podkladu a požadovaný termín. Poté doporučí vhodný materiál a navrhne harmonogram. U omítek je důležité dokončení rozvodů, ochrana otvorů a připravenost místností. U fasád se navíc řeší lešení, počasí, sokl, ostění a napojení na střechu nebo klempířské prvky.</p>
<p>Další fáze je příprava podkladu. Ta bývá méně viditelná než samotná aplikace, ale často rozhoduje o výsledku. Podklad musí být soudržný, přiměřeně suchý a čistý. V případě potřeby se používá penetrace, profily, armovací vrstva, lokální vysprávky nebo jiné systémové prvky. Teprve potom má smysl začít s hlavní aplikací.</p>

<h3>Kontrola detailů během práce</h3>
<p>U kvalitní realizace se kontrolují rohy, špalety, přechody mezi materiály, rovinnost ploch, tloušťka vrstvy a čistota napojení. U fasád se sleduje také armovací vrstva, kotvení, dilatační místa, sokl a finální struktura omítky. Tyto detaily nejsou drobnosti. Právě na nich zákazník pozná, zda byla práce provedena pečlivě.</p>
<p>Výsledkem má být $($Article.result). Aby toho bylo možné dosáhnout, musí být mezi zákazníkem a firmou jasná komunikace. Dobrá domluva před zahájením prací obvykle ušetří více času než rychlé rozhodování uprostřed stavby.</p>

<h2>Cena a rozpočet bez nepříjemných překvapení</h2>
<p>$($Article.price). Proto se vyplatí poslat co nejpřesnější informace už při první poptávce. Orientační plocha v m², fotografie stavby, projektová dokumentace a informace o termínu pomohou připravit nabídku, která bude blíže realitě.</p>
<p>U dotazů jako $($Article.keyword) zákazníci často očekávají okamžitou cenu. Přesnější odpověď ale vyžaduje kontext. Dvě stavby se stejnou plochou mohou mít zcela jinou náročnost kvůli přístupu, členitosti, výšce, stavu podkladu nebo požadavkům na detail. Profesionální firma cenu vysvětlí, ne jen pošle číslo bez souvislostí.</p>

<h3>Co poslat pro přesnější kalkulaci</h3>
<p>$($Article.prep). Kromě toho pomáhá napsat, zda jde o novostavbu, starší objekt, bytovou jednotku nebo fasádu. Uveďte také město, očekávaný termín a případná omezení přístupu. Čím konkrétnější podklady pošlete, tím rychleji lze připravit reálnou nabídku.</p>
<p>Nejde o administrativu navíc. Dobrá poptávka zkracuje telefonáty, omezuje dohady a pomáhá firmě vybrat správný materiál. Zákazník zároveň získá lepší představu o tom, co je v ceně a jak bude realizace probíhat.</p>

<h2>Nejčastější chyby a rizika</h2>
<p>$($Article.warning). Další častou chybou je objednat práce příliš pozdě, když už na stavbě čekají další profese. Omítky i fasádní práce mají technologické přestávky a nelze je donekonečna zkracovat bez vlivu na kvalitu.</p>
<p>$($Article.challenge). Pokud se problém odhalí až při realizaci, často vzniká zdržení nebo vícepráce. Proto je lepší podklad zkontrolovat předem a otevřeně si říct, co je připravené a co ještě ne.</p>

<h3>Jak se rozhodovat prakticky</h3>
<p>Rozhodnutí by mělo vycházet ze tří věcí: technického stavu stavby, očekávaného výsledku a rozumného rozpočtu. Pokud jedna z těchto oblastí chybí, výběr bývá nepřesný. U omítek se často řeší hladkost, odolnost a schnutí. U fasád zase skladba systému, počasí, sokl a finální vzhled domu.</p>
<p>KOST STAV PRAHA s.r.o. pomáhá zákazníkům v Praze a Středočeském kraji s konkrétním návrhem postupu. Nejdříve potřebujeme pochopit stavbu, potom doporučujeme řešení. Tento přístup je pomalejší než univerzální odpověď, ale vede k přesnější ceně a lepšímu výsledku.</p>

<h2>Interní odkazy a související služby</h2>
<p>Pokud řešíte hlavně vnitřní povrchy, pokračujte na stránku <a href="/omitky.html">Omítky</a>. Pokud vás zajímá obvodový plášť domu, zateplení nebo finální povrch, podívejte se na stránku <a href="/fasady.html">Fasády</a>. Pro rychlou domluvu je k dispozici <a href="/kontakt.html">Kontakt</a> a samostatná <a href="/poptavka.html">Poptávka</a>.</p>
"@
}

function Extra-Paragraphs($Article) {
@"
<h2>Doporučení pro zákazníky v Praze a okolí</h2>
<p>Praha má specifickou kombinaci starší městské zástavby, nových rodinných domů, příměstských lokalit a objektů s různou dostupností. Proto je dobré řešit realizaci včas. U bytových domů se často řeší ochrana společných prostor a časová okna pro dopravu materiálu. U rodinných domů zase návaznost na okna, podlahy, elektroinstalaci, vytápění a další dokončovací práce.</p>
<p>U poptávky služby $($Article.service) je výhodou, když zákazník pošle i stručný popis cíle. Jinak se navrhuje řešení pro rychlé dokončení novostavby, jinak pro obnovu staršího domu a jinak pro fasádu, kde je potřeba spojit technickou ochranu s novým vzhledem. Konkrétní zadání pomáhá vybrat správnou technologii a předejít zbytečným kompromisům.</p>
<p>Pokud porovnáváte více nabídek, sledujte rozsah položek. Nabídka by měla popisovat materiál, přípravu, ochranu stavby, případné profily, lešení nebo dokončení detailů. Nízká cena bez popisu může vypadat dobře, ale často neříká, co se stane při horším podkladu, složitější logistice nebo nutných opravách.</p>
"@
}

function Article-Cta($Article) {
@"
<div class="article-cta">
  <h2>Zavolejte nám ještě dnes a získejte nezávaznou cenovou nabídku zdarma.</h2>
  <p>Pošlete nám město, přibližnou plochu v m², fotografie stavby a požadovaný termín. Připravíme doporučení pro $($Article.service) a navrhneme další postup.</p>
  <div class="actions"><a class="btn" href="$PhoneHref">$Phone</a><a class="btn alt" href="/poptavka.html">Odeslat poptávku</a></div>
</div>
"@
}

function Build-Article($Article) {
  $MetaDescription = "$($Article.summary) KOST STAV PRAHA s.r.o. realizuje $($Article.service) v Praze a Středočeském kraji."
  if ($MetaDescription.Length -gt 170) { $MetaDescription = $MetaDescription.Substring(0, 167).Trim() + "..." }
  $Title = "$($Article.title) | KOST STAV PRAHA"
  $Canonical = "$SiteUrl/blog/$($Article.slug).html"
  $Links = Service-Link-Html $Article
  $Faq = Faq-Html $Article
  $Body = (Article-Paragraphs $Article) + "`n" + $Links + "`n" + (Extra-Paragraphs $Article) + "`n" + (Article-Cta $Article) + "`n<section><h2>FAQ</h2><div class=""faq"">$Faq</div></section>"
  $Plain = [regex]::Replace($Body, "<[^>]+>", " ")
  $Words = @([regex]::Matches($Plain, "\S+")).Count
  $Schema = @{
    "@context" = "https://schema.org"
    "@type" = "Article"
    headline = $Article.title
    description = $MetaDescription
    inLanguage = "cs"
    author = @{ "@type" = "Organization"; name = $Company }
    publisher = @{ "@type" = "Organization"; name = $Company }
    mainEntityOfPage = $Canonical
  } | ConvertTo-Json -Depth 6 -Compress
@"
<!doctype html>
<html lang="cs">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>$(Escape-Html $Title)</title>
  <meta name="description" content="$(Escape-Html $MetaDescription)">
  <link rel="canonical" href="$Canonical">
  <link rel="stylesheet" href="../styles.css">
  <script type="application/ld+json">$Schema</script>
</head>
<body>
$(Header-Html "../")
<main>
  <section class="pagehead seo-head">
    <div class="container">
      <p class="breadcrumb"><a href="../index.html">Domů</a> / <a href="../blog.html">Blog</a> / $(Escape-Html $Article.category)</p>
      <h1>$(Escape-Html $Article.title)</h1>
      <p class="muted">$(Escape-Html $Article.summary)</p>
      <p class="article-meta">Kategorie: <strong>$(Escape-Html $Article.category)</strong> · Klíčové téma: <strong>$(Escape-Html $Article.keyword)</strong> · Rozsah článku: $Words slov</p>
    </div>
  </section>
  <section>
    <div class="container seo-layout">
      <article class="seo-article blog-article">
        $Body
      </article>
      <aside class="contactbox seo-sidebox">
        <h2>Rychlá nabídka</h2>
        <p class="muted">Řešíte $($Article.service) v Praze nebo okolí? Zavolejte nebo pošlete poptávku s fotkami a plochou v m².</p>
        <div class="actions"><a class="btn" href="$PhoneHref">Zavolat</a><a class="btn alt" href="/poptavka.html">Poptávka</a></div>
        <div class="mini-links"><a href="/omitky.html">Omítky</a><a href="/fasady.html">Fasády</a><a href="/kontakt.html">Kontakt</a></div>
      </aside>
    </div>
  </section>
</main>
$(Footer-Html "../")
</body>
</html>
"@
}

function Blog-Index($Articles) {
  $Cards = (($Articles | ForEach-Object {
@"
<article class="card blog-card"><span class="blog-tag">$($_.category)</span><h2><a href="blog/$($_.slug).html">$(Escape-Html $_.title)</a></h2><p>$(Escape-Html $_.summary)</p><a class="text-link" href="blog/$($_.slug).html">Číst článek</a></article>
"@
  }) -join "`n")
@"
<!doctype html>
<html lang="cs">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Blog o omítkách a fasádách | KOST STAV PRAHA s.r.o.</title>
  <meta name="description" content="SEO blog KOST STAV PRAHA s.r.o. o strojních omítkách, sádrových omítkách, štukových omítkách, vápenocementových omítkách, zateplení fasád a fasádních pracích v Praze.">
  <link rel="canonical" href="$SiteUrl/blog.html">
  <link rel="stylesheet" href="styles.css">
</head>
<body>
$(Header-Html "")
<main>
  <section class="pagehead">
    <div class="container">
      <p class="breadcrumb"><a href="index.html">Domů</a> / Blog</p>
      <h1>Blog o omítkách a fasádách</h1>
      <p class="muted">Praktické články pro zákazníky z Prahy a Středočeského kraje. Témata pokrývají strojní omítky, sádrové omítky, štukové omítky, vápenocementové omítky, zateplení fasád a fasádní práce.</p>
    </div>
  </section>
  <section>
    <div class="container">
      <div class="grid blog-grid">$Cards</div>
    </div>
  </section>
</main>
$(Footer-Html "")
</body>
</html>
"@
}

function Quote-Form-Html {
@"
<form class="quote-form" data-poptavka-form action="/api/contact" method="POST" enctype="multipart/form-data">
  <div class="form-section"><h3>Kontaktní údaje</h3><div class="form-grid"><div class="form-field"><label>Jméno a příjmení<input name="jmeno" autocomplete="name" required></label></div><div class="form-field"><label>Telefon<input name="telefon" type="tel" autocomplete="tel" required></label></div><div class="form-field"><label>E-mail<input name="email" type="email" autocomplete="email"></label></div><div class="form-field"><label>Adresa stavby / obec<input name="adresa_stavby" required></label></div></div></div>
  <div class="form-section"><h3>Typ práce</h3><div class="choice-grid"><label class="choice-pill"><input type="radio" name="typ_prace" value="omitky" checked> Omítky</label><label class="choice-pill"><input type="radio" name="typ_prace" value="fasady"> Fasády</label></div><div data-specific-group="omitky"><p class="form-label">Konkrétní typ omítky</p><div class="choice-grid"><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Strojní sádrové omítky"> Strojní sádrové omítky</label><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Štukové omítky"> Štukové omítky</label><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Vápenocementové omítky"> Vápenocementové omítky</label><label class="choice-pill"><input type="checkbox" name="typ_omitky[]" value="Vnitřní omítky"> Vnitřní omítky</label></div></div><div data-specific-group="fasady" hidden><p class="form-label">Konkrétní typ fasády</p><div class="choice-grid"><label class="choice-pill"><input type="checkbox" name="typ_fasady[]" value="Zateplení fasády" disabled> Zateplení fasády</label><label class="choice-pill"><input type="checkbox" name="typ_fasady[]" value="Fasádní omítka" disabled> Fasádní omítka</label><label class="choice-pill"><input type="checkbox" name="typ_fasady[]" value="Oprava fasády" disabled> Oprava fasády</label><label class="choice-pill"><input type="checkbox" name="typ_fasady[]" value="Sokl fasády" disabled> Sokl fasády</label></div></div></div>
  <div class="form-section"><h3>Parametry</h3><p class="form-label">Novostavba nebo rekonstrukce</p><div class="choice-grid"><label class="choice-pill"><input type="radio" name="stav_objektu" value="Novostavba" required> Novostavba</label><label class="choice-pill"><input type="radio" name="stav_objektu" value="Rekonstrukce" required> Rekonstrukce</label></div><div class="form-grid"><div class="form-field"><label>Přibližná plocha v m²<input name="plocha" type="number" min="1"></label></div><div class="form-field"><label>Požadovaný termín realizace<input name="termin"></label></div></div><div class="form-field"><label>Popis zakázky<textarea name="popis"></textarea></label></div><div class="form-field"><label>Nahrání souborů / fotek / projektové dokumentace<input class="file-input" name="prilohy[]" type="file" multiple accept="image/*,.pdf,.dwg,.dxf"></label></div></div>
  <label class="muted consent"><input type="checkbox" name="souhlas" required> Souhlasím se zpracováním osobních údajů pro vyřízení poptávky.</label><div class="form-alert" data-form-alert role="status" aria-live="polite"></div><button class="btn" type="submit">Odeslat poptávku</button>
</form>
"@
}

function Landing-Page($Kind) {
  $IsFacade = $Kind -eq "fasady"
  $File = if ($IsFacade) { "fasady.html" } else { "omitky.html" }
  $H1 = if ($IsFacade) { "Fasády Praha a Středočeský kraj" } else { "Omítky Praha a Středočeský kraj" }
  $Title = if ($IsFacade) { "Fasády Praha | Zateplení fasád a fasádní práce" } else { "Omítky Praha | Strojní, sádrové a štukové omítky" }
  $Desc = if ($IsFacade) { "Profesionální zateplení fasád, fasádní omítky a fasádní práce v Praze a Středočeském kraji." } else { "Profesionální strojní omítky, sádrové omítky, štukové omítky a vápenocementové omítky v Praze a Středočeském kraji." }
  $Cards = if ($IsFacade) {
    "<article class=""card service-photo-card""><div class=""card-media""><img decoding=""async"" loading=""lazy"" src=""assets/images/moderni-exterier-rodinneho-domu.jpg"" alt=""Moderní exteriér rodinného domu se zateplenou fasádou""></div><h2>Zateplení fasád</h2><p>Kompletní zateplovací systémy včetně přípravy podkladu, izolantu, armovací vrstvy a finální omítky.</p><a class=""text-link"" href=""/lokality/zatepleni-fasad-praha-9.html"">Zateplení fasád Praha</a></article><article class=""card service-photo-card""><div class=""card-media""><img decoding=""async"" loading=""lazy"" src=""assets/images/detail-moderni-fasady-lamely.jpg"" alt=""Detail moderní fasády s čistou omítkou a lamelami""></div><h2>Fasádní omítka</h2><p>Finální povrch fasády s důrazem na správnou strukturu, barvu, detail a dlouhodobou životnost.</p><a class=""text-link"" href=""/lokality/fasadni-prace-praha-9.html"">Fasádní práce Praha</a></article>"
  } else {
    "<article class=""card service-photo-card""><div class=""card-media""><img decoding=""async"" loading=""lazy"" src=""assets/images/luxusni-bile-omitky-interier.jpg"" alt=""Luxusní bílé omítky v moderním interiéru""></div><h2>Strojní omítky</h2><p>Rychlé a rovné omítky pro novostavby, rodinné domy, byty a komerční prostory.</p><a class=""text-link"" href=""/lokality/strojni-omitky-praha-9.html"">Strojní omítky Praha</a></article><article class=""card service-photo-card""><div class=""card-media""><img decoding=""async"" loading=""lazy"" src=""assets/images/ciste-bile-steny-interier.jpg"" alt=""Čisté bílé stěny se sádrovou omítkou""></div><h2>Sádrové omítky</h2><p>Hladké interiérové povrchy pro moderní bydlení a čisté dokončení stěn.</p><a class=""text-link"" href=""/lokality/sadrove-omitky-praha-9.html"">Sádrové omítky Praha</a></article><article class=""card service-photo-card""><div class=""card-media""><img decoding=""async"" loading=""lazy"" src=""assets/images/moderni-interier-bile-steny.jpg"" alt=""Hladké bílé stěny s finální štukovou omítkou""></div><h2>Štukové a vápenocementové omítky</h2><p>Klasické a odolné povrchy podle typu místnosti, vlhkosti a zatížení.</p><a class=""text-link"" href=""/lokality/vapenocementove-omitky-praha-9.html"">Vápenocementové omítky Praha</a></article>"
  }
  $Cards = [regex]::Replace($Cards, '<a class="text-link" href="/lokality/[^"]+">[^<]+</a>', '<a class="text-link" href="/poptavka.html">Nezávazná poptávka</a>')
  $Visuals = if ($IsFacade) {
    "<section class=""section-soft""><div class=""container""><div class=""section-head""><h2>Fotografie fasád a detailů</h2><p>Moderní fasády, zateplení domů a finální struktury fasádních omítek.</p></div><div class=""photo-mosaic""><figure><img decoding=""async"" loading=""lazy"" src=""assets/images/minimalisticka-bila-fasada-domu.jpg"" alt=""Minimalistická bílá fasáda moderního domu""><figcaption>Moderní fasády</figcaption></figure><figure><img decoding=""async"" loading=""lazy"" src=""assets/images/moderni-fasadni-detail-okna.jpg"" alt=""Moderní fasádní detail s okny a pravidelnou strukturou""><figcaption>Detail struktury</figcaption></figure></div></div></section>"
  } else {
    "<section class=""section-soft""><div class=""container""><div class=""section-head""><h2>Fotografie omítkových prací</h2><p>Strojní, sádrové, štukové a vápenocementové omítky v interiéru.</p></div><div class=""photo-mosaic""><figure><img decoding=""async"" loading=""lazy"" src=""assets/images/luxusni-bile-omitky-interier.jpg"" alt=""Luxusní bílé omítky v čistém moderním interiéru""><figcaption>Strojní omítky</figcaption></figure><figure><img decoding=""async"" loading=""lazy"" src=""assets/images/ciste-bile-steny-interier.jpg"" alt=""Sádrové omítky a hladké bílé stěny""><figcaption>Sádrové omítky</figcaption></figure><figure><img decoding=""async"" loading=""lazy"" src=""assets/images/moderni-interier-bile-steny.jpg"" alt=""Hladké bílé stěny po finální omítce""><figcaption>Vápenocementové omítky</figcaption></figure></div></div></section>"
  }
@"
<!doctype html>
<html lang="cs">
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>$Title</title><meta name="description" content="$Desc"><link rel="canonical" href="$SiteUrl/$File"><link rel="stylesheet" href="styles.css"></head>
<body>$(Header-Html "")<main><section class="pagehead"><div class="container"><p class="breadcrumb"><a href="index.html">Domů</a> / $H1</p><h1>$H1</h1><p class="muted">$Desc</p></div></section><section><div class="container"><div class="grid">$Cards</div></div></section>$Visuals<section class="cta"><div class="container box"><h2>Zavolejte nám ještě dnes a získejte nezávaznou cenovou nabídku zdarma.</h2><p class="muted">Rádi posoudíme váš projekt a doporučíme vhodný postup.</p><div class="actions" style="justify-content:center"><a class="btn" href="$PhoneHref">$Phone</a><a class="btn alt" href="/poptavka.html">Odeslat poptávku</a></div></div></section></main>$(Footer-Html "")</body></html>
"@
}

function Poptavka-Page {
@"
<!doctype html>
<html lang="cs">
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Poptávka omítek a fasád | KOST STAV PRAHA</title><meta name="description" content="Nezávazná poptávka na omítky a fasády v Praze a Středočeském kraji."><link rel="canonical" href="$SiteUrl/poptavka.html"><link rel="stylesheet" href="styles.css"><script src="poptavka.js" defer></script></head>
<body>$(Header-Html "")<main><section class="pagehead"><div class="container"><p class="breadcrumb"><a href="index.html">Domů</a> / Poptávka</p><h1>Poptávka omítek a fasád</h1><p class="muted">Rádi Vám spočítáme nezávaznou cenovou nabídku na omítky nebo fasádu. Vyplňte prosím krátký formulář a my se Vám co nejdříve ozveme.</p></div></section><section><div class="container split"><div><p class="quote-help">Pro přesnější kalkulaci nám prosím pošlete plochu v m², fotky stavby, případně projektovou dokumentaci.</p><div class="list"><div>Strojní sádrové, štukové a vápenocementové omítky</div><div>Zateplení fasád a fasádní omítky</div><div>Praha a Středočeský kraj</div></div></div><div class="contactbox">$(Quote-Form-Html)</div></div></section></main>$(Footer-Html "")</body></html>
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
      $Priority = if ($Rel -eq "index.html") { "1.0" } elseif ($Rel -eq "blog.html") { "0.9" } elseif ($Rel.StartsWith("blog/")) { "0.8" } elseif ($Rel.StartsWith("lokality/")) { "0.7" } else { "0.7" }
    }
    $Entries += "  <url>`n    <loc>$Loc</loc>`n    <lastmod>$LastMod</lastmod>`n    <changefreq>weekly</changefreq>`n    <priority>$Priority</priority>`n  </url>"
  }
  $Xml = "<?xml version=""1.0"" encoding=""UTF-8""?>`n<urlset xmlns=""http://www.sitemaps.org/schemas/sitemap/0.9"">`n$($Entries -join "`n")`n</urlset>`n"
  Write-Utf8File (Join-Path $Root "sitemap.xml") $Xml
}

if (!(Test-Path $BlogDir)) {
  New-Item -ItemType Directory -Force -Path $BlogDir | Out-Null
}

$Counts = @()
foreach ($Article in $Articles) {
  $Html = Build-Article $Article
  $Path = Join-Path $BlogDir "$($Article.slug).html"
  Write-Utf8File $Path $Html
  $Plain = [regex]::Replace($Html, "<[^>]+>", " ")
  $Count = @([regex]::Matches($Plain, "\S+")).Count
  $Counts += [pscustomobject]@{ slug = $Article.slug; words = $Count }
}

Write-Utf8File (Join-Path $Root "blog.html") (Blog-Index $Articles)
Write-Utf8File (Join-Path $Root "omitky.html") (Landing-Page "omitky")
Write-Utf8File (Join-Path $Root "fasady.html") (Landing-Page "fasady")
Write-Utf8File (Join-Path $Root "poptavka.html") (Poptavka-Page)
Update-Sitemap

$Min = ($Counts | Measure-Object -Property words -Minimum).Minimum
$Max = ($Counts | Measure-Object -Property words -Maximum).Maximum
$Below = @($Counts | Where-Object { $_.words -lt 1200 }).Count
$Above = @($Counts | Where-Object { $_.words -gt 1800 }).Count
Write-Host "Generated $($Articles.Count) blog articles."
Write-Host "Word count range: $Min - $Max."
Write-Host "Articles below 1200 words: $Below."
Write-Host "Articles above 1800 words: $Above."
Write-Host "Updated blog.html, omitky.html, fasady.html, poptavka.html and sitemap.xml."

$SeoBuild = Join-Path $Root "generate-seo.ps1"
if (Test-Path $SeoBuild) {
  & $SeoBuild
}






