#!/bin/bash
# Setup script per DSL Generator Pipeline

echo "🚀 DSL Generator - Setup Automatico"
echo "===================================="
echo ""

# Controlla Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 non trovato. Installa Python 3.8+ e riprova."
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
echo "✓ Python $PYTHON_VERSION trovato"

# Crea ambiente virtuale
echo ""
echo "📦 Creazione ambiente virtuale..."
python3 -m venv venv

if [ $? -ne 0 ]; then
    echo "❌ Errore nella creazione dell'ambiente virtuale"
    exit 1
fi

echo "✓ Ambiente virtuale creato"

# Attiva ambiente virtuale
echo ""
echo "🔧 Attivazione ambiente virtuale..."
source venv/bin/activate

# Aggiorna pip
echo ""
echo "⬆️  Aggiornamento pip..."
pip install --upgrade pip > /dev/null 2>&1

# Installa dipendenze
echo ""
echo "📥 Installazione dipendenze..."
echo "   (Questo potrebbe richiedere alcuni minuti...)"
pip install -r requirements.txt

if [ $? -ne 0 ]; then
    echo "❌ Errore nell'installazione delle dipendenze"
    exit 1
fi

echo "✓ Dipendenze installate"

# Crea directory necessarie
echo ""
echo "📁 Creazione directory..."
mkdir -p data/documents
mkdir -p data/vector_db
mkdir -p data/generated_dsl
mkdir -p logs

echo "✓ Directory create"

# Crea file .env se non esiste
echo ""
if [ ! -f .env ]; then
    echo "📝 Creazione file .env..."
    cp .env.example .env
    echo "✓ File .env creato"
    echo ""
    echo "⚠️  IMPORTANTE: Modifica il file .env e inserisci la tua API key!"
    echo "   Usa: nano .env"
else
    echo "✓ File .env già esistente"
fi

# Rendi eseguibili gli script
chmod +x generate_dsl.py

echo ""
echo "===================================="
echo "✅ Setup completato con successo!"
echo "===================================="
echo ""
echo "📋 Prossimi passi:"
echo ""
echo "1. Attiva l'ambiente virtuale:"
echo "   source venv/bin/activate"
echo ""
echo "2. Configura la tua API key:"
echo "   nano .env"
echo ""
echo "3. Testa l'installazione:"
echo "   python examples/example_usage.py"
echo ""
echo "4. Genera il tuo primo DSL:"
echo "   python generate_dsl.py ../SpaceOBC_DSL/spaceOBC1_manual.md"
echo ""
echo "📚 Per maggiori informazioni:"
echo "   - Leggi QUICKSTART.md per iniziare subito"
echo "   - Leggi README.md per la documentazione completa"
echo ""
