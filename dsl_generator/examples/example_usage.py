"""
Esempio di utilizzo della DSL Generator Pipeline

Questo script mostra come usare la pipeline per generare DSL da documentazione.
"""

import sys
from pathlib import Path

# Aggiungi src al path
sys.path.insert(0, str(Path(__file__).parent.parent))

from src.pipeline import DSLGeneratorPipeline


def example_1_single_document():
    """Esempio 1: Genera DSL da un singolo documento"""
    print("\n" + "="*70)
    print("ESEMPIO 1: Generazione DSL da singolo documento")
    print("="*70 + "\n")
    
    # Inizializza pipeline
    pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")
    
    # Path alla documentazione
    doc_path = "../SpaceOBC_DSL/spaceOBC1_manual_extended.md"
    output_path = "data/generated_dsl/spaceOBC1_generated.dsl"
    
    # Genera DSL
    result = pipeline.generate_dsl(
        documentation_path=doc_path,
        output_path=output_path,
        use_indexed=False  # Indicizza al volo
    )
    
    # Mostra risultati
    print("\n📊 Risultati:")
    print(f"  Valido: {result['validation']['is_valid']}")
    print(f"  Errori: {len(result['validation']['errors'])}")
    print(f"  Warning: {len(result['validation']['warnings'])}")
    
    if result['dsl_data']:
        print(f"\n  Sistema: {result['dsl_data']['wsp']['name']}")
        print(f"  Servizi: {len(result['dsl_data']['services'])}")
        print(f"  Task: {len(result['dsl_data']['tasks'])}")
        print(f"  Vincoli: {len(result['dsl_data'].get('start_constraints', []))}")


def example_2_batch_processing():
    """Esempio 2: Genera DSL per molteplici documenti"""
    print("\n" + "="*70)
    print("ESEMPIO 2: Generazione batch da directory")
    print("="*70 + "\n")
    
    # Inizializza pipeline
    pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")
    
    # Directory con documentazione
    input_dir = "../SpaceOBC_DSL"
    output_dir = "data/generated_dsl/batch"
    
    # Genera DSL per tutti i file .md
    results = pipeline.generate_batch(
        input_dir=input_dir,
        output_dir=output_dir,
        file_pattern="*_manual_extended.md"
    )
    
    # Analizza risultati
    print("\n📊 Analisi risultati:")
    
    for result in results:
        input_file = Path(result['input_file']).name
        is_valid = result['validation']['is_valid']
        status = "✓" if is_valid else "✗"
        
        print(f"  {status} {input_file}")
        
        if not is_valid and result['validation']['errors']:
            print(f"     Errori: {len(result['validation']['errors'])}")


def example_3_with_rag():
    """Esempio 3: Usa RAG per migliorare la generazione"""
    print("\n" + "="*70)
    print("ESEMPIO 3: Generazione con RAG pre-indicizzato")
    print("="*70 + "\n")
    
    # Inizializza pipeline
    pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")
    
    # Step 1: Indicizza tutta la documentazione disponibile
    print("📑 Step 1: Indicizzazione documentazione...")
    doc_dir = "../SpaceOBC_DSL"
    pipeline.index_documentation(doc_dir, reset_collection=True)
    
    # Step 2: Genera DSL usando la knowledge base indicizzata
    print("\n⚙️  Step 2: Generazione DSL con RAG...")
    
    doc_path = "../SpaceOBC_DSL/spaceOBC2_manual.md"
    output_path = "data/generated_dsl/spaceOBC2_with_rag.dsl"
    
    result = pipeline.generate_dsl(
        documentation_path=doc_path,
        output_path=output_path,
        use_indexed=True  # Usa documentazione già indicizzata
    )
    
    print(f"\n✓ DSL generato con RAG")
    print(f"  Valido: {result['validation']['is_valid']}")


def example_4_custom_configuration():
    """Esempio 4: Usa configurazione personalizzata"""
    print("\n" + "="*70)
    print("ESEMPIO 4: Configurazione personalizzata")
    print("="*70 + "\n")
    
    # Puoi creare una configurazione personalizzata
    # Copia config/config.yaml e modifica i parametri
    
    custom_config = "config/config.yaml"  # Usa la tua configurazione
    
    pipeline = DSLGeneratorPipeline(config_path=custom_config)
    
    # Mostra statistiche
    stats = pipeline.get_stats()
    
    print("📊 Configurazione pipeline:")
    print(f"  LLM Provider: {stats['llm']['provider']}")
    print(f"  LLM Model: {stats['llm']['model']}")
    print(f"  Embedding Model: {stats['embedding']['model']}")
    print(f"  Vector Store: {stats['vector_store']['collection_name']}")
    print(f"  Documenti indicizzati: {stats['vector_store']['total_documents']}")


def example_5_validation_only():
    """Esempio 5: Valida un DSL esistente"""
    print("\n" + "="*70)
    print("ESEMPIO 5: Validazione DSL esistente")
    print("="*70 + "\n")
    
    from src.dsl.validator import DSLValidator
    
    # Carica DSL esistente
    dsl_path = "../SpaceOBC_DSL/spaceOBC1.dsl"
    
    with open(dsl_path, 'r') as f:
        dsl_content = f.read()
    
    # Valida
    validator = DSLValidator(strict_mode=True)
    is_valid, errors, warnings = validator.validate(dsl_content)
    
    print(f"📄 File: {dsl_path}")
    print(f"✓ Valido: {is_valid}")
    print(f"  Errori: {len(errors)}")
    print(f"  Warning: {len(warnings)}")
    
    if errors:
        print("\n❌ Errori trovati:")
        for error in errors:
            print(f"  - {error}")
    
    if warnings:
        print("\n⚠️  Warning:")
        for warning in warnings[:5]:  # Mostra primi 5
            print(f"  - {warning}")


def main():
    """Menu principale"""
    print("\n" + "="*70)
    print("DSL GENERATOR - ESEMPI DI UTILIZZO")
    print("="*70)
    print("\nScegli un esempio da eseguire:")
    print("  1. Genera DSL da singolo documento")
    print("  2. Genera DSL batch da directory")
    print("  3. Genera DSL con RAG pre-indicizzato")
    print("  4. Mostra configurazione personalizzata")
    print("  5. Valida DSL esistente")
    print("  0. Esci")
    
    choice = input("\nScelta (0-5): ").strip()
    
    if choice == "1":
        example_1_single_document()
    elif choice == "2":
        example_2_batch_processing()
    elif choice == "3":
        example_3_with_rag()
    elif choice == "4":
        example_4_custom_configuration()
    elif choice == "5":
        example_5_validation_only()
    elif choice == "0":
        print("\n👋 Arrivederci!")
        return
    else:
        print("\n❌ Scelta non valida")
        return
    
    print("\n✓ Esempio completato!")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n👋 Interruzione utente")
    except Exception as e:
        print(f"\n❌ Errore: {e}")
        import traceback
        traceback.print_exc()
