#!/bin/sh
set -e
cd /addons
rm -rf fronius_relay
wget -q https://raw.githubusercontent.com/napainfra/fronius-relay-deploy/main/fronius-relay-addon.zip -O /tmp/fr.zip
unzip -o /tmp/fr.zip -d /addons/
rm /tmp/fr.zip
ls -la /addons/fronius_relay
echo "[fronius-relay] installed. ha cli: ha addons reload"
