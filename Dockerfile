# Bruk offisiell Flutter Docker image
FROM ubuntu:20.04

# Unngå interaktive dialoger under installasjon
ENV DEBIAN_FRONTEND=noninteractive

# Sett arbeidskatalog
WORKDIR /app

# Installer nødvendige verktøy
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Installer Flutter
ENV FLUTTER_HOME=/flutter
ENV FLUTTER_VERSION=3.16.4
RUN git clone --depth 1 --branch $FLUTTER_VERSION https://github.com/flutter/flutter.git $FLUTTER_HOME

# Legg til Flutter i PATH
ENV PATH=$FLUTTER_HOME/bin:$PATH

# Verifiser Flutter installasjon og pre-download Flutter artifacts
RUN flutter doctor -v \
    && flutter config --no-analytics \
    && flutter precache \
    && flutter pub global activate webdev

# Kopier prosjektfiler
COPY . .

# Kjør Flutter kommandoer
RUN flutter clean
RUN flutter pub get
RUN flutter build web --release

# Sett opp web server
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html