FROM docker/dev-environments-default:latest

# Installing necessary dependencies
RUN apt update
RUN apt install -y clang cmake ninja-build pkg-config libgtk-3-dev
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb

RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN code-server --install-extension Dart-Code.dart-code \
                --install-extension Dart-Code.flutter \
                --install-extension alexisvt.flutter-snippets

# Configuring the working directory and user to use
ARG USER=developer
RUN useradd -ms /bin/bash $USER
USER $USER
WORKDIR /home/$USER

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git

# Setup PATH environment variable
ENV PATH $PATH:/home/$USER/flutter/bin

# Verify the status licenses
RUN yes | flutter doctor -v
