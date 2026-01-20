#!/usr/bin/env python3
"""
Esempio d'Uso del DSL Generator
================================

Questo script mostra come usare il sistema DSL Generator da Python.
"""

import sys
from pathlib import Path

# Aggiungi il path del modulo
sys.path.insert(0, str(Path(__file__).parent / "dsl_generator" / "src"))

from pipeline import DSLGeneratorPipeline


def esempio_base():
    """Esempio base: indicizza e genera DSL da un singolo file"""
    print("="*60)
    print("ESEMPIO BASE: Generazione DSL da singolo file")
    print("="*60)
    print()
    
    # 1. Inizializza la pipeline
    print("1️⃣  Inizializzazione pipeline...")
    pipeline = DSLGeneratorPipeline(
        config_path="dsl_generator/config/config.yaml"
    )
    print("✓ Pipeline inizializzata\n")
    
    # 2. Indicizza documentazione
    print("2️⃣  Indicizzazione documenti...")
    doc_count = pipeline.index_documentation(
        "dsl_generator/documenti/",
        reset_collection=True
    )
    print(f"✓ {doc_count} documenti indicizzati\n")
    
    # 3. Genera DSL
    print("3️⃣  Generazione DSL...")
    
    # Trova un file nella cartella documenti
    doc_dir = Path("dsl_generator/documenti")
    files = list(doc_dir.glob("*.md"))
    
    if not files:
        print("❌ Nessun file .md trovato in dsl_generator/documenti/")
        print("   Aggiungi dei file prima di eseguire questo script")
        return
    
    # Usa il primo file trovato
    input_file = files[0]
    output_file = Path("data/generated_dsl") / f"{input_file.stem}_generated.dsl"
    
    print(f"   Input:  {input_file}")
    print(f"   Output: {output_file}\n")
    
    result = pipeline.generate_dsl(
        documentation_path=str(input_file),
        output_path=str(output_file)
    )
    
    # 4. Mostra risultati
    print("\n4️⃣  Risultati:")
    print(f"   Valido:    {'✅ Sì' if result['validation']['is_valid'] else '❌ No'}")
    print(f"   Errori:    {len(result['validation']['errors'])}")
    print(f"   Warning:   {len(result['validation']['warnings'])}")
    print(f"   Tentativi: {result['validation']['attempts']}")
    
    if result['validation']['errors']:
        print("\n   Errori trovati:")
        for error in result['validation']['errors']:
            print(f"     - {error}")
    
    print()


def esempio_batch():
    """Esempio batch: genera DSL per tutti i file in una directory"""
    print("="*60)
    print("ESEMPIO BATCH: Generazione DSL multipla")
    print("="*60)
    print()
    
    # 1. Inizializza la pipeline
    print("1️⃣  Inizializzazione pipeline...")
    pipeline = DSLGeneratorPipeline(
        config_path="dsl_generator/config/config.yaml"
    )
    
    # 2. Batch processing
    print("\n2️⃣  Generazione batch...")
    results = pipeline.generate_batch(
        input_dir="dsl_generator/documenti/",
        output_dir="data/generated_dsl/",
        file_pattern="*.md"
    )
    
    # 3. Analisi risultati
    print("\n3️⃣  Analisi risultati:")
    total = len(results)
    valid = sum(1 for r in results if r['validation']['is_valid'])
    errors = sum(1 for r in results if 'error' in r)
    
    print(f"   File totali:  {total}")
    print(f"   DSL validi:   {valid}")
    print(f"   Con errori:   {errors}")
    print(f"   Successo:     {(valid/total*100) if total > 0 else 0:.1f}%")
    
    # Dettagli per ogni file
    print("\n   Dettaglio per file:")
    for r in results:
        filename = Path(r['input_file']).name
        status = "✅" if r['validation']['is_valid'] else "❌"
        print(f"     {status} {filename}")
    
    print()


