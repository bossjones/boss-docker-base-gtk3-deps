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

touch /home/pi/.execline-loginshell
sudo chown pi:pi /home/pi/.execline-loginshell

cat <<EOF > /home/pi/.execline-loginshell
#!/usr/bin/execlineb -S0

# Import defaults from linked container.
with-contenv

foreground { if -t { s6-test 'true' } }

# s6-envuidgid potentially sets the UID, GID and GIDLIST environment variables according to the options and arguments it is given; then it executes into another program.
s6-envuidgid pi
multisubstitute {
  importas HOME HOME
  importas SHELL SHELL
  importas XDG_RUNTIME_DIR XDG_RUNTIME_DIR
  importas UID UID
  importas GID GID
  importas PATH PATH
  importas ENABLE_PYTHON3 ENABLE_PYTHON3
  importas ENABLE_GTK ENABLE_GTK
  importas PREFIX PREFIX
  importas JHBUILD JHBUILD
  importas LD_LIBRARY_PATH LD_LIBRARY_PATH
  importas PYTHONPATH PYTHONPATH
}

multisubstitute {
    import -D "1000" UID
    import -D "1000" GID
}

# Modify the runtime environment variables. These guys live in /run/user/1000/env
foreground {
    s6-applyuidgid -u 1000 -g 1000 umask 022 ${HOME}/.local/bin/env-setup
}

# Now that they're generated, load dynamic environment vars
envdir ${XDG_RUNTIME_DIR}/env

# set GPG_TTY if possible
backtick -n GPG_TTY
{
  tty
}

# set SYSTEM to linux
backtick -n SYSTEM
{
  pipeline
  {
    uname -s
  }
  tr A-Z a-z
}

# kick off shell
$SHELL $@

# #################################################################################
# # NOTE: backtick program
# # backtick runs a program and stores its output in an environment variable, then executes another program.
# # backtick [ -i | -I | -D default ] [ -n ] variable { prog1... } prog2...
# # -n : chomp an ending newline off prog1...'s output.
# #################################################################################
# backtick -n PATH.new
# {
#   #################################################################################
#   # NOTE: import program
#   # import replaces an environment variable name with its value, then executes another program.
#   # import [ -i | -D default ] [ -u ] [ -s ] [ -C | -c ] [ -n ] [ -d delim ] envvar prog...
#   #################################################################################
#   importas PATH PATH

#   #################################################################################
#   # NOTE: multidefine package
#   # multidefine splits a value and defines several variables at once, then executes another program.
#   # multidefine [ -0 ] [ -r ] [ -C | -c ] [ -n ] [ -d delim ] value { variables... } prog...
#   # source: https://skarnet.org/software/execline/multidefine.html
#   # -r : behave similarly to the "read" shell command.
#   # If there are more words in the split value than there are variables in the block,
#   # the last variable will be replaced with all the remaining words (and will be split).
#   # Without this option, the last variable is replaced with a single word,
#   # and the excess words are lost.
#   # -C : crunching ( aka join command )
#   # You can tell the substitution command to merge sets of consecutive delimiters into a single delimiter.
#   # For instance, to replace three consecutive spaces, or a space and 4 tab characters, with a single space.
#   # This is called crunching, and it is done by giving the -C switch to the substitution command.
#   # The remaining delimiter will always be the first in the sequence.
#   # source: https://skarnet.org/software/execline/el_transform.html
#   #################################################################################
#   multidefine -r -C -d : $PATH
#   {
#     # NOTE: This literally evaluates to
#     # /home/pi/bin:/home/pi/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games.first: No such file or directory
#     PATH.first
#     PATH.rest
#   }
#   ifelse
#   {
#     #################################################################################
#     # same as [ x$1 = x ] or [ -z "$1" ]
#     # That checks that $1 is empty, though it should be quoted (identical to [ -z "$1" ]).
#     # Some very old shells didn't handle empty strings properly,
#     # so writers of portable scripts adopted this style of checking.
#     # It hasn't been necessary for decades,
#     # but people still do it that way because people still do it that way.
#     #################################################################################
#     test x$PATH.first = x/command

