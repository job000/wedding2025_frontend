FROM debian:latest AS build-env

# System deps
RUN apt-get update && \
    apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 && \
    apt-get clean

# Create user
RUN useradd -ms /bin/bash developer
USER developer

# Download Flutter SDK with retry
RUN for i in {1..3}; do \
    git clone --depth 1 --branch stable https://github.com/flutter/flutter.git /home/developer/flutter && break || \
    sleep 5; \
    done

WORKDIR /home/developer/flutter
ENV PATH="/home/developer/flutter/bin:/home/developer/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Flutter setup
RUN flutter doctor -v && \
    flutter config --enable-web

# Copy project files
WORKDIR /home/developer/app
COPY --chown=developer:developer . .

# Build
RUN flutter clean && \
    flutter pub get && \
    flutter build web --release

# Production stage
FROM nginx:1.21.1-alpine
COPY --from=build-env /home/developer/app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf