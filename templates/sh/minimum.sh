#!/bin/bash

set -euo pipefail

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
}

error() {
    log "ERROR: $*"
    exit 1
}

main() {
    # This is a minimal shell script template.
    log "Starting the script..."
}

main "$@"
