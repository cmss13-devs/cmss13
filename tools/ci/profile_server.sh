#!/usr/bin/env bash
set -euo pipefail

OUTPUT_CSV="${1:-startup.csv}"
OUTPUT_TRACY="startup.tracy"
TRACY_PORT="${TRACY_PORT:-8086}"

DMB="${DMB_PATH:-$(find . -maxdepth 1 -name "*.dmb" | head -n1)}"
[[ -z "$DMB" || ! -f "$DMB" ]] && { echo "ERROR: No .dmb found." >&2; exit 1; }

_find_tool() {
    if [[ -x "./$1" ]]; then echo "./$1"
    elif command -v "$1" &>/dev/null; then echo "$1"
    else echo "ERROR: '$1' not found" >&2; exit 1; fi
}
TRACY_CAPTURE="$(_find_tool tracy-capture)"
TRACY_CSVEXPORT="$(_find_tool tracy-csvexport)"
DREAM_DAEMON="$(_find_tool DreamDaemon)"

BYOND_TRACY_LIB="${BYOND_TRACY_LIB:-./libprof.so}"
[[ ! -f "$BYOND_TRACY_LIB" ]] && { echo "ERROR: byond-tracy library not found at '$BYOND_TRACY_LIB'" >&2; exit 1; }

(
    "$TRACY_CAPTURE" -o "$OUTPUT_TRACY" -f -a 127.0.0.1 -p "$TRACY_PORT" 2>/dev/null || true
    "$TRACY_CAPTURE" -o "$OUTPUT_TRACY" -f -a 127.0.0.1 -p "$TRACY_PORT" 2>/dev/null || true
) &

"$DREAM_DAEMON" "$DMB" -trusted -invisible &

wait

[[ ! -f "$OUTPUT_TRACY" ]] && { echo "ERROR: Tracy capture file not created." >&2; exit 1; }

"$TRACY_CSVEXPORT" "$OUTPUT_TRACY" > "$OUTPUT_CSV"

echo "--- Zone timing summary (top 20 by total time) ---"
if command -v awk &>/dev/null; then
    awk -F',' 'NR==1 { print; next } { print | "sort -t, -k4 -rn" }' "$OUTPUT_CSV" \
        | head -n 21 \
        | awk -F',' 'NR==1 { printf "%-60s %12s %8s %12s\n", "Zone", "Total(ms)", "Count", "Mean(µs)" }
                     NR>1  { printf "%-60s %12.3f %8s %12.3f\n", $1, $4/1e6, $6, $7/1e3 }'
fi
