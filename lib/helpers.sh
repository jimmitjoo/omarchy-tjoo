#!/bin/bash
# Omarchy helper functions
# Source this file in scripts: source "$OMARCHY_PATH/lib/helpers.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo -e "${BLUE}ℹ${NC} $*"
}

log_success() {
  echo -e "${GREEN}✓${NC} $*"
}

log_warning() {
  echo -e "${YELLOW}⚠${NC} $*"
}

log_error() {
  echo -e "${RED}✗${NC} $*" >&2
}

# Check if a command exists
require_command() {
  local cmd="$1"
  local package="${2:-$cmd}"
  if ! command -v "$cmd" &>/dev/null; then
    log_error "$cmd is not installed. Install with: paru -S $package"
    return 1
  fi
}

# Check multiple commands
require_commands() {
  local missing=()
  for cmd in "$@"; do
    if ! command -v "$cmd" &>/dev/null; then
      missing+=("$cmd")
    fi
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    log_error "Missing commands: ${missing[*]}"
    return 1
  fi
}

# Install icon to hicolor theme directories
install_icon() {
  local app="$1"
  local source_dir="${2:-$OMARCHY_PATH/applications/icons}"
  local dest_base="$HOME/.local/share/icons/hicolor"

  [[ -f "$source_dir/$app.png" ]] || return 0

  for size in 128x128 256x256; do
    local dest="$dest_base/$size/apps"
    mkdir -p "$dest"
    cp "$source_dir/$app.png" "$dest/" 2>/dev/null || true
  done
  log_success "Installed icon: $app"
}

# Hide application from launcher
hide_app() {
  local app="$1"
  local desktop_file="$HOME/.local/share/applications/$app.desktop"

  cat > "$desktop_file" << EOF
[Desktop Entry]
Hidden=true
EOF
  log_success "Hidden app: $app"
}

# Create .desktop file with Swedish name
create_desktop_entry() {
  local app="$1"
  local name_sv="$2"
  local exec_cmd="$3"
  local icon="${4:-$app}"
  local desktop_file="$HOME/.local/share/applications/$app.desktop"

  cat > "$desktop_file" << EOF
[Desktop Entry]
Name=$name_sv
Exec=$exec_cmd
Icon=$icon
Type=Application
Categories=Utility;
EOF
  log_success "Created desktop entry: $name_sv"
}

# Backup a file before modifying
backup_file() {
  local file="$1"
  local backup="${file}.bak.$(date +%Y%m%d_%H%M%S)"

  if [[ -f "$file" ]]; then
    cp "$file" "$backup"
    log_info "Backed up: $file → $backup"
  fi
}

# Check if running in Hyprland
is_hyprland() {
  [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]
}

# Check if running in Wayland
is_wayland() {
  [[ -n "${WAYLAND_DISPLAY:-}" ]]
}

# Restart a service safely
restart_service() {
  local service="$1"
  if pgrep -x "$service" &>/dev/null; then
    pkill -x "$service"
    sleep 0.5
  fi
  "$service" &>/dev/null &
  disown
  log_success "Restarted: $service"
}

# Notify user (works in both terminal and GUI)
notify() {
  local title="$1"
  local message="${2:-}"

  if command -v notify-send &>/dev/null && is_wayland; then
    notify-send "$title" "$message"
  else
    log_info "$title: $message"
  fi
}

# Confirm action (returns 0 for yes, 1 for no)
confirm() {
  local prompt="${1:-Continue?}"
  read -rp "$prompt [y/N] " response
  [[ "$response" =~ ^[Yy]$ ]]
}
