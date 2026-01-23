# Setup Semplificato WordPress + Faust.js

## Architettura

```
┌─────────────────────────────────────┐
│ Container: app (Node.js 20)         │
│ - Next.js/Faust dev                 │
│ - Porta 3000                        │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│ Container: wordpress                │
│ - WordPress ufficiale               │
│ - Porta 3001 (HTTP 80)              │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│ Container: db (MariaDB)             │
│ - Database persistente              │
└─────────────────────────────────────┘
```

## Volumi Persistenti

- `db_data`: Database MariaDB (tutto persiste automaticamente)
- `wp_data`: Tutti i file WordPress (core, plugin, temi, uploads)

## URL Automatici

- **Codespace**: `https://{CODESPACE}-3001.app.github.dev`
- **Locale**: `http://localhost:3001`

Lo script `update-wordpress-url.sh` aggiorna automaticamente il DB ad ogni avvio.

## Prima Installazione

1. Rebuild del Codespace
2. Apri `https://{CODESPACE}-3001.app.github.dev`
3. Completa wizard WordPress (5 minuti)
4. Installa plugin FaustWP e WP-GraphQL
5. Copia FAUST_SECRET_KEY in `.env.local`

## Credenziali Default

Durante il wizard WordPress imposta:
- **Username**: a tua scelta
- **Password**: a tua scelta
- **Email**: a tua scelta

Database (già configurato):
- **Nome**: wordpress
- **Utente**: wordpress  
- **Password**: wordpress
- **Host**: db

## Comandi Utili

```bash
# Avvia dev server Next.js
npm run dev

# Accedi al container WordPress
docker exec -it $(docker ps -qf "name=wordpress") bash

# WP-CLI nel container WordPress
docker exec -it $(docker ps -qf "name=wordpress") wp --info --allow-root

# Aggiorna manualmente URL
bash .devcontainer/update-wordpress-url.sh
```

## File Rimossi

I seguenti file del vecchio setup sono ora obsoleti:
- `Dockerfile` (sostituito da docker-compose)
- `init-wordpress.sh` (WordPress si auto-installa)
- `start-services.sh` (Docker gestisce i servizi)
- `verify-wordpress.sh` (non più necessario)
