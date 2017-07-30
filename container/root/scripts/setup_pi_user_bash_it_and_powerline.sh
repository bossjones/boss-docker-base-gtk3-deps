#!/usr/bin/env bash

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

# install powershell
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
&& chown pi:pi /home/pi/.pythonrc

# FIXME: MIGHT NOT NEED THIS
# mkdir -p /home/pi/.bash_it/{plugins,aliases,completion}/enabled && \
# for i in "base history"; do ln -s /home/pi/.bash_it/plugins/available/${i}.plugin.bash /home/pi/.bash_it/plugins/enabled/${i}.plugin.bash; done && \
# for i in "general"; do ln -s /home/pi/.bash_it/plugins/available/${i}.aliases.bash /home/pi/.bash_it/plugins/enabled/${i}.aliases.bash; done && \
# for i in "git"; do ln -s /home/pi/.bash_it/plugins/available/${i}.completion.bash /home/pi/.bash_it/plugins/enabled/${i}.completion.bash; done && \
