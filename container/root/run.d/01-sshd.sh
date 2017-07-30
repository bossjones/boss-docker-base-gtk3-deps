#!/bin/bash -x

# Ensure that worker entrypoint does not also run nginx processes
if [ $SCARLETT_ENABLE_SSHD == true ]
then

  echo '[run] enabling sshd'

  # Enable sshd as a supervised service
  if [ -d /etc/services.d/sshd ]
  then
    echo '[run] sshd already enabled'
  else
    ln -s /etc/services-available/sshd /etc/services.d/sshd
  fi

else
  echo '[run] sshd disabled, bypassing sshd startup'
fi
