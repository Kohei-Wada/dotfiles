#!/bin/bash

set -euo pipefail

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
}

error() {
    log "ERROR: $*"
    exit 1
}

help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help      Show this help message"
    echo "  -v, --version   Show version information"
    echo "  -a, --another-option  Another option description"
}

main() {

    # template
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                help
                exit 0
                ;;
            -v|--version)
                echo "Version 1.0.0"
                exit 0
                ;;
            -a|--another-option)
                # Handle another option
                ;;
            *)
                error "Unknown option: $1"
                ;;
        esac
        shift
    done

    # Main script logic goes here
    log "Script executed successfully."
}

main "$@"