def esempio_statistiche():
    """Esempio: mostra statistiche del sistema"""
    print("="*60)
    print("STATISTICHE SISTEMA")
    print("="*60)
    print()
    
    pipeline = DSLGeneratorPipeline(
        config_path="dsl_generator/config/config.yaml"
    )
    
    stats = pipeline.get_stats()
    
    print("📊 Vector Store:")
    print(f"   Collection:  {stats['vector_store']['collection_name']}")
    print(f"   Documenti:   {stats['vector_store']['total_documents']}")
    print(f"   Path:        {stats['vector_store']['store_path']}")
    
    print("\n🤖 LLM:")
    print(f"   Provider:    {stats['llm']['provider']}")
    print(f"   Modello:     {stats['llm']['model']}")
    
    print("\n📊 Embeddings:")
    print(f"   Provider:    {stats['embedding']['provider']}")
    print(f"   Modello:     {stats['embedding']['model']}")
    
    print()


def esempio_personalizzato():
    """Esempio personalizzato con controllo dettagliato"""
    print("="*60)
    print("ESEMPIO PERSONALIZZATO: Controllo granulare")
    print("="*60)
    print()
    
    from rag.document_loader import DocumentLoader
    from rag.embeddings import EmbeddingGenerator
    from rag.vector_store import VectorStore
    from llm.llm_client import LLMClient
    
    # 1. Carica documenti manualmente
    print("1️⃣  Caricamento documenti...")
    loader = DocumentLoader(chunk_size=2000, chunk_overlap=400)
    
    doc_dir = Path("dsl_generator/documenti")
    if not doc_dir.exists() or not any(doc_dir.glob("*.md")):
        print("❌ Nessun documento trovato")
        return
    
    documents = loader.load_directory(str(doc_dir))
    print(f"✓ {len(documents)} chunks caricati\n")
    
    # 2. Crea embeddings
    print("2️⃣  Creazione embeddings...")
    embedding_gen = EmbeddingGenerator(
        provider="openai",
        model="text-embedding-3-small"
    )
    print("✓ Embedding generator pronto\n")
    
    # 3. Crea vector store
    print("3️⃣  Creazione vector store...")
    vector_store = VectorStore(
        store_path="data/vector_db_custom",
        collection_name="custom_docs",
        embedding_generator=embedding_gen
    )
    
    vector_store.add_documents(documents, show_progress=True)
    print()
    
    # 4. Test retrieval
    print("4️⃣  Test retrieval...")
    query = "Quali sono i task del sistema?"
    results = vector_store.search(query, top_k=3)
    
    print(f"Query: '{query}'")
    print(f"Risultati: {len(results)}\n")
    
    for i, result in enumerate(results, 1):
        print(f"Risultato {i}:")
        print(f"  Content: {result['content'][:100]}...")
        print(f"  Score:   {1 - result['distance']:.3f}")
        print()


def menu():
    """Menu interattivo"""
    print("\n")
    print("="*60)
    print("DSL GENERATOR - Menu Esempi")
    print("="*60)
    print()
    print("Seleziona un esempio:")
    print()
    print("1) Esempio Base (singolo file)")
    print("2) Esempio Batch (multipli file)")
    print("3) Statistiche Sistema")
    print("4) Esempio Personalizzato (controllo granulare)")
    print("5) Esci")
    print()
    
    while True:
        try:
            scelta = input("Scelta (1-5): ").strip()
            
            if scelta == "1":
                esempio_base()
                break
            elif scelta == "2":
                esempio_batch()
                break
            elif scelta == "3":
                esempio_statistiche()
                break
            elif scelta == "4":
                esempio_personalizzato()
                break
            elif scelta == "5":
                print("Arrivederci!")
                break
            else:
                print("Scelta non valida. Riprova.")
        except KeyboardInterrupt:
            print("\n\nInterrotto dall'utente")
            break
        except Exception as e:
            print(f"\n❌ Errore: {e}")
            break


if __name__ == "__main__":
    # Controlla se ci sono argomenti
    if len(sys.argv) > 1:
        comando = sys.argv[1]
        
        if comando == "base":
            esempio_base()
        elif comando == "batch":
            esempio_batch()
        elif comando == "stats":
            esempio_statistiche()
        elif comando == "custom":
            esempio_personalizzato()
        else:
            print(f"Comando sconosciuto: {comando}")
            print("Uso: python esempio_uso.py [base|batch|stats|custom]")
    else:
        # Mostra menu
        menu()