#     # ^ re: command, what is it?
#     # source: https://askubuntu.com/questions/512770/what-is-use-of-command-command
#     # Can be used to invoke commands on disk when a function with the same name exists
#     # run: help command
#     #################################################################################
#     # Execute a simple command or display information about commands.
#     # Runs COMMAND with ARGS suppressing  shell function lookup, or display
#     # information about the specified COMMANDs.  Can be used to invoke commands
#     # on disk when a function with the same name exists.
#     #################################################################################
#     # And yes, command -v will give the same kind of result as type.
#     #################################################################################
#   }
#   {
#     #################################################################################
#     # NOTE:  pipeline program
#     # pipeline runs two commands with a pipe between them.
#     # pipeline [ -d ] [ -r | -w ] { prog1... } prog2...
#     # It runs prog1... as a child process and execs into prog2..., with a pipe between prog1's stdout and prog2's stdin.
#     # prog1's pid is available in prog2 as the ! environment variable.
#     #################################################################################
#     pipeline
#     {
#       #################################################################################
#       # NOTE: echo program
#       # -n     do not output the trailing newline
#       #################################################################################
#       echo -n
#       $PATH.rest
#     }
#     #################################################################################
#     # NOTE: tr program
#     # tr - translate or delete characters
#     # tr [OPTION]... SET1 [SET2]
#     #################################################################################
#     tr " " :
#   }
#   pipeline
#   {
#     echo -n
#     $PATH.first
#     $PATH.rest
#   }
#   tr " " :
# }
# #################################################################################
# # NOTE: multisubstitute program [ help output is only a subset of full options ]
# #  multisubstitute performs several substitutions at once in its argv, then executes another program.
# #  multisubstitute
# #      {
# #        [ define [ -n ] [ -s ] [ -C | -c ] [ -d delim ] variable value ]
# #        [ importas [ -i | -D default ] [ -n ] [ -s ] [ -C | -c ] [ -d delim ] variable envvar ]
# #        ...
# #      }
# #      prog...
# #################################################################################
# multisubstitute
# {
#   importas HOME HOME
#   importas PATH.new PATH.new
#   importas SHELL SHELL
# }
# unexport PATH.new
# #################################################################################
# # NOTE: The s6-envdir program
# # envdir runs another program with environment modified according to files in a specified directory.
# # s6-envdir changes its environment, then executes into another program.
# # s6-envdir [ -I | -i ] [ -n ] [ -f ] [ -c nullis ] dir prog...
# # * s6-envdir reads files in dir. For every file f in dir,
# # that does not begin with a dot and does not contain the '=' character:
# # * If f is empty, remove a variable named f from the environment, if any.
# # * Else add a variable named f to the environment (or replace f if it already exists)
# # with the first line of the contents of file f as value.
# # Spaces and tabs at the end of this line are removed;
# # null characters in this line are changed to newlines in the environment variable.
# #################################################################################
# # FIXME: Change this to /run/user/1000/env (7/7/2017)
# envdir ${HOME}/.execline-env

# #################################################################################
# # NOTE: GPG_TTY
# # source: https://www.gnupg.org/documentation/manuals/gnupg/Common-Problems.html
# # Problem: "The Curses based Pinentry does not work"
# # A: The far most common reason for this is that the environment variable GPG_TTY has not been set correctly.
# # Make sure that it has been set to a real tty device and not just to
# # '/dev/tty'; i.e. 'GPG_TTY=tty' is plainly wrong;
# # what you want is 'GPG_TTY=`tty`' — note the back ticks.
# # Also make sure that this environment variable gets exported,
# # that is you should follow up the setting with an 'export GPG_TTY'
# # (assuming a Bourne style shell). Even for GUI based Pinentries;
# # you should have set GPG_TTY. See the section on installing the gpg-agent on how to do it.
# #################################################################################
# backtick -n GPG_TTY
# {
#   tty
# }
# backtick -n PATH
# {
#   # multisubstitute
#   # {
#   #  importas GOPATH GOPATH
#   # }
#   pipeline
#   {
#     echo -n
#     /usr/local/bin
#     /usr/local/sbin
#     $PATH.new
#     ${HOME}/bin
#     ${HOME}/sbin
#   }
#   tr " " :
# }
# backtick -n SYSTEM
# {
#   pipeline
#   {
#     uname -s
#   }
#   tr A-Z a-z
# }
# $SHELL $@
EOF

sudo chown pi:pi -R /home/pi/
