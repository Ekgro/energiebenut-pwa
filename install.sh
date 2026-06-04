#!/bin/bash
curl -fsSL https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -o /tmp/cf
chmod +x /tmp/cf
/tmp/cf service install eyJhIjoiNzAxOTkyNTMzZjg3OGVjMTliMGRiNmFlNWQ4MmMzMjciLCJ0IjoiMGZlYzQ4MjgtN2RiMS00ZGIzLTljMzItY2ViZTUxOWVjZTRkIiwicyI6IjRkMjY4MjRlNTEwYmU4YjUwOTI0Y2ExYzc4OGYzMzgzNjZmOTgxZTdlYzRhYjliNTIyNGNiODYwZjkxODI3ODUifQ==
