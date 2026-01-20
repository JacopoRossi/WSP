#!/bin/bash
# Quick Start Script per DSL Generator

echo "======================================"
echo "🚀 DSL Generator - Quick Start"
echo "======================================"
echo ""

# Colori per output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Directory base
BASE_DIR="/home/ice/Desktop/WSP"
DOC_DIR="dsl_generator/documenti"

cd "$BASE_DIR"

# Menu
echo "Seleziona un'operazione:"
echo ""
echo "1) Indicizza documenti (crea vector store per RAG)"
echo "2) Genera DSL da singolo file"
echo "3) Genera DSL batch (tutti i file)"
echo "4) Mostra statistiche sistema"
echo "5) Reset vector store"
echo "6) Visualizza documenti nella cartella"
echo ""
read -p "Scelta (1-6): " choice

case $choice in
    1)
        echo ""
        echo -e "${YELLOW}📑 Indicizzazione documenti...${NC}"
        python dsl_generator/src/pipeline.py index \
            --input "$DOC_DIR/" \
            --reset
        echo -e "${GREEN}✓ Indicizzazione completata${NC}"
        ;;
    
    2)
        echo ""
        echo "File disponibili in $DOC_DIR:"
        ls -1 "$DOC_DIR/" 2>/dev/null || echo "Nessun file trovato"
        echo ""
        read -p "Nome file da processare: " filename
        read -p "Nome output (default: generated.dsl): " output
        output=${output:-generated.dsl}
        
        echo ""
        echo -e "${YELLOW}🚀 Generazione DSL...${NC}"
        python dsl_generator/src/pipeline.py generate \
            --input "$DOC_DIR/$filename" \
            --output "data/generated_dsl/$output"
        echo -e "${GREEN}✓ DSL generato in data/generated_dsl/$output${NC}"
        ;;
    
    3)
        echo ""
        read -p "Pattern file (default: *.md): " pattern
        pattern=${pattern:-*.md}
        
        echo ""
        echo -e "${YELLOW}🔄 Generazione batch...${NC}"
        python dsl_generator/src/pipeline.py generate-batch \
            --input "$DOC_DIR/" \
            --pattern "$pattern" \
            --output "data/generated_dsl/"
        echo -e "${GREEN}✓ Batch completato${NC}"
        ;;
    
    4)
        echo ""
        echo -e "${YELLOW}📊 Statistiche sistema:${NC}"
        python dsl_generator/src/pipeline.py stats
        ;;
    
    5)
        echo ""
        read -p "Sei sicuro di voler resettare il vector store? (y/n): " confirm
        if [ "$confirm" = "y" ]; then
            echo -e "${YELLOW}🔄 Reset vector store...${NC}"
            rm -rf dsl_generator/data/vector_db/
            echo -e "${GREEN}✓ Vector store resettato${NC}"
        else
            echo "Operazione annullata"
        fi
        ;;
    
    6)
        echo ""
        echo "📁 Documenti in $DOC_DIR:"
        echo ""
        ls -lh "$DOC_DIR/" 2>/dev/null || echo "Cartella vuota o non esistente"
        echo ""
        echo "Formati supportati: .md, .pdf, .txt, .docx"
        ;;
    
    *)
        echo -e "${RED}Scelta non valida${NC}"
        exit 1
        ;;
esac

echo ""
echo "======================================"
echo "✓ Operazione completata"
echo "======================================"
