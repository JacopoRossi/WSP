# Guida Completa: Usare il Sistema DSL Generator da Zero

## 📋 Prerequisiti

### 1. Installazione Dipendenze

```bash
cd /home/ice/Desktop/WSP/dsl_generator

# Crea ambiente virtuale (opzionale ma consigliato)
python -m venv venv
source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate  # Windows

# Installa dipendenze
pip install -r requirements.txt
```

### 2. Configurazione API Key

Crea un file `.env` nella root del progetto:

```bash
# Crea file .env
nano .env
```

Aggiungi la tua API key OpenAI:

```env
OPENAI_API_KEY=sk-your-api-key-here
```

**IMPORTANTE**: Se non hai OpenAI, puoi usare un modello locale (vedi sezione Alternative).

---

## 🚀 Workflow Completo

### STEP 1: Preparare la Documentazione

Metti i tuoi documenti nella cartella `dsl_generator/documenti/`:

```bash
# La cartella è già creata, aggiungi i tuoi file
cp /percorso/ai/tuoi/file/*.md dsl_generator/documenti/
cp /percorso/ai/tuoi/file/*.pdf dsl_generator/documenti/

# Verifica i file
ls -la dsl_generator/documenti/
```

**Formati supportati**: `.md`, `.pdf`, `.txt`, `.docx`

---

### STEP 2: Indicizzare la Documentazione (RAG)

Questo crea il vector store per il retrieval:

```bash
cd /home/ice/Desktop/WSP

# Indicizza tutti i documenti nella cartella
python dsl_generator/src/pipeline.py index \
  --input dsl_generator/documenti/ \
  --reset
```

**Output atteso**:
```
📑 Indicizzazione documentazione da: dsl_generator/documenti/
✓ Caricato: documento1.md (15 chunks)
✓ Caricato: documento2.pdf (23 chunks)
Generazione embeddings per 38 documenti...
✓ 38 documenti aggiunti al vector store
```

---

### STEP 3: Generare DSL da un Singolo Documento

```bash
# Genera DSL da un file specifico
python dsl_generator/src/pipeline.py generate \
  --input dsl_generator/documenti/tuo_documento.md \
  --output data/generated_dsl/output.dsl
```

**Cosa succede**:
1. Il sistema resetta e indicizza il documento
2. Estrae informazioni usando RAG + LLM
3. Genera il DSL nel formato corretto
4. Valida il DSL generato
5. Salva il risultato

**Output atteso**:
```
🚀 GENERAZIONE DSL
===================================================
📑 Reset vector store e indicizzazione del file di input...
✓ Caricati 12 chunks
🤖 Estrazione informazioni con RAG...
📝 Generazione DSL...
✅ Validazione DSL...
✓ DSL salvato in: data/generated_dsl/output.dsl

📊 RIEPILOGO GENERAZIONE
===================================================
Documentazione: dsl_generator/documenti/tuo_documento.md
Output: data/generated_dsl/output.dsl
Valido: ✓ Sì
Errori: 0
Warning: 0
Tentativi: 1
```

---

### STEP 4: Generare DSL per Tutti i Documenti (Batch)

```bash
# Genera DSL per tutti i file .md nella cartella
python dsl_generator/src/pipeline.py generate-batch \
  --input dsl_generator/documenti/ \
  --pattern "*.md" \
  --output data/generated_dsl/

# O per tutti i PDF
python dsl_generator/src/pipeline.py generate-batch \
  --input dsl_generator/documenti/ \
  --pattern "*.pdf"
```

---

### STEP 5: Verificare le Statistiche

```bash
# Controlla statistiche del sistema
python dsl_generator/src/pipeline.py stats
```

**Output**:
```
📊 Statistiche Pipeline:
vector_store:
  collection_name: dsl_documentation
  total_documents: 38
  store_path: data/vector_db
llm:
  provider: openai
  model: gpt-5.1
embedding:
  provider: openai
  model: text-embedding-3-small
```

---

## 📝 Uso via Codice Python

Se preferisci usare Python direttamente:

```python
from dsl_generator.src.pipeline import DSLGeneratorPipeline

# 1. Inizializza la pipeline
pipeline = DSLGeneratorPipeline(config_path="dsl_generator/config/config.yaml")

# 2. Indicizza la documentazione
pipeline.index_documentation(
    "dsl_generator/documenti/",
    reset_collection=True
)

# 3. Genera DSL da un singolo file
result = pipeline.generate_dsl(
    documentation_path="dsl_generator/documenti/documento.md",
    output_path="data/generated_dsl/output.dsl"
)

print(f"DSL valido: {result['validation']['is_valid']}")
print(f"Errori: {result['validation']['errors']}")

# 4. Batch processing
results = pipeline.generate_batch(
    input_dir="dsl_generator/documenti/",
    output_dir="data/generated_dsl/",
    file_pattern="*.md"
)

print(f"Processati: {len(results)} file")
valid = sum(1 for r in results if r['validation']['is_valid'])
print(f"Validi: {valid}/{len(results)}")
```

---

## 🔧 Configurazione Avanzata

### Modificare il file config.yaml

```bash
nano dsl_generator/config/config.yaml
```

**Parametri principali**:

