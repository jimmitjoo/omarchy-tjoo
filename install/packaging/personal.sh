#!/bin/bash
set -euo pipefail

# Install personal packages from personal.packages
source "$OMARCHY_PATH/lib/helpers.sh"

PERSONAL_PACKAGES_FILE="$OMARCHY_PATH/install/personal.packages"

if [ ! -f "$PERSONAL_PACKAGES_FILE" ]; then
  log_info "No personal.packages file found, skipping..."
  exit 0
fi

log_info "Installing personal packages..."

installed=0
skipped=0

# Read packages from file, skip comments and empty lines
while IFS= read -r package || [ -n "$package" ]; do
  # Skip comments and empty lines
  [[ "$package" =~ ^#.*$ ]] && continue
  [[ -z "$package" ]] && continue

  # Install package if not already installed
  if ! pacman -Q "$package" &>/dev/null; then
    log_info "Installing $package..."
    if omarchy-pkg-add "$package"; then
      ((installed++))
    else
      log_warning "Failed to install: $package"
    fi
  else
    ((skipped++))
  fi
done < "$PERSONAL_PACKAGES_FILE"

log_success "Personal packages: $installed installed, $skipped already present"
