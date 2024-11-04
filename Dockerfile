FROM debian:stable-slim AS build

# install all needed stuff
RUN apt-get update
RUN apt-get install -y git curl unzip 

# define variables
ARG FLUTTER_SDK=/usr/local/flutter
ARG FLUTTER_VERSION=3.24.4
ARG FLUTTER_GIT_URL=https://github.com/flutter/flutter.git
ENV APP_DIRECTORY=/app

# clone flutter
# This gets mad about being on a user defined channel and not matching FLUTTER_GIT_URL
# but seems to work ok, tho we should investigate this
RUN git clone $FLUTTER_GIT_URL $FLUTTER_SDK -b $FLUTTER_VERSION --progress

# setup the flutter path as an enviromental variable
ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:$PATH"

# Start to run Flutter commands
# doctor to see if all was installed ok
RUN flutter config --no-cli-animations --no-analytics
RUN flutter doctor -v

# Create a user and group named flutter to use in child images
RUN groupadd -r flutter && useradd -r -g flutter flutter