#!/usr/bin/env bash

#---------------------------------------------------------------------------------
# A standard set of tweaks to ensure container
# runs performant, reliably, and consistent between variants
#---------------------------------------------------------------------------------

# - Required for php-fpm to place .sock file into, fails otherwise

sudo mkdir -p /var/run/sshd && \
sudo chmod 755 /var/run/sshd && \
sudo chown -R $NOT_ROOT_USER:$NOT_ROOT_USER /var/run/lock /home/$NOT_ROOT_USER /tests
