#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="${LOG_FILE:-./ram_usage.log}"

get_ram_usage() {
    free -m | awk '/^Mem:/ {
        printf "TOTAL=%sMB USED=%sMB FREE=%sMB", $2, $3, $4
    }'
}

log_entry() {
    printf "%s | %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$(get_ram_usage)"
}

log_entry >> "$LOG_FILE"
