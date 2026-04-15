#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$BASE_DIR/lib/common.sh"
require_root

FILE="$(dirname "${BASH_SOURCE[0]}")/packages.txt"

section "Installing Base Packages"

run_cmd "apt-get update -y"

while read -r pkg; do
    [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue

    if is_installed "$pkg"; then
        warn "$pkg already installed."
    else
        info "Installing $pkg..."
        run_cmd "apt-get install -y $pkg"
        success "$pkg installed."
    fi
done < "$FILE"

