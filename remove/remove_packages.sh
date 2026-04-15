#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$BASE_DIR/lib/common.sh"
require_root

FILE="$(dirname "${BASH_SOURCE[0]}")/packages.txt"

section "Removing Unwanted Packages"

while read -r pkg; do
    [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue

    if is_installed "$pkg"; then
        info "Removing $pkg..."
        run_cmd "apt-get purge -y $pkg"
        success "$pkg removed."
    else
        warn "$pkg already removed."
    fi
done < "$FILE"

run_cmd "apt-get autoremove -y"
run_cmd "apt-get autoclean -y"

success "Removal complete."

