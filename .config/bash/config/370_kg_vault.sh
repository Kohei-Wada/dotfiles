#!/bin/bash
# shellcheck disable=SC2155

# Markdown knowledge base path — consumed by the knowledge-gardener Claude
# Code plugin (https://github.com/Kohei-Wada/knowledge-gardener) and any
# other tool that wants to locate the user's primary markdown vault.
export KG_VAULT="$HOME/ghq/github.com/Kohei-Wada/Obsidian/vault"
