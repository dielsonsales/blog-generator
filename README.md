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
serve.sh       Local preview server and browser launcher
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

### macOS Setup

Install [Homebrew](https://brew.sh/) if it is not already available, then
install Pandoc:

```sh
brew install pandoc
pandoc --version
```

The version command confirms that Pandoc is installed and available on your
`PATH`.

## Build

Add Markdown posts with `title` and `date` YAML front matter under `content/`,
then build the site:

```sh
make build
```

The generated home page and post pages are written to `public/`. Remove the
generated site with:

```sh
make clean
```

Pandoc reports an error if a post is missing its required metadata. Optional
`tags` metadata is displayed on the post page.

## Preview

Build the site and serve it locally with Python 3:

```sh
make serve
```

The target attempts to open `http://127.0.0.1:8000` in your browser, using
`open` or the `xdg-open` fallback. If neither can launch a browser, it prints
the URL for you to open manually. The server runs in the foreground; press
Ctrl-C to stop it. This target requires Pandoc to build the site and Python 3
to serve it.

## Design Notes

The project favors transparent shell and Make rules over a framework. In
particular, the build should fail clearly when its converter is missing,
escape content safely when placing it into HTML, and avoid shell or utility
extensions that make the script unnecessarily platform-specific.