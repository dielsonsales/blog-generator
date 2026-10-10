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

rm -rf public
mkdir -p public
cat templates/index-header.html > public/index.html

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
            --lua-filter=filters/validate-metadata.lua \
            --output="public/$slug.html" \
            "$post"

        pandoc \
            --from=markdown \
            --to=html5 \
            --standalone \
            --template=templates/index-entry.html \
            --lua-filter=filters/validate-metadata.lua \
            --variable="slug:$slug" \
            --output=- \
            "$post" >> public/index.html
    done
fi

cat templates/index-footer.html >> public/index.html
printf '%s\n' 'Build complete: public/'