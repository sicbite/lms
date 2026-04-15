#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$BASE_DIR/lib/common.sh"
require_root

section "Installing ProtonVPN GUI"

if is_installed proton-vpn-gnome-desktop; then
    warn "ProtonVPN already installed."
    exit 0
fi

KEYRING="/usr/share/keyrings/protonvpn-archive-keyring.gpg"
REPO_FILE="/etc/apt/sources.list.d/protonvpn-stable.list"

if [[ ! -f "$KEYRING" ]]; then
    info "Adding ProtonVPN GPG key..."
    run_cmd "curl -fsSL https://repo.protonvpn.com/debian/public_key.asc | gpg --dearmor -o $KEYRING"
    success "GPG key added."
else
    warn "ProtonVPN GPG key already exists."
fi

if [[ ! -f "$REPO_FILE" ]]; then
    info "Adding ProtonVPN repository..."
    run_cmd "echo 'deb [signed-by=$KEYRING] https://repo.protonvpn.com/debian stable main' > $REPO_FILE"
    success "Repository added."
else
    warn "ProtonVPN repository already exists."
fi

run_cmd "apt-get update -y"
run_cmd "apt-get install -y proton-vpn-gnome-desktop"

success "ProtonVPN GUI installed."

