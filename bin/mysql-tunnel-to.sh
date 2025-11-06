#!/bin/bash

readonly LOCAL_PORT=3306
readonly REMOTE_PORT=3306

choose_remote_host() {
    grep -H -R '^Host' ~/.ssh 2>/dev/null |
        awk '{ print $2 }' |
        grep -v '\*' |
        fzf --prompt="Select remote host for MySQL tunnel: "
}

confirm() {
    read -r -p "${1:-Are you sure? [y/N]} " response
    [[ "$response" =~ ^[Yy]$ ]]
}

main() {
    local remote_host="$1"

    if [ -z "$remote_host" ]; then

        remote_host=$(choose_remote_host)
        if [ -z "$remote_host" ]; then
            echo "No remote host selected. Exiting."
            exit 1
        fi
    fi

    echo "--------------------------------------------------"
    echo " Setting up MySQL tunnel:"
    echo "   Remote host : $remote_host"
    echo "   Local port  : $LOCAL_PORT"
    echo "   Remote port : $REMOTE_PORT"
    echo "--------------------------------------------------"

    if ! confirm "Proceed with setting up the tunnel? [y/N] "; then
        echo "Cancelled."
        exit 0
    fi

    echo "Connecting to $remote_host..."
    if ! ssh -q -o BatchMode=yes -o ConnectTimeout=5 "$remote_host" exit 0 2>/dev/null; then
        echo "Connection failed to $remote_host."
        exit 1
    fi

    echo "SSH connection established. Tunnel is now active."
    echo "Press Ctrl+C to close the tunnel."
    echo "--------------------------------------------------"
    trap 'echo; echo "Tunnel closed. Goodbye."; exit 0' INT

    ssh -N -L ${LOCAL_PORT}:localhost:${REMOTE_PORT} "$remote_host"
}

main "$@"
