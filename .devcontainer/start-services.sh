#!/bin/bash

# Script di avvio dei servizi
set -e

WORDPRESS_PATH="/var/www/wordpress"

echo "🚀 Avvio dei servizi..."

# Avvia MariaDB
echo "Starting MariaDB..."
sudo service mariadb start || true
sleep 1

# Avvia Apache
echo "Starting Apache..."
sudo service apache2 start || true
sleep 1

# Aggiorna l'URL di WordPress se in Codespace
if [ ! -z "${CODESPACE_NAME}" ] && [ -d "${WORDPRESS_PATH}" ]; then
    echo "Aggiornamento URL Codespace in WordPress..."
    WP_URL="https://${CODESPACE_NAME}-3001.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
    
    cd ${WORDPRESS_PATH}
    sudo -u www-data wp option update siteurl "${WP_URL}" --allow-root 2>/dev/null || true
    sudo -u www-data wp option update home "${WP_URL}" --allow-root 2>/dev/null || true
    
    echo "✅ URL aggiornato: ${WP_URL}"
fi

echo "✅ Servizi avviati correttamente!"
