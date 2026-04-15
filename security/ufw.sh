#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$BASE_DIR/lib/common.sh"
require_root

section "Configuring UFW"

if ! is_installed ufw; then
    run_cmd "apt-get install -y ufw"
fi

run_cmd "ufw default deny incoming"
run_cmd "ufw default allow outgoing"
run_cmd "ufw --force enable"

success "UFW configured."

