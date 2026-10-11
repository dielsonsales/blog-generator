#!/bin/sh
set -eu

LC_ALL=C
export LC_ALL

if ! command -v pandoc >/dev/null 2>&1; then
    printf '%s\n' 'Error: Pandoc is required to build the site. Install it with: brew install pandoc' >&2
    exit 1
fi

if [ ! -d content ]; then
    printf '%s\n' 'Error: content directory not found.' >&2
    exit 1
fi

if [ ! -f config.yaml ]; then
    printf '%s\n' 'Error: config.yaml not found. Create it with a site-name setting.' >&2
    exit 1
fi

rm -rf public
mkdir -p public
if ! cp templates/site.css public/site.css; then
    printf '%s\n' 'Error: unable to copy templates/site.css to public/site.css.' >&2
    exit 1
fi
if [ -d content/images ]; then
    if ! cp -R content/images public/; then
        printf '%s\n' 'Error: unable to copy content/images to public/images.' >&2
        exit 1
    fi
fi
if ! printf '%s\n' '' | pandoc \
    --from=markdown \
    --to=html5 \
    --standalone \
    --template=templates/index-header.html \
    --metadata-file=config.yaml \
    --output=public/index.html; then
    printf '%s\n' 'Error: unable to render templates/index-header.html.' >&2
    exit 1
fi

set -- content/*.md
if [ ! -f "$1" ]; then
    cat templates/index-empty.html >> public/index.html
else
    for post in "$@"; do
        [ -f "$post" ] || continue

        filename=${post##*/}
        slug=${filename%.md}
        case "$slug" in
            ''|*[!A-Za-z0-9._-]*)
                printf 'Error: post filename must use only letters, numbers, dots, underscores, or hyphens: %s\n' "$post" >&2
                exit 1
                ;;
        esac

        printf 'Building %s\n' "$post"
        pandoc \
            --from=markdown \
            --to=html5 \
            --standalone \
            --template=templates/post.html \
            --metadata-file=config.yaml \
            --lua-filter=filters/validate-metadata.lua \
            --output="public/$slug.html" \
            "$post"

        pandoc \
            --from=markdown \
            --to=html5 \
            --standalone \
            --template=templates/index-entry.html \
            --metadata-file=config.yaml \
            --lua-filter=filters/validate-metadata.lua \
            --variable="slug:$slug" \
            --output=- \
            "$post" >> public/index.html
    done
fi

cat templates/index-footer.html >> public/index.html
printf '%s\n' 'Build complete: public/'