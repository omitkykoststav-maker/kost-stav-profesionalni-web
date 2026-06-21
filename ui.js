document.addEventListener("DOMContentLoaded", () => {
  const phone = "+420777977571";
  const phoneText = "+420 777 977 571";
  const whatsapp = "https://wa.me/420777977571";

  document.querySelectorAll("img").forEach((img, index) => {
    if (!img.hasAttribute("decoding")) img.setAttribute("decoding", "async");
    if (index > 0 && !img.hasAttribute("loading")) img.setAttribute("loading", "lazy");
  });

  document.querySelectorAll("iframe").forEach((frame) => {
    if (!frame.hasAttribute("loading")) frame.setAttribute("loading", "lazy");
  });

  if (!document.querySelector(".floating-actions")) {
    const actions = document.createElement("div");
    actions.className = "floating-actions";
    actions.innerHTML = `
      <a class="sticky-call" href="tel:${phone}" aria-label="Zavolat ${phoneText}">Zavolat</a>
      <a class="sticky-whatsapp" href="${whatsapp}" aria-label="Napsat přes WhatsApp">WhatsApp</a>
      <button class="back-to-top" type="button" aria-label="Zpět nahoru">↑</button>
    `;
    document.body.appendChild(actions);
    document.body.classList.add("has-floating-actions");
  }

  const backToTop = document.querySelector(".back-to-top");
  const floatingActions = document.querySelector(".floating-actions");
  const toggleStickyActions = () => {
    floatingActions?.classList.toggle("is-visible", window.scrollY > 360);
    if (!backToTop) return;
    backToTop.classList.toggle("is-visible", window.scrollY > 520);
  };

  backToTop?.addEventListener("click", () => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  });

  toggleStickyActions();
  window.addEventListener("scroll", toggleStickyActions, { passive: true });

  // Never hide whole sections: if the observer is delayed, article pages can look blank.
  const revealTargets = document.querySelectorAll(".card, .review, .contactbox, .gallery-photo, .premium-gallery figure");
  revealTargets.forEach((target) => target.classList.add("reveal"));

  const showRevealTargets = () => {
    revealTargets.forEach((target) => target.classList.add("is-visible"));
  };

  if ("IntersectionObserver" in window) {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        entry.target.classList.add("is-visible");
        observer.unobserve(entry.target);
      });
    }, { rootMargin: "0px 0px -12% 0px", threshold: 0.08 });

    revealTargets.forEach((target) => observer.observe(target));
    window.setTimeout(showRevealTargets, 1200);
  } else {
    showRevealTargets();
  }
});
