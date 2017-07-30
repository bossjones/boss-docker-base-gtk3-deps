FROM bossjones/boss-docker-python3:latest
MAINTAINER Malcolm Jones <bossjones@theblacktonystark.com>

# Prepare packaging environment
ENV DEBIAN_FRONTEND noninteractive

# build-arg are acceptable
# eg. docker build --build-arg var=xxx
ARG SCARLETT_ENABLE_SSHD
ARG SCARLETT_ENABLE_DBUS
ARG SCARLETT_BUILD_GNOME
ARG TRAVIS_CI

# metadata
ARG CONTAINER_VERSION
ARG GIT_BRANCH
ARG GIT_SHA

ENV SCARLETT_ENABLE_SSHD ${SCARLETT_ENABLE_SSHD:-0}
ENV SCARLETT_ENABLE_DBUS ${SCARLETT_ENABLE_DBUS:-'true'}
ENV SCARLETT_BUILD_GNOME ${SCARLETT_BUILD_GNOME:-'true'}
ENV TRAVIS_CI ${TRAVIS_CI:-'true'}

RUN echo "SCARLETT_ENABLE_SSHD: ${SCARLETT_ENABLE_SSHD}"
RUN echo "SCARLETT_ENABLE_DBUS: ${SCARLETT_ENABLE_DBUS}"
RUN echo "SCARLETT_BUILD_GNOME: ${SCARLETT_BUILD_GNOME}"
RUN echo "TRAVIS_CI: ${TRAVIS_CI}"

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
# So, to prevent services from being started automatically when you install packages with dpkg, apt, etc., just do this (as root):
# RUN sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

# DISABLED # # make apt use ipv4 instead of ipv6 ( faster resolution )
# DISABLED # RUN sed -i "s@^#precedence ::ffff:0:0/96  100@precedence ::ffff:0:0/96  100@" /etc/gai.conf

# # Ensure UTF-8 lang and locale
# RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:/usr/local/sbin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.

# FIXME: DO NOT SET env var USER
ENV UNAME "pi"
ENV NOT_ROOT_USER "pi"

# /home/pi
ENV USER_HOME "/home/${UNAME}"

# /home/pi/dev
ENV PROJECT_HOME "/home/${UNAME}/dev"

ENV LANG C.UTF-8
ENV SKIP_ON_TRAVIS yes
ENV CURRENT_DIR $(pwd)
ENV GSTREAMER 1.0
ENV ENABLE_PYTHON3 yes
ENV ENABLE_GTK yes
ENV PYTHON_VERSION_MAJOR 3
ENV PYTHON_VERSION 3.5
ENV CFLAGS "-fPIC -O0 -ggdb -fno-inline -fno-omit-frame-pointer"
ENV MAKEFLAGS "-j4 V=1"

# /home/pi/jhbuild
ENV PREFIX "${USER_HOME}/jhbuild"

# /home/pi/gnome
ENV JHBUILD "${USER_HOME}/gnome"

# /home/pi/.virtualenvs
ENV PATH_TO_DOT_VIRTUALENV "${USER_HOME}/.virtualenvs"

# /home/pi/jhbuild/bin:/home/pi/jhbuild/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PATH ${PREFIX}/bin:${PREFIX}/sbin:${PATH}

# /home/pi/.virtualenvs/scarlett_os/lib
ENV LD_LIBRARY_PATH ${PREFIX}/lib:${LD_LIBRARY_PATH}

# /home/pi/jhbuild/lib/python3.5/site-packages:/usr/lib/python3.5/site-packages
ENV PYTHONPATH ${PREFIX}/lib/python${PYTHON_VERSION}/site-packages:/usr/lib/python${PYTHON_VERSION}/site-packages

# /home/pi/.virtualenvs/scarlett_os/lib/pkgconfig
ENV PKG_CONFIG_PATH ${PREFIX}/lib/pkgconfig:${PREFIX}/share/pkgconfig:/usr/lib/pkgconfig

# /home/pi/jhbuild/share:/usr/share
ENV XDG_DATA_DIRS ${PREFIX}/share:/usr/share

