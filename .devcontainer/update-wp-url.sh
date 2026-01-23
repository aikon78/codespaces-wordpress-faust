#!/bin/bash
# Aggiorna dinamicamente WP_HOME e WP_SITEURL per Codespace

if [ -n "$CODESPACE_NAME" ]; then
    WP_URL="https://${CODESPACE_NAME}-3001.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
    echo "🔄 Aggiornamento URL WordPress: $WP_URL"
    
    # Attendi che WordPress sia pronto
    for i in {1..30}; do
        if curl -s http://wordpress:80 > /dev/null 2>&1; then
            break
        fi
        sleep 1
    done
    
    # Esporta variabili per docker-compose
    export WP_HOME="$WP_URL"
    export WP_SITEURL="$WP_URL"
    
    # Aggiorna DB (se wp-cli è disponibile nel container app)
    if command -v wp &> /dev/null; then
        wp db set-charset utf8mb4 --allow-root 2>/dev/null || true
    fi
    
    echo "✅ URL configurato"
else
    echo "ℹ️ Ambiente locale - URL: http://localhost:3001"
fi
