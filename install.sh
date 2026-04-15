#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect dry-run
if [[ "${1:-}" == "--dry-run" ]]; then
    export DRY_RUN_MODE=true
fi

source "$BASE_DIR/lib/common.sh"
require_root

section "Linux Mint 22.2 Cinnamon Setup"

run_script() {
    local script="$1"

    if [[ -f "$script" ]]; then
        info "Running $(basename "$script")..."
        if $DRY_RUN; then
            bash "$script" --dry-run
        else
            bash "$script"
        fi
        success "$(basename "$script") completed."
    else
        warn "$(basename "$script") not found."
    fi
}

# Run scripts in order
run_script "$BASE_DIR/install/install_packages.sh"
run_script "$BASE_DIR/repos/brave.sh"
run_script "$BASE_DIR/repos/protonvpn.sh"
run_script "$BASE_DIR/security/ufw.sh"
run_script "$BASE_DIR/remove/remove_packages.sh"
run_script "$BASE_DIR/system/upgrade.sh"
run_script "$BASE_DIR/system/cleanup.sh"

success "All tasks completed."
info "Restart required!"

