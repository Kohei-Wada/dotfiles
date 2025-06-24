#!/usr/bin/env bash

echo "Setting up pre-commit hooks..."
yadm enter <<'EOF'
if command -v pre-commit >/dev/null 2>&1; then
  pre-commit install
fi
EOF
echo "Pre-commit hooks setup complete."