# /home/pi/jhbuild/etc/xdg
ENV XDG_CONFIG_DIRS ${PREFIX}/etc/xdg

ENV PYTHON "python3"
ENV TERM "xterm-256color"
ENV PACKAGES "python3-gi python3-gi-cairo"
ENV CC gcc

# NOTE: Couple other things to install for future, like valgrind etc
# source: https://github.com/avranju/docker-linux-dev-image/blob/master/Dockerfile.template

# NOTE: It's an example of how to pass environment variables when running a Dockerized SSHD service.
# NOTE: SSHD scrubs the environment, therefore ENV variables contained in Dockerfile must be pushed to
# /etc/profile in order for them to be available.
# source: https://stackoverflow.com/questions/36292317/why-set-visible-now-in-etc-profile
ENV NOTVISIBLE "in users profile"
# DISABLED # RUN echo 'export VISIBLE=now' >> /etc/profile

# virtualenv stuff
ENV VIRTUALENVWRAPPER_PYTHON '/usr/local/bin/python3'
ENV VIRTUALENVWRAPPER_VIRTUALENV '/usr/local/bin/virtualenv'
ENV VIRTUALENV_WRAPPER_SH '/usr/local/bin/virtualenvwrapper.sh'

# Ensure that Python outputs everything that's printed inside
# the application rather than buffering it.
ENV PYTHONUNBUFFERED 1
ENV PYTHON_VERSION_MAJOR "3"
ENV GSTREAMER "1.0"
ENV USER "pi"
ENV USER_HOME "/home/${UNAME}"
ENV LANGUAGE_ID 1473
ENV GITHUB_BRANCH "master"
ENV GITHUB_REPO_NAME "scarlett_os"
ENV GITHUB_REPO_ORG "bossjones"
ENV PI_HOME "/home/pi"

# /home/pi/dev/bossjones-github/scarlett_os
ENV MAIN_DIR "${PI_HOME}/dev/${GITHUB_REPO_ORG}-github/${GITHUB_REPO_NAME}"

# /home/pi/.virtualenvs/scarlett_os
ENV VIRT_ROOT "${PI_HOME}/.virtualenvs/${GITHUB_REPO_NAME}"

# /home/pi/.virtualenvs/scarlett_os/lib/pkgconfig
ENV PKG_CONFIG_PATH "${PI_HOME}/.virtualenvs/${GITHUB_REPO_NAME}/lib/pkgconfig"

# /home/pi/dev/bossjones-github/scarlett_os/tests/fixtures/.scarlett
ENV SCARLETT_CONFIG "${PI_HOME}/dev/${GITHUB_REPO_ORG}-github/${GITHUB_REPO_NAME}/tests/fixtures/.scarlett"

# /home/pi/dev/bossjones-github/scarlett_os/static/speech/hmm/en_US/hub4wsj_sc_8k
ENV SCARLETT_HMM "${PI_HOME}/dev/${GITHUB_REPO_ORG}-github/${GITHUB_REPO_NAME}/static/speech/hmm/en_US/hub4wsj_sc_8k"

# /home/pi/dev/bossjones-github/scarlett_os/static/speech/lm/1473.lm
ENV SCARLETT_LM "${PI_HOME}/dev/${GITHUB_REPO_ORG}-github/${GITHUB_REPO_NAME}/static/speech/lm/${LANGUAGE_ID}.lm"

# /home/pi/dev/bossjones-github/scarlett_os/static/speech/dict/1473.dic
ENV SCARLETT_DICT "${PI_HOME}/dev/${GITHUB_REPO_ORG}-github/${GITHUB_REPO_NAME}/static/speech/dict/${LANGUAGE_ID}.dic"

# /home/pi/.virtualenvs/repoduce_pytest_mock_issue_84/lib
ENV LD_LIBRARY_PATH "${PI_HOME}/.virtualenvs/${GITHUB_REPO_NAME}/lib"

