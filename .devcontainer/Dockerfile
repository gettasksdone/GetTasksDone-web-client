FROM ubuntu:latest

ARG USER="developer"

RUN apt update

# Install Flutter development dependencies
RUN apt install -y clang cmake ninja-build pkg-config libgtk-3-dev

RUN apt install -y wget curl unzip git sudo nano

# Install Google Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb

RUN useradd -rm -d /home/${USER} -s /bin/bash -g root -G sudo -u 1001 -p "$(openssl passwd -1 ${USER})" ${USER}

USER ${USER}

# Install Flutter
RUN cd /home/${USER} && git clone https://github.com/flutter/flutter.git
ENV PATH $PATH:/home/${USER}/flutter/bin
RUN yes | flutter doctor -v

WORKDIR /home/${USER}/app
