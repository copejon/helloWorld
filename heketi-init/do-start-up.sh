#! /bin/bash

# Copy this script into the start-up script box in the GCE instance creation ui.

cd /tmp/
curl -LO https://raw.githubusercontent.com/copejon/sandbox/master/heketi-init/startup-basic.sh
chmod +x startup-basic.sh
. startup-basic.sh
