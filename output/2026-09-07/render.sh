#!/bin/bash
export PATH="$HOME/bin:$PATH"
cd "/Users/leondietrich/Desktop/Launch.Lab/repeet/output/2026-09-07"

NAMES=(numbered-listicle before-after graveyard-rip order-receipt official-statement iceberg wanted-poster)

for i in 1 2 3 4 5 6 7; do
  out="ad-${i}-${NAMES[$((i-1))]}.png"
  P=$(python3 -c "
import re
t=open('ad-set.md').read()
b=re.findall(r'### Image prompt\n(.*?)(?=\n---|\Z)', t, re.S)
print(b[$i-1].strip())
")
  echo \"### rendering $out\"
  url=$(higgsfield generate create gpt_image_2 --prompt "$P" --aspect_ratio 3:4 --wait --wait-timeout 6m 2>&1 | grep -oE 'https://[^ ]+\.png' | tail -1)
  if [ -n "$url" ]; then
    curl -sS -o "$out" "$url" && echo "OK   $out  ($(du -h "$out" | cut -f1))"
  else
    echo "FAIL $out"
  fi
done
echo "### done"
