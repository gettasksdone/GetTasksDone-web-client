FROM docker/dev-environments-default:latest

RUN apt update
RUN apt install -y clang cmake ninja-build pkg-config libgtk-3-dev
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb

ARG USER=developer
RUN useradd -ms /bin/bash developer
USER $USER
WORKDIR /home/$USER

RUN git clone https://github.com/flutter/flutter.git

ENV PATH $PATH:/home/$USER/flutter/bin

RUN yes | flutter doctor -v
