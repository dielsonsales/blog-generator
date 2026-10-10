# Static Home Page Post List

---
**Status:** Draft
**Created:** 2026-10-10
**Updated:** 2026-10-10
---


## Outcome

A build turns Markdown posts with YAML front matter into static HTML pages and
generates `public/index.html` with a deterministic list of links to those pages.
Authors can add a post and rebuild without editing the home page by hand.

## Problem

The project has no generator yet, so there is no established path from its
existing Markdown posts and YAML front matter to usable post pages and a home
page. It is not yet validated that a small POSIX shell build can create both
while keeping the source and generated output separate.

## Hypothesis

A POSIX shell script can use Pandoc's YAML metadata support to generate post
pages and a useful home page from the Markdown files already stored directly in
`content/`. The metadata fields `title` and `date` provide displayed post
information, while `tags` can be shown on each post without requiring a larger
generator framework.

## Scope

- Read Markdown posts from `content/*.md`.
- Require YAML front matter with a non-empty `title` and `date`; accept an
optional list of `tags`.
- Generate a corresponding page at `public/<filename>.html` using the title,
date, tags, and converted Markdown body.
- Generate `public/index.html` with links and dates for all posts, sorted by
filename.
- Produce a clear empty state when there are no posts.
- Provide Make targets to build and clean the generated site.

## Out of Scope

- Tag pages, filtering, pagination, search, RSS, comments, or client-side
behavior.
- Incremental builds, themes, multiple page layouts, or deployment automation.
- A test framework or a new runtime dependency beyond the chosen Markdown
converter.

## Constraints

- Keep build logic POSIX-shell-compatible and use Make for common commands.
- Treat the Markdown converter as an explicit external dependency and fail
clearly if it is unavailable.
- Escape titles before inserting them into HTML; do not use unescaped content in
shell replacement strings.
- Keep source under `content/`, templates under `templates/`, and generated
output under `public/`.
- Builds must be deterministic, and generated output must not be read as build
input.
- Keep the home page and post pages as ordinary static HTML with no injected ads
or third-party tracking.

## Proposed Change

Add the smallest generator slice using the existing project intent documented in
`README.md`, `AGENTS.md`, and `docs/001-original-idea.md`. Use the existing
`content/post-title.md` post as the representative input, add a shared page
template, a POSIX shell build script, and Make targets for building and
cleaning.

The data flow is: enumerate `content/*.md` in filename order, let Pandoc read
each post's YAML front matter, convert its Markdown body to HTML, and render the
post page and home-page entry from the metadata and converted content. Use
`title` and `date` in the post page and index; show `tags` on the post page when
present. Use the source filename (without `.md`) as the output page slug. Do not
parse YAML by extracting values with shell text substitutions.

There is no interactive UI, cancellation flow, or permission prompt. A build
failure, including a missing converter, malformed front matter, missing
required metadata, or an unwritable output directory, must exit unsuccessfully
with a useful diagnostic rather than report success.

## Acceptance Criteria

- [ ] Given a Markdown post with valid YAML front matter containing `title` and
`date`, when the site is built, then its static page displays those values and
the converted body, and `public/index.html` links to it using the title and
shows its date.
- [ ] Given a post with a `tags` list, when its page is generated, then the tags
are displayed there and no tag pages or filtering are generated.
- [ ] Given multiple valid posts, when the site is built repeatedly, then the
home-page links appear in filename order and the generated output is
reproducible.
- [ ] Given no Markdown posts, when the site is built, then `public/index.html`
is generated with a clear empty-state message and the build succeeds.
- [ ] Given a post with malformed YAML front matter or without a required
`title` or `date`, when the site is built, then the build fails with a
diagnostic identifying the invalid post and missing or malformed metadata.
- [ ] Given the Markdown converter is unavailable, when the site is built, then
the build fails with a useful installation or dependency message.
- [ ] Given the output directory cannot be written, when the site is built, then
the build fails and does not report a successful build.

## Validation Plan

Run the build from a clean output directory using the existing post, which has
`title` and `date` metadata and representative Markdown formatting. Inspect the
generated page, rendered tags when present, and home-page link; then rebuild and
compare the output for determinism. Also run the empty-posts case, cases with
missing required metadata and malformed front matter, and a build with the
converter unavailable to verify the empty state and failure diagnostics. No
device checks are needed because the output is a static website with no
device-specific behavior.

## Risks and Open Questions

- Filename ordering is predictable but may not match publication order; this
experiment deliberately avoids date sorting to keep the build deterministic
without adding date parsing and ordering complexity.
- Confirm the date display format and whether tags should appear on the home
page in a later iteration; this spec limits tag display to individual post
pages.
