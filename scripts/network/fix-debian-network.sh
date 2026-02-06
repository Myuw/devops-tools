#!/bin/bash
set -e

echo "[+] Stopping and disabling legacy networking.service..."
systemctl stop networking || true
systemctl disable networking || true

echo "[+] Creating systemd-networkd configuration..."
mkdir -p /etc/systemd/network

cat > /etc/systemd/network/10-eth0.network <<'EOF'
[Match]
Name=eth0

[Network]
DHCP=yes
EOF

echo "[+] Enabling and restarting systemd-networkd..."
systemctl enable systemd-networkd
systemctl restart systemd-networkd

# Optional: Clean up legacy ifupdown (uncomment if sure)
# echo "[+] Removing ifupdown..."
# apt purge -y ifupdown

echo "[+] Showing systemd-networkd status:"
systemctl status systemd-networkd --no-pager

echo "[+] Showing current IP addresses:"
ip a

echo "[✓] Network setup complete. No reboot required."
