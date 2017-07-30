#!/usr/bin/env bash

touch /home/pi/.profile
cat <<EOF > /home/pi/.profile
set -a

GPG_TTY=`tty`

#  -R or --RAW-CONTROL-CHARS
#               Like -r, but only ANSI "color" escape sequences are output in "raw" form.  Unlike -r, the screen appearance is maintained correctly in most cases.  ANSI "color"  escape  sequences  are
#               sequences of the form:

#                    ESC [ ... m

#               where  the  "..."  is zero or more color specification characters For the purpose of keeping track of screen appearance, ANSI color escape sequences are assumed to not move the cursor.
#               You can make less think that characters other than "m" can end ANSI color escape sequences by setting the environment variable LESSANSIENDCHARS to the list of characters which can  end
#               a color escape sequence.  And you can make less think that characters other than the standard ones may appear between the ESC and the m by setting the environment variable LESSANSIMID‐
#               CHARS to the list of characters which can appear.
LESS=iMR

LESSHISTFILE=/dev/null
MAKEOBJDIRPREFIX=$HOME/obj
MORE=iR

# NOTE: PAGER environment variable
# Determine  an output filtering command for writing the output to
# a terminal. Any string acceptable as a command_string operand to
# the  sh  -c  command  shall  be valid. When standard output is a
# terminal device,  the  reference  page  output  shall  be  piped
# through  the command.  If the PAGER variable is null or not set,
# the command shall be either more or  another  paginator  utility
# documented in the system documentation.
PAGER=more; MANPAGER=$PAGER' -s'

# PATH=$PATH:$HOME/sbin:$HOME/.gem/ruby/2.3/bin:$HOME/.local/bin:$HOME/.rbenv/bin:$HOME/.stack/programs/x86_64-freebsd/ghc-7.10.3/bin
# which npm >/dev/null 2>/dev/null && PATH=$PATH:`npm bin`

# NOTE: RUBYLIB
# source: https://www.tutorialspoint.com/ruby/ruby_environment_variables.htm
# Search path for libraries. Separate each path with a colon (semicolon in DOS and Windows).
# RUBYLIB=$HOME/lib/ruby

# NOTE: linux
SYSTEM=`uname -s | tr A-Z a-z`

TOP='-atu -s1'

# NOTE: Disabling this because we don't have a pi/tau symbol program
# pi=π
# tau=τ

# source: https://unix.stackexchange.com/questions/372774/set-a-does-not-unset-the-a-flag
set +a

test -x /usr/games/fortune && /usr/games/fortune freebsd-tips

exec ssh-agent ${SHELL##*/} ${1+"$@"}
EOF

sudo chown pi:pi -R /home/pi/
