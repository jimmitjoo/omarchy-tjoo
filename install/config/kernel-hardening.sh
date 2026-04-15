#!/bin/bash
# Apply kernel hardening via sysctl

SYSCTL_CONF="/etc/sysctl.d/99-security-hardening.conf"

if [ ! -f "$SYSCTL_CONF" ]; then
    echo "Applying kernel security hardening..."

    sudo tee "$SYSCTL_CONF" > /dev/null << 'EOF'
# Kernel hardening parameters

# Restrict access to kernel logs
kernel.dmesg_restrict = 1

# Hide kernel pointers from unprivileged users
kernel.kptr_restrict = 2

# Disable kexec (prevents loading new kernels)
kernel.kexec_load_disabled = 1

# Restrict access to BPF for unprivileged users
kernel.unprivileged_bpf_disabled = 1

# Restrict ptrace to processes with same UID (safer than 2 for compatibility)
kernel.yama.ptrace_scope = 1

# Enable address space layout randomization
kernel.randomize_va_space = 2

# Restrict loading of TTY line disciplines
dev.tty.ldisc_autoload = 0

# Network hardening
# Enable reverse path filtering (anti-spoofing)
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

# Do not send ICMP redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Ignore ICMP broadcasts
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Ignore bogus ICMP error responses
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Enable TCP SYN cookies (SYN flood protection)
net.ipv4.tcp_syncookies = 1

# Disable IPv6 router advertisements
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.default.accept_ra = 0

# Filesystem hardening
# Protect hardlinks and symlinks
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
fs.protected_fifos = 2
fs.protected_regular = 2

# Memory protection
vm.mmap_min_addr = 65536

# Keep existing Omarchy setting
net.ipv4.tcp_mtu_probing = 1
EOF

    # Apply settings immediately
    sudo sysctl --system >/dev/null 2>&1

    echo "✓ Kernel security hardening applied"
else
    echo "✓ Kernel security hardening already configured"
fi
