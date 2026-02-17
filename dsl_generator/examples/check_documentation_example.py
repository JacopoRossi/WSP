#!/usr/bin/env python3
"""
Esempio di utilizzo della funzionalità di verifica documentazione

Questo script mostra come:
1. Verificare se il vector store è vuoto
2. Gestire il caso di documentazione mancante
3. Indicizzare documentazione prima della generazione
"""

import sys
from pathlib import Path

# Aggiungi il parent directory al path per gli import
sys.path.insert(0, str(Path(__file__).parent.parent))

from src.pipeline import DSLGeneratorPipeline


def example_check_vector_store():
    """Esempio: Verifica se il vector store contiene dati"""
    print("="*60)
    print("Esempio 1: Verifica Vector Store")
    print("="*60 + "\n")
    
    # Inizializza pipeline
    pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")
    
    # Verifica se il vector store è vuoto
    if pipeline.vector_store.is_empty():
        print("⚠️  Vector store è VUOTO")
        print("   Nessun dato DSL disponibile per RAG\n")
        
        # Ottieni statistiche
        stats = pipeline.vector_store.get_stats()
        print("📊 Statistiche Vector Store:")
        print(f"   - Collection: {stats['collection_name']}")
        print(f"   - Documenti: {stats['total_documents']}")
        print(f"   - Path: {stats['store_path']}\n")
        
        return False
    else:
        print("✅ Vector store contiene dati")
        stats = pipeline.vector_store.get_stats()
        print(f"   - Documenti indicizzati: {stats['total_documents']}\n")
        return True


def example_index_before_generation():
    """Esempio: Indicizza documentazione prima di generare DSL"""
    print("="*60)
    print("Esempio 2: Indicizzazione Prima della Generazione")
    print("="*60 + "\n")
    
    # Inizializza pipeline
    pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")
    
    # Path alla documentazione
    doc_path = "../SpaceOBC_DSL/spaceOBC1_manual.md"
    
    if not Path(doc_path).exists():
        print(f"❌ File non trovato: {doc_path}")
        print("   Modifica il path nel codice per puntare a un file valido\n")
        return
    
    # Verifica se vector store è vuoto
    if pipeline.vector_store.is_empty():
        print("📚 Vector store vuoto, indicizzazione necessaria...")
        
        # Indicizza la documentazione
        try:
            count = pipeline.index_documentation(
                doc_path,
                reset_collection=True
            )
            print(f"✅ Indicizzati {count} documenti\n")
        except Exception as e:
            print(f"❌ Errore durante l'indicizzazione: {e}\n")
            return
    
    # Ora genera il DSL
    print("🚀 Generazione DSL con documentazione indicizzata...")
    try:
        result = pipeline.generate_dsl(
            documentation_path=doc_path,
            output_path="data/generated_dsl/example_output.dsl"
        )
        
        if result['validation']['is_valid']:
            print("✅ DSL generato con successo!\n")
        else:
            print(f"⚠️  DSL generato con {len(result['validation']['errors'])} errori\n")
            
    except Exception as e:
        print(f"❌ Errore durante la generazione: {e}\n")


def example_conditional_generation():
    """Esempio: Generazione condizionale basata sulla disponibilità di dati"""
    print("="*60)
    print("Esempio 3: Generazione Condizionale")
    print("="*60 + "\n")
    
    # Inizializza pipeline
    pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")
    
    # Path alla documentazione
    doc_path = "../SpaceOBC_DSL/spaceOBC1_manual.md"
    fallback_doc_path = "documenti/SpaceOBC1_Technical_Manual.pdf"
    
    # Verifica disponibilità dati
    if pipeline.vector_store.is_empty():
        print("⚠️  Dati non disponibili, cerco documentazione...")
        
        # Prova con il primo path
        if Path(doc_path).exists():
            print(f"✓ Trovato: {doc_path}")
            target_doc = doc_path
        elif Path(fallback_doc_path).exists():
            print(f"✓ Trovato (fallback): {fallback_doc_path}")
            target_doc = fallback_doc_path
        else:
            print("❌ Nessuna documentazione trovata")
            print("   Path provati:")
            print(f"   - {doc_path}")
            print(f"   - {fallback_doc_path}\n")
            return
        
        # Indicizza
        print(f"\n📑 Indicizzazione di {target_doc}...")
        pipeline.index_documentation(target_doc, reset_collection=True)
    
    # Genera DSL
    print("\n🚀 Generazione DSL...")
    if Path(doc_path).exists():
        pipeline.generate_dsl(
            documentation_path=doc_path,
            output_path="data/generated_dsl/conditional_output.dsl"
        )
        print("✅ Completato!\n")
    else:
        print(f"❌ File di input non trovato: {doc_path}\n")


def example_batch_with_check():
    """Esempio: Generazione batch con verifica preliminare"""
    print("="*60)
    print("Esempio 4: Generazione Batch con Verifica")
    print("="*60 + "\n")
    
    # Inizializza pipeline
    pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")
    
    # Directory con documentazione
    doc_dir = "../SpaceOBC_DSL"
    
    if not Path(doc_dir).exists():
        print(f"❌ Directory non trovata: {doc_dir}")
        print("   Modifica il path nel codice\n")
        return
    
    # Verifica e indicizza se necessario
    if pipeline.vector_store.is_empty():
        print("📚 Indicizzazione directory prima del batch...")
        count = pipeline.index_documentation(doc_dir, reset_collection=True)
        print(f"✓ Indicizzati {count} documenti\n")
    else:
        print("✅ Vector store già popolato\n")
    
    # Ora esegui batch generation
    print("🔄 Avvio generazione batch...")
    try:
        results = pipeline.generate_batch(
            input_dir=doc_dir,
            output_dir="data/generated_dsl/batch_output",
            file_pattern="*.md"
        )
        
        valid = sum(1 for r in results if r['validation']['is_valid'])
        print(f"\n✅ Completato: {valid}/{len(results)} DSL validi\n")
        
    except Exception as e:
        print(f"❌ Errore durante batch generation: {e}\n")


def main():
    """Esegue tutti gli esempi"""
    print("\n" + "="*60)
    print("ESEMPI DI VERIFICA DOCUMENTAZIONE")
    print("="*60 + "\n")
    
    try:
        # Esempio 1: Check base
        has_data = example_check_vector_store()
        input("\n⏸️  Premi ENTER per continuare...\n")
        
        # Esempio 2: Indicizzazione prima della generazione
        example_index_before_generation()
        input("\n⏸️  Premi ENTER per continuare...\n")
        
        # Esempio 3: Generazione condizionale
        example_conditional_generation()
        input("\n⏸️  Premi ENTER per continuare...\n")
        
        # Esempio 4: Batch con verifica
        # Decommenta per eseguire (può richiedere tempo)
        # example_batch_with_check()
        
        print("\n" + "="*60)
        print("✅ ESEMPI COMPLETATI")
        print("="*60 + "\n")
        
    except KeyboardInterrupt:
        print("\n\n👋 Interruzione utente\n")
    except Exception as e:
        print(f"\n❌ Errore: {e}\n")


if __name__ == "__main__":
    main()
