# DSL Generator Pipeline
## Generazione Automatica di DSL da Documentazione con LLM e RAG

Questo progetto implementa una pipeline completa per generare automaticamente file DSL (Domain Specific Language) a partire da documentazione tecnica, utilizzando Large Language Models (LLM) e Retrieval-Augmented Generation (RAG).

## 🎯 Caratteristiche

- **Sistema RAG**: Indicizzazione e retrieval semantico della documentazione
- **Generazione LLM**: Utilizzo di modelli avanzati (OpenAI, Anthropic, o modelli locali)
- **Pipeline Modulare**: Componenti indipendenti e riutilizzabili
- **Validazione DSL**: Controllo automatico della sintassi e semantica
- **Supporto Multi-formato**: Markdown, PDF, TXT
- **Configurabile**: Template personalizzabili per diversi tipi di DSL

## 📁 Struttura del Progetto

```
dsl_generator/
├── config/
│   ├── config.yaml              # Configurazione principale
│   └── prompts/
│       ├── system_prompt.txt    # Prompt di sistema per LLM
│       └── extraction_prompt.txt # Prompt per estrazione informazioni
├── src/
│   ├── rag/
│   │   ├── document_loader.py   # Caricamento documenti
│   │   ├── embeddings.py        # Generazione embeddings
│   │   └── vector_store.py      # Vector database
│   ├── llm/
│   │   ├── llm_client.py        # Client LLM unificato
│   │   └── prompt_builder.py    # Costruzione prompt
│   ├── dsl/
│   │   ├── generator.py         # Generatore DSL
│   │   ├── validator.py         # Validatore DSL
│   │   └── templates.py         # Template DSL
│   └── pipeline.py              # Pipeline principale
├── data/
│   ├── documents/               # Documentazione input
│   ├── vector_db/               # Database vettoriale
│   └── generated_dsl/           # DSL generati
├── examples/
│   └── example_usage.py         # Esempi di utilizzo
├── requirements.txt
└── README.md
```

## 🚀 Installazione

```bash
# Clona il repository o naviga nella directory
cd dsl_generator

# Crea ambiente virtuale
python -m venv venv
source venv/bin/activate  # Linux/Mac
# oppure
venv\Scripts\activate  # Windows

# Installa dipendenze
pip install -r requirements.txt
```

## ⚙️ Configurazione

1. Copia il file di configurazione di esempio:
```bash
cp config/config.yaml.example config/config.yaml
```

2. Modifica `config/config.yaml` con le tue credenziali:
```yaml
llm:
  provider: "openai"  # openai, anthropic, ollama
  model: "gpt-4"
  api_key: "your-api-key"
  temperature: 0.3

rag:
  embedding_model: "text-embedding-3-small"
  chunk_size: 1000
  chunk_overlap: 200
  top_k: 5

dsl:
  output_format: "yaml"
  validate: true
```

## 📖 Utilizzo

### Utilizzo Base

```python
from src.pipeline import DSLGeneratorPipeline

# Inizializza la pipeline
pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")

# Genera DSL da documentazione
dsl_output = pipeline.generate_dsl(
    documentation_path="data/documents/spaceOBC_manual.md",
    output_path="data/generated_dsl/spaceOBC_generated.dsl"
)

print(f"DSL generato: {dsl_output}")
```

### Utilizzo da CLI

```bash
# Genera DSL da un singolo documento
python -m src.pipeline generate \
    --input data/documents/spaceOBC_manual.md \
    --output data/generated_dsl/output.dsl

# Genera DSL da una directory di documenti
python -m src.pipeline generate-batch \
    --input-dir data/documents/ \
    --output-dir data/generated_dsl/

# Valida un DSL generato
python -m src.pipeline validate \
    --dsl-file data/generated_dsl/output.dsl
```

## 🔧 Componenti Principali

### 1. Document Loader
Carica e preprocessa la documentazione in vari formati.

### 2. RAG System
- Divide i documenti in chunks semantici
- Genera embeddings vettoriali
- Memorizza in vector database (ChromaDB/FAISS)
- Recupera contesto rilevante per le query

### 3. LLM Generator
- Costruisce prompt contestuali
- Interagisce con LLM (OpenAI/Anthropic/Ollama)
- Genera DSL strutturato

### 4. DSL Validator
- Valida sintassi YAML
- Verifica vincoli semantici
- Controlla coerenza dei dati

## 🎨 Personalizzazione

### Template DSL Personalizzati

Modifica `src/dsl/templates.py` per definire nuovi template:

```python
CUSTOM_TEMPLATE = {
    "wsp": {
        "name": str,
        "h_start": int,
        "h_end": int,
        "r_max": int
    },
    "services": list,
    "tasks": list,
    "start_constraints": list
}
```

### Prompt Personalizzati

Modifica i file in `config/prompts/` per adattare il comportamento del LLM.

## 📊 Esempi

Vedi la directory `examples/` per esempi completi di utilizzo.

## 🧪 Testing

```bash
# Esegui tutti i test
pytest tests/

# Test specifici
pytest tests/test_rag.py
pytest tests/test_generator.py
```

## 🤝 Contributi

Contributi benvenuti! Apri una issue o pull request.

## 📝 Licenza

MIT License

## 🔗 Risorse

- [LangChain Documentation](https://python.langchain.com/)
- [OpenAI API](https://platform.openai.com/docs)
- [ChromaDB](https://www.trychroma.com/)
