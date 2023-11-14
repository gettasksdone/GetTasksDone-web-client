# Solution to make xrdp work:
# https://dev.to/darksmile92/linux-on-windows-wsl-with-desktop-environment-via-rdp-522g#comment-obea

FROM ubuntu:latest

RUN apt update

# Install xrdp and xfce4
RUN apt install -y xrdp xfce4 xfce4-goodies

# Install Flutter development dependencies
RUN apt install -y clang cmake ninja-build pkg-config libgtk-3-dev

RUN apt install -y wget curl unzip git sudo nano

# Install Google Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb

RUN useradd -rm -d /home/developer -s /bin/bash -g root -G sudo -u 1001 -p "$(openssl passwd -1 developer)" developer

# xrdp and xfce4 setup
RUN cp /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.ini.bak
RUN sed -i 's/max_bpp=32/#max_bpp=32\nmax_bpp=128/g' /etc/xrdp/xrdp.ini
RUN sed -i 's/xserverbpp=24/#xserverbpp=24\nxserverbpp=128/g' /etc/xrdp/xrdp.ini
RUN cd /home/developer && echo xfce4-session > .xsession
RUN sed -i "s|test -x /etc/X11/Xsession && exec /etc/X11/Xsession||g" /etc/xrdp/startwm.sh
RUN sed -i "s|exec /bin/sh /etc/X11/Xsession||g" /etc/xrdp/startwm.sh
RUN echo "startxfce4" >> /etc/xrdp/startwm.sh

USER developer

# Install Flutter
RUN cd /home/developer && git clone https://github.com/flutter/flutter.git
ENV PATH $PATH:/home/developer/flutter/bin
RUN yes | flutter doctor -v

WORKDIR /home/developer/app
