(() => {
  const storageKey = "blog-font-style";
  const themeStorageKey = "blog-theme";
  const supportedStyles = new Set(["default", "serif", "mono"]);
  const controls = document.querySelectorAll("[data-font-style]");
  const themeToggle = document.querySelector("[data-theme-toggle]");

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

  let savedTheme = "light";
  try {
    savedTheme = window.localStorage.getItem(themeStorageKey) || savedTheme;
  } catch {
    // Storage can be unavailable in restricted browser contexts.
  }

  function applyTheme(theme) {
    const isDark = theme === "dark";
    document.documentElement.dataset.theme = isDark ? "dark" : "light";
    if (themeToggle) {
      themeToggle.checked = isDark;
    }
  }

  applyTheme(savedTheme);

  if (themeToggle) {
    themeToggle.addEventListener("change", () => {
      const theme = themeToggle.checked ? "dark" : "light";
      applyTheme(theme);

      try {
        window.localStorage.setItem(themeStorageKey, theme);
      } catch {
        // The theme still applies for the current page.
      }
    });
  }

  controls.forEach((control) => {
    control.addEventListener("click", () => {
      const style = control.dataset.fontStyle;
      applyFontStyle(style);

      try {
        window.localStorage.setItem(storageKey, style);
      } catch {
        // The font choice still applies for the current page.
      }

    });
  });
})();