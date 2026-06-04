#!/bin/bash
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ]; then
  URL=https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64
elif [ "$ARCH" = "armv7l" ] || [ "$ARCH" = "armv6l" ]; then
  URL=https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm
else
  URL=https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
fi
echo "Arch: $ARCH"
curl -fsSL $URL -o /tmp/cf
chmod +x /tmp/cf
/tmp/cf service install eyJhIjoiNzAxOTkyNTMzZjg3OGVjMTliMGRiNmFlNWQ4MmMzMjciLCJ0IjoiMGZlYzQ4MjgtN2RiMS00ZGIzLTljMzItY2ViZTUxOWVjZTRkIiwicyI6IjRkMjY4MjRlNTEwYmU4YjUwOTI0Y2ExYzc4OGYzMzgzNjZmOTgxZTdlYzRhYjliNTIyNGNiODYwZjkxODI3ODUifQ==
