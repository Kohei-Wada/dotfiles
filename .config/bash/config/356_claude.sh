#!/bin/bash
#shellcheck disable=SC1090
#shellcheck disable=SC1091

_log_info "Setting up Claude Code helpers..."

if ! _is_command_available 'claude'; then
    _log_warn "claude not found. Skipping Claude Code helpers."
    return 0
fi

if ! _is_command_available 'systemd-inhibit'; then
    _log_warn "systemd-inhibit not found. claude wrapper will fall back to plain claude."
fi

# claude: systemd-inhibit でラップし、起動中 suspend / idle / lid-close を block。
# Remote Control 中に notePC が suspend してセッションが切れるのを防ぐ。
# claude 終了で inhibit は自動 release。詳細は vault: claude-code-prevent-suspend-rc.md
claude() {
    if _is_command_available 'systemd-inhibit'; then
        systemd-inhibit \
            --what=idle:sleep:handle-lid-switch \
            --who="claude-code" \
            --why="Claude Code session (prevent suspend during RC)" \
            --mode=block \
            command claude "$@"
    else
        command claude "$@"
    fi
}

_log_ok "Claude Code helpers set up successfully."
