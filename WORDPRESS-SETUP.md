# Setup WordPress nel Workspace

## ✅ Installazione Automatica nella Build del Container

WordPress è stato completamente automatizzato nella build del container di sviluppo. La seguente procedura viene eseguita automaticamente:

1. **Build Phase** - Durante il build del container:
   - Installa PHP, Apache, MariaDB, WP-CLI
   - Abilita moduli Apache necessari (rewrite, php7.4)

2. **Post-Create Phase** - Dopo la creazione del container:
   - Installa le dipendenze npm (`npm install`)
   - Esegue lo script `init-wordpress.sh` che:
     - Avvia MariaDB
     - Crea il database `wordpress`
     - Scarica l'ultima versione di WordPress
     - Installa WordPress tramite WP-CLI
     - Installa i plugin **FaustWP** e **WP-GraphQL**
     - Configura le URL corrette (supporta Codespaces)

3. **Post-Start Phase** - Ad ogni avvio del container:
   - Avvia i servizi MariaDB e Apache
   - Aggiorna automaticamente l'URL di WordPress se in Codespace

## 🔑 Credenziali di Accesso

### WordPress Admin

- **URL:** `http://localhost:3001/wp-admin`
- **Username:** `admin`
- **Password:** `admin123`

### Database

- **Database:** `wordpress`
- **Utente:** `wp_user`
- **Password:** `wordpress`
- **Host:** `localhost`

## 🌐 URL di Accesso

### Locale (Dev Container)

- 🌍 **WordPress:** `http://localhost:3001`
- 📱 **Next.js Faust:** `http://localhost:3000`
- 🔌 **REST API:** `http://localhost:3001/wp-json`
- 🎯 **GraphQL:** `http://localhost:3001/graphql`

### Codespace

L'URL viene automaticamente rilevato e configurato nel database:

- 🌍 **WordPress:** `https://{CODESPACE_NAME}-3001.{GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}`

WordPress si autoreferenzia correttamente al dominio rilevato automaticamente.

## 📦 Plugin Installati

1. **FaustWP** - Integrazione completa con Faust/Next.js
   - Fornisce le impostazioni per headless WordPress
   - Configura le URL di origine/front-end

2. **WP-GraphQL** - API GraphQL per WordPress
   - Interfaccia GraphQL completa
   - Supporto per query e mutazioni

## 📂 File Principali

### WordPress Installation

- **Root Path:** `/var/www/wordpress`
- **Config:** `/var/www/wordpress/wp-config.php`
- **Temi:** `/var/www/wordpress/wp-content/themes/`
- **Plugin:** `/var/www/wordpress/wp-content/plugins/`
- **Upload Media:** `/var/www/wordpress/wp-content/uploads/`

### Dev Container

- **Dockerfile:** `.devcontainer/Dockerfile` - Configurazione build
- **devcontainer.json:** `.devcontainer/devcontainer.json` - Configurazione container
- **init-wordpress.sh:** `.devcontainer/init-wordpress.sh` - Script di inizializzazione
- **start-services.sh:** `.devcontainer/start-services.sh` - Script di avvio

## 🚀 Comandi Utili

### Verificare lo stato dei servizi

```bash
sudo service mariadb status
sudo service apache2 status
```

### Accedere al database

```bash
sudo mariadb -u wp_user -pwordpress wordpress
```

### WP-CLI - Operazioni comuni

```bash
# Verificare stato WordPress
cd /var/www/wordpress
wp core is-installed

# Elencare plugin
wp plugin list

# Aggiornare WordPress
wp core update

# Elencare utenti
wp user list
```

### Configurare variabili di ambiente

```bash
# Nel file .env.local
NEXT_PUBLIC_WORDPRESS_URL=http://localhost:3001
```

## 🔄 Flusso di Lavoro

1. **Primo avvio container:**
   - Container build → WordPress installato automaticamente → npm install
   - I servizi si avviano automaticamente

2. **Avvio successivi:**
   - I servizi si avviano automaticamente tramite `postStartCommand`
   - URL di WordPress si aggiorna se in Codespace

3. **Sviluppo:**
   - Modifica i file nel workspace
   - Accedi a WordPress admin per gestire contenuti
   - Il frontend Faust si connette tramite le API

## ⚠️ Note Importanti

### Per Produzione

Prima di deploiare in produzione:

1. Cambiare tutte le password
2. Generare nuove chiavi di sicurezza in `wp-config.php`:
   ```php
   define('AUTH_KEY',         'put your unique phrase here');
   define('SECURE_AUTH_KEY',  'put your unique phrase here');
   define('LOGGED_IN_KEY',    'put your unique phrase here');
   define('NONCE_KEY',        'put your unique phrase here');
   ```
3. Configurare HTTPS
4. Impostare backup automatici
5. Verificare i permessi dei file
6. Disabilitare debug mode

### Problemi Comuni

**WordPress non è raggiungibile:**

- Verificare che Apache sia in esecuzione: `sudo service apache2 status`
- Verificare che MariaDB sia in esecuzione: `sudo service mariadb status`
- Controllare i log: `sudo tail -f /var/log/apache2/wordpress-error.log`

**Plugins non si caricano:**

- Verificare i permessi: `sudo chown -R www-data:www-data /var/www/wordpress/wp-content/plugins/`
- Verificare lo spazio disco disponibile

**URL errato in Codespace:**

- Lo script `start-services.sh` aggiorna automaticamente l'URL
- Se non funziona, aggiornare manualmente: `wp option update siteurl "https://..."

## Connessione Faust a WordPress

La configurazione è stata aggiornata in `.env.local`:

```env
NEXT_PUBLIC_WORDPRESS_URL=http://localhost
```

## Accesso ai Servizi

### WordPress Admin

```
http://localhost/wp-admin
```

### Faust Frontend (Next.js)

```
http://localhost:3000
```

### Verifica Connessione

Il frontend Faust si connette a WordPress tramite REST API:

```
http://localhost/wp-json
```

## Comandi Utili

### Avviare i servizi

```bash
sudo service mariadb start
sudo service apache2 start
```

### Fermare i servizi

```bash
sudo service mariadb stop
sudo service apache2 stop
```

### Controllare lo stato

```bash
sudo service mariadb status
sudo service apache2 status
```

### Accedere al database

```bash
sudo mariadb -u wp_user -pwordpress wordpress
```

## File Principali WordPress

- **Configurazione:** `./wordpress/wp-config.php`
- **Theme:** `./wordpress/wp-content/themes/`
- **Plugin:** `./wordpress/wp-content/plugins/`
- **Upload Media:** `./wordpress/wp-content/uploads/`

## Note Importanti

⚠️ Le credenziali attuali sono per lo sviluppo locale. Prima di deploiare in produzione:

1. Cambiare tutte le password
2. Configurare chiavi di sicurezza in `wp-config.php`
3. Abilitare HTTPS
4. Configurare i backup automatici
