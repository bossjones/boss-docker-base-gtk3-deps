#!/usr/bin/env bash

mkdir -p /home/pi/gnome

# Install jhbuild if not done
if [[ ! -f "/usr/local/bin/jhbuild" ]] && [[ -f "/home/pi/jhbuild/autogen.sh" ]] || [[ "${FORCE_BUILD_JHBUILD}" = "" ]]; then
    echo "****************[JHBUILD]****************" && \
    cd /home/pi && \
    if test ! -d /home/pi/jhbuild; then git clone https://github.com/GNOME/jhbuild.git && \
    cd jhbuild; else echo "exists" && cd jhbuild; fi && \
    git checkout 86d958b6778da649b559815c0a0dbe6a5d1a8cd4 && \
    ./autogen.sh --prefix=/usr/local > /dev/null && \
    make > /dev/null && \
    sudo make install > /dev/null && \
    sudo chown pi:pi -R /usr/local/ && \
    chown pi:pi -R /home/pi/jhbuild && \

    echo "****************[GTK-DOC]****************" && \
    cd /home/pi/gnome && \
    git clone https://github.com/GNOME/gtk-doc.git && \
    jhbuild buildone -n gtk-doc && \

    echo "****************[GLIB]****************" && \
    cd /home/pi/gnome && \
    git clone https://github.com/GNOME/glib.git && \
    cd glib && \
    git checkout eaca4f4116801f99e30e42a857559e19a1e6f4ce && \
    jhbuild buildone -n glib && \

    echo "****************[GOBJECT-INTROSPECTION]****************" && \
    cd /home/pi/gnome && \
    git clone https://github.com/GNOME/gobject-introspection.git && \
    cd gobject-introspection && \
    git checkout cee2a4f215d5edf2e27b9964d3cfcb28a9d4941c && \
    jhbuild buildone -n gobject-introspection && \

    echo "****************[PYGOBJECT]****************" && \
    cd /home/pi/gnome && \
    git clone https://github.com/GNOME/pygobject.git && \
    cd /home/pi/gnome && \
    cd pygobject && \
    git checkout fb1b8fa8a67f2c7ea7ad4b53076496a8f2b4afdb && \
    jhbuild run ./autogen.sh --prefix=/home/pi/jhbuild --with-python=$(which python3) > /dev/null && \
    jhbuild run make install > /dev/null && \

    echo "****************[GSTREAMER]****************" && \
    cd /home/pi/gnome && \
    curl -L "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.8.2.tar.xz" > gstreamer-1.8.2.tar.xz && \
    tar -xJf gstreamer-1.8.2.tar.xz && \
    cd gstreamer-1.8.2 && \
    jhbuild run ./configure --enable-doc-installation=no --prefix=/home/pi/jhbuild > /dev/null && \
    jhbuild run make -j4  > /dev/null && \
    jhbuild run make install > /dev/null && \

    echo "****************[ORC]****************" && \
    cd /home/pi/gnome && \
    curl -L "https://gstreamer.freedesktop.org/src/orc/orc-0.4.25.tar.xz" > orc-0.4.25.tar.xz && \
    tar -xJf orc-0.4.25.tar.xz && \
    cd orc-0.4.25 && \
    jhbuild run ./configure --prefix=/home/pi/jhbuild > /dev/null && \
    jhbuild run make -j4  > /dev/null && \
    jhbuild run make install > /dev/null && \

    echo "****************[GST-PLUGINS-BASE]****************" && \
    cd /home/pi/gnome && \
    curl -L "http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.8.2.tar.xz" > gst-plugins-base-1.8.2.tar.xz && \
    tar -xJf gst-plugins-base-1.8.2.tar.xz && \
    cd gst-plugins-base-1.8.2 && \
    jhbuild run ./configure --prefix=/home/pi/jhbuild --enable-orc --with-x > /dev/null && \
    jhbuild run make -j4  > /dev/null && \
    jhbuild run make install > /dev/null && \

    echo "****************[GST-PLUGINS-GOOD]****************" && \
    cd /home/pi/gnome && \
    curl -L "http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.8.2.tar.xz" > gst-plugins-good-1.8.2.tar.xz && \
    tar -xJf gst-plugins-good-1.8.2.tar.xz && \
    cd gst-plugins-good-1.8.2 && \
    jhbuild run ./configure --prefix=/home/pi/jhbuild --enable-orc --with-libv4l2 --with-x  > /dev/null && \
    jhbuild run make -j4  > /dev/null && \
    jhbuild run make install > /dev/null && \

    echo "****************[GST-PLUGINS-UGLY]****************" && \
    cd /home/pi/gnome && \
    curl -L "http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.8.2.tar.xz" > gst-plugins-ugly-1.8.2.tar.xz && \
    tar -xJf gst-plugins-ugly-1.8.2.tar.xz && \
    cd gst-plugins-ugly-1.8.2 && \
    jhbuild run ./configure --prefix=/home/pi/jhbuild --enable-orc  > /dev/null && \
    jhbuild run make -j4  > /dev/null && \
    jhbuild run make install > /dev/null && \

    echo "****************[GST-PLUGINS-BAD]****************" && \
    cat /home/pi/jhbuild/bin/gdbus-codegen && \
    export BOSSJONES_PATH_TO_PYTHON=$(which python3) && \
    sed -i "s,#!python3,#!/usr/bin/python3,g" /home/pi/jhbuild/bin/gdbus-codegen && \
    cat /home/pi/jhbuild/bin/gdbus-codegen && \
    cd /home/pi/gnome && \
    curl -L "http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.8.2.tar.xz" > gst-plugins-bad-1.8.2.tar.xz && \
    tar -xJf gst-plugins-bad-1.8.2.tar.xz && \
    cd gst-plugins-bad-1.8.2 && \
    jhbuild run ./configure --prefix=/home/pi/jhbuild --enable-orc  > /dev/null && \
    jhbuild run make -j4  > /dev/null && \
    jhbuild run make install > /dev/null && \

    echo "****************[GST-LIBAV]****************" && \
    cd /home/pi/gnome && \
    curl -L "http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.8.2.tar.xz" > gst-libav-1.8.2.tar.xz && \
    tar -xJf gst-libav-1.8.2.tar.xz && \
    cd gst-libav-1.8.2 && \
    jhbuild run ./configure --prefix=/home/pi/jhbuild --enable-orc  > /dev/null && \
    jhbuild run make -j4  > /dev/null && \
    jhbuild run make install > /dev/null && \

    echo "****************[GST-PLUGINS-ESPEAK]****************" && \
    cd $JHBUILD && \
    curl -L "https://github.com/bossjones/bossjones-gst-plugins-espeak-0-4-0/archive/v0.4.1.tar.gz" > gst-plugins-espeak-0.4.0.tar.gz && \
    tar xvf gst-plugins-espeak-0.4.0.tar.gz && \
    rm -rfv gst-plugins-espeak-0.4.0 && \
    mv -fv bossjones-gst-plugins-espeak-0-4-0-0.4.1 gst-plugins-espeak-0.4.0 && \
    cd gst-plugins-espeak-0.4.0 && \
    jhbuild run ./configure --prefix=/home/pi/jhbuild > /dev/null && \
    jhbuild run make > /dev/null && \
    jhbuild run make install > /dev/null && \

    echo "****************[SPHINXBASE]****************" && \
    cd $JHBUILD && \
    git clone https://github.com/cmusphinx/sphinxbase.git && \
    cd sphinxbase && \
    git checkout 74370799d5b53afc5b5b94a22f5eff9cb9907b97 && \
    cd $JHBUILD/sphinxbase && \
    jhbuild run ./autogen.sh --prefix=/home/pi/jhbuild > /dev/null && \
    jhbuild run ./configure --prefix=/home/pi/jhbuild > /dev/null && \
    jhbuild run make clean all > /dev/null && \
    jhbuild run make install > /dev/null && \

    echo "****************[POCKETSPHINX]****************" && \
    cd $JHBUILD && \
    git clone https://github.com/cmusphinx/pocketsphinx.git && \
    cd pocketsphinx && \
    git checkout 68ef5dc6d48d791a747026cd43cc6940a9e19f69 && \
    jhbuild run ./autogen.sh --prefix=/home/pi/jhbuild > /dev/null && \
    jhbuild run ./configure --prefix=/home/pi/jhbuild > /dev/null && \
    jhbuild run make clean all > /dev/null && \
    jhbuild run make install > /dev/null && \

    echo "****************[GDBINIT]****************" && \
    sudo zcat /usr/share/doc/python3.5/gdbinit.gz | tee /home/pi/.gdbinit && \
    sudo chown pi:pi /home/pi/.gdbinit && \

    echo "****************[GSTREAMER-COMPLETION]****************" && \
    curl -L "https://raw.githubusercontent.com/drothlis/gstreamer/bash-completion-master/tools/gstreamer-completion" | sudo tee -a /etc/bash_completion.d/gstreamer-completion && \
    sudo chown root:root /etc/bash_completion.d/gstreamer-completion
else
    # if we don't need to re-build
    echo "****************[HEY GUESS WHAT]****************"
    echo "****************[JHBUILD IS RDY]****************"
    [[ ! -f "/usr/local/bin/jhbuild" ]] && echo 'TRUE: ! -f "/usr/local/bin/jhbuild"' || echo 'FALSE: ! -f "/usr/local/bin/jhbuild"'
    [[ -f "/home/pi/jhbuild/autogen.sh" ]] && echo 'TRUE: -f "/home/pi/jhbuild/autogen.sh"' || echo 'FALSE: -f "/home/pi/jhbuild/autogen.sh"'
    [[ $FORCE_BUILD_JHBUILD = 1 ]] && echo 'TRUE: $FORCE_BUILD_JHBUILD = 1' || echo 'FALSE: $FORCE_BUILD_JHBUILD = 1'
fi
