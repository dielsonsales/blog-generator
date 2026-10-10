# Readable Blog Templates

---
**Status:** Draft
**Created:** 2026-10-10
**Updated:** 2026-10-10
---

## Outcome

Generated post and home pages have a shared, restrained reading-focused style:
comfortable line length and spacing, legible type, clear heading hierarchy, and
responsive side padding, while remaining fast and usable without external
services.

## Problem

The current post and home-page templates contain semantic HTML but no styling.
Their default browser presentation may be cramped or difficult to read, and
there is no shared styling path to improve both consistently.

## Hypothesis

A small local stylesheet shared by both page types can make the blog easier to
read at desktop and mobile widths without introducing a framework, external
assets, or complexity to Markdown generation.

## Scope

- Add one stylesheet for typography, readable content width, spacing, link
  treatment, and responsive page padding.
- Link the stylesheet from post pages and the generated home page.
- Copy the stylesheet into `public/` during the existing build.
- Preserve current post metadata, list ordering, and empty-post behavior.

## Out of Scope

- Redesigning the blog brand or adding decorative layouts, themes, or dark-mode
  controls.
- JavaScript, external fonts, analytics, tracking, or other remote assets.
- Changing post content, metadata, generated URLs, or index behavior.

## Constraints

- Keep stylesheet source under `templates/`; generated assets belong under
  `public/` and must not be used as build inputs.
- Ensure text remains readable at narrow and wide viewport sizes and maintain
  visible keyboard focus and sufficient text contrast.
- Do not copy the source page's profanity or include its third-party scripts.

## Proposed Change

Use `templates/post.html` and `templates/index-header.html` as the page-shell
integration points, and `build.sh` to copy a new `templates/site.css` to
`public/site.css`. Link the same local asset from both page types. The data flow
remains unchanged: Pandoc renders post and index HTML, and the build publishes
the stylesheet beside those files.

Keep the CSS limited to a readable text column, comfortable body line-height
and type size, tighter heading line-height, restrained text colors, responsive
horizontal padding, and discernible links and focus states. There is no
interactive UI, cancellation behavior, or permission request. A failed asset
copy or build must still fail rather than produce a successful build with a
missing stylesheet. The existing empty state should use the same page styling.

## Acceptance Criteria

- [ ] Given a valid post, when the site is built, then its page links to the
local stylesheet and retains its title, date, tags, and body.
- [ ] Given one or more posts, when the site is built, then the home page links
to the same stylesheet and retains its existing filename order and post links.
- [ ] Given no posts, when the site is built, then the home page still shows its
empty state and links to the stylesheet.
- [ ] Given the stylesheet is missing or cannot be copied, when the site is
built, then the build fails with a nonzero status instead of reporting success.
- [ ] Given a reader opens either page at narrow and desktop viewport widths,
when they inspect the content, then text has comfortable line length, spacing,
and contrast without horizontal overflow.
- [ ] Given a reader navigates links with a keyboard, when a link receives
focus, then its focus state is visible.

## Validation Plan

Run `make clean` and `make build`, then inspect generated post and index HTML
for stylesheet links and verify that `public/site.css` exists. Confirm the
existing post metadata/body and index listing render as before; temporarily
build with no posts to verify the styled empty state. Open the generated pages
in a browser at narrow and desktop widths, checking text measure, spacing,
contrast, overflow, and keyboard focus. Repeat the build to confirm that the
asset and HTML output are deterministic. No permission or cancellation checks
are needed because the build and pages have no such flows.

## Risks and Open Questions

- The initial style values may need adjustment after viewing the actual post
  content at narrow widths; keep this experiment focused on readability rather
  than adding a broader visual identity.
- Decide later whether any post-specific elements need a distinct measure or
  spacing; this first pass should share the same basic reading rules.