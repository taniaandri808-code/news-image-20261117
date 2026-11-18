#!/bin/bash
set -e
cd /workspace/newsimg17-entry
CHROME=/root/.cache/ms-playwright/chromium-1208/chrome-linux64/chrome
# 1) recolor the public-domain equirectangular base map to the poster palette
python3 - <<'PY'
from PIL import Image
im = Image.open("world.svg").convert("RGB").resize((1024, 516))
px = im.load()
W, H = im.size
out = Image.new("RGB", (W, H), (33, 37, 46))
po = out.load()
for y in range(H):
    for x in range(W):
        r, g, b = px[x, y]
        if g >= b - 8:      # land
            po[x, y] = (74, 80, 96)
out.save("map.png")
print("map.png", out.size)
PY
# 2) screenshot the poster
"$CHROME" --headless=new --no-sandbox --disable-gpu --hide-scrollbars \
  --force-device-scale-factor=1 --window-size=1024,1024 \
  --screenshot=entry.png --virtual-time-budget=10000 \
  "file://$PWD/news.html" 2>/dev/null
# 3) verify
python3 - <<'PY'
from PIL import Image
import os
im = Image.open("entry.png").convert("RGB")
print("entry:", im.size, os.path.getsize("entry.png"), "bytes")
assert im.size == (1024, 1024)
assert os.path.getsize("entry.png") <= 1048576
print("CHECK_OK")
PY
