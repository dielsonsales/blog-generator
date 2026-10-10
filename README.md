# Plain-Text Static Blog

A small static blog generator for writing posts in Markdown and publishing
ordinary HTML files. The goal is to make rebuilding the blog straightforward
without large dependency setup, while avoiding hosted publishing platforms that
inject advertising or tracking into the site.

## Goals

- Write posts as plain Markdown files.
- Generate static HTML that can be hosted on a basic web server or static
  hosting service.
- Keep the build logic small, readable, and easy to inspect.
- Minimize dependencies and make the remaining requirements explicit.
- Keep the published site free of injected ads and unnecessary third-party
  tracking.

## Proposed Structure

```text
content/       Markdown source posts
templates/     Shared HTML page fragments
public/        Generated site output
build.sh       Site generation script
Makefile       Build, clean, and local preview targets
```

The exact structure and generated-page conventions will be settled as the
generator is implemented. Generated output should be reproducible from the
Markdown content and templates.

## Tools and Dependencies

The intended build uses a POSIX-compatible shell and Make, plus a Markdown to
HTML converter such as Pandoc. The converter is a real dependency: the project
aims to avoid a large language-specific dependency tree, not to pretend that
Markdown conversion requires no software. A Python 3 local server may be used
for previewing generated pages, but it is not needed to build or host them.

Installation instructions and exact version requirements will be documented
once the build implementation is in place.

## Intended Workflow

The planned workflow is to add a Markdown file under `content/`, build the
site with Make, and publish the generated files from `public/`. A local preview
target is also planned. These commands are not available yet.

## Design Notes

The project favors transparent shell and Make rules over a framework. In
particular, the build should fail clearly when its converter is missing,
escape content safely when placing it into HTML, and avoid shell or utility
extensions that make the script unnecessarily platform-specific.