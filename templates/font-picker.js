(() => {
  const storageKey = "blog-font-style";
  const themeStorageKey = "blog-theme";
  const supportedStyles = new Set(["default", "serif", "mono"]);
  const root = document.documentElement;

  function applyFontStyle(style) {
    if (!supportedStyles.has(style)) {
      return;
    }

    root.dataset.fontStyle = style;
  }

  let savedStyle = "default";
  let savedTheme = "light";
  try {
    savedStyle = window.localStorage.getItem(storageKey) || savedStyle;
    savedTheme = window.localStorage.getItem(themeStorageKey) || savedTheme;
  } catch {
    // Storage can be unavailable in restricted browser contexts.
  }
  applyFontStyle(savedStyle);

  function applyTheme(theme) {
    root.dataset.theme = theme === "dark" ? "dark" : "light";
  }

  applyTheme(savedTheme);

  document.addEventListener("DOMContentLoaded", () => {
    const picker = document.querySelector(".font-picker");
    const controls = document.querySelectorAll("[data-font-style]");
    const themeToggle = document.querySelector("[data-theme-toggle]");

    if (picker) {
      document.addEventListener("click", (event) => {
        if (!picker.contains(event.target)) {
          picker.open = false;
        }
      });
    }

    controls.forEach((control) => {
      control.setAttribute("aria-pressed", String(control.dataset.fontStyle === savedStyle));
    });
    if (themeToggle) {
      themeToggle.checked = root.dataset.theme === "dark";
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
        controls.forEach((option) => {
          option.setAttribute("aria-pressed", String(option === control));
        });

        try {
          window.localStorage.setItem(storageKey, style);
        } catch {
          // The font choice still applies for the current page.
        }
      });
    });
  });
})();