# Static Home Page Post List

## Outcome

A build turns Markdown posts into static HTML pages and generates
`public/index.html` with a deterministic list of links to those pages. Authors
can add a post and rebuild without editing the home page by hand.

## Problem

The project has no generator yet, so there is no established path from Markdown
source files to a usable home page. It is not yet validated that a small POSIX
shell build can create both post pages and the list while keeping the source and
generated output separate.

## Hypothesis

A POSIX shell script can convert a small set of Markdown files and generate a
useful home page using each post's filename as its URL slug and its first-level
heading as its displayed title. This avoids introducing metadata parsing or a
larger generator framework for the first working slice.

## Scope

- Read Markdown posts from `content/posts/`.
- Require each post to begin with a first-level Markdown heading (`# Title`).
- Generate a corresponding page at `public/posts/<filename>.html`.
- Generate `public/index.html` with links to all posts, sorted by filename.
- Produce a clear empty state when there are no posts.
- Provide Make targets to build and clean the generated site; include local
preview only if it remains a small addition to the same workflow.

## Out of Scope

- YAML front matter or other post metadata, including dates and tags.
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
`README.md`, `AGENTS.md`, and `docs/001-original-idea.md`. Add a representative
post under `content/posts/`, a shared page template, a POSIX shell build script,
and Make targets for building and cleaning.

The data flow is: enumerate `content/posts/*.md` in filename order, read the
first-level heading as the plain-text title, convert the Markdown to HTML, write
the post page under `public/posts/`, and write a link for that post into
`public/index.html`. The title appears in the generated index; the Markdown
converter handles the post body. YAML front matter is not part of the input
format for this experiment.

There is no interactive UI, cancellation flow, or permission prompt. A build
failure, including a missing converter, missing title, or unwritable output
directory, must exit unsuccessfully with a useful diagnostic rather than report
success.

## Acceptance Criteria

- [ ] Given a valid Markdown post with a first-level heading and basic
formatting, when the site is built, then its static page contains the converted
content and `public/index.html` links to it using the heading text.
- [ ] Given multiple valid posts, when the site is built repeatedly, then the
home-page links appear in filename order and the generated output is
reproducible.
- [ ] Given no Markdown posts, when the site is built, then `public/index.html`
is generated with a clear empty-state message and the build succeeds.
- [ ] Given a post without a first-level heading, when the site is built, then
the build fails with a diagnostic identifying the invalid post.
- [ ] Given the Markdown converter is unavailable, when the site is built, then
the build fails with a useful installation or dependency message.
- [ ] Given the output directory cannot be written, when the site is built, then
the build fails and does not report a successful build.
- [ ] Given a post contains YAML front matter, when this version of the build
processes it, then it is not interpreted as metadata; metadata support remains
deferred.

## Validation Plan

Run the build from a clean output directory using a representative Markdown post
with a title and basic formatting. Inspect the generated page and home-page
link, then rebuild and compare the output for determinism. Also run the
empty-posts case, the missing-title case, and a build with the converter
unavailable to verify the empty state and failure diagnostics. No device checks
are needed because the output is a static website with no device-specific
behavior.

## Risks and Open Questions

- The first-heading title convention is intentionally temporary; adding front
matter later will require defining how metadata titles relate to headings.
- Filename ordering is predictable but may not match desired publication order.
A date-based order can be considered when date metadata is introduced.
- The exact Markdown converter and its HTML output conventions remain to be
selected during implementation.
