#!/bin/bash
# shellcheck disable=SC2155

# Obsidian vault path — consumed by the knowledge-gardener Claude Code plugin
# (https://github.com/Kohei-Wada/knowledge-gardener) and any other tool that
# wants to locate the user's primary markdown knowledge base.
export OBSIDIAN_VAULT="$HOME/ghq/github.com/Kohei-Wada/Obsidian/vault"
