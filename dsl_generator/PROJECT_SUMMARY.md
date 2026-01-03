# DSL Generator Pipeline - Riepilogo Progetto

## 🎯 Obiettivo

Pipeline completa per generare automaticamente file DSL (Domain Specific Language) da documentazione tecnica, utilizzando:
- **Large Language Models (LLM)** per la generazione
- **Retrieval-Augmented Generation (RAG)** per migliorare l'accuratezza
- **Validazione automatica** per garantire correttezza

## 📦 Struttura Progetto

```
dsl_generator/
├── config/                      # Configurazione
│   ├── config.yaml             # Configurazione principale
│   └── prompts/                # Prompt per LLM
│       ├── system_prompt.txt
│       ├── extraction_prompt.txt
│       └── generation_prompt.txt
│
├── src/                        # Codice sorgente
│   ├── rag/                    # Sistema RAG
│   │   ├── document_loader.py  # Caricamento documenti
│   │   ├── embeddings.py       # Generazione embeddings
│   │   └── vector_store.py     # Database vettoriale
│   │
│   ├── llm/                    # Gestione LLM
│   │   ├── llm_client.py       # Client unificato LLM
│   │   └── prompt_builder.py   # Costruzione prompt
│   │
│   ├── dsl/                    # Generazione DSL
│   │   ├── generator.py        # Generatore principale
│   │   ├── validator.py        # Validatore DSL
│   │   └── templates.py        # Template DSL
│   │
│   └── pipeline.py             # Pipeline completa
│
├── data/                       # Dati
│   ├── documents/              # Documentazione input
│   ├── vector_db/              # Database vettoriale
│   └── generated_dsl/          # DSL generati
│
├── examples/                   # Esempi
│   └── example_usage.py        # Esempi interattivi
│
├── generate_dsl.py             # Script principale
├── requirements.txt            # Dipendenze
├── README.md                   # Documentazione completa
├── QUICKSTART.md              # Guida rapida
└── .env.example               # Template variabili ambiente
```

## 🔧 Componenti Principali

### 1. Sistema RAG (Retrieval-Augmented Generation)

**Document Loader** (`src/rag/document_loader.py`)
- Carica documenti in vari formati (MD, PDF, TXT, DOCX)
- Divide in chunks semantici
- Preprocessa il testo

**Embedding Generator** (`src/rag/embeddings.py`)
- Genera embeddings vettoriali
- Supporta OpenAI e HuggingFace
- Cache per ottimizzazione

**Vector Store** (`src/rag/vector_store.py`)
- Database vettoriale con ChromaDB
- Ricerca semantica
- Retrieval contestuale per RAG

### 2. Sistema LLM

**LLM Client** (`src/llm/llm_client.py`)
- Client unificato per OpenAI, Anthropic, Ollama
- Retry automatico
- Generazione strutturata (JSON/YAML)

**Prompt Builder** (`src/llm/prompt_builder.py`)
- Costruzione prompt dinamici
- Template riutilizzabili
- Gestione contesto RAG

### 3. Generazione e Validazione DSL

**DSL Generator** (`src/dsl/generator.py`)
- Estrazione informazioni da documentazione
- Generazione DSL con LLM
- Correzione automatica errori

**DSL Validator** (`src/dsl/validator.py`)
- Validazione sintassi YAML
- Validazione semantica
- Controllo riferimenti e dipendenze circolari

**DSL Templates** (`src/dsl/templates.py`)
- Schema DSL
- Template predefiniti
- Helper per creazione elementi

### 4. Pipeline Completa

**Pipeline** (`src/pipeline.py`)
- Integra tutti i componenti
- Gestione configurazione
- CLI e API Python
- Batch processing

## 🚀 Funzionalità

### Generazione DSL
- ✅ Da singolo documento
- ✅ Batch da directory
- ✅ Con o senza RAG
- ✅ Validazione automatica
- ✅ Correzione errori automatica

### Sistema RAG
- ✅ Indicizzazione documenti
- ✅ Ricerca semantica
- ✅ Retrieval contestuale
- ✅ Supporto multi-formato

### LLM Support
- ✅ OpenAI (GPT-3.5, GPT-4)
- ✅ Anthropic (Claude)
- ✅ Ollama (modelli locali)
- ✅ Configurabile

### Validazione
- ✅ Sintassi YAML
- ✅ Schema DSL
- ✅ Riferimenti task/servizi
- ✅ Dipendenze circolari
- ✅ Uso risorse

