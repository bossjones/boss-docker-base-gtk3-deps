#!/usr/bin/env bash

# NOTE: execline-shell script
# execline-shell executes $HOME/.execline-shell if available (or /bin/sh otherwise) with the arguments it is given.
# execline-shell transforms itself into ${HOME}/.execline-shell $@.
# ${HOME}/.execline-shell must be readable and executable by the user.
# It must exec into an interactive shell with $@ as its argument.


# execline-shell is meant to be used as the SHELL environment variable value.
# It allows one to specify his favourite shell and shell configuration in any language,
# since the ${HOME}/.execline-shell file can be any executable program.
# ${HOME}/.execline-shell can be seen as a portable .whateverrc file.

# As an administrator-modifiable configuration file,
# execline-shell provided in execline's examples/etc/ subdirectory,
# and should be copied by the administrator to /etc.

touch /root/.execline-shell
sudo chown root:root /root/.execline-shell
# executable by user only
sudo chmod 700 /root/.execline-shell

# source: https://github.com/skarnet/lh-bootstrap/blob/master/layout/rootfs/root/.execline-shell

cat <<EOF > /root/.execline-shell
#!/usr/bin/execlineb -S0

export PS1 "${USER}@%%HOSTNAME%%:${PWD} # "
/bin/bash $@
EOF

sudo chown root:root -R /root/
