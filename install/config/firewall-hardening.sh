#!/bin/bash
# Harden UFW firewall configuration

# Ensure UFW is installed and enabled
if command -v ufw >/dev/null 2>&1; then
    echo "Hardening UFW firewall configuration..."

    # Enable UFW if not already enabled
    sudo ufw --force enable >/dev/null 2>&1

    # Set default policies
    sudo ufw default deny incoming >/dev/null 2>&1
    sudo ufw default allow outgoing >/dev/null 2>&1

    # Enable logging at medium level
    sudo ufw logging medium >/dev/null 2>&1

    # Reload to apply changes
    sudo ufw reload >/dev/null 2>&1

    echo "✓ UFW firewall hardened (deny incoming, allow outgoing, logging enabled)"
else
    echo "⚠ UFW not installed, skipping firewall hardening"
fi
