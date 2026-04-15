#!/usr/bin/env bash
[[ -n "$COMMON_LIB_LOADED" ]] && return
COMMON_LIB_LOADED=1

set -Eeuo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_FILE="$BASE_DIR/mint-setup.log"

# Redirect all output to log file + stdout
exec > >(tee -a "$LOG_FILE") 2>&1

# ========================
# Dry Run
# ========================
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]] || [[ "${DRY_RUN_MODE:-}" == "true" ]]; then
    DRY_RUN=true
fi

# ========================
# Colors
# ========================
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
RESET="\e[0m"

info()    { echo -e "${BLUE}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[OK]${RESET} $1"; }
warn()    { echo -e "${YELLOW}[SKIP]${RESET} $1"; }
error()   { echo -e "${RED}[ERROR]${RESET} $1"; }
section() { echo -e "\n${MAGENTA}========== $1 ==========${RESET}\n"; }

# ========================
# Error Trap
# ========================
trap 'error "Script failed at line $LINENO"; exit 1' ERR

# ========================
# Root Check
# ========================
require_root() {
    if [[ $EUID -ne 0 ]]; then
        error "Run with sudo."
        exit 1
    fi
}

# ========================
# Package Check
# ========================
is_installed() {
    dpkg -s "$1" &>/dev/null
}

# ========================
# Command Wrapper
# ========================
run_cmd() {
    if $DRY_RUN; then
        echo -e "${CYAN}[DRY-RUN]${RESET} $*"
    else
        eval "$@"
    fi
}

