#!/usr/bin/env bash

# The execline-startup script ( runs before calling execline-loginshell )

# execline-startup performs some system-specific login initialization, then executes ${HOME}/.execline-loginshell.
# execline-startup sets the SHELL environment variable to /etc/execline-shell.
# It then performs some system-specific initialization,
# and transforms itself into ${HOME}/.execline-loginshell $@ if available (and /etc/execline-shell otherwise).

# ${HOME}/.execline-loginshell must be readable and executable by the user.
# It must exec into $SHELL $@.

# execline-startup is an execlineb script; hence, it is readable and modifiable.
# It is meant to be modified by the system administrator to perform system-specific login-time initialization.

# As a modifiable configuration file,
# execline-startup is provided in execline's examples/etc/ subdirectory,
# and should be copied by the administrator to /etc.

# execline-startup is meant to be used as a login shell.
# System administrators should manually add /etc/execline-startup to the /etc/shells file.
# The /etc/execline-startup file itself plays the role of the /etc/profile file,
# and ${HOME}/.execline-loginshell plays the role of the ${HOME}/.profile file.

touch /root/.execline-loginshell
sudo chown root:root /root/.execline-loginshell

# source: https://github.com/skarnet/lh-bootstrap/blob/master/layout/rootfs/root/.execline-loginshell
cat <<EOF > /home/pi/.execline-loginshell
#!/usr/bin/execlineb -S0
importas -D /etc/execline-shell SHELL SHELL
$SHELL $@
EOF

sudo chown root:root -R /root/

# executable by user only
sudo chmod 700 /root/.execline-shell
