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

touch /home/pi/.execline-shell
sudo chown pi:pi /home/pi/.execline-shell
# executable by user only
sudo chmod 700 /home/pi/.execline-shell

cat <<EOF > /home/pi/.execline-shell
#!/usr/bin/execlineb -S0

# Eg. /home/pi
importas HOME HOME

# $ENV is $HOME/.shrc in newer versions of the Bourne Shell
# source: https://en.wikipedia.org/wiki/Unix_shell
export ENV ${HOME}/.shrc

# source: https://github.com/dragonmaus/home-old/tree/master/.sh
# export ENVD ${HOME}/.sh

ssh-agent
# NOTE: tryexec program
# tryexec executes into a command line, with a fallback.
# tryexec [ -n ] [ -c ] [ -l ] [ -a argv0 ] { prog1... } prog2...
# -a argv0 : argv0. Replace prog's argv[0] with argv0. This is done before adding a dash, if the -l option is also present.
# https://skarnet.org/software/execline/tryexec.html
tryexec -a sh
{
  bash $@
}
sh $@
EOF

sudo chown pi:pi -R /home/pi/