# /home/pi/.virtualenvs/scarlett_os/lib/gstreamer-1.0
ENV GST_PLUGIN_PATH "${PI_HOME}/.virtualenvs/${GITHUB_REPO_NAME}/lib/gstreamer-${GSTREAMER}"
ENV PYTHON "/usr/local/bin/python3"
ENV PYTHON_VERSION "3.5"
ENV VIRTUALENVWRAPPER_PYTHON "/usr/local/bin/python3"
ENV VIRTUALENVWRAPPER_VIRTUALENV "/usr/local/bin/virtualenv"
ENV VIRTUALENVWRAPPER_SCRIPT "/usr/local/bin/virtualenvwrapper.sh"

# /home/pi/.pythonrc
ENV PYTHONSTARTUP "${USER_HOME}/.pythonrc"
ENV PIP_DOWNLOAD_CACHE "${USER_HOME}/.pip/cache"

# /home/pi/.virtualenvs/scarlett_os
ENV WORKON_HOME "${VIRT_ROOT}"

# Vagrant pub key for development
ENV USER_SSH_PUBKEY "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"

# Configure runtime directory
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# source: https://github.com/jakelee8/dockerfiles/blob/b1f7fd4520ae3e1b7e9ccebf2b07381a4069cc00/images/steam/steam-ubuntu16.10/Dockerfile
ENV XDG_RUNTIME_DIR=/run/user/1000

# Expose port for ssh
EXPOSE 22

# Overlay the root filesystem from this repo
COPY ./container/root /

# Copy over dotfiles repo, we'll use this later on to init a bunch of thing
COPY ./dotfiles /dotfiles

WORKDIR /home/$UNAME

ENV HOME "/home/$UNAME"

ENV CCACHE_DIR /ccache

#------------------------------------ more changes


# FIXME: required for jhbuild( sudo apt-get install docbook-xsl build-essential git-core python-libxml2 )
# source: https://wiki.gnome.org/HowDoI/Jhbuild

