#!/bin/bash

# Script per verificare e configurare l'ambiente WordPress per Codespace
# Utile se l'URL non viene aggiornato automaticamente

WORDPRESS_PATH="/var/www/wordpress"

if [ ! -d "$WORDPRESS_PATH" ]; then
    echo "❌ WordPress non trovato in $WORDPRESS_PATH"
    exit 1
fi

echo "🔍 Verificazione ambiente WordPress..."
echo ""

# Verificare se WordPress è installato
cd "$WORDPRESS_PATH"
if sudo -u www-data wp core is-installed --allow-root 2>/dev/null; then
    echo "✅ WordPress è installato"
else
    echo "❌ WordPress non è ancora installato"
    exit 1
fi

echo ""
echo "📋 Informazioni attuali:"
echo "URL Siteurl: $(sudo -u www-data wp option get siteurl --allow-root)"
echo "URL Home: $(sudo -u www-data wp option get home --allow-root)"
echo ""

# Se in Codespace, aggiornare l'URL
if [ ! -z "${CODESPACE_NAME}" ]; then
    WP_URL="https://${CODESPACE_NAME}-3001.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
    echo "📱 Rilevato ambiente Codespace"
    echo "Nuovo URL: $WP_URL"
    echo ""
    
    echo "🔄 Aggiornamento URL..."
    sudo -u www-data wp option update siteurl "$WP_URL" --allow-root
    sudo -u www-data wp option update home "$WP_URL" --allow-root
    
    echo "✅ URL aggiornato correttamente"
else
    echo "💻 Ambiente locale"
    WP_URL="http://localhost:3001"
    echo "URL: $WP_URL"
fi

echo ""
echo "🔗 Verificazione plugin FaustWP e WP-GraphQL:"
sudo -u www-data wp plugin list --allow-root | grep -E "faustwp|wp-graphql"

echo ""
echo "✅ Verifica completata"
