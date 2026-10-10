# Repository Instructions

## Project Goal

Keep this project a small, understandable static blog generator. Blog posts are
written in Markdown and generated pages are ordinary static HTML. Prefer a few
transparent tools over a large framework or runtime dependency stack.

This repository is at the design and setup stage. The generator and its build
commands have not been implemented yet.

## Implementation Principles

- Keep source posts, templates, and generated output clearly separated.
- Prefer portable POSIX shell for build logic and Make for common tasks.
- Treat the Markdown converter as an explicit external dependency; document how
  to install it and check for it clearly instead of implying the build has no
  dependencies.
- Avoid Bash-only features and non-portable utility flags in the build.
- Escape titles and other content appropriately when inserting values into
  HTML. Do not rely on unescaped text in `sed` replacement strings.
- Make builds deterministic, fail clearly on errors, and keep generated output
  reproducible from tracked source files.
- Keep generated files out of source inputs and avoid committing generated
  output unless the project explicitly adopts that publishing workflow.
- Keep documentation in sync with the actual commands, dependencies, and
  directory layout as the implementation evolves.

## Validation

When build code is added, validate it with a clean build and a representative
Markdown post containing at least a title and basic formatting. Verify that a
missing converter produces a useful error. Add broader checks when behavior or
the build interface grows; do not introduce a test framework for the initial
small build without a concrete need.