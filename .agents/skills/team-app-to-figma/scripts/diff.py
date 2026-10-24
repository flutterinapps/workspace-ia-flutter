#!/usr/bin/env python3
"""Diferencia media por píxel entre la captura de la app y la réplica en Figma.

Uso: diff.py <captura.png> <figma.png> [lado_a_lado.png]
"""
import sys

from PIL import Image, ImageChops, ImageStat

app = Image.open(sys.argv[1]).convert("RGB")
replica = Image.open(sys.argv[2]).convert("RGB").resize(app.size)
diff = ImageChops.difference(app, replica)
print(f"diferencia media: {sum(ImageStat.Stat(diff).mean) / 3:.2f}")

if len(sys.argv) > 3:
    width, height = app.size
    sheet = Image.new("RGB", (width * 3, height))
    sheet.paste(app, (0, 0))
    sheet.paste(replica, (width, 0))
    sheet.paste(diff.point(lambda v: min(255, v * 4)), (width * 2, 0))
    sheet.resize((width, height // 3)).save(sys.argv[3])
