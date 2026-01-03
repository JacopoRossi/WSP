# Quick Start Guide
## Inizia subito con DSL Generator

Questa guida ti aiuterà a generare il tuo primo DSL in pochi minuti.

## 📋 Prerequisiti

- Python 3.8 o superiore
- API key per OpenAI, Anthropic, o un'istanza Ollama locale

## 🚀 Setup Rapido

### 1. Installazione

```bash
cd dsl_generator

# Crea ambiente virtuale
python -m venv venv
source venv/bin/activate  # Linux/Mac
# oppure
venv\Scripts\activate  # Windows

# Installa dipendenze
pip install -r requirements.txt
```

### 2. Configurazione

```bash
# Copia il file di esempio
cp .env.example .env

# Modifica .env e inserisci la tua API key
nano .env  # o usa il tuo editor preferito
```

Inserisci la tua API key:
```
OPENAI_API_KEY=sk-your-actual-api-key-here
```

### 3. Primo Test

Testa che tutto funzioni:

```bash
# Test con validazione di un DSL esistente
python examples/example_usage.py
# Scegli opzione 5 per validare un DSL esistente
```

## 📝 Generazione del Primo DSL

### Metodo 1: Da Linea di Comando

```bash
# Genera DSL da un singolo documento
python -m src.pipeline generate \
    --input ../SpaceOBC_DSL/spaceOBC1_manual.md \
    --output data/generated_dsl/my_first.dsl
```

### Metodo 2: Da Script Python

Crea un file `generate_my_dsl.py`:

```python
from src.pipeline import DSLGeneratorPipeline

# Inizializza pipeline
pipeline = DSLGeneratorPipeline()

# Genera DSL
result = pipeline.generate_dsl(
    documentation_path="../SpaceOBC_DSL/spaceOBC1_manual.md",
    output_path="data/generated_dsl/my_first.dsl"
)

print(f"DSL generato! Valido: {result['validation']['is_valid']}")
```

Esegui:
```bash
python generate_my_dsl.py
```

### Metodo 3: Usa gli Esempi Interattivi

```bash
python examples/example_usage.py
```

Scegli l'esempio che preferisci dal menu interattivo.

## 🎯 Workflow Tipico

### 1. Indicizza la Documentazione

Prima di generare DSL, indicizza la tua documentazione per abilitare il RAG:

```bash
python -m src.pipeline index \
    --input ../SpaceOBC_DSL \
    --reset
```

### 2. Genera DSL

Ora genera DSL usando la knowledge base indicizzata:

```bash
python -m src.pipeline generate \
    --input ../SpaceOBC_DSL/spaceOBC2_manual.md \
    --output data/generated_dsl/spaceOBC2.dsl
```

### 3. Valida il Risultato

Il DSL viene validato automaticamente, ma puoi anche validarlo manualmente:

```python
from src.dsl.validator import DSLValidator

validator = DSLValidator()
with open("data/generated_dsl/spaceOBC2.dsl", 'r') as f:
    dsl_content = f.read()

is_valid, errors, warnings = validator.validate(dsl_content)
print(f"Valido: {is_valid}")
```

## 🔧 Configurazione Avanzata

### Usa un Modello Diverso

Modifica `config/config.yaml`:

```yaml
llm:
  provider: "openai"
  model: "gpt-4-turbo-preview"  # Cambia questo
  temperature: 0.2
```

### Usa Ollama (Locale, Gratis)

1. Installa Ollama: https://ollama.ai
2. Scarica un modello: `ollama pull llama2`
3. Modifica configurazione:

```yaml
llm:
  provider: "ollama"
  model: "llama2"
  temperature: 0.3
```

### Personalizza i Prompt

I prompt sono in `config/prompts/`. Modificali per adattarli al tuo caso d'uso:

- `system_prompt.txt` - Comportamento generale del sistema
- `extraction_prompt.txt` - Come estrarre informazioni
- `generation_prompt.txt` - Come generare il DSL

## 📊 Generazione Batch

Per generare DSL da molteplici documenti:

```bash
python -m src.pipeline generate-batch \
    --input ../SpaceOBC_DSL \
    --output data/generated_dsl/batch \
    --pattern "*_manual.md"
```

## 🐛 Troubleshooting

### Errore: "API key not found"

Assicurati di aver creato il file `.env` e inserito la tua API key:
```bash
cp .env.example .env
nano .env  # Inserisci la tua key
```

### Errore: "Module not found"

Assicurati di aver installato tutte le dipendenze:
```bash
pip install -r requirements.txt
```

### DSL non valido

Il sistema tenta automaticamente di correggere errori. Se fallisce:

1. Controlla gli errori di validazione nel output
2. Aumenta `max_retries` in `config/config.yaml`
3. Prova con un modello più potente (es. GPT-4)
4. Migliora la documentazione input

### Performance lente

- Usa un modello più veloce (es. GPT-3.5 invece di GPT-4)
- Riduci `chunk_size` in configurazione
- Usa embeddings locali invece di OpenAI

## 📚 Prossimi Passi

1. **Esplora gli esempi**: `examples/example_usage.py`
2. **Leggi la documentazione completa**: `README.md`
3. **Personalizza i prompt**: `config/prompts/`
4. **Sperimenta con diversi modelli**: Modifica `config/config.yaml`

## 💡 Tips

- **Documentazione di qualità**: Più la documentazione è chiara e strutturata, migliore sarà il DSL generato
- **Usa RAG**: Indicizza sempre la documentazione prima di generare per risultati migliori
- **Valida sempre**: Controlla sempre il DSL generato prima di usarlo in produzione
- **Itera**: Se il risultato non è perfetto, raffina la documentazione o i prompt

## 🆘 Supporto

- Controlla gli esempi in `examples/`
- Leggi il README completo
- Controlla i log per dettagli sugli errori

## ✅ Checklist Setup

- [ ] Python 3.8+ installato
- [ ] Ambiente virtuale creato e attivato
- [ ] Dipendenze installate (`pip install -r requirements.txt`)
- [ ] File `.env` creato con API key
- [ ] Test di validazione eseguito con successo
- [ ] Primo DSL generato

Congratulazioni! Sei pronto per generare DSL dalla tua documentazione! 🎉
