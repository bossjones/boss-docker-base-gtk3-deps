#!/usr/bin/env awk -f
# HOW TO RUN: `$ echo "something" | ./awk-script`

# source: http://www.thegeekstuff.com/2010/01/8-powerful-awk-built-in-variables-fs-ofs-rs-ors-nr-nf-filename-fnr/?ref=binfind.com/web

# Begin section
BEGIN {
# Awk FS is any single character or regular expression which you want to use as a input field separator.
# Awk FS can be changed any number of times,
# it retains its values until it is explicitly changed.
# If you want to change the field separator,
# its better to change before you read the line. So that change affects the line what you read.
FS=" ";

# Awk OFS is an output equivalent of awk FS variable.
# By default awk OFS is a single space character.
# Following is an awk OFS example.
OFS=";";
}

# Loop section
{
    for (i=1;i<=NF;i++) {
        $i="\""$i"\""
    }1
}

# End section
END {

}

# data
# /tests/goss.d/jhbuild/python3.yaml
# /tests/goss.d/jhbuild/gnome_file_permissions.yaml
# /tests/goss.d/jhbuild/jhbuild_file_permissions.yaml
# /tests/goss.d/jhbuild/commands.yaml
# /tests/goss.d/shell/env_vars.yaml
# /tests/goss.d/s6/env_vars_container_environment.yaml
# /tests/goss.d/user/user.yaml
# /tests/goss.d/user/file_permissions.yaml
# /tests/goss.d/hosts/hostname.yaml
# /tests/goss.d/services/dbus.yaml
# /tests/goss.d/packages/xenial.yaml
# /tests/goss.python3.yaml
# /tests/goss.gtk3_deps.yaml


# ORIG
# awk '{for (i=1;i<=NF;i++) $i="\""$i"\""}1' FS=";" OFS=";" input
# WORKING
#  \cat env_to_change_envvar | awk '{for (i=3;i<=NF;i++) $i="\""$i"\""}1' FS=" " OFS=" " | pbcopy

# WOOT: THIS WORKS
#  |2.2.3|    dev7behance1484 in ~/dev/bossjones/boss-docker-base-gtk3-deps/container/root/tests
# ± |feature-push-dockerhub ↑2 {1} U:5 ?:2 ✗| → echo '/tests/goss.d/jhbuild/python3.yaml' | awk '{for (i=1;i<=NF;i++) $i="\""$i"\""": {}"}1' FS=" " OFS=" "
# "/tests/goss.d/jhbuild/python3.yaml": {}
