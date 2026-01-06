#!/bin/zsh
# shellcheck disable=SC1090,SC1091

# 000-100 - General
# 100-199 - libraries
# 200-250 - cloud
# 251-299 - languages
# 300-399 - tools
# 900-999 - custom

BASE_DIR="$HOME/.config/zsh"
for file in "$BASE_DIR"/config/*.{sh,zsh}(N); do
    if ! source "$file"; then
        echo "Error: Failed to load configuration file: $file" >&2
        return 1
    fi
done
_log_ok "Zsh configuration files loaded successfully."
