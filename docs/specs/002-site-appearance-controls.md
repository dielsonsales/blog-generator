# Site Appearance Controls

---
**Status:** Implemented
**Created:** 2026-10-11
**Last Updated:** 2026-10-12
---

## Outcome

Readers can choose a site-wide font style and light or dark appearance from a
compact picker in the header on both the home page and post pages. Choices are
remembered in that browser, and a saved dark theme is applied before the page's
stylesheet can paint the light theme. The default typography uses a 16px
Helvetica Neue-compatible sans-serif stack with a 1.5 line-height. The dark
theme uses softened charcoal backgrounds, and links use Tumblr's `#4EA3D0`
blue without underlines.

## Problem

Currently the site does not offer any user controls for font style or light/dark
appearance, and there is no mechanism to remember user preferences across page
loads. All of these preferences are good for accessibility and user experience.

## Hypothesis

One shared picker fragment, combined with a small local script that reads saved
preferences before the stylesheet loads, will provide consistent controls and
prevent a light-theme flash on reload without adding a framework or runtime
service.

## Scope

- Offer Default, Serif, and Mono choices with distinct font previews; the
  Default preview uses the blue accent and the other previews use the current
  text color.
- Apply the selected font style site-wide while keeping code blocks readable and
  monospaced. The default style uses a Helvetica Neue-compatible sans-serif
  stack, 16px base size, 1.5 line-height, and antialiased rendering.
- Offer a Light/Dark switch in an Appearance section. Apply theme-aware colors
  to page backgrounds, text, links, header and footer borders, and the picker.
- Keep the dark page and picker surfaces neutral charcoal rather than near-black;
  use `#4EA3D0` for links in both themes and omit link underlines.
- Persist font and theme choices in browser `localStorage` and reuse them on
  the home page and post pages.
- Keep one picker markup source in `templates/font-picker.html`, rendered into
  both page types by `build.sh`.
- Apply stored preferences before `site.css` loads; keep the header and footer
  layout usable at narrow viewport widths.

## Out of Scope

- System-theme detection, additional themes, font-size controls, full-width
  layout controls, or table-of-contents controls.
- Changing post content, adding external fonts or libraries, or introducing a
  test framework.

## Constraints

- Keep the site as ordinary static HTML and CSS, with local vanilla JavaScript
  and the existing Pandoc/Make/POSIX-shell build.
- Store preferences only in the current browser.
- If storage is blocked or unavailable, the page and controls must still work
  for the current visit and fall back to the default appearance on a later
  load.
- Keep controls keyboard-accessible, labeled, and responsive. Font-preview
  colors must not reduce the contrast of their labels or selected state.
- The early preference script must remain small and run before the stylesheet;
  the build must copy it and inject the shared picker into both page templates.

## Proposed Change

Use `templates/font-picker.html` as the only source for picker markup. Pass it
to `templates/index-header.html` and `templates/post.html` through the
`font-picker` Pandoc variable in `build.sh`. Use `templates/site.css` for the
compact panel, font previews, header/footer layout, and light/dark CSS
variables. Use `templates/font-picker.js` to read `blog-font-style` and
`blog-theme` synchronously in the document head before `site.css`, then attach
the control handlers after the page markup loads.

Changing a font or theme updates the current page immediately and attempts to
save the selection locally. Closing the native picker without changing a
control has no effect. Storage failures are caught; they do not block page
rendering or the current-page change. There is no permission prompt or network
request. The smallest experiment is to build both page types, set dark mode,
and reload a page while observing its first rendered frame.

## Acceptance Criteria

- [ ] Given the home page or a post page, when the reader opens the header
  picker, then it shows Default, Serif, and Mono previews plus the Appearance
  theme switch.
- [ ] Given any font choice, when the reader selects it, then page text changes
  immediately, the selected choice is visibly highlighted and announced as
  pressed, and the choice is restored on both page types after navigation or
  reload.
- [ ] Given either theme, when the reader changes the switch, then the page,
  header, footer, links, and picker update immediately and the choice persists
  across page navigation and reload.
- [ ] Given the dark theme is active, when the page renders, then its page and
  picker surfaces use softened charcoal backgrounds and its links use
  `#4EA3D0` without underlines.
- [ ] Given Dark is saved, when the reader reloads a page, then the saved dark
  theme is applied before the stylesheet is evaluated and no light-theme frame
  appears after the page begins rendering.
- [ ] Given the picker is open and the reader closes it without changing an
  option, when it closes, then the saved font and theme choices remain
  unchanged.
- [ ] Given there are no posts, when the home page is built, then its empty
  state still includes a working picker and themed header/footer.
- [ ] Given browser storage is unavailable, when the reader changes a setting,
  then the current page updates without an exception or permission prompt, and
  the page remains usable after reload with the default appearance.
- [ ] Given `templates/font-picker.html` is missing, when the site is built,
  then the build fails with a useful error instead of generating pages without
  the shared control.

## Risks and Open Questions

- A synchronous head script can delay stylesheet loading slightly; keep it
  minimal and confirm the no-flash benefit is worth that local request.
- The default remains Light regardless of the operating system theme unless a
  later requirement asks to follow system preferences.