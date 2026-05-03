#!/bin/sh
set -e
cd /addons
rm -rf fronius_relay
wget -q "https://raw.githubusercontent.com/napainfra/fronius-relay-deploy/bc58b15f4e205725398a7bec75080012dba56c71/fronius-relay-addon.zip" -O /tmp/fr.zip
unzip -o /tmp/fr.zip -d /addons/
rm /tmp/fr.zip
echo "[fronius-relay] version installed:"
grep version /addons/fronius_relay/config.yaml
ls /addons/fronius_relay/
echo "[fronius-relay] installed. ha cli: ha addons reload"
