# Plain-Text Static Blog

A lightweight, transparent static blog generator. Write in Markdown, publish
simple HTML, and maintain full control over your site.

## 🚀 Quick Start

1. **Install Dependencies:**
   - **macOS:** `brew install pandoc`
   - **Linux:** `sudo apt install pandoc`
2. **Build the site:** `make build`
3. **Preview locally:** `make serve`

## ✨ Features
- [x] Markdown to HTML conversion via Pandoc.
- [x] Lightweight `Makefile` based build system.
- [x] Local preview server.
- [ ] Custom CSS themes (Planned).
- [ ] RSS feed generation (Planned).

## 🛠️ Prerequisites

- **Pandoc**: The core engine for Markdown conversion.
- **Make**: For automating the build process.
- **Python 3**: Required for the local preview server.

## 📂 Project Structure

```text
content/          Markdown source posts
content/images/   Post images (copied to public/images/)
templates/        Shared HTML page fragments
public/           Generated site output
config.yaml       Local site settings (ignored by Git)
build.sh          Site generation script
serve.sh          Local preview server and browser launcher
Makefile          Build, clean, and local preview targets
```

## 📖 Usage

### Building
Add posts with YAML front matter (`title` and `date`) under `content/`, then
build the site:

```sh
make build
```

The generated home page and post pages are written to `public/`. Any images in
`content/images/` that a post references are copied to `public/images/` during
the build. To remove the generated site, run:

```sh
make clean
```

Pandoc reports an error if a post is missing its required metadata. Optional
`tags` metadata is displayed on the post page.

### Previewing
Build the site and serve it locally with Python 3:

```sh
make serve
```

The target attempts to open `http://127.0.0.1:8000` in your browser. The server
runs in the foreground; press `Ctrl+C` to stop it.

## 🤝 Contributing

Contributions are welcome! If you find a bug or have a feature suggestion,
please open an issue.

## 📄 License

This project is licensed under the [LICENSE](LICENSE) file.