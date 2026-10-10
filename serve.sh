#!/bin/sh
set -eu

url=http://127.0.0.1:8000

if [ ! -d public ]; then
    printf '%s\n' 'Error: public/ not found. Run make build first.' >&2
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    printf '%s\n' 'Error: Python 3 is required to serve the site.' >&2
    exit 1
fi

(
    cd public
    exec python3 -m http.server --bind 127.0.0.1 8000
) &
server_pid=$!

stop_server() {
    kill "$server_pid" 2>/dev/null || true
}

trap stop_server 0
trap 'exit 130' INT
trap 'exit 143' TERM

sleep 1
if ! kill -0 "$server_pid" 2>/dev/null; then
    wait "$server_pid" || exit $?
    printf '%s\n' 'Error: preview server stopped before it was ready.' >&2
    exit 1
fi

if command -v open >/dev/null 2>&1 && open "$url"; then
    :
elif command -v xdg-open >/dev/null 2>&1 && xdg-open "$url"; then
    :
else
    printf 'Could not open a browser automatically. Visit %s\n' "$url"
fi

wait "$server_pid"