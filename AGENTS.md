# Repository Instructions

## Project Goal

Keep this project a small, understandable static blog generator. It converts
local Markdown posts into ordinary static HTML using POSIX shell, Make, and
Pandoc rather than a large framework or runtime dependency stack. The original
idea is documented in `docs/001-original-idea.md`.

## Content and Generated Files

- Posts are local user content in `content/*.md` and are intentionally excluded
  from version control. Do not add, remove, or edit post content unless
  explicitly requested.
- Each post uses YAML front matter with a non-empty `title` and `date`; `tags`
  are optional. Pandoc reads the metadata, and the Lua filter in
  `filters/validate-metadata.lua` checks required fields.
- The source filename, without `.md`, is the post URL slug.
- `build.sh` reads posts in filename order, renders each post using
  `templates/post.html`, and builds `public/index.html` using the index
  templates. The home page contains a list of post links and shows an empty
  state when there are no posts.
- `public/` is generated output and is intentionally excluded from version
  control. Never use generated files as build inputs or hand-edit them as source.

## Build Commands

- `make` and `make build` run `build.sh` to generate the site in `public/`.
- `make clean` removes `public/`.
- Pandoc is an explicit build dependency. The build must fail clearly if it is
  unavailable; its Lua filter runs through Pandoc's bundled Lua engine.
- There is currently no Make target for local preview or deployment.

## Implementation Principles

- Write scripts for POSIX `/bin/sh` by default and use Make for common
  commands. Keep shell syntax and utility usage as portable as possible across
  macOS and common Unix-like systems; avoid Bash-only features and non-POSIX
  utility flags. If a shell-specific feature is necessary, declare the
  interpreter explicitly and document the reason.
- Keep templates and metadata handling small and transparent. Do not parse YAML
  using shell text substitutions or insert unescaped values into HTML.
- Keep output deterministic from the local Markdown inputs and tracked build
  files. Use filename ordering unless the requested feature changes that policy.
- Keep documentation synchronized with implemented commands, dependencies,
  metadata conventions, and directory layout.

## Validation

For build changes, run `make clean` followed by `make build` with Pandoc
installed. Check generated post and index HTML, including title, date, optional
tags, and filename ordering. Also verify the empty-post state, useful failures
for missing Pandoc or invalid required metadata, and reproducibility across
repeated builds. Do not introduce a test framework for this small build without
a concrete need.