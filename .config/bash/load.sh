#!/bin/bash
# shellcheck disable=SC1090,SC1091

# 000-199 - General (library)
# 200-250 - cloud
# 251-299 - languages
# 300-399 - tools
# 900-999 - custom

BASE_DIR="$HOME/.config/bash"
for file in $(find "$BASE_DIR/config" -type f -name "*.sh" | sort); do
    source "$file"
done
_log_ok "Bash configuration files loaded successfully."
