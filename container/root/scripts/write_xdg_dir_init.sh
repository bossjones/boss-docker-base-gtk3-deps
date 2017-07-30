#!/usr/bin/env bash

# Create XDG DIRs and set the ownership correctly for each one

# source for below: https://github.com/squarenomad/nodeus/blob/0d0ff7f5796e57147b3da86e79e5a5b0f0c284f0/Dockerfile#L13
# ENV XDG_RUNTIME_DIR /run/user/%I

# SET defaults if empty
function check_script_arg_set() {
  if [[ "${1}" == "" ]] ; then
    echo "Please set username before using this scripts eg. 'xdg_dir_init pi'"
    exit 1
  fi
}

function verify_user_exists() {
    # this should evaluate to the user name
    _GET_USER=$(cat /etc/passwd | grep "^${1}" | cut -d ":" -f1)
    if [[ "${_GET_USER}" != "" ]] && [[ "${_GET_USER}" == "${1}" ]]; then
        return 0
    else
        return 1
    fi
}

function get_user_uid() {
    # this should evaluate to the user name
    _GET_UID=$(cat /etc/passwd | grep "^${_USER}" | cut -d ":" -f3)
    if [[ "${_GET_UID}" != "" ]]; then
        return ${_GET_UID}
    else
        echo '[get_user_uid]: error getting user uid'
        echo "_GET_UID: ${_GET_UID}"
        exit 1
    fi
}

function print_xdg_vars() {
    ############################
    # Example output:
    ############################
    #
    # d478bc28d79d:~# bash -x ./xdg_run_dir "pi"
    # + check_script_arg_set pi
    # + [[ pi == '' ]]
    # + verify_user_exists pi
    # ++ cat /etc/passwd
    # ++ grep '^pi'
    # ++ cut -d : -f1
    # + _GET_USER=pi
    # + [[ pi != '' ]]
    # + [[ pi == \p\i ]]
    # + return 0
    # + _RETVAL=0
    # + [[ 0 != \0 ]]
    # + _USER=pi
    # ++ cat /etc/passwd
    # ++ grep '^pi'
    # ++ cut -d : -f3
    # + _UID=1000
    # ++ cat /etc/passwd
    # ++ grep '^pi'
    # ++ cut -d : -f4
    # + _GID=1000
    # ++ homeof pi
    # + _HOME=/home/pi
    # + _XDG_RUNTIME_DIR=/run/user/1000
    # + _XDG_CACHE_HOME=/home/pi/.cache
    # + _XDG_CONFIG_HOME=/home/pi/.config
    # + _XDG_DATA_HOME=/home/pi/.local/share
    # + _XDG_ENV_DIR=/run/user/1000/env
    # + _XDG_DIRS_ARRY=(${_XDG_RUNTIME_DIR} ${_XDG_CACHE_HOME} ${_XDG_CONFIG_HOME} ${_XDG_DATA_HOME} ${_XDG_ENV_DIR})
    # + print_xdg_vars
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + echo /run/user/1000
    # /run/user/1000
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + echo /home/pi/.cache
    # /home/pi/.cache
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + echo /home/pi/.config
    # /home/pi/.config
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + echo /home/pi/.local/share
    # /home/pi/.local/share
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + echo /run/user/1000/env
    # /run/user/1000/env
    # + mkdir_xdg_dirs
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + test -d /run/user/1000
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + test -d /home/pi/.cache
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + test -d /home/pi/.config
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + test -d /home/pi/.local/share
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + test -d /run/user/1000/env
    # + chown_xdg_dirs
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + [[ /run/user/1000 == \/\r\u\n\/\u\s\e\r\/\1\0\0\0 ]]
    # + echo ' (chown_xdg_dirs) chmod 0700 /run/user/1000'
    # (chown_xdg_dirs) chmod 0700 /run/user/1000
    # + chmod 0700 /run/user/1000
    # + chown -R pi:pi /run/user/1000
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + [[ /home/pi/.cache == \/\r\u\n\/\u\s\e\r\/\1\0\0\0 ]]
    # + chown -R pi:pi /home/pi/.cache
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + [[ /home/pi/.config == \/\r\u\n\/\u\s\e\r\/\1\0\0\0 ]]
    # + chown -R pi:pi /home/pi/.config
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + [[ /home/pi/.local/share == \/\r\u\n\/\u\s\e\r\/\1\0\0\0 ]]
    # + chown -R pi:pi /home/pi/.local/share
    # + for varItem in '"${_XDG_DIRS_ARRY[@]}"'
    # + [[ /run/user/1000/env == \/\r\u\n\/\u\s\e\r\/\1\0\0\0 ]]
    # + chown -R pi:pi /run/user/1000/env
    ############################

    for varItem in "${_XDG_DIRS_ARRY[@]}" # double quote and `@' is needed
    do
        echo "$varItem"
    done
}

function mkdir_xdg_dirs() {
    for varItem in "${_XDG_DIRS_ARRY[@]}" # double quote and `@' is needed
    do
        test -d ${varItem} || mkdir -p "${varItem}"
    done
}

function chown_xdg_dirs() {
    for varItem in "${_XDG_DIRS_ARRY[@]}" # double quote and `@' is needed
    do
        if [[ "${varItem}" == "${_XDG_RUNTIME_DIR}" ]]; then
            echo " (chown_xdg_dirs) chmod 0700 ${varItem}"
            chmod 0700 ${varItem}
            chown -R $_USER:$_USER ${varItem}
        else
            # chmod 0700 ${varItem}
            chown -R $_USER:$_USER ${varItem}
        fi
    done

}

# make sure $1 is set
check_script_arg_set "${1}"

# make sure user exists by checking /etc/passwd as well
verify_user_exists "${1}"

# as along as user exists, move forward
_RETVAL=$?
if [[ "${_RETVAL}" != "0" ]]; then
    echo -e "Something went wrong with 'verify_user_exists'"
    exit 1
fi

# set _USER = value passed in from command line
_USER=$1
_UID=$(cat /etc/passwd | grep "^${_USER}" | cut -d ":" -f3)
_GID=$(cat /etc/passwd | grep "^${_USER}" | cut -d ":" -f4)
_HOME=$(homeof "${_USER}")

# sets all the XDG_RUNTIME_DIR vars we need

_XDG_RUNTIME_DIR="${_XDG_RUNTIME_DIR:-/run/user/${_UID}}"
_XDG_CACHE_HOME="${XDG_CACHE_HOME:-${_HOME}/.cache}"
_XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${_HOME}/.config}"
_XDG_DATA_HOME="${XDG_DATA_HOME:-${_HOME}/.local/share}"
_XDG_ENV_DIR="${_XDG_ENV_DIR:-${_XDG_RUNTIME_DIR}/env}"

# now create all of them

_XDG_DIRS_ARRY=( ${_XDG_RUNTIME_DIR} ${_XDG_CACHE_HOME} ${_XDG_CONFIG_HOME} ${_XDG_DATA_HOME} ${_XDG_ENV_DIR} )

print_xdg_vars

mkdir_xdg_dirs

chown_xdg_dirs
