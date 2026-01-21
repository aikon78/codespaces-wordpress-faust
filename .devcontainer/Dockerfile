FROM mcr.microsoft.com/devcontainers/typescript-node:18-bullseye

# Installa dipendenze per WordPress, PHP, Apache e MariaDB
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install --no-install-recommends \
    git \
    curl \
    wget \
    php \
    php-mysql \
    php-cli \
    php-curl \
    php-xml \
    php-mbstring \
    php-json \
    libapache2-mod-php \
    apache2 \
    apache2-utils \
    mariadb-server \
    mariadb-client \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Installa WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Imposta la shell di default
ENV SHELL=/bin/bash

# Abilita moduli Apache necessari
RUN a2enmod rewrite && a2enmod php7.4

# Crea la directory di lavoro
WORKDIR /workspace

# Copia lo script di inizializzazione
COPY .devcontainer/init-wordpress.sh /usr/local/bin/init-wordpress.sh
RUN chmod +x /usr/local/bin/init-wordpress.sh

# Startup script che gestisce WordPress e i servizi
COPY .devcontainer/start-services.sh /usr/local/bin/start-services.sh
RUN chmod +x /usr/local/bin/start-services.sh
