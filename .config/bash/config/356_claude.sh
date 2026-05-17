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

# claude: systemd-inhibit で suspend / idle / lid-close を block しつつ起動する wrapper。
# Remote Control 中に notePC が suspend してセッションが切れるのを防ぐ。
# claude 終了で inhibit は自動 release。詳細は vault: claude-code-prevent-suspend-rc.md
#
# WSL では systemd-inhibit が Windows ホストのスリープを抑止できないので no-op になる。
# WSL 用に Windows 側へ SetThreadExecutionState を投げる方式は vault note 参照。
claude() {
    if _claude_is_wsl; then
        _log_warn "WSL detected: systemd-inhibit does not affect Windows suspend. Running plain claude."
        command claude "$@"
        return
    fi

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
