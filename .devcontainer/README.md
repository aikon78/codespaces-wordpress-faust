# Dev Container Configuration

## Componenti Automatizzati

### Dockerfile

Configura l'immagine Docker con:

- Node.js 18 TypeScript base
- PHP 7.4 e Apache 2.4
- MariaDB 10.5
- WP-CLI per la gestione di WordPress

### devcontainer.json

Configurazione del container di sviluppo con:

- Build automatico del Dockerfile
- Forwarding porte: 3000 (Next.js), 3001 (WordPress), 80 (Apache)
- Script di inizializzazione automatici
- Estensioni VS Code consigliate

### init-wordpress.sh

Script eseguito al primo avvio (`postCreateCommand`) che:

1. Avvia MariaDB
2. Crea database e utente WordPress
3. Scarica e installa WordPress
4. Installa e attiva plugin FaustWP e WP-GraphQL
5. Configura URL di WordPress (supporta Codespaces)

### start-services.sh

Script eseguito ad ogni avvio (`postStartCommand`) che:

1. Avvia i servizi MariaDB e Apache
2. Aggiorna URL di WordPress se in Codespace

## Processo di Build

### Fase 1: Build (Dockerfile)

```
1. Base image: mcr.microsoft.com/devcontainers/typescript-node:18-bullseye
2. Installa: PHP, Apache, MariaDB, WP-CLI
3. Abilita: moduli Apache (rewrite, php7.4)
4. Copia: script di inizializzazione
```

### Fase 2: Post-Create

```
1. npm install (installa dipendenze Node.js)
2. init-wordpress.sh (installa WordPress e plugin)
```

### Fase 3: Post-Start (Ogni avvio)

```
1. start-services.sh (avvia servizi)
2. Aggiornamento URL Codespace (se applicabile)
```

## Variabili di Ambiente Rilevate

Il container rileva automaticamente:

- `CODESPACE_NAME` - Nome del Codespace (per URL dinamico)
- `GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN` - Dominio di port forwarding

Se rilevate, WordPress si autoreferenzia correttamente all'URL HTTPS generato automaticamente.

## Personalizzazione

Per modificare il comportamento:

1. **Cambiar versione PHP:**
   - Modificare `libapache2-mod-php` in Dockerfile

2. **Aggiungere plugin WordPress:**
   - Aggiungere righe in `init-wordpress.sh`:

   ```bash
   sudo -u www-data wp plugin install plugin-name --activate --allow-root
   ```

3. **Cambiar credenziali default:**
   - Modificare in `init-wordpress.sh`:

   ```bash
   DB_NAME="wordpress"
   DB_USER="wp_user"
   DB_PASS="wordpress"
   ```

4. **Aggiungere estensioni VS Code:**
   - Modificare `devcontainer.json` nella sezione `customizations.vscode.extensions`

## Troubleshooting

### WordPress non è raggiungibile

```bash
# Verificare Apache
sudo service apache2 status
sudo service apache2 restart

# Verificare MariaDB
sudo service mariadb status

# Controllare log
tail -f /var/log/apache2/wordpress-error.log
tail -f /var/log/apache2/wordpress-access.log
```

### WP-CLI non è trovato

```bash
which wp
# Dovrebbe essere: /usr/local/bin/wp
```

### Permessi file WordPress

```bash
sudo chown -R www-data:www-data /var/www/wordpress
sudo chmod -R 755 /var/www/wordpress
```

## Note Importanti

- I dati del database e i file WordPress persistono tra gli avvii del container
- Le credenziali default sono solo per sviluppo locale
- In Codespace, l'URL viene automaticamente aggiornato al dominio HTTPS assegnato
- I plugin FaustWP e WP-GraphQL sono installati e attivi di default
