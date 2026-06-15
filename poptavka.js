document.addEventListener("DOMContentLoaded", () => {
  const forms = document.querySelectorAll("[data-poptavka-form]");
  const params = new URLSearchParams(window.location.search);
  const wasSubmitted = params.get("odeslano") === "1";
  const thankYouMessage = "Děkujeme za poptávku. Ozveme se vám do 24 hodin.";

  forms.forEach((form) => {
    const alertBox = form.querySelector("[data-form-alert]");
    const workRadios = form.querySelectorAll('input[name="typ_prace"]');
    const specificGroups = form.querySelectorAll("[data-specific-group]");

    const setAlert = (message, isError = false) => {
      if (!alertBox) return;
      alertBox.textContent = message;
      alertBox.classList.toggle("error", isError);
      alertBox.classList.add("show");
    };

    const updateSpecificGroups = () => {
      const selected = form.querySelector('input[name="typ_prace"]:checked')?.value || "omitky";

      specificGroups.forEach((group) => {
        const isActive = group.dataset.specificGroup === selected;
        group.hidden = !isActive;
        group.querySelectorAll("input").forEach((input) => {
          input.disabled = !isActive;
        });
      });
    };

    workRadios.forEach((radio) => {
      radio.addEventListener("change", () => {
        updateSpecificGroups();
        if (alertBox) alertBox.classList.remove("show", "error");
      });
    });

    form.addEventListener("submit", async (event) => {
      event.preventDefault();
      updateSpecificGroups();

      if (!form.checkValidity()) {
        form.reportValidity();
        return;
      }

      const selected = form.querySelector('input[name="typ_prace"]:checked')?.value || "omitky";
      const activeGroup = form.querySelector(`[data-specific-group="${selected}"]`);
      const hasSpecificChoice = activeGroup && activeGroup.querySelectorAll("input:checked").length > 0;

      if (!hasSpecificChoice) {
        setAlert("Vyberte prosím konkrétní typ omítky nebo fasády.", true);
        activeGroup?.scrollIntoView({ behavior: "smooth", block: "center" });
        return;
      }

      const submitButton = form.querySelector('button[type="submit"]');
      setAlert("Odesíláme Vaši poptávku.");
      if (submitButton) submitButton.disabled = true;

      try {
        const response = await fetch("/api/contact", {
          method: "POST",
          body: new FormData(form),
        });

        const data = await response.json();

        if (data.ok === true && data.redirect) {
          window.location.href = data.redirect;
          return;
        }

        throw new Error(data.message || "Odeslání se nepodařilo.");
      } catch (error) {
        console.error("Chyba při odesílání poptávky:", error);
        setAlert("Odeslání se nepodařilo. Zkuste to prosím znovu nebo nám zavolejte.", true);
        if (submitButton) submitButton.disabled = false;
      }
    });

    updateSpecificGroups();
    if (wasSubmitted) {
      setAlert(thankYouMessage);
    }
  });
});
