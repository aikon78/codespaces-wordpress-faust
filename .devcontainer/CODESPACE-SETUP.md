# Deployment Dev Container per Codespace

## Introduzione

Questo progetto è completamente configurato per funzionare in Codespace di GitHub con WordPress, Faust e i plugin necessari pre-installati e automaticamente configurati.

## Come Usare

### 1. Avviare il Codespace

- Apri il repository su GitHub
- Clicca su **Code** → **Codespaces** → **Create codespace on main**
- Aspetta il completamento della build del container (~5-10 minuti al primo avvio)

### 2. Al Primo Avvio

Il container eseguirà automaticamente:

1. **Build** (Dockerfile):
   - Installa PHP, Apache, MariaDB, WP-CLI

2. **Post-Create** (init-wordpress.sh):
   - Installa WordPress
   - Crea il database
   - Installa plugin FaustWP e WP-GraphQL

3. **Post-Start** (start-services.sh):
   - Avvia i servizi
   - Configura l'URL automaticamente

### 3. Accedere ai Servizi

Una volta completata la build, VS Code notificherà le porte forwarded:

- **WordPress Admin**: Clicca su "Open in Browser" per la porta 3001
- **Next.js Frontend**: Clicca su "Open in Browser" per la porta 3000

### 4. Login WordPress

```
URL: https://{CODESPACE_NAME}-3001.{GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}
Username: admin
Password: admin123
```

## Struttura del Progetto

```
.devcontainer/
├── Dockerfile              # Build image con PHP, Apache, MariaDB
├── devcontainer.json       # Configurazione VS Code dev container
├── init-wordpress.sh       # Script installazione WordPress (postCreateCommand)
├── start-services.sh       # Script avvio servizi (postStartCommand)
├── verify-wordpress.sh     # Script verifica WordPress
├── .dockerignore           # File esclusei dalla build Docker
└── README.md               # Documentazione tecnica

.env.local                  # Configurazione Faust (NEXT_PUBLIC_WORDPRESS_URL)
WORDPRESS-SETUP.md          # Guida setup e utilizzo
```

## Personalizzazioni

### Aggiungere Plugin Aggiuntivi

Modificare `.devcontainer/init-wordpress.sh`:

```bash
# Aggiungere prima della riga di Faust
sudo -u www-data wp plugin install nuovo-plugin --activate --allow-root
```

### Aggiungere Estensioni PHP

Modificare `.devcontainer/Dockerfile`:

```dockerfile
# Aggiungere nella sezione RUN apt-get install
php-imagick \
php-redis \
```

### Modificare Credenziali Database

Modificare `.devcontainer/init-wordpress.sh`:

```bash
DB_NAME="nuovo_nome"
DB_USER="nuovo_utente"
DB_PASS="nuova_password"
```

## Troubleshooting

### WordPress non è raggiungibile

1. Verificare che i servizi siano in esecuzione:

   ```bash
   sudo service mariadb status
   sudo service apache2 status
   ```

2. Se non sono in esecuzione:

   ```bash
   sudo service mariadb start
   sudo service apache2 start
   ```

3. Verificare i log:
   ```bash
   sudo tail -f /var/log/apache2/wordpress-error.log
   ```

### URL non è aggiornato in Codespace

Eseguire manualmente lo script di verifica:

```bash
/usr/local/bin/verify-wordpress.sh
```

O aggiornare manualmente:

```bash
cd /var/www/wordpress
wp option update siteurl "https://YOUR-CODESPACE-URL"
wp option update home "https://YOUR-CODESPACE-URL"
```

### Plugin non compaiono

Verificare i permessi:

```bash
sudo chown -R www-data:www-data /var/www/wordpress/wp-content/plugins/
sudo chmod -R 755 /var/www/wordpress
```

Riavviare Apache:

```bash
sudo service apache2 restart
```

## Variabili di Ambiente

Durante la build in Codespace, vengono rilevate:

- `CODESPACE_NAME` - Nome del codespace
- `GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN` - Dominio di forwarding

Usate automaticamente per configurare l'URL di WordPress.

## Database Persistence

I dati del database MariaDB persistono tra i riavvii del Codespace grazie al volume Docker della workspace.

Se necessario resettare il database:

```bash
sudo mariadb -e "DROP DATABASE wordpress;"
sudo mariadb -e "CREATE DATABASE wordpress;"
sudo mariadb -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';"
```

Quindi reinstallare WordPress:

```bash
cd /var/www/wordpress
wp core install --url="..." --title="..." --admin_user="..." --admin_password="..." --admin_email="..."
```

## Ottimizzazioni per Produzione

Prima di usare questo setup in produzione:

1. Cambiar tutte le password
2. Disabilitare debug mode
3. Configurare HTTPS con certificati reali
4. Impostare backup automatici
5. Configurare rate limiting e firewall
6. Ottimizzare database
7. Impostare CDN per media

## Support e Documentazione

- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
- [GitHub Codespaces](https://docs.github.com/en/codespaces)
- [WordPress Docker Best Practices](https://developer.wordpress.org/plugins/deployment/)
- [FaustWP Documentation](https://faustjs.org/)
- [WP-GraphQL Documentation](https://www.wpgraphql.com/)
