#!/usr/bin/with-contenv bash

echo "[run] Starting Pi."
home="$(echo ~pi)"

find \( -name __pycache__ -o -name '*.pyc' \) | xargs rm -rf
chown $NOT_ROOT_USER:$NOT_ROOT_USER -R /home/$NOT_ROOT_USER/dev

exec s6-setuidgid $NOT_ROOT_USER "$@"
