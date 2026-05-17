#!/bin/bash
#shellcheck disable=SC1090
#shellcheck disable=SC1091

_log_info "Setting up Claude Code helpers..."

if ! _is_command_available 'claude'; then
    _log_warn "claude not found. Skipping Claude Code helpers."
    return 0
fi

if ! _is_command_available 'systemd-inhibit'; then
    _log_warn "systemd-inhibit not found. claude-rc will fall back to plain claude."
fi

# claude-rc: Claude Code を Remote Control 用に起動するラッパー。
# systemd-inhibit で suspend / idle / lid-close を block し、claude 終了で自動 release。
# 詳細は vault note: claude-code-prevent-suspend-rc.md
claude-rc() {
    if _is_command_available 'systemd-inhibit'; then
        systemd-inhibit \
            --what=idle:sleep:handle-lid-switch \
            --who="claude-code" \
            --why="Claude Code Remote Control session" \
            --mode=block \
            claude "$@"
    else
        command claude "$@"
    fi
}

_log_ok "Claude Code helpers set up successfully."
