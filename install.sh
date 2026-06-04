#!/bin/bash
set -e
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ]; then
  URL=https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64
elif [ "$ARCH" = "armv7l" ] || [ "$ARCH" = "armv6l" ]; then
  URL=https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm
else
  URL=https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
fi
echo "Arch: $ARCH, downloading..."
curl -fsSL $URL -o /usr/local/bin/cloudflared
chmod +x /usr/local/bin/cloudflared
# Stop eventueel bestaande instantie
pkill cloudflared 2>/dev/null || true
# Start tunnel als achtergrondproces
nohup /usr/local/bin/cloudflared tunnel --no-autoupdate run --token eyJhIjoiNzAxOTkyNTMzZjg3OGVjMTliMGRiNmFlNWQ4MmMzMjciLCJ0IjoiMGZlYzQ4MjgtN2RiMS00ZGIzLTljMzItY2ViZTUxOWVjZTRkIiwicyI6IjRkMjY4MjRlNTEwYmU4YjUwOTI0Y2ExYzc4OGYzMzgzNjZmOTgxZTdlYzRhYjliNTIyNGNiODYwZjkxODI3ODUifQ== > /var/log/cloudflared.log 2>&1 &
echo "Tunnel gestart (PID: $!)"
# Voeg toe aan crontab voor herstart na reboot
(crontab -l 2>/dev/null | grep -v cloudflared; echo "@reboot nohup /usr/local/bin/cloudflared tunnel --no-autoupdate run --token eyJhIjoiNzAxOTkyNTMzZjg3OGVjMTliMGRiNmFlNWQ4MmMzMjciLCJ0IjoiMGZlYzQ4MjgtN2RiMS00ZGIzLTljMzItY2ViZTUxOWVjZTRkIiwicyI6IjRkMjY4MjRlNTEwYmU4YjUwOTI0Y2ExYzc4OGYzMzgzNjZmOTgxZTdlYzRhYjliNTIyNGNiODYwZjkxODI3ODUifQ== > /var/log/cloudflared.log 2>&1 &") | crontab -
echo "Crontab ingesteld voor automatisch herstarten"
sleep 3
if pgrep cloudflared > /dev/null; then
  echo "✅ Tunnel draait!"
else
  echo "❌ Tunnel start mislukt, check /var/log/cloudflared.log"
fi
