# 🚀 Quick Start Guide - DSL Generator

## Setup Rapido (5 minuti)

### 1. Installa Dipendenze

```bash
cd /home/ice/Desktop/WSP
pip install -r dsl_generator/requirements.txt
```

### 2. Configura API Key

```bash
# Crea file .env nella root
echo "OPENAI_API_KEY=sk-tua-chiave-qui" > .env
```

### 3. Aggiungi Documenti

```bash
# La cartella è già pronta!
# Aggiungi i tuoi file .md, .pdf, .txt, .docx
cp /percorso/documenti/*.md dsl_generator/documenti/

# Oppure usa il PDF già presente:
ls dsl_generator/documenti/
# Output: SpaceOBC1_Technical_Manual.pdf
```

## 🎯 Uso Immediato

### Metodo 1: Script Interattivo (Più Semplice)

```bash
# Usa il menu interattivo
./quick_start.sh

# Oppure con Python
python esempio_uso.py
```

### Metodo 2: Comandi Diretti

```bash
# Indicizza i documenti
python dsl_generator/src/pipeline.py index \
  --input dsl_generator/documenti/ \
  --reset

# Genera DSL dal PDF già presente
python dsl_generator/src/pipeline.py generate \
  --input dsl_generator/documenti/SpaceOBC1_Technical_Manual.pdf \
  --output data/generated_dsl/output.dsl

# Oppure genera batch per tutti i file
python dsl_generator/src/pipeline.py generate-batch \
  --input dsl_generator/documenti/ \
  --pattern "*.pdf"
```

### Metodo 3: Codice Python

```python
from dsl_generator.src.pipeline import DSLGeneratorPipeline

# Inizializza
pipeline = DSLGeneratorPipeline()

# Genera DSL
result = pipeline.generate_dsl(
    "dsl_generator/documenti/SpaceOBC1_Technical_Manual.pdf",
    "data/generated_dsl/output.dsl"
)

print(f"Valido: {result['validation']['is_valid']}")
```

## 📁 Struttura Creata

```
/home/ice/Desktop/WSP/
├── dsl_generator/
│   ├── documenti/              ← Aggiungi i tuoi documenti QUI
│   │   ├── README.md           ← Istruzioni dettagliate
│   │   └── SpaceOBC1_Technical_Manual.pdf  ← Esempio già presente
│   ├── data/
│   │   ├── vector_db/          ← Database vettoriale RAG (auto-creato)
│   │   └── generated_dsl/      ← DSL generati (auto-creato)
│   └── config/
│       └── config.yaml         ← Configurazione sistema
├── quick_start.sh              ← Script menu interattivo
├── esempio_uso.py              ← Esempi Python
├── GUIDA_COMPLETA.md           ← Documentazione completa
└── .env                        ← API keys (da creare)
```

## ✅ Verifica Rapida

```bash
# 1. Verifica che tutto funzioni
python dsl_generator/src/pipeline.py stats

# 2. Test con il PDF già presente
python dsl_generator/src/pipeline.py generate \
  --input dsl_generator/documenti/SpaceOBC1_Technical_Manual.pdf \
  --output test_output.dsl

# 3. Controlla il risultato
cat test_output.dsl
```

## 🎓 Comandi Essenziali

| Comando | Descrizione |
|---------|-------------|
| `./quick_start.sh` | Menu interattivo |
| `python esempio_uso.py` | Esempi Python interattivi |
| `python ... index --input documenti/ --reset` | Indicizza documenti |
| `python ... generate --input file.pdf --output out.dsl` | Genera DSL |
| `python ... generate-batch --input dir/ --pattern "*.md"` | Batch |
| `python ... stats` | Mostra statistiche |

## 🔧 Configurazione Veloce

### Cambiare Modello LLM

Modifica `dsl_generator/config/config.yaml`:

```yaml
llm:
  model: "gpt-4o"  # Cambia qui (gpt-4o, gpt-4o-mini, gpt-3.5-turbo)
```

### Regolare Performance RAG

```yaml
rag:
  chunk_size: 4000    # ↓ Riduci se lento
  top_k: 20          # Numero chunks recuperati
```

## 🐛 Problemi Comuni

### "API key not found"
```bash
# Assicurati che .env esista nella root
cat .env  # Deve mostrare: OPENAI_API_KEY=sk-...
```

### "No documents found"
```bash
# Verifica i file
ls -la dsl_generator/documenti/
# Formati supportati: .md, .pdf, .txt, .docx
```

### DSL non valido
```bash
# Controlla i log
tail -f dsl_generator/logs/pipeline.log

# Il sistema riprova automaticamente (max 3 volte)
```

## 📚 Prossimi Passi

1. **Leggi la guida completa**: `GUIDA_COMPLETA.md`
2. **Prova gli esempi**: `python esempio_uso.py`
3. **Esplora i prompt**: `dsl_generator/config/prompts/`
4. **Personalizza la config**: `dsl_generator/config/config.yaml`

## 💡 Tips

- ✅ Usa `--reset` quando cambi documenti per indicizzare di nuovo
- ✅ I file .md strutturati danno risultati migliori
- ✅ Controlla sempre `result['validation']['is_valid']`
- ✅ Per debug, aumenta `log_level: "DEBUG"` in config.yaml

## 🎯 Workflow Tipico

```bash
# 1. Aggiungi documenti
cp documenti_nuovi/*.md dsl_generator/documenti/

# 2. Genera DSL
./quick_start.sh  # Seleziona opzione 3 (batch)

# 3. Controlla risultati
ls -l data/generated_dsl/

# 4. Usa DSL generato nella pipeline
python 0_1_dsl_converter.py data/generated_dsl/output.dsl dzn_experiments/output.dzn
```

---

**🚀 Sei pronto! Inizia con `./quick_start.sh` o `python esempio_uso.py`**
