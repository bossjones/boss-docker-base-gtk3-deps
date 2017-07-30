#!/bin/bash -x

# Ensure that worker entrypoint does not also run dbus processes
if [ $SCARLETT_ENABLE_DBUS == true ]
then

  echo '[run] enabling dbus'

  # Enable dbus as a supervised service
  if [ -d /etc/services.d/dbus ]
  then
    echo '[run] dbus already enabled'
  else
    ln -s /etc/services-available/dbus /etc/services.d/dbus
  fi

else
  echo '[run] dbus disabled, bypassing dbus startup'
fi
