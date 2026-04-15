#!/bin/bash
# Configure snapper retention policy

if ! command -v snapper &>/dev/null; then
    echo "⚠ Snapper not installed, skipping retention configuration"
    exit 0
fi

echo "Configuring snapper retention policy..."

# Configure root snapshots
if sudo snapper list-configs 2>/dev/null | grep -q "root"; then
    sudo snapper -c root set-config "NUMBER_CLEANUP=yes" 2>/dev/null || true
    sudo snapper -c root set-config "NUMBER_MIN_AGE=1800" 2>/dev/null || true      # Keep snapshots at least 30 min
    sudo snapper -c root set-config "NUMBER_LIMIT=10" 2>/dev/null || true          # Keep last 10 snapshots
    sudo snapper -c root set-config "NUMBER_LIMIT_IMPORTANT=5" 2>/dev/null || true # Keep 5 important ones

    sudo snapper -c root set-config "TIMELINE_CREATE=yes" 2>/dev/null || true
    sudo snapper -c root set-config "TIMELINE_CLEANUP=yes" 2>/dev/null || true
    sudo snapper -c root set-config "TIMELINE_MIN_AGE=1800" 2>/dev/null || true
    sudo snapper -c root set-config "TIMELINE_LIMIT_HOURLY=5" 2>/dev/null || true
    sudo snapper -c root set-config "TIMELINE_LIMIT_DAILY=7" 2>/dev/null || true
    sudo snapper -c root set-config "TIMELINE_LIMIT_WEEKLY=0" 2>/dev/null || true
    sudo snapper -c root set-config "TIMELINE_LIMIT_MONTHLY=0" 2>/dev/null || true
    sudo snapper -c root set-config "TIMELINE_LIMIT_YEARLY=0" 2>/dev/null || true

    echo "✓ Configured 'root' retention policy"
fi

# Configure home snapshots
if sudo snapper list-configs 2>/dev/null | grep -q "home"; then
    sudo snapper -c home set-config "NUMBER_CLEANUP=yes" 2>/dev/null || true
    sudo snapper -c home set-config "NUMBER_MIN_AGE=1800" 2>/dev/null || true
    sudo snapper -c home set-config "NUMBER_LIMIT=10" 2>/dev/null || true
    sudo snapper -c home set-config "NUMBER_LIMIT_IMPORTANT=5" 2>/dev/null || true

    sudo snapper -c home set-config "TIMELINE_CREATE=yes" 2>/dev/null || true
    sudo snapper -c home set-config "TIMELINE_CLEANUP=yes" 2>/dev/null || true
    sudo snapper -c home set-config "TIMELINE_MIN_AGE=1800" 2>/dev/null || true
    sudo snapper -c home set-config "TIMELINE_LIMIT_HOURLY=5" 2>/dev/null || true
    sudo snapper -c home set-config "TIMELINE_LIMIT_DAILY=7" 2>/dev/null || true
    sudo snapper -c home set-config "TIMELINE_LIMIT_WEEKLY=0" 2>/dev/null || true
    sudo snapper -c home set-config "TIMELINE_LIMIT_MONTHLY=0" 2>/dev/null || true
    sudo snapper -c home set-config "TIMELINE_LIMIT_YEARLY=0" 2>/dev/null || true

    echo "✓ Configured 'home' retention policy"
fi

# Enable snapper timers
sudo systemctl enable --now snapper-timeline.timer 2>/dev/null || true
sudo systemctl enable --now snapper-cleanup.timer 2>/dev/null || true

echo "✓ Snapper retention policy configured (10 number snapshots, 7 daily, 5 hourly)"