```yaml
llm:
  model: "gpt-5.1"           # Cambia modello
  temperature: 0.2            # Creatività (0=deterministico, 1=creativo)
  max_tokens: 8000           # Token massimi per risposta

rag:
  chunk_size: 4000           # Dimensione chunk documenti
  chunk_overlap: 800         # Sovrapposizione chunk
  top_k: 20                  # Numero di chunk recuperati per RAG
  similarity_threshold: 0.3  # Soglia similarità (più basso=più permissivo)
```

---

## 🔄 Alternative a OpenAI

### Usare un Modello Locale (Ollama)

1. Installa Ollama: https://ollama.ai
2. Scarica un modello:
```bash
ollama pull llama2
```

3. Modifica `config.yaml`:
```yaml
llm:
  provider: "ollama"
  model: "llama2"
  base_url: "http://localhost:11434"
  # Rimuovi api_key

rag:
  embedding_provider: "huggingface"
  embedding_model: "sentence-transformers/all-MiniLM-L6-v2"
```

### Usare Anthropic Claude

```yaml
llm:
  provider: "anthropic"
  model: "claude-3-opus-20240229"
  api_key: "${ANTHROPIC_API_KEY}"
```

Aggiungi al `.env`:
```env
ANTHROPIC_API_KEY=sk-ant-your-key-here
```

---

## 🎯 Esempio Completo Passo-Passo

```bash
# 1. Vai nella directory
cd /home/ice/Desktop/WSP

# 2. Copia documentazione di esempio
cp SpaceOBC_DSL/spaceOBC1_manual.md dsl_generator/documenti/

# 3. Indicizza
python dsl_generator/src/pipeline.py index \
  --input dsl_generator/documenti/ \
  --reset

# 4. Genera DSL
python dsl_generator/src/pipeline.py generate \
  --input dsl_generator/documenti/spaceOBC1_manual.md \
  --output data/generated_dsl/spaceOBC1_generated.dsl

# 5. Verifica il risultato
cat data/generated_dsl/spaceOBC1_generated.dsl

# 6. (Opzionale) Processa con pipeline completa
python 0_1_dsl_converter.py \
  data/generated_dsl/spaceOBC1_generated.dsl \
  dzn_experiments/output.dzn
```

---

## 📊 Struttura Output

Il DSL generato avrà questa struttura:

```yaml
wsp:
  name: "System Name"
  h_start: 0
  h_end: 100
  r_max: 8

services:
  - id: 0
    name: "Service1"
    tasks_set: [0, 1, 2]

tasks:
  - id: 0
    name: "TASK_NAME"
    sig: "..."
    dur: 10
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

start_constraints:
  - from: 0
    to: 1
    delay: 0
    wait_all: false
```

---

## 🐛 Troubleshooting

### Errore: "OpenAI API key not found"
```bash
# Verifica che il file .env esista
cat .env

# Deve contenere:
OPENAI_API_KEY=sk-...
```

### Errore: "No documents found"
```bash
# Verifica i file nella cartella
ls -la dsl_generator/documenti/

# Verifica i formati supportati (.md, .pdf, .txt, .docx)
```

### DSL non valido
```bash
# Controlla i log per dettagli
cat logs/pipeline.log

# Aumenta max_retries in config.yaml
# La pipeline riprova automaticamente
```

### Performance lente
```bash
# Riduci chunk_size e top_k in config.yaml
rag:
  chunk_size: 2000
  top_k: 10
```

---

## 📚 Comandi Utili

```bash
# Reset completo del vector store
rm -rf dsl_generator/data/vector_db/

# Visualizza tutti i documenti indicizzati
python -c "
from dsl_generator.src.rag.vector_store import VectorStore
from dsl_generator.src.rag.embeddings import EmbeddingGenerator

emb = EmbeddingGenerator('openai', 'text-embedding-3-small')
vs = VectorStore(embedding_generator=emb)
print(vs.get_stats())
"

# Test veloce del sistema
cd dsl_generator/src/rag
python document_loader.py
python vector_store.py
```

---

## 🎓 Best Practices

1. **Documentazione Chiara**: I file .md devono essere ben strutturati con titoli e sezioni
2. **Reset Collection**: Usa `--reset` quando cambi documentazione
3. **Batch Processing**: Per molti file, usa `generate-batch` invece di generare uno alla volta
4. **Validazione**: Controlla sempre gli errori nel risultato
5. **Logs**: Consulta `logs/pipeline.log` per debugging

---

## 🚀 Workflow Rapido

```bash
# Setup iniziale (una sola volta)
cd /home/ice/Desktop/WSP
echo "OPENAI_API_KEY=sk-your-key" > .env
pip install -r dsl_generator/requirements.txt

# Uso quotidiano
cp /percorso/documenti/*.md dsl_generator/documenti/
python dsl_generator/src/pipeline.py generate-batch \
  --input dsl_generator/documenti/ \
  --pattern "*.md"
```

---

## 📞 Riferimenti

- Config: `dsl_generator/config/config.yaml`
- Prompts: `dsl_generator/config/prompts/`
- Output: `dsl_generator/data/generated_dsl/`
- Vector DB: `dsl_generator/data/vector_db/`
- Logs: `dsl_generator/logs/`
