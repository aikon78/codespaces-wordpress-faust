#!/bin/bash

# Script di inizializzazione di WordPress
set -e

WORDPRESS_PATH="/var/www/wordpress"
DB_NAME="wordpress"
DB_USER="wp_user"
DB_PASS="wordpress"
DB_HOST="localhost"

# Colori per output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 Inizializzazione WordPress...${NC}"

# 1. Avvia MariaDB se non è già in esecuzione
echo -e "${BLUE}1️⃣ Avvio MariaDB...${NC}"
sudo service mariadb start || true
sleep 2

# 2. Crea il database e l'utente se non esistono
echo -e "${BLUE}2️⃣ Configurazione database...${NC}"
sudo mariadb -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
sudo mariadb -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASS}';"
sudo mariadb -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'${DB_HOST}';"
sudo mariadb -e "FLUSH PRIVILEGES;"

# 3. Scarica e installa WordPress se non esiste
if [ ! -d "${WORDPRESS_PATH}" ]; then
    echo -e "${BLUE}3️⃣ Download WordPress...${NC}"
    cd /tmp
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    
    echo -e "${BLUE}4️⃣ Installazione file WordPress...${NC}"
    sudo mkdir -p ${WORDPRESS_PATH}
    sudo cp -r /tmp/wordpress/* ${WORDPRESS_PATH}/
    sudo chown -R www-data:www-data ${WORDPRESS_PATH}
    sudo chmod -R 755 ${WORDPRESS_PATH}
    
    rm -rf /tmp/wordpress /tmp/latest.tar.gz
else
    echo -e "${BLUE}3️⃣ WordPress già installato, configurazione database...${NC}"
fi

# 4. Copia e configura wp-config.php
if [ ! -f "${WORDPRESS_PATH}/wp-config.php" ]; then
    echo -e "${BLUE}5️⃣ Configurazione wp-config.php...${NC}"
    sudo cp ${WORDPRESS_PATH}/wp-config-sample.php ${WORDPRESS_PATH}/wp-config.php
    
    sudo sed -i "s/database_name_here/${DB_NAME}/g" ${WORDPRESS_PATH}/wp-config.php
    sudo sed -i "s/username_here/${DB_USER}/g" ${WORDPRESS_PATH}/wp-config.php
    sudo sed -i "s/password_here/${DB_PASS}/g" ${WORDPRESS_PATH}/wp-config.php
    sudo sed -i "s/localhost/${DB_HOST}/g" ${WORDPRESS_PATH}/wp-config.php
fi

# 5. Installa WordPress tramite WP-CLI se non è ancora installato
echo -e "${BLUE}6️⃣ Installazione WordPress tramite WP-CLI...${NC}"
cd ${WORDPRESS_PATH}

if ! sudo -u www-data wp core is-installed --allow-root 2>/dev/null; then
    echo "WordPress non ancora installato, procedo con installazione..."
    
    sudo -u www-data wp core install \
        --url="http://localhost:3001" \
        --title="WordPress Faust" \
        --admin_user="admin" \
        --admin_password="admin123" \
        --admin_email="admin@localhost.local" \
        --allow-root
    
    echo -e "${GREEN}✅ WordPress installato${NC}"
else
    echo -e "${GREEN}✅ WordPress già installato${NC}"
fi

# 6. Installa i plugin FaustWP e WP-GraphQL
echo -e "${BLUE}7️⃣ Installazione plugin FaustWP...${NC}"
sudo -u www-data wp plugin install faustwp --activate --allow-root || true

echo -e "${BLUE}8️⃣ Installazione plugin WP-GraphQL...${NC}"
sudo -u www-data wp plugin install wp-graphql --activate --allow-root || true

# 7. Ottiene l'URL corrente per configurare WordPress
echo -e "${BLUE}9️⃣ Configurazione URL per Codespace...${NC}"
# Se siamo in Codespace, rileva l'URL dinamico
if [ ! -z "${CODESPACE_NAME}" ]; then
    WP_URL="https://${CODESPACE_NAME}-3001.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
    echo "Rilevato Codespace: ${WP_URL}"
    sudo -u www-data wp option update siteurl "${WP_URL}" --allow-root || true
    sudo -u www-data wp option update home "${WP_URL}" --allow-root || true
else
    # Fallback per ambiente locale
    WP_URL="http://localhost:3001"
    sudo -u www-data wp option update siteurl "${WP_URL}" --allow-root || true
    sudo -u www-data wp option update home "${WP_URL}" --allow-root || true
fi

# 8. Configura il VirtualHost di Apache
echo -e "${BLUE}🔟 Configurazione Apache VirtualHost...${NC}"
if [ ! -f "/etc/apache2/sites-available/wordpress.conf" ]; then
    sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null << 'EOF'
<VirtualHost *:80>
    ServerName localhost
    ServerAlias wordpress.local *.local
    DocumentRoot /var/www/wordpress

    <Directory /var/www/wordpress>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/wordpress-error.log
    CustomLog ${APACHE_LOG_DIR}/wordpress-access.log combined
</VirtualHost>
EOF
    sudo a2ensite wordpress
fi

# 9. Riavvia Apache
echo -e "${BLUE}1️⃣1️⃣ Riavvio Apache...${NC}"
sudo service apache2 restart || true

echo -e "${GREEN}✅ Inizializzazione WordPress completata!${NC}"
echo ""
echo -e "${GREEN}📋 Credenziali:${NC}"
echo "  Admin URL: http://localhost:3001/wp-admin"
echo "  Username: admin"
echo "  Password: admin123"
echo ""
echo -e "${GREEN}📌 URL WordPress: http://localhost:3001${NC}"
echo -e "${GREEN}📌 REST API: http://localhost:3001/wp-json${NC}"
echo -e "${GREEN}📌 GraphQL: http://localhost:3001/graphql${NC}"
