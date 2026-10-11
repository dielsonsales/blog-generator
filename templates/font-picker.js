(() => {
  const storageKey = "blog-font-style";
  const supportedStyles = new Set(["default", "serif", "mono"]);
  const controls = document.querySelectorAll("[data-font-style]");

  function applyFontStyle(style) {
    if (!supportedStyles.has(style)) {
      return;
    }

    document.documentElement.dataset.fontStyle = style;
    controls.forEach((control) => {
      control.setAttribute("aria-pressed", String(control.dataset.fontStyle === style));
    });
  }

  let savedStyle = "default";
  try {
    savedStyle = window.localStorage.getItem(storageKey) || savedStyle;
  } catch {
    // Storage can be unavailable in restricted browser contexts.
  }
  applyFontStyle(savedStyle);

  controls.forEach((control) => {
    control.addEventListener("click", () => {
      const style = control.dataset.fontStyle;
      applyFontStyle(style);

      try {
        window.localStorage.setItem(storageKey, style);
      } catch {
        // The font choice still applies for the current page.
      }

      const picker = control.closest("details");
      if (picker) {
        picker.open = false;
        picker.querySelector("summary").focus();
      }
    });
  });
})();