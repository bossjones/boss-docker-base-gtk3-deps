#!/usr/bin/env bash

touch /home/pi/.shrc
cat <<EOF > /home/pi/.shrc
case $TERM in
*dvtm*)
  TERM=`echo $TERM | sed s/dvtm/xterm/g`
  export TERM
  ;;
esac

. $ENV.$SYSTEM

# where ENVD = $HOME/.sh
# for i in $ENVD/*.sh; do
#   test -x $i && . $i
# done
# unset i


# lsc on

# eval "`rbenv init -`"

trap -- 'test -r $HOME/.logout && . $HOME/.logout' EXIT
EOF

sudo chown pi:pi -R /home/pi/
