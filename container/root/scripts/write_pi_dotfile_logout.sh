#!/usr/bin/env bash

touch /home/pi/.logout
cat <<EOF > /home/pi/.logout
sudo -K
EOF

sudo chown pi:pi -R /home/pi/
