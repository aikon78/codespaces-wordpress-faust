# 🚀 Setup Completo - Guida Step-by-Step

## Stato Attuale

✅ **Configurato:**
- Docker Compose con WordPress + MariaDB + Next.js
- Script automatici per URL dinamici
- Porte esposte correttamente (3000, 3001)

⚠️ **Da completare manualmente:**
- Installazione WordPress
- Attivazione plugin
- Configurazione Faust secret key

---

## 📋 Procedura di Setup (5 minuti)

### 1. Installa WordPress

Apri l'URL WordPress dal tab **PORTS** di VS Code:
- Clicca su `WordPress (3001)` → "Open in Browser"
- O visita: https://jubilant-space-lamp-g7xj6p9xpr39jp5-3001.app.github.dev

Completa l'installazione:
- **Lingua**: Italiano / English
- **Titolo sito**: `Faust WordPress`
- **Username**: `admin`
- **Password**: `admin` (o una tua scelta sicura)
- **Email**: `admin@example.com`

### 2. Installa e Attiva i Plugin

Dal pannello WordPress (`/wp-admin`):

1. **WPGraphQL**:
   - Vai in **Plugin** → **Aggiungi nuovo**
   - Cerca `WPGraphQL`
   - Clicca **Installa** → **Attiva**

2. **FaustWP**:
   - Vai in **Plugin** → **Aggiungi nuovo**
   - Cerca `FaustWP`
   - Clicca **Installa** → **Attiva**

### 3. Ottieni il Faust Secret Key

1. Vai in **Impostazioni** → **Faust** (o Settings → Faust)
2. Troverai il **Secret Key** generato automaticamente
3. Copialo (es. `a1b2c3d4-e5f6-7890-abcd-ef1234567890`)

### 4. Aggiorna `.env.local`

Nel file `/workspace/.env.local`, sostituisci il valore di `FAUST_SECRET_KEY`:

```dotenv
FAUST_SECRET_KEY=IL_TUO_SECRET_KEY_COPIATO
```

### 5. Avvia Next.js

Nel terminale di VS Code:

```bash
cd /workspace
npm run dev
```

Oppure usa lo script di verifica:

```bash
bash .devcontainer/verify-setup.sh
```

---

## 🌐 Accesso alle Applicazioni

Usa il tab **PORTS** di VS Code per aprire:

| Servizio | Porta | URL |
|----------|-------|-----|
| **WordPress** | 3001 | https://jubilant-space-lamp-g7xj6p9xpr39jp5-3001.app.github.dev |
| **WordPress Admin** | 3001 | https://jubilant-space-lamp-g7xj6p9xpr39jp5-3001.app.github.dev/wp-admin |
| **Next.js** | 3000 | https://jubilant-space-lamp-g7xj6p9xpr39jp5-3000.app.github.dev |

---

## ✅ Verifica Funzionamento

Dopo aver completato i passaggi:

```bash
# Verifica setup completo
bash .devcontainer/verify-setup.sh

# Test GraphQL (dovrebbe rispondere con dati)
curl -s http://localhost/graphql \\
  -H 'Content-Type: application/json' \\
  -d '{"query":"{ generalSettings { title } }"}'
```

---

## 🔧 Troubleshooting

### "GraphQL non risponde"
- Verifica che WPGraphQL sia **attivato** in `/wp-admin/plugins.php`
- Prova a disattivare e riattivare il plugin

### "FAUST_SECRET_KEY non corrisponde"
- Vai in WordPress → Settings → Faust
- Copia il secret key esatto
- Aggiorna `.env.local`
- Riavvia Next.js

### "Porte non visibili in VS Code"
- Ricarica la finestra: `Cmd/Ctrl + Shift + P` → "Reload Window"
- Verifica `devcontainer.json` → `forwardPorts`: `[3000, 3001]`

---

## 📖 Documentazione Correlata

- [ENV-CONFIG.md](.devcontainer/ENV-CONFIG.md) - Gestione URL dinamici
- [WORDPRESS-URL-MAPPING.md](.devcontainer/WORDPRESS-URL-MAPPING.md) - Mapping URL Codespaces
- [verify-setup.sh](.devcontainer/verify-setup.sh) - Script di verifica

---

**Tempo stimato**: 5 minuti  
**Difficoltà**: ⭐ Facile
