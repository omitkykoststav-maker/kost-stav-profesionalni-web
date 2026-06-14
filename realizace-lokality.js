(function () {
  const SERVICE_MATCH = {
    "strojni-omitky": ["Strojní sádrové omítky", "Kombinace služeb"],
    "sadrove-omitky": ["Strojní sádrové omítky", "Kombinace služeb"],
    "stukove-omitky": ["Štukové omítky", "Kombinace služeb"],
    "vapenocementove-omitky": ["Vápenocementové omítky", "Kombinace služeb"],
    "zatepleni-fasad": ["Zateplení fasády", "Kombinace služeb"],
    "fasadni-prace": ["Fasádní omítka", "Oprava fasády", "Sokl fasády", "Kombinace služeb"]
  };

  document.addEventListener("DOMContentLoaded", async () => {
    const blocks = document.querySelectorAll("[data-realizace-lokality]");
    if (!blocks.length) return;

    let projects = [];
    try {
      const response = await fetch("../data/realizace.json", { cache: "no-store" });
      if (!response.ok) throw new Error(response.statusText);
      projects = await response.json();
    } catch (error) {
      blocks.forEach((block) => block.hidden = true);
      return;
    }

    blocks.forEach((block) => {
      const serviceSlug = block.dataset.service;
      const citySlug = block.dataset.city;
      const cityName = block.dataset.cityName || "";
      const services = SERVICE_MATCH[serviceSlug] || [];
      const matches = projects
        .filter((project) => project.status !== "draft")
        .filter((project) => slugify(project.city) === citySlug)
        .filter((project) => (project.services || []).some((service) => services.includes(service)))
        .slice(0, 6);

      if (!matches.length) {
        block.hidden = true;
        return;
      }

      const target = block.querySelector("[data-realizace-list]");
      const heading = block.querySelector("[data-realizace-heading]");
      if (heading) heading.textContent = "Realizace v lokalitě " + cityName;
      if (target) {
        target.innerHTML = matches.map((project) => `
          <article class="card realization-card">
            <a class="realization-thumb" href="../realizace/${escapeHtml(project.slug)}/" style="background-image:url('${escapeAttr(project.mainPhoto || "")}')"></a>
            <h3><a href="../realizace/${escapeHtml(project.slug)}/">${escapeHtml(project.title)}</a></h3>
            <p>${escapeHtml(project.city)} · ${escapeHtml(String(project.year || ""))} · ${escapeHtml(String(project.area || ""))} m²</p>
            <a class="text-link" href="../realizace/${escapeHtml(project.slug)}/">Detail realizace</a>
          </article>
        `).join("");
      }
      block.hidden = false;
    });
  });

  function slugify(value) {
    return String(value || "")
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-+|-+$/g, "");
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

  function escapeAttr(value) {
    return String(value || "").replace(/'/g, "%27").replace(/"/g, "%22");
  }
})();
