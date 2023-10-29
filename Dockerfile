FROM docker/dev-environments-default:latest

RUN apt update
RUN apt install -y clang cmake ninja-build pkg-config libgtk-3-dev
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb
RUN apt install -y nginx

ARG USER=developer
ARG USER_UID=2000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USER \
    && useradd --uid $USER_UID --gid $USER_GID -m $USER \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR /home/$USER

RUN git clone https://github.com/flutter/flutter.git

ENV PATH $PATH:/home/$USER/flutter/bin

RUN yes | flutter doctor -v

EXPOSE 80

SHELL ["/bin/bash", "-c"]
