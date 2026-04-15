#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$BASE_DIR/lib/common.sh"
require_root

section "Upgrading"

run_cmd "apt-get upgrade"

success "System upgraded."

