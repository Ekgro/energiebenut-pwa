#!/bin/bash
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ]; then
  URL=https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64
elif [ "$ARCH" = "armv7l" ] || [ "$ARCH" = "armv6l" ]; then
  URL=https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm
else
  URL=https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
fi
echo "Arch: $ARCH, downloading cloudflared..."
curl -fsSL $URL -o /usr/local/bin/cloudflared
chmod +x /usr/local/bin/cloudflared
pkill cloudflared 2>/dev/null || true
nohup /usr/local/bin/cloudflared tunnel --no-autoupdate run --token eyJhIjoiNzAxOTkyNTMzZjg3OGVjMTliMGRiNmFlNWQ4MmMzMjciLCJ0IjoiMGZlYzQ4MjgtN2RiMS00ZGIzLTljMzItY2ViZTUxOWVjZTRkIiwicyI6IjRkMjY4MjRlNTEwYmU4YjUwOTI0Y2ExYzc4OGYzMzgzNjZmOTgxZTdlYzRhYjliNTIyNGNiODYwZjkxODI3ODUifQ== > /var/log/cloudflared.log 2>&1 &
echo "Tunnel gestart (PID: $!)"
(crontab -l 2>/dev/null | grep -v cloudflared; echo "@reboot nohup /usr/local/bin/cloudflared tunnel --no-autoupdate run --token eyJhIjoiNzAxOTkyNTMzZjg3OGVjMTliMGRiNmFlNWQ4MmMzMjciLCJ0IjoiMGZlYzQ4MjgtN2RiMS00ZGIzLTljMzItY2ViZTUxOWVjZTRkIiwicyI6IjRkMjY4MjRlNTEwYmU4YjUwOTI0Y2ExYzc4OGYzMzgzNjZmOTgxZTdlYzRhYjliNTIyNGNiODYwZjkxODI3ODUifQ== > /var/log/cloudflared.log 2>&1 &") | crontab -
# Fix HA config voor reverse proxy
CFG=/config/configuration.yaml
if [ -f "$CFG" ] && ! grep -q "use_x_forwarded_for" "$CFG"; then
  printf "\nhttp:\n  use_x_forwarded_for: true\n  trusted_proxies:\n    - 127.0.0.1\n    - ::1\n" >> "$CFG"
  echo "HA config bijgewerkt, herstart HA..."
  pkill -f "homeassistant" 2>/dev/null || true
else
  echo "HA config al correct of niet gevonden"
fi
sleep 3
pgrep cloudflared > /dev/null && echo "Tunnel draait!" || echo "Tunnel fout, check /var/log/cloudflared.log"
