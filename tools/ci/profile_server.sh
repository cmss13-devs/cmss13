#!/usr/bin/env bash
set -euo pipefail

OUTPUT_CSV="${1:-startup.csv}"
OUTPUT_TRACY="${2:-startup.tracy}"
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
	# we need to capture twice - tracy-capture, if it hooks as soon as byond-tracy is ready, captures 3 frames then disconnects
    "$TRACY_CAPTURE" -o "$OUTPUT_TRACY" -f -a 127.0.0.1 -p "$TRACY_PORT" 2>/dev/null || true
    "$TRACY_CAPTURE" -o "$OUTPUT_TRACY" -f -a 127.0.0.1 -p "$TRACY_PORT" 2>/dev/null || true
) &

UTRACY_BIND_PORT="$TRACY_PORT" "$DREAM_DAEMON" "$DMB" -trusted -invisible -map-threads 0 &

wait

[[ ! -f "$OUTPUT_TRACY" ]] && { echo "ERROR: Tracy capture file not created." >&2; exit 1; }

# export total (inclusive) and self (exclusive) time, then merge into one CSV
TOTAL_TMP="$(mktemp)"
SELF_TMP="$(mktemp)"
"$TRACY_CSVEXPORT"    "$OUTPUT_TRACY" > "$TOTAL_TMP"
"$TRACY_CSVEXPORT" -e "$OUTPUT_TRACY" > "$SELF_TMP"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 "$SCRIPT_DIR/profile_merge.py" "$TOTAL_TMP" "$SELF_TMP" "$OUTPUT_CSV"

rm "$TOTAL_TMP" "$SELF_TMP"

echo "--- Zone timing summary (top 20 by total time) ---"
awk -F',' 'NR==1 { print; next } { print | "sort -t, -k4 -rn" }' "$OUTPUT_CSV" \
    | head -n 21 \
    | awk -F',' 'NR==1 { printf "%-60s %12s %12s %8s\n", "Zone", "Total(ms)", "Self(ms)", "Count" }
                 NR>1  { printf "%-60s %12.3f %12.3f %8s\n", $1, $4/1e6, $7/1e6, $6 }'
