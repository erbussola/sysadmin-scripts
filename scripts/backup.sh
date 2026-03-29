#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/backup"
SOURCE="/home"
RETENTION=7
LOG_FILE="/var/log/backup.log"

mkdir -p "$BACKUP_DIR"

log() {
    echo "[$(date '+%F %T')] $1" | tee -a "$LOG_FILE"
}

TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz"

log "Backup started"

tar -czf "$BACKUP_FILE" -C / home

log "Backup completed: $BACKUP_FILE"

log "Applying rotation (keep $RETENTION)"

find "$BACKUP_DIR" -type f -name "backup_*.tar.gz" -printf "%T@ %p\n" \
| sort -nr \
| awk "NR>$RETENTION {print \$2}" \
| xargs -r rm -f

log "Rotation completed"
