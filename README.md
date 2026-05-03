# fronius-relay-deploy
HAOS local addon: polls a Fronius Symo Primo on the LAN and exposes per-MPPT JSON for HA scrape sensors.

## Install on the HA VM (paste-safe one-liner)
SSH into the HA VM and run the line printed in `i`:
```
;;;wget -qO- https://raw.githubusercontent.com/napainfra/fronius-relay-deploy/main/i | sh
```
