# Cartella Documenti per RAG

Questa cartella contiene i documenti che verranno indicizzati per il sistema RAG (Retrieval-Augmented Generation).

## 📁 Cosa mettere qui

Aggiungi i tuoi documenti in uno dei seguenti formati:

- ✅ **`.md`** - File Markdown (consigliato)
- ✅ **`.pdf`** - Documenti PDF
- ✅ **`.txt`** - File di testo semplice
- ✅ **`.docx`** - Documenti Microsoft Word

## 🚀 Come usare

### 1. Aggiungi i tuoi documenti

```bash
# Copia i file in questa cartella
cp /percorso/ai/tuoi/documenti/*.md /home/ice/Desktop/WSP/dsl_generator/documenti/
```

### 2. Indicizza i documenti

```bash
cd /home/ice/Desktop/WSP

# Indicizza tutti i documenti
python dsl_generator/src/pipeline.py index \
  --input dsl_generator/documenti/ \
  --reset
```

### 3. Genera DSL

```bash
# Da un singolo file
python dsl_generator/src/pipeline.py generate \
  --input dsl_generator/documenti/tuo_file.md \
  --output data/generated_dsl/output.dsl

# O batch (tutti i file)
python dsl_generator/src/pipeline.py generate-batch \
  --input dsl_generator/documenti/ \
  --pattern "*.md"
```

## 📝 Formato consigliato per i documenti

Per ottenere i migliori risultati, struttura i tuoi documenti Markdown in questo modo:

```markdown
# Nome del Sistema

## Informazioni Generali
- Nome: SpaceOBC1
- Periodo: 0-100
- Risorse: 8

## Servizi

### Service 1
- ID: 0
- Tasks: TASK1, TASK2, TASK3

## Tasks

### TASK1
- Durata: 10 unità
- Risorse richieste: 2
- Release time: 0
- Deadline relativa: 0
- Massimo completamenti: 1

## Vincoli
- TASK1 deve iniziare prima di TASK2
- ...
```

## 🎯 Best Practices

1. **File ben strutturati**: Usa titoli e sezioni chiare
2. **Informazioni complete**: Specifica tutti i dettagli richiesti
3. **Formato consistente**: Mantieni lo stesso formato tra documenti simili
4. **Nomi descrittivi**: Usa nomi file significativi (es. `spaceOBC1_manual.md`)

## 🔄 Gestione dei documenti

### Aggiungere nuovi documenti

Dopo aver aggiunto nuovi file, re-indicizza:

```bash
python dsl_generator/src/pipeline.py index \
  --input dsl_generator/documenti/ \
  --reset
```

### Rimuovere documenti

1. Elimina i file dalla cartella
2. Re-indicizza con `--reset`

### Verificare i documenti indicizzati

```bash
python dsl_generator/src/pipeline.py stats
```

## 📊 Esempio di contenuto

Vedi i file di esempio nelle cartelle:
- `/home/ice/Desktop/WSP/SpaceOBC_DSL/` - Documenti SpaceOBC
- `/home/ice/Desktop/WSP/Syntethic_DSL/` - Documenti sintetici

Puoi copiare questi file qui come punto di partenza:

```bash
# Esempio: copia un file di test
cp ../SpaceOBC_DSL/spaceOBC1_manual.md .
```

## 🐛 Troubleshooting

### "No documents found"
- Verifica che i file siano in un formato supportato
- Controlla i permessi dei file

### "Indexing failed"
- Verifica la chiave API in `.env`
- Controlla che i documenti non siano corrotti

### Performance lente
- Riduci `chunk_size` in `config/config.yaml`
- Usa documenti più piccoli e focalizzati

## 📞 Per maggiori informazioni

Consulta:
- `/home/ice/Desktop/WSP/dsl_generator/GUIDA_COMPLETA.md` - Guida dettagliata
- `/home/ice/Desktop/WSP/esempio_uso.py` - Esempi di codice
- `/home/ice/Desktop/WSP/quick_start.sh` - Script rapido