RUN \
    sed -i "s@^#precedence ::ffff:0:0/96  100@precedence ::ffff:0:0/96  100@" /etc/gai.conf; \
    apt-get update && \
    # install apt-fast and other deps
    apt-get -y upgrade && \
    apt-get install -y \
        language-pack-en-base && \
    apt-get clean && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{cache,log}/ && \
    rm -rf /var/lib/apt/lists/*.lz4 /tmp/* /var/tmp/* && \
    # Set locale (fix the locale warnings)
    locale-gen en_US.UTF-8 && \
    localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || : && \
    export LANG=en_US.UTF-8 && \
    export LC_ALL=en_US.UTF-8 && \
    PATH=/usr/local/bin:/usr/local/sbin:$PATH && \
    set -x \
    apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:saiarcot895/myppa && \
    apt-get update && \
    echo "apt-fast apt-fast/maxdownloads string 5" | debconf-set-selections; \
    echo "apt-fast apt-fast/dlflag boolean true" | debconf-set-selections; \
    echo "apt-fast apt-fast/aptmanager string apt-get" | debconf-set-selections; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-fast; \
    apt-fast update && \
    apt-fast install -y dbus dbus-x11 psmisc vim xvfb xclip htop && \
    # now that apt-fast is setup, lets clean everything in this layer
    apt-fast autoremove -y && \
    # now clean regular apt-get stuff
    apt-get clean && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{cache,log}/ && \
    rm -rf /var/lib/apt/lists/*.lz4 /tmp/* /var/tmp/*; \
    # after cleaning up files from apt-fast, lets start installing the real stuff
    ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"' > /etc/default/locale && \
    dpkg-reconfigure -f noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    echo 'deb http://us.archive.ubuntu.com/ubuntu/ xenial main restricted' | tee /etc/apt/sources.list && \
    echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ xenial main restricted' | tee -a /etc/apt/sources.list && \
    echo 'deb http://us.archive.ubuntu.com/ubuntu/ xenial-updates main restricted' | tee -a /etc/apt/sources.list && \
    echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-updates main restricted' | tee -a /etc/apt/sources.list && \
    echo 'deb http://us.archive.ubuntu.com/ubuntu/ xenial universe' | tee -a /etc/apt/sources.list && \
    echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ xenial universe' | tee -a /etc/apt/sources.list && \
    echo 'deb http://us.archive.ubuntu.com/ubuntu/ xenial-updates universe' | tee -a /etc/apt/sources.list && \
    echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-updates universe' | tee -a /etc/apt/sources.list && \
    echo 'deb http://us.archive.ubuntu.com/ubuntu/ xenial-security main restricted' | tee -a /etc/apt/sources.list && \
    echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-security main restricted' | tee -a /etc/apt/sources.list && \
    echo 'deb http://us.archive.ubuntu.com/ubuntu/ xenial-security universe' | tee -a /etc/apt/sources.list && \
    echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-security universe' | tee -a /etc/apt/sources.list && \
    echo 'deb http://us.archive.ubuntu.com/ubuntu/ xenial multiverse' | tee -a /etc/apt/sources.list && \
    echo 'deb http://us.archive.ubuntu.com/ubuntu/ xenial-updates multiverse' | tee -a /etc/apt/sources.list && \
    echo 'deb http://security.ubuntu.com/ubuntu xenial-security main restricted' | tee -a /etc/apt/sources.list && \
    echo 'deb http://security.ubuntu.com/ubuntu xenial-security main restricted' | tee -a /etc/apt/sources.list && \
    echo 'deb http://security.ubuntu.com/ubuntu xenial-security universe' | tee -a /etc/apt/sources.list && \
    echo 'deb http://us.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse' | tee -a /etc/apt/sources.list && \
    echo 'deb http://security.ubuntu.com/ubuntu xenial-security multiverse' | tee -a /etc/apt/sources.list && \
    cat /etc/apt/sources.list | grep -v "^#" | sort -u > /etc/apt/sources.list.bak && \
    mv -fv /etc/apt/sources.list.bak /etc/apt/sources.list && \
    add-apt-repository -y ppa:ricotz/testing && \
    add-apt-repository -y ppa:gnome3-team/gnome3 && \
    add-apt-repository -y ppa:gnome3-team/gnome3-staging && \
    add-apt-repository -y ppa:pitti/systemd-semaphore && \
    apt-fast update -yqq && \
    apt-fast upgrade -yqq && \
    export LANG=en_US.UTF-8 && \
    apt-fast install -qqy libpulse-dev espeak && \
    apt-cache search --names-only '^(lib)?gstreamer1.0\S*' | sed 's/\(.*\) -.*/\1 /' | grep -iv "Speech"  > dependencies && \
    cat dependencies && \
    apt-fast build-dep -y `cat dependencies` && \
    apt-fast install -qqy gnome-common \
                        gtk-doc-tools \
                        libgtk-3-dev \
                        libgirepository1.0-dev \
                        yelp-tools \
                        libgladeui-dev \
                        python3-dev \
                        python3-cairo-dev \
                        python3-gi \
                        automake \
                        autopoint \
                        bison \
                        build-essential \
                        byacc \
                        flex \
                        gcc \
                        automake \
                        autoconf \
                        libtool \
                        bison \
                        swig \
                        python-dev \
                        libpulse-dev \
                        gettext \
                        gnome-common \
                        gtk-doc-tools \
                        libgtk-3-dev \
                        libgirepository1.0-dev \
                        python3-gi-cairo \
                        yasm \
                        nasm \
                        bison \
                        flex \
                        libusb-1.0-0-dev \
                        libgudev-1.0-dev \
                        libxv-dev \
                        build-essential \
                        autotools-dev \
                        automake \
                        autoconf \
                        libtool \
                        binutils \
                        autopoint \
                        libxml2-dev \
                        zlib1g-dev \
                        libglib2.0-dev \
                        pkg-config \
                        flex \
                        python \
                        libasound2-dev \
                        libgudev-1.0-dev \
                        libxt-dev \
                        libvorbis-dev \
                        libcdparanoia-dev \
                        libpango1.0-dev \
                        libtheora-dev \
                        libvisual-0.4-dev \
                        iso-codes \
                        libgtk-3-dev \
                        libraw1394-dev \
                        libiec61883-dev \
                        libavc1394-dev \
                        libv4l-dev \
                        libcairo2-dev \
                        libcaca-dev \
                        libspeex-dev \
                        libpng-dev \
                        libshout3-dev \
                        libjpeg-dev \
                        libaa1-dev \
                        libflac-dev \
                        libdv4-dev \
                        libtag1-dev \
                        libwavpack-dev \
                        libpulse-dev \
                        gstreamer1.0* \
                        lame \
                        flac \
                        libfftw3-dev \
                        xvfb \
                        gir1.2-gtk-3.0 \
                        xsltproc \
                        docbook-xml \
                        docbook-xsl \
                        python-libxml2 \
                        sudo \
                        # begin - gst-plugins-bad req
                        libqt4-opengl \
                        libdvdread4 \
                        libdvdnav4 \
                        libllvm3.8 \
                        libsoundtouch-dev \
                        libsoundtouch1 \
                        # For general debugging
                        gdb \
                        gdbserver \
                        strace \
                        lsof \
                        ltrace \
                        yelp-xsl \
                        docbook-xsl \
                        docbook-xsl-doc-html \
                        python-libxslt1 \
                        libxslt1-dev \
                        graphviz \
                        openssh-server \
                        # optimize compiling
                        gperf \
                        bc \
                        ccache \
                        file \
                        rsync \
                        # vim for debugging
                        # vim for debugging
                        vim \
                        source-highlight \
                        fortune \
                        # end gst-plugins-bad req
                        ubuntu-restricted-extras && \
    apt-fast update && \
    # now that apt-fast is setup, lets clean everything in this layer
    apt-fast autoremove -y && \
    # now clean regular apt-get stuff
    apt-get clean && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{cache,log}/ && \
    rm -rf /var/lib/apt/lists/*.lz4 /tmp/* /var/tmp/*; \

    # needed to fix *.html issues
    export LANG=en_US.UTF-8 && \
    apt-fast install -y asciidoctor \
                         libghc-cmark-prof \
                         libghc-markdown-prof \
                         libhtml-wikiconverter-markdown-perl \
                         libmarkdown2-dev \
                         libpod-markdown-perl \
                         libsmdev-dev \
                         libsoldout1-dev \
                         libtext-markdown-discount-perl \
                         libxft2-dbg \
                         linuxdoc-tools \
                         linuxdoc-tools-info \
                         linuxdoc-tools-latex \
                         linuxdoc-tools-text \
                         markdown \
                         python-html2text \
                         python-markdown \
                         python-mistune \
                         python3-html2text \
                         python3-markdown \
                         python3-misaka \
                         # specifics gtk-doc
                         docbook-utils \
                         docbook-xsl \
                         docbook-simple \
                         docbook-to-man \
                         docbook-dsssl \
                         jade \
                         python3-mistune && \
    apt-fast update && \
    # now that apt-fast is setup, lets clean everything in this layer
    apt-fast autoremove -y && \
    # now clean regular apt-get stuff
    apt-get clean && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{cache,log}/ && \
    rm -rf /var/lib/apt/lists/*.lz4 /tmp/* /var/tmp/*; \

    # SSH login fix. Otherwise user is kicked off after login
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd \
    && sed -i -r 's/.?UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config \
    && sed -i -r 's/.?PasswordAuthentication.+/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i -r 's/.?ChallengeResponseAuthentication.+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config; \
    export NOTVISIBLE="in users profile" && \
    echo 'export VISIBLE=now' >> /etc/profile; \

    # Source: https://github.com/ambakshi/dockerfiles/blob/09a05ceab3b5a93c974783ad27a8a6301f3c4ca2/devbox/debian8/Dockerfile
    echo "[ \$UID -eq 0 ] && PS1='\[\e[31m\]\h:\w#\[\e[m\] ' || PS1='[\[\033[32m\]\u@\h\[\033[00m\] \[\033[36m\]\W\[\033[31m\]\$(__git_ps1)\[\033[00m\]] \$ '"  | tee /etc/bash_completion.d/prompt; \

    # create pi user
    set -xe \
    && useradd -U -d ${PI_HOME} -m -r -G adm,sudo,dip,plugdev,tty,audio ${UNAME} \
    && usermod -a -G ${UNAME} -s /bin/bash -u 1000 ${UNAME} \
    && groupmod -g 1000 ${UNAME} \
    && mkdir -p ${PI_HOME}/dev/${GITHUB_REPO_ORG}-github \
    && mkdir -p ${PI_HOME}/dev/${GITHUB_REPO_ORG}-github/${GITHUB_REPO_NAME} \
    && mkdir -p ${MAIN_DIR} \
    && ( mkdir ${PI_HOME}/.ssh \
        && chmod og-rwx ${PI_HOME}/.ssh \
        && echo "${USER_SSH_PUBKEY}" \
            > ${PI_HOME}/.ssh/authorized_keys \
    ) \
    && chown -hR ${UNAME}:${UNAME} ${MAIN_DIR} \
    && echo 'pi     ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo '%pi     ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && cat /etc/sudoers \
    && echo 'pi:raspberry' | chpasswd \
    && mkdir -p "$XDG_RUNTIME_DIR" \
    && chown -R pi:pi "$XDG_RUNTIME_DIR" \
    && chmod -R 0700 "$XDG_RUNTIME_DIR"; \

    # Prepare git to use ssh-agent ( root )
    mkdir -p /root/.ssh && chmod og-rwx /root/.ssh && \
    echo "Host * " > /root/.ssh/config && \
    echo "StrictHostKeyChecking no " >> /root/.ssh/config && \
    echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config; \

    # Prepare git to use ssh-agent ( pi )
    # ********************* PI USER ********************************************
    echo "Host * " > ${PI_HOME}/.ssh/config && \
    echo "StrictHostKeyChecking no " >> ${PI_HOME}/.ssh/config && \
    echo "UserKnownHostsFile=/dev/null" >> ${PI_HOME}/.ssh/config; \

    # Make sure the ruby2.2 packages are installed (Debian)
    add-apt-repository -y ppa:brightbox/ruby-ng && \
    apt-fast update -yqq && \
    export LANG=en_US.UTF-8 && \
    apt-fast install -qqy ruby2.2 ruby2.2-dev && \
    # now that apt-fast is setup, lets clean everything in this layer
    apt-fast autoremove -y && \
    # now clean regular apt-get stuff
    apt-get clean && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{cache,log}/ && \
    rm -rf /var/lib/apt/lists/*.lz4 /tmp/* /var/tmp/*; \

    # Install powerline deps
    # source: https://hub.docker.com/r/namredips/docker-dev/~/dockerfile/
    apt-fast update -yqq && \
    export LANG=en_US.UTF-8 && \
    apt-fast install -y autoconf automake libtool autotools-dev build-essential checkinstall bc ncurses-dev ncurses-term powerline python3-powerline fonts-powerline && \
    # now that apt-fast is setup, lets clean everything in this layer
    apt-fast autoremove -y && \
    # now clean regular apt-get stuff
    apt-get clean && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{cache,log}/ && \
    rm -rf /var/lib/apt/lists/*.lz4 /tmp/* /var/tmp/*; \

    export HOME="/home/$UNAME" && \
    cd /home/$UNAME && \

    # jhbuild config
    echo "import os"                                   > /home/pi/.jhbuildrc && \
    echo "prefix='$PREFIX'"                         >> /home/pi/.jhbuildrc && \
    echo "checkoutroot='$JHBUILD'"                  >> /home/pi/.jhbuildrc && \
    echo "moduleset = 'gnome-world'"                  >> /home/pi/.jhbuildrc && \
    echo "interact = False"                           >> /home/pi/.jhbuildrc && \
    echo "makeargs = '$MAKEFLAGS'"                  >> /home/pi/.jhbuildrc && \
    echo "module_autogenargs['gtk-doc'] = 'PYTHON=/usr/bin/python3'" >> /home/pi/.jhbuildrc && \
    echo "os.environ['CFLAGS'] = '$CFLAGS'"         >> /home/pi/.jhbuildrc && \
    echo "os.environ['PYTHON'] = 'python$PYTHON_VERSION_MAJOR'"           >> /home/pi/.jhbuildrc && \
    echo "os.environ['GSTREAMER'] = '1.0'"            >> /home/pi/.jhbuildrc && \
    echo "os.environ['ENABLE_PYTHON3'] = 'yes'"       >> /home/pi/.jhbuildrc && \
    echo "os.environ['ENABLE_GTK'] = 'yes'"           >> /home/pi/.jhbuildrc && \
    echo "os.environ['PYTHON_VERSION'] = '$PYTHON_VERSION'"       >> /home/pi/.jhbuildrc && \
    echo "os.environ['CFLAGS'] = '-fPIC -O0 -ggdb -fno-inline -fno-omit-frame-pointer'" >> /home/pi/.jhbuildrc && \
    echo "os.environ['MAKEFLAGS'] = '-j4 V=1'"            >> /home/pi/.jhbuildrc && \
    echo "os.environ['PREFIX'] = '$USER_HOME/jhbuild'"   >> /home/pi/.jhbuildrc && \
    echo "os.environ['JHBUILD'] = '$USER_HOME/gnome'"    >> /home/pi/.jhbuildrc && \
    echo "os.environ['PATH'] = '$PREFIX/bin:$PREFIX/sbin:$PATH'" >> /home/pi/.jhbuildrc && \
    echo "os.environ['LD_LIBRARY_PATH'] = '$PREFIX/lib:$LD_LIBRARY_PATH'" >> /home/pi/.jhbuildrc && \
    echo "os.environ['PYTHONPATH'] = '$PREFIX/lib/python$PYTHON_VERSION/site-packages:/usr/lib/python$PYTHON_VERSION/site-packages'" >> /home/pi/.jhbuildrc && \
    echo "os.environ['PKG_CONFIG_PATH'] = '$PREFIX/lib/pkgconfig:$PREFIX/share/pkgconfig:/usr/lib/pkgconfig'" >> /home/pi/.jhbuildrc && \
    echo "os.environ['XDG_DATA_DIRS'] = '$PREFIX/share:/usr/share'" >> /home/pi/.jhbuildrc && \
    echo "os.environ['XDG_CONFIG_DIRS'] = '$PREFIX/etc/xdg'"        >> /home/pi/.jhbuildrc && \
    echo "os.environ['CC'] = 'gcc'"                                   >> /home/pi/.jhbuildrc && \
    echo "os.environ['WORKON_HOME'] = '$USER_HOME/.virtualenvs'"                           >> /home/pi/.jhbuildrc && \
    echo "os.environ['PROJECT_HOME'] = '$USER_HOME/dev'"                                   >> /home/pi/.jhbuildrc && \
    echo "os.environ['VIRTUALENVWRAPPER_PYTHON'] = '$VIRTUALENVWRAPPER_PYTHON'"                  >> /home/pi/.jhbuildrc && \
    echo "os.environ['VIRTUALENVWRAPPER_VIRTUALENV'] = '$VIRTUALENVWRAPPER_VIRTUALENV'"     >> /home/pi/.jhbuildrc && \
    echo "os.environ['PYTHONSTARTUP'] = '$USER_HOME/.pythonrc'"                              >> /home/pi/.jhbuildrc && \
    echo "os.environ['PIP_DOWNLOAD_CACHE'] = '$USER_HOME/.pip/cache'"                        >> /home/pi/.jhbuildrc && \
    cat /home/pi/.jhbuildrc; \

    mkdir -p /home/pi/.local/bin \
    && cp -a /env-setup /home/pi/.local/bin/env-setup \
    && chmod +x /home/pi/.local/bin/env-setup; \

    # NOTE: This should get around any docker permission issues we normally have
    cp -a /scripts/compile_jhbuild_and_deps.sh /home/pi/.local/bin/compile_jhbuild_and_deps.sh \
    && chmod +x /home/pi/.local/bin/compile_jhbuild_and_deps.sh \
    && chown pi:pi /home/pi/.local/bin/compile_jhbuild_and_deps.sh; \

    cp -a /scripts/with-dynenv /usr/local/bin/with-dynenv \
    && chmod +x /usr/local/bin/with-dynenv \
    && chown pi:pi /usr/local/bin/with-dynenv; \

    export CCACHE_DIR=/ccache && \
    mkdir -p /ccache && \
    echo "max_size = 5.0G" > /ccache/ccache.conf && \
    chown -R ${UNAME}:${UNAME} /ccache; \

    # bash-it stuff
    mkdir -p /home/pi/.tmp && \
    chown pi:pi -R /home/pi/.tmp && \
    cd /home/pi/.tmp && \
    git clone --depth=1 https://github.com/Bash-it/bash-it.git /home/pi/.bash_it && \
    /home/pi/.bash_it/install.sh --silent --no-modify-config && \
    git clone --depth 1 https://github.com/sstephenson/bats.git /home/pi/.tmp/bats && \
    /home/pi/.tmp/bats/install.sh /usr/local && \
    chown pi:pi -R /usr/local && \
    chown -R pi:pi /home/pi \
    && \

    # install powerline
    # source: https://github.com/adidenko/powerline
    # source: https://ubuntu-mate.community/t/installing-powerline-as-quickly-as-possible/5381
    mkdir -p /home/pi/.tmp && \
    chown pi:pi -R /home/pi/.tmp && \
    cd /home/pi/.tmp && \
    git clone https://github.com/powerline/fonts.git /home/pi/dev/powerline-fonts \
    && wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf \
    && wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf \
    && mkdir -p /home/pi/.fonts \
    && mv PowerlineSymbols.otf /home/pi/.fonts/ \
    && fc-cache -vf /home/pi/.fonts/ \
    && mkdir -p /home/pi/.config/fontconfig/conf.d/ \
    && mv 10-powerline-symbols.conf /home/pi/.config/fontconfig/conf.d/ \
    && touch /home/pi/.screenrc \
    && sed -i '1i term screen-256color' /home/pi/.screenrc \
    && git clone https://github.com/adidenko/powerline /home/pi/.config/powerline \
    && chown -R pi:pi /home/pi \
    && \

    # rubygem defaults
    cp -f /dotfiles/gemrc /home/pi/.gemrc \
    && chmod 0644 /home/pi/.gemrc \
    && chown pi:pi /home/pi/.gemrc \
    && \

    # pythonrc defaults
    cp -f /dotfiles/pythonrc /home/pi/.pythonrc \
    && chmod 0644 /home/pi/.pythonrc \
    && chown pi:pi /home/pi/.pythonrc; \

    # NOTE: Add proper .profile and .bashrc files
    cp -f /dotfiles/profile /home/pi/.profile \
    && chmod 0644 /home/pi/.profile \
    && chown pi:pi /home/pi/.profile \

    && cp -f /dotfiles/bash_profile /home/pi/.bash_profile \
    && chmod 0644 /home/pi/.bash_profile \
    && chown pi:pi /home/pi/.bash_profile \

    && cp -f /dotfiles/bashrc /home/pi/.bashrc \
    && chmod 0644 /home/pi/.bashrc \
    && chown pi:pi /home/pi/.bashrc \

    && cp -a /dotfiles/bash.functions.d/. /home/pi/bash.functions.d/ \
    && chown pi:pi -R /home/pi/bash.functions.d/ \

    && touch /home/pi/.bash_history \
    && chown pi:pi /home/pi/.bash_history \
    && chmod 0600 /home/pi/.bash_history \
    && mkdir -p /home/pi/.cache \
    && chown pi:pi -R /home/pi/.cache \
    && chmod 0755 /home/pi/.cache

# NOTE: Temp run install as pi user
USER $UNAME

RUN bash /prep-pi.sh && \
    mkdir -p /home/pi/gnome && \
    pip install --user powerline-status && \
    git config --global core.editor "vim" && \
    git config --global push.default simple && \
    git config --global color.ui true && \
    sudo mv /home/pi/.ssh /home/pi/.ssh.bak && \
    sudo mv /home/pi/.ssh.bak /home/pi/.ssh && \
    ls -lta /home/pi/.ssh

# NOTE: Return to root user when finished
USER root

# NOTE: Prepare XDG_RUNTIME_DIR and everything else
# we need to run our scripts correctly
RUN bash /prep-pi.sh && \
    bash /scripts/write_xdg_dir_init.sh "pi" && \
    bash /scripts/write_xdg_dir_init.sh "root"; \

    mkdir -p /artifacts && sudo chown -R pi:pi /artifacts && \
    ls -lta /artifacts

CMD ["/bin/bash", "/run.sh"]

