(function () {
  const STORAGE_KEY = "kost-stav-realizace-projects";
  const DATA_URL = "data/realizace.json";
  const SEO_LOCALITIES = 258;
  const MAX_RENDERED_PROJECTS = 200;
  const SERVICES = [
    "Strojní sádrové omítky",
    "Štukové omítky",
    "Vápenocementové omítky",
    "Zateplení fasády",
    "Fasádní omítka",
    "Kombinace služeb"
  ];

  const SERVICE_META = {
    "Strojní sádrové omítky": {
      generic: "Strojní omítky",
      lower: "strojní omítky",
      h1: "strojních omítek",
      localitySlug: "strojni-omitky",
      benefits: "rychlé nanášení, velmi dobrá rovinnost, čisté rohy a kratší čas realizace"
    },
    "Štukové omítky": {
      generic: "Štukové omítky",
      lower: "štukové omítky",
      h1: "štukových omítek",
      localitySlug: "stukove-omitky",
      benefits: "pevný klasický povrch, dobrá opravitelnost a přirozený vzhled stěn"
    },
    "Vápenocementové omítky": {
      generic: "Vápenocementové omítky",
      lower: "vápenocementové omítky",
      h1: "vápenocementových omítek",
      localitySlug: "vapenocementove-omitky",
      benefits: "vyšší odolnost, vhodnost do zatížených prostor a dobré chování na minerálních podkladech"
    },
    "Zateplení fasády": {
      generic: "Zateplení fasády",
      lower: "zateplení fasády",
      h1: "zateplení fasády",
      localitySlug: "zatepleni-fasad",
      benefits: "nižší tepelné ztráty, lepší ochrana zdiva a moderní vzhled domu"
    },
    "Fasádní omítka": {
      generic: "Fasádní omítka",
      lower: "fasádní omítka",
      h1: "fasádní omítky",
      localitySlug: "fasadni-prace",
      benefits: "sjednocený vzhled fasády, ochrana povrchu a čisté zakončení detailů"
    },
    "Kombinace služeb": {
      generic: "Omítky a fasády",
      lower: "omítky a fasády",
      h1: "omítek a fasád",
      localitySlug: "strojni-omitky",
      benefits: "lepší návaznost prací, jeden harmonogram a jednodušší kontrola kvality"
    }
  };

  const LOCATION_PHRASES = {
    "Praha 1": "v Praze 1",
    "Praha 2": "v Praze 2",
    "Praha 3": "v Praze 3",
    "Praha 4": "v Praze 4",
    "Praha 5": "v Praze 5",
    "Praha 6": "v Praze 6",
    "Praha 7": "v Praze 7",
    "Praha 8": "v Praze 8",
    "Praha 9": "v Praze 9",
    "Praha 10": "v Praze 10",
    "Kladno": "v Kladně",
    "Beroun": "v Berouně",
    "Benešov": "v Benešově",
    "Kolín": "v Kolíně",
    "Kutná Hora": "v Kutné Hoře",
    "Nymburk": "v Nymburce",
    "Mladá Boleslav": "v Mladé Boleslavi",
    "Mělník": "v Mělníku",
    "Brandýs nad Labem": "v Brandýse nad Labem",
    "Čelákovice": "v Čelákovicích",
    "Lysá nad Labem": "v Lysé nad Labem",
    "Milovice": "v Milovicích",
    "Poděbrady": "v Poděbradech",
    "Český Brod": "v Českém Brodě",
    "Říčany": "v Říčanech",
    "Jesenice": "v Jesenici",
    "Hostivice": "v Hostivici",
    "Roztoky": "v Roztokách",
    "Rudná": "v Rudné",
    "Dobříš": "v Dobříši",
    "Příbram": "v Příbrami",
    "Hořovice": "v Hořovicích",
    "Slaný": "ve Slaném",
    "Kralupy nad Vltavou": "v Kralupech nad Vltavou",
    "Neratovice": "v Neratovicích",
    "Mnichovo Hradiště": "v Mnichově Hradišti",
    "Benátky nad Jizerou": "v Benátkách nad Jizerou",
    "Vlašim": "ve Vlašimi",
    "Sedlčany": "v Sedlčanech",
    "Unhošť": "v Unhošti",
    "Rakovník": "v Rakovníku",
    "Praha-východ": "v okrese Praha-východ",
    "Praha-západ": "v okrese Praha-západ"
  };

  let projects = [];
  let activeId = "";

  document.addEventListener("DOMContentLoaded", async () => {
    const root = document.querySelector("[data-admin-realizace]");
    if (!root) return;

    projects = await loadProjects();
    bindForm();
    renderAll();
    resetForm();
  });

  async function loadProjects() {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored) {
      try {
        return JSON.parse(stored);
      } catch (error) {
        console.warn("Neplatná lokální data realizací.", error);
      }
    }

    try {
      const response = await fetch(DATA_URL, { cache: "no-store" });
      if (!response.ok) throw new Error(response.statusText);
      return await response.json();
    } catch (error) {
      console.warn("Nepodařilo se načíst výchozí realizace.", error);
      return [];
    }
  }

  function saveProjects() {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(projects, null, 2));
  }

  function bindForm() {
    const form = document.querySelector("[data-project-form]");
    const title = form.elements.title;
    const city = form.elements.city;
    const year = form.elements.year;
    const slug = form.elements.slug;
    const gallery = form.elements.gallery;
    const mainPhoto = form.elements.mainPhoto;

    title.addEventListener("input", () => {
      if (!activeId || !slug.value.trim()) slug.value = slugify([title.value, city.value, year.value].filter(Boolean).join(" "));
      updatePreview();
    });
    city.addEventListener("input", () => {
      if (!activeId) slug.value = slugify([title.value, city.value, year.value].filter(Boolean).join(" "));
      updatePreview();
    });
    year.addEventListener("input", () => {
      if (!activeId) slug.value = slugify([title.value, city.value, year.value].filter(Boolean).join(" "));
      updatePreview();
    });
    slug.addEventListener("input", updatePreview);
    gallery.addEventListener("input", renderGalleryPreview);
    mainPhoto.addEventListener("input", renderGalleryPreview);

    document.querySelector("[data-generate-seo]").addEventListener("click", () => {
      applySeoToForm(buildProjectFromForm(false));
      showAlert("SEO title, meta description, H1, text a FAQ byly vygenerovány.");
    });

    document.querySelector("[data-new-project]").addEventListener("click", resetForm);
    document.querySelector("[data-export-json]").addEventListener("click", exportJson);
    document.querySelector("[data-import-json]").addEventListener("change", importJson);
    document.querySelector("[data-project-search]").addEventListener("input", renderProjectList);

    document.querySelector("[data-project-list]").addEventListener("click", (event) => {
      const editButton = event.target.closest("[data-edit-project]");
      const deleteButton = event.target.closest("[data-delete-project]");
      if (editButton) editProject(editButton.dataset.editProject);
      if (deleteButton) deleteProject(deleteButton.dataset.deleteProject);
    });

    form.addEventListener("submit", (event) => {
      event.preventDefault();
      const project = buildProjectFromForm(true);
      if (!project.services.length) {
        showAlert("Vyberte alespoň jednu službu realizace.", true);
        return;
      }
      if (!project.seo.title || !project.seo.description || !project.seo.h1 || !project.seo.text || !project.seo.faq.length) {
        Object.assign(project.seo, generateSeo(project));
      }

      const index = projects.findIndex((item) => item.id === project.id);
      if (index >= 0) projects[index] = project;
      else projects.unshift(project);

      activeId = project.id;
      saveProjects();
      renderAll();
      fillForm(project);
      showAlert("Projekt byl uložen. URL realizace: /realizace/" + project.slug + "/");
    });
  }

  function buildProjectFromForm(includeId) {
    const form = document.querySelector("[data-project-form]");
    const selectedServices = Array.from(form.querySelectorAll('input[name="services"]:checked')).map((input) => input.value);
    const slug = slugify(form.elements.slug.value || [form.elements.title.value, form.elements.city.value, form.elements.year.value].join(" "));
    const id = includeId && form.elements.id.value ? form.elements.id.value : "realizace-" + slug;
    const gallery = splitLines(form.elements.gallery.value);
    const materials = splitLines(form.elements.materials.value);
    const faq = parseFaq(form.elements.faq.value);

    return {
      id,
      status: form.elements.status.value,
      title: form.elements.title.value.trim(),
      slug,
      city: form.elements.city.value.trim(),
      district: form.elements.district.value.trim(),
      year: Number(form.elements.year.value || new Date().getFullYear()),
      area: Number(form.elements.area.value || 0),
      realizationType: form.elements.realizationType.value.trim(),
      services: selectedServices,
      mainPhoto: form.elements.mainPhoto.value.trim(),
      gallery,
      description: form.elements.description.value.trim(),
      materials,
      seo: {
        title: form.elements.seoTitle.value.trim(),
        description: form.elements.seoDescription.value.trim(),
        h1: form.elements.seoH1.value.trim(),
        text: form.elements.seoText.value.trim(),
        faq
      }
    };
  }

  function fillForm(project) {
    const form = document.querySelector("[data-project-form]");
    activeId = project.id;
    form.elements.id.value = project.id || "";
    form.elements.title.value = project.title || "";
    form.elements.slug.value = project.slug || "";
    form.elements.city.value = project.city || "";
    form.elements.district.value = project.district || "";
    form.elements.year.value = project.year || "";
    form.elements.area.value = project.area || "";
    form.elements.realizationType.value = project.realizationType || "";
    form.elements.status.value = project.status || "published";
    form.elements.mainPhoto.value = project.mainPhoto || "";
    form.elements.gallery.value = (project.gallery || []).join("\n");
    form.elements.description.value = project.description || "";
    form.elements.materials.value = (project.materials || []).join("\n");
    form.elements.seoTitle.value = project.seo?.title || "";
    form.elements.seoDescription.value = project.seo?.description || "";
    form.elements.seoH1.value = project.seo?.h1 || "";
    form.elements.seoText.value = project.seo?.text || "";
    form.elements.faq.value = formatFaq(project.seo?.faq || []);
    form.querySelectorAll('input[name="services"]').forEach((input) => {
      input.checked = (project.services || []).includes(input.value);
    });
    form.querySelector(".admin-panel-head h2").textContent = "Upravit realizaci";
    updatePreview();
    renderGalleryPreview();
  }

  function resetForm() {
    const form = document.querySelector("[data-project-form]");
    activeId = "";
    form.reset();
    form.elements.year.value = new Date().getFullYear();
    form.elements.status.value = "published";
    form.querySelector(".admin-panel-head h2").textContent = "Nová realizace";
    updatePreview();
    renderGalleryPreview();
    showAlert("");
  }

  function editProject(id) {
    const project = projects.find((item) => item.id === id);
    if (project) {
      fillForm(project);
      document.querySelector("[data-project-form]").scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }

  function deleteProject(id) {
    const project = projects.find((item) => item.id === id);
    if (!project) return;
    const ok = window.confirm("Opravdu odstranit realizaci „" + project.title + "“?");
    if (!ok) return;
    projects = projects.filter((item) => item.id !== id);
    saveProjects();
    renderAll();
    resetForm();
    showAlert("Realizace byla odstraněna.");
  }

  function renderAll() {
    renderDashboard();
    renderProjectList();
  }

  function renderDashboard() {
    const cities = new Set(projects.map((project) => project.city).filter(Boolean));
    const published = projects.filter((project) => project.status !== "draft").length;
    setStat("projects", projects.length);
    setStat("cities", cities.size);
    setStat("published", published);
    setStat("localities", SEO_LOCALITIES);
  }

  function setStat(name, value) {
    const node = document.querySelector('[data-stat="' + name + '"]');
    if (node) node.textContent = value.toLocaleString("cs-CZ");
  }

  function renderProjectList() {
    const list = document.querySelector("[data-project-list]");
    const query = (document.querySelector("[data-project-search]").value || "").toLowerCase();
    const filtered = projects.filter((project) => {
      const haystack = [project.title, project.city, project.district, project.slug, ...(project.services || [])].join(" ").toLowerCase();
      return haystack.includes(query);
    });
    const visible = filtered.slice(0, MAX_RENDERED_PROJECTS);

    if (!visible.length) {
      list.innerHTML = '<p class="muted">Žádná realizace neodpovídá filtru.</p>';
      return;
    }

    list.innerHTML = visible.map((project) => {
      const services = (project.services || []).slice(0, 3).join(", ");
      return `
        <article class="admin-project-row">
          <div>
            <strong>${escapeHtml(project.title)}</strong>
            <span>${escapeHtml(project.city)} · ${escapeHtml(String(project.year || ""))} · ${escapeHtml(services)}</span>
            <code>/realizace/${escapeHtml(project.slug)}/</code>
          </div>
          <div class="admin-row-actions">
            <button class="btn alt" type="button" data-edit-project="${escapeHtml(project.id)}">Upravit</button>
            <button class="btn alt danger" type="button" data-delete-project="${escapeHtml(project.id)}">Smazat</button>
          </div>
        </article>
      `;
    }).join("");

    if (filtered.length > visible.length) {
      list.innerHTML += '<p class="muted">Zobrazeno prvních ' + MAX_RENDERED_PROJECTS + " z " + filtered.length + " realizací.</p>";
    }
  }

  function renderGalleryPreview() {
    const form = document.querySelector("[data-project-form]");
    const box = document.querySelector("[data-gallery-preview]");
    const images = [form.elements.mainPhoto.value.trim(), ...splitLines(form.elements.gallery.value)].filter(Boolean).slice(0, 8);
    box.innerHTML = images.map((src) => '<div style="background-image:url(' + cssUrl(src) + ')"></div>').join("");
  }

  function updatePreview() {
    const form = document.querySelector("[data-project-form]");
    const slug = slugify(form.elements.slug.value || "slug");
    const preview = document.querySelector("[data-preview-url]");
    if (preview) preview.textContent = "/realizace/" + slug + "/";
  }

  function applySeoToForm(project) {
    const form = document.querySelector("[data-project-form]");
    const seo = generateSeo(project);
    form.elements.seoTitle.value = seo.title;
    form.elements.seoDescription.value = seo.description;
    form.elements.seoH1.value = seo.h1;
    form.elements.seoText.value = seo.text;
    form.elements.faq.value = formatFaq(seo.faq);
    updatePreview();
  }

  function generateSeo(project) {
    const primary = getPrimaryMeta(project.services || []);
    const city = project.city || "[město]";
    const year = project.year || new Date().getFullYear();
    const area = project.area || "[m²]";
    const title = primary.generic + " " + city + " | Realizace " + year + " | KOST STAV PRAHA";
    const description = "Provedli jsme " + primary.lower + " v lokalitě " + city + ". Plocha " + area + " m². Kvalitní realizace omítek a fasád v Praze a Středočeském kraji.";
    const h1 = "Realizace " + primary.h1 + " " + locationPhrase(city);
    const text = buildSeoText(project, primary);
    const faq = buildFaq(project, primary);
    return { title, description, h1, text, faq };
  }

  function buildSeoText(project, primary) {
    const city = project.city || "[město]";
    const district = project.district || "Středočeský kraj";
    const year = project.year || new Date().getFullYear();
    const area = project.area || "[m²]";
    const type = project.realizationType || "stavební objekt";
    const services = (project.services || [primary.generic]).join(", ");
    const materials = (project.materials || []).length ? project.materials.join(", ") : "ověřené omítkové a fasádní materiály";

    return [
      "Realizace v lokalitě " + city + " patří mezi ukázky práce, kde je důležitá dobrá příprava, přesné zaměření a pečlivé dokončení detailů. V roce " + year + " jsme zde řešili projekt typu " + type + " o přibližné ploše " + area + " m². Zakázka zahrnovala služby " + services + " a byla navržena tak, aby výsledný povrch dobře fungoval při běžném užívání domu i při navazujících dokončovacích pracích.",
      "Před zahájením jsme posoudili stav podkladu, přístup na stavbu, návaznost dalších profesí a požadovaný termín dokončení. U realizací omítek a fasád se vyplatí nepodcenit přípravu, protože právě ta rozhoduje o rovinnosti, soudržnosti vrstev, čistotě rohů, špalet, soklů a detailů kolem oken. Díky tomu lze předejít zbytečným opravám a investor má jasnou představu o průběhu prací.",
      "Pro projekt v lokalitě " + city + " jsme zvolili materiály odpovídající rozsahu a technickým požadavkům stavby. Použité materiály zahrnovaly " + materials + ". Důležitá byla také ochrana okolních ploch, průběžná kontrola napojení a dodržení technologických přestávek. U omítek sledujeme především savost a pevnost podkladu, u fasád správnou skladbu systému, kotvení, armovací vrstvu a finální povrch.",
      "Hlavní výhodou řešení jako " + primary.lower + " je " + primary.benefits + ". U zákazníků v Praze a Středočeském kraji se často setkáváme s tím, že chtějí rychlou realizaci, ale zároveň potřebují kvalitní výsledek bez kompromisů. Proto vždy vysvětlujeme, které kroky lze urychlit a kde je naopak nutné dodržet technologický postup.",
      "Během realizace jsme průběžně kontrolovali rovinnost, kvalitu detailů a návaznost na další povrchové úpravy. U větších ploch je důležité rozdělit práci do logických etap, aby materiál správně vyzrál a aby se na stavbě zbytečně nekřížily profese. Investor tak má přehled o tom, kdy je možné pokračovat malbou, montáží zařizovacích prvků nebo dalšími pracemi na fasádě.",
      "Při plánování podobné zakázky se vyplatí připravit co nejvíce informací už před prvním zaměřením. Pomáhá orientační výměra, fotografie aktuálního stavu, informace o typu zdiva, dokončených rozvodech a požadovaném termínu. Díky tomu lze rychleji určit vhodný materiál, předpokládanou délku realizace a místa, která mohou cenu nebo harmonogram ovlivnit.",
      "Kvalita realizace se nepozná jen podle velké plochy stěny nebo fasády. Rozhodují také rohy, přechody mezi materiály, špalety, dilatační místa, sokl, ostění a návaznost na okna nebo dveře. Právě těmto detailům věnujeme pozornost, protože bývají nejvíce vidět a zároveň mají velký vliv na životnost výsledného povrchu.",
      "U omítek i fasád je důležité dodržet technologické přestávky a nepřekrývat vrstvy dříve, než je podklad připravený. Rychlost práce proto vždy vyvažujeme správným postupem. Cílem není pouze dokončit zakázku rychle, ale předat povrch, který bude stabilní, rovný, čistý a připravený na běžné užívání bez zbytečných dodatečných oprav.",
      "Realizace v lokalitě " + city + " zároveň dobře ukazuje, proč je vhodné řešit omítky a fasádní práce s firmou, která umí navrhnout celý postup v souvislostech. Pokud se na stavbě kombinuje více typů prací, například vnitřní omítky, opravy podkladu, zateplení fasády nebo finální omítka, pomáhá jeden koordinovaný harmonogram a jasná odpovědnost za výsledek.",
      "Výsledkem je realizace, která odpovídá požadavkům na poctivé omítky a fasádní práce v lokalitě " + city + ". KOST STAV PRAHA s.r.o. zajišťuje podobné zakázky v okrese " + district + ", v celé Praze a ve Středočeském kraji. Pokud řešíte podobný rozsah, pošlete nám město, přibližnou plochu v m², fotografie stavby a případně projektovou dokumentaci. Připravíme nezávaznou cenovou nabídku a doporučíme vhodný postup."
    ].join("\n\n");
  }

  function buildFaq(project, primary) {
    const city = project.city || "[město]";
    const area = project.area || "[m²]";
    const year = project.year || new Date().getFullYear();
    return [
      {
        question: "Jaký typ prací byl realizován v lokalitě " + city + "?",
        answer: "Realizace zahrnovala " + primary.lower + " a související omítkářské nebo fasádní práce podle rozsahu zakázky."
      },
      {
        question: "Jaká byla přibližná plocha realizace?",
        answer: "Přibližná plocha projektu byla " + area + " m². Přesná cena se vždy odvíjí od stavu podkladu, členitosti a dostupnosti stavby."
      },
      {
        question: "Kdy byla realizace dokončena?",
        answer: "Projekt byl veden jako realizace roku " + year + ". Termín u podobných zakázek stanovujeme po zaměření a kontrole připravenosti stavby."
      },
      {
        question: "Umíte připravit podobnou realizaci v okolí?",
        answer: "Ano, KOST STAV PRAHA s.r.o. realizuje omítky a fasády v Praze, ve Středočeském kraji i v okolních městech."
      },
      {
        question: "Co poslat pro rychlou cenovou nabídku?",
        answer: "Nejlepší je poslat město, přibližnou plochu v m², fotografie stavby, požadovaný termín a případně projektovou dokumentaci."
      }
    ];
  }

  function getPrimaryMeta(services) {
    const priority = [
      "Strojní sádrové omítky",
      "Zateplení fasády",
      "Fasádní omítka",
      "Vápenocementové omítky",
      "Štukové omítky",
      "Kombinace služeb"
    ];
    const selected = priority.find((service) => services.includes(service)) || services[0] || "Strojní sádrové omítky";
    return SERVICE_META[selected] || SERVICE_META["Strojní sádrové omítky"];
  }

  function locationPhrase(city) {
    return LOCATION_PHRASES[city] || ("v lokalitě " + city);
  }

  function exportJson() {
    const blob = new Blob([JSON.stringify(projects, null, 2)], { type: "application/json;charset=utf-8" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = "realizace.json";
    link.click();
    URL.revokeObjectURL(url);
    showAlert("Data byla připravena ke stažení.");
  }

  async function importJson(event) {
    const file = event.target.files[0];
    if (!file) return;
    try {
      const imported = JSON.parse(await file.text());
      if (!Array.isArray(imported)) throw new Error("Soubor neobsahuje pole realizací.");
      projects = imported;
      saveProjects();
      renderAll();
      resetForm();
      showAlert("Data realizací byla importována.");
    } catch (error) {
      showAlert("Import se nepodařil: " + error.message, true);
    } finally {
      event.target.value = "";
    }
  }

  function showAlert(message, error) {
    const alert = document.querySelector("[data-admin-alert]");
    if (!alert) return;
    alert.textContent = message || "";
    alert.classList.toggle("show", Boolean(message));
    alert.classList.toggle("error", Boolean(error));
  }

  function slugify(value) {
    return String(value || "")
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-+|-+$/g, "")
      .slice(0, 90);
  }

  function splitLines(value) {
    return String(value || "").split(/\r?\n/).map((line) => line.trim()).filter(Boolean);
  }

  function parseFaq(value) {
    return splitLines(value).map((line) => {
      const parts = line.split("|");
      return {
        question: (parts[0] || "").trim(),
        answer: parts.slice(1).join("|").trim()
      };
    }).filter((item) => item.question && item.answer);
  }

  function formatFaq(items) {
    return (items || []).map((item) => item.question + " | " + item.answer).join("\n");
  }

  function escapeHtml(value) {
    return String(value || "").replace(/[&<>"']/g, (char) => ({
      "&": "&amp;",
      "<": "&lt;",
      ">": "&gt;",
      '"': "&quot;",
      "'": "&#039;"
    }[char]));
  }

  function cssUrl(value) {
    return "'" + String(value || "").replace(/'/g, "%27") + "'";
  }
})();
