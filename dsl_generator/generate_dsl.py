#!/usr/bin/env python3
"""
Script semplificato per generare DSL da documentazione

Uso rapido:
    python generate_dsl.py path/to/documentation.md
"""

import sys
import argparse
from pathlib import Path

from src.pipeline import DSLGeneratorPipeline


def main():
    parser = argparse.ArgumentParser(
        description="Genera DSL da documentazione tecnica",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Esempi:
  # Genera DSL da un documento
  python generate_dsl.py ../SpaceOBC_DSL/spaceOBC1_manual.md

  # Specifica output personalizzato
  python generate_dsl.py ../SpaceOBC_DSL/spaceOBC1_manual.md -o my_output.dsl

  # Usa configurazione personalizzata
  python generate_dsl.py ../SpaceOBC_DSL/spaceOBC1_manual.md -c my_config.yaml

  # Genera batch da directory
  python generate_dsl.py ../SpaceOBC_DSL/ --batch

  # Indicizza documentazione (per RAG)
  python generate_dsl.py ../SpaceOBC_DSL/ --index-only
        """
    )
    
    parser.add_argument(
        "input",
        help="Path al file documentazione o directory"
    )
    
    parser.add_argument(
        "-o", "--output",
        help="Path per il file DSL output (default: auto)"
    )
    
    parser.add_argument(
        "-c", "--config",
        default="config/config.yaml",
        help="Path al file di configurazione (default: config/config.yaml)"
    )
    
    parser.add_argument(
        "--batch",
        action="store_true",
        help="Genera DSL per tutti i file nella directory"
    )
    
    parser.add_argument(
        "--pattern",
        default="*.md",
        help="Pattern per file in modalità batch (default: *.md)"
    )
    
    parser.add_argument(
        "--index-only",
        action="store_true",
        help="Indicizza solo la documentazione senza generare DSL"
    )
    
    parser.add_argument(
        "--no-rag",
        action="store_true",
        help="Disabilita RAG (più veloce ma meno accurato)"
    )
    
    parser.add_argument(
        "--reset",
        action="store_true",
        help="Reset vector store prima di indicizzare"
    )
    
    args = parser.parse_args()
    
    # Verifica che input esista
    input_path = Path(args.input)
    if not input_path.exists():
        print(f"❌ Errore: Path non trovato: {args.input}")
        return 1
    
    try:
        # Inizializza pipeline
        print("🔧 Inizializzazione pipeline...")
        pipeline = DSLGeneratorPipeline(config_path=args.config)
        
        # Modalità index-only
        if args.index_only:
            print(f"\n📑 Indicizzazione documentazione da: {args.input}")
            count = pipeline.index_documentation(
                args.input,
                reset_collection=args.reset
            )
            print(f"✓ Indicizzati {count} documenti")
            return 0
        
        # Modalità batch
        if args.batch:
            if not input_path.is_dir():
                print(f"❌ Errore: --batch richiede una directory, trovato file")
                return 1
            
            results = pipeline.generate_batch(
                input_dir=args.input,
                output_dir=args.output,
                file_pattern=args.pattern
            )
            
            # Riepilogo
            valid_count = sum(1 for r in results if r['validation']['is_valid'])
            print(f"\n✓ Completato: {valid_count}/{len(results)} DSL validi")
            
            return 0 if valid_count == len(results) else 1
        
        # Modalità singolo file
        if input_path.is_dir():
            print(f"❌ Errore: Specificato directory ma non --batch")
            print(f"   Usa --batch per processare directory")
            return 1
        
        # Genera DSL
        result = pipeline.generate_dsl(
            documentation_path=args.input,
            output_path=args.output,
            use_indexed=not args.no_rag
        )
        
        # Risultato
        if result['validation']['is_valid']:
            print("\n✅ DSL generato con successo!")
            return 0
        else:
            print(f"\n⚠️  DSL generato ma con {len(result['validation']['errors'])} errori")
            return 1
    
    except KeyboardInterrupt:
        print("\n\n👋 Interruzione utente")
        return 130
    
    except Exception as e:
        print(f"\n❌ Errore: {e}")
        
        if "--debug" in sys.argv:
            import traceback
            traceback.print_exc()
        else:
            print("   (usa --debug per dettagli)")
        
        return 1


if __name__ == "__main__":
    sys.exit(main())