## 📊 Workflow

```
1. INDICIZZAZIONE (opzionale ma consigliato)
   Documentazione → Document Loader → Embeddings → Vector Store

2. ESTRAZIONE
   Documentazione + RAG Context → LLM → Informazioni Strutturate

3. GENERAZIONE
   Informazioni Strutturate → LLM → DSL YAML

4. VALIDAZIONE
   DSL → Validator → Errori/Warning

5. CORREZIONE (se necessario)
   DSL + Errori → LLM → DSL Corretto

6. OUTPUT
   DSL Valido → File .dsl
```

## 💻 Utilizzo

### Metodo 1: Script Semplificato
```bash
python generate_dsl.py path/to/documentation.md
```

### Metodo 2: CLI Pipeline
```bash
python -m src.pipeline generate --input doc.md --output out.dsl
```

### Metodo 3: API Python
```python
from src.pipeline import DSLGeneratorPipeline

pipeline = DSLGeneratorPipeline()
result = pipeline.generate_dsl("doc.md", "out.dsl")
```

### Metodo 4: Esempi Interattivi
```bash
python examples/example_usage.py
```

## ⚙️ Configurazione

### File Principale: `config/config.yaml`

```yaml
llm:
  provider: "openai"
  model: "gpt-4-turbo-preview"
  temperature: 0.2

rag:
  embedding_model: "text-embedding-3-small"
  chunk_size: 1000
  top_k: 5

dsl:
  validate: true
  strict_mode: false
```

### Variabili Ambiente: `.env`

```bash
OPENAI_API_KEY=your-key-here
ANTHROPIC_API_KEY=your-key-here
```

## 📈 Performance

### Con RAG
- ✅ Maggiore accuratezza
- ✅ Migliore gestione contesto
- ✅ Coerenza tra documenti
- ⚠️  Richiede indicizzazione iniziale

### Senza RAG
- ✅ Più veloce
- ✅ Nessuna indicizzazione necessaria
- ⚠️  Meno accurato
- ⚠️  Limitato dalla finestra contesto LLM

## 🎓 Esempi Inclusi

1. **Singolo documento** - Genera DSL da un file
2. **Batch processing** - Genera DSL da directory
3. **Con RAG** - Usa knowledge base indicizzata
4. **Configurazione custom** - Personalizza parametri
5. **Solo validazione** - Valida DSL esistenti

## 🔍 Testing

Ogni modulo include test integrati:

```bash
# Test document loader
python src/rag/document_loader.py

# Test embeddings
python src/rag/embeddings.py

# Test vector store
python src/rag/vector_store.py

# Test validator
python src/dsl/validator.py
```

## 📝 Personalizzazione

### Prompt Personalizzati
Modifica i file in `config/prompts/` per adattare il comportamento del LLM.

### Template DSL
Estendi `src/dsl/templates.py` per nuovi tipi di DSL.

### Validazione Custom
Aggiungi regole in `src/dsl/validator.py`.

## 🛠️ Requisiti Tecnici

- Python 3.8+
- 2GB RAM minimo (4GB+ consigliato)
- API key LLM (o Ollama locale)
- Spazio disco per vector database

## 📚 Dipendenze Principali

- `langchain` - Framework LLM
- `chromadb` - Vector database
- `openai` / `anthropic` - LLM providers
- `pyyaml` - Parsing YAML
- `sentence-transformers` - Embeddings locali

## 🎯 Casi d'Uso

1. **Documentazione → DSL**: Genera DSL da manuali tecnici
2. **Migrazione**: Converte documentazione legacy in DSL
3. **Validazione**: Verifica correttezza DSL esistenti
4. **Batch**: Processa grandi quantità di documenti
5. **Prototipazione**: Genera rapidamente DSL per test

## 🔮 Estensioni Future

- [ ] Supporto più formati input (HTML, LaTeX)
- [ ] GUI web per generazione interattiva
- [ ] Fine-tuning modelli per DSL specifici
- [ ] Export in formati alternativi (JSON, XML)
- [ ] Integrazione CI/CD
- [ ] Metriche qualità automatiche

## 📄 Licenza

MIT License - Vedi file LICENSE

## 🤝 Contributi

Contributi benvenuti! Vedi CONTRIBUTING.md per linee guida.

---

**Creato con ❤️ per automatizzare la generazione di DSL da documentazione tecnica**
