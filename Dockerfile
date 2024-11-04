FROM debian:stable-slim AS build

ENV DEBIAN_FRONTEND=noninteractive

# Install all needed stuff and clean up APT cache
RUN apt-get update && \
    apt-get install -y git curl unzip && \
    rm -rf /var/lib/apt/lists/*

# Define variables
ARG FLUTTER_SDK=/flutter
ARG FLUTTER_VERSION=3.24.4
ARG FLUTTER_GIT_URL=https://github.com/flutter/flutter.git

# Create a user and group named flutter to use in child images
# and to install flutter so it doesn't get mad about using super user
RUN groupadd -r flutter && useradd -r -g flutter -m flutter

# Create the Flutter SDK directory and change its ownership
RUN mkdir -p $FLUTTER_SDK && chown flutter:flutter $FLUTTER_SDK

# Switch to the flutter user
USER flutter

# Clone Flutter
# This gets mad about being on a user-defined channel and not matching FLUTTER_GIT_URL
# but seems to work ok, though we should investigate this
RUN git clone $FLUTTER_GIT_URL $FLUTTER_SDK -b $FLUTTER_VERSION --progress

# Setup the Flutter path as an environmental variable
ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:$PATH"

# Start to run Flutter commands
# Doctor to see if all was installed ok
RUN flutter config --no-cli-animations --no-analytics --enable-web
RUN flutter doctor -v
