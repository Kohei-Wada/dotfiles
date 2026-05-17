#!/bin/bash
#shellcheck disable=SC1090
#shellcheck disable=SC1091

_log_info "Setting up Claude Code helpers..."

if ! _is_command_available 'claude'; then
    _log_warn "claude not found. Skipping Claude Code helpers."
    return 0
fi

_claude_is_wsl() {
    [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qi microsoft /proc/version 2>/dev/null
}

# Wraps `claude` with systemd-inhibit so the laptop won't suspend while a
# Remote Control session is running. Inhibit is released when claude exits.
# WSL is a no-op (systemd-inhibit can't reach the Windows host sleep state).
# See vault: claude-code-prevent-suspend-rc.md
claude() {
    # `type -P` bypasses this function/alias and returns the real binary path.
    # systemd-inhibit runs without a shell, so the `command` builtin can't be
    # used — we need an absolute path.
    local claude_bin
    claude_bin=$(type -P claude)
    if [[ -z "$claude_bin" ]]; then
        _log_error "claude binary not found in PATH"
        return 127
    fi

    if _claude_is_wsl; then
        _log_warn "WSL detected: systemd-inhibit does not affect Windows suspend. Running plain claude."
        "$claude_bin" "$@"
        return
    fi

    if _is_command_available 'systemd-inhibit'; then
        systemd-inhibit \
            --what=idle:sleep:handle-lid-switch \
            --who="claude-code" \
            --why="Claude Code session (prevent suspend during RC)" \
            --mode=block \
            "$claude_bin" "$@"
    else
        "$claude_bin" "$@"
    fi
}

_log_ok "Claude Code helpers set up successfully."
