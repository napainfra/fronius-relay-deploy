#!/bin/sh
# Install Allview solar fix package
# - drops package YAML into /config/packages/
# - idempotently enables packages: in configuration.yaml if not already set
# - no editor needed, no scp, no samba
set -e

CFG=/config/configuration.yaml
PKG_DIR=/config/packages
PKG_FILE=$PKG_DIR/allview_solar_fix.yaml
RAW=https://raw.githubusercontent.com/napainfra/fronius-relay-deploy/cbd07e3478a5350dd3577c3274e4b7f6a109293a/allview_solar_fix.yaml

echo "==> Step 1: ensure $PKG_DIR exists"
mkdir -p "$PKG_DIR"

echo "==> Step 2: download package YAML"
wget -qO "$PKG_FILE" "$RAW"
echo "    wrote $PKG_FILE ($(wc -l < "$PKG_FILE") lines)"

echo "==> Step 3: check configuration.yaml for packages:"
if grep -qE "^[[:space:]]*packages:[[:space:]]*!include_dir_named[[:space:]]+packages" "$CFG"; then
  echo "    packages: already enabled — no change"
elif grep -qE "^homeassistant:" "$CFG"; then
  echo "    homeassistant: block exists — appending packages: under it"
  # Backup
  cp "$CFG" "$CFG.bak.$(date +%s)"
  # Insert "  packages: !include_dir_named packages" right after the homeassistant: line
  awk '
    BEGIN{done=0}
    /^homeassistant:[[:space:]]*$/ && !done {
      print
      print "  packages: !include_dir_named packages"
      done=1
      next
    }
    {print}
  ' "$CFG" > "$CFG.new"
  mv "$CFG.new" "$CFG"
  echo "    patched $CFG (backup saved)"
else
  echo "    no homeassistant: block — appending fresh block at top"
  cp "$CFG" "$CFG.bak.$(date +%s)"
  printf "homeassistant:\n  packages: !include_dir_named packages\n\n" > "$CFG.new"
  cat "$CFG" >> "$CFG.new"
  mv "$CFG.new" "$CFG"
  echo "    patched $CFG (backup saved)"
fi

echo ""
echo "==> Done. Now in HA UI:"
echo "    1) Developer Tools -> YAML -> CHECK CONFIGURATION"
echo "    2) If valid -> RESTART"
echo ""
echo "After restart, these new entities will appear:"
echo "    sensor.allview_solar_lifetime"
echo "    sensor.allview_solar_daily      <- replaces broken solar_today_combined"
echo "    sensor.allview_solar_monthly"
echo "    sensor.allview_solar_yearly"
echo "    sensor.allview_cost_cumulative  <- replaces broken grid_cost_today"
echo "    sensor.allview_credit_cumulative"
