#!/bin/bash

# Setup script per il devcontainer
set -e

echo "🚀 Setup di WordPress Faust (Next.js) in corso..."

# Verifica Node.js
echo "✓ Node.js: $(node --version)"
echo "✓ npm: $(npm --version)"

# Installa dipendenze npm
if [ -f "package.json" ]; then
    echo "📦 Installazione dipendenze npm..."
    npm install
fi

# Copia il file .env.local.sample se non esiste .env.local
if [ -f ".env.local.sample" ] && [ ! -f ".env.local" ]; then
    echo "📝 Creazione .env.local da template..."
    cp .env.local.sample .env.local
fi

echo "✅ Setup completato!"
echo ""
echo "📖 Prossimi passi:"
echo "  - Configura le variabili d'ambiente in .env.local"
echo "  - Esegui: npm run dev"
echo "  - Apri: http://localhost:3000"
