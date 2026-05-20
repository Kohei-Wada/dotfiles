#!/bin/bash
# shellcheck disable=SC2155

# Markdown knowledge base path — consumed by the knowledge-gardener Claude
# Code plugin (https://github.com/Kohei-Wada/knowledge-gardener) and any
# other tool that wants to locate the user's primary markdown vault.
export KG_VAULT="$HOME/ghq/github.com/Kohei-Wada/Obsidian/vault"

# Opt in to knowledge-gardener's silent auto-recap on Claude Code's Stop hook.
# When set, every Stop event spawns headless `claude -p` to write today's
# session block into the daily note + git commit && git push the vault.
# Default-off in the plugin; we opt in here because this vault is solo.
# See docs/specs/2026-05-20-auto-recap-design.md in the plugin repo.
export KG_AUTO_RECAP=1
