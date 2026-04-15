#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$BASE_DIR/lib/common.sh"
require_root

section "Final Cleanup"

run_cmd "apt-get autoremove -y"
run_cmd "apt-get autoclean -y"

success "System cleaned."

