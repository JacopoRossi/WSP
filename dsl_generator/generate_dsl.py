#!/usr/bin/env python3
"""
Script semplificato per generare DSL da documentazione

Uso rapido:
    python generate_dsl.py path/to/documentation.md
"""

import sys
import argparse
from pathlib import Path
from typing import Optional

from src.pipeline import DSLGeneratorPipeline


def is_valid_documentation(file_path: Path) -> bool:
    """
    Verifica se il file è una documentazione valida
    
    Args:
        file_path: Path al file da verificare
        
    Returns:
        True se il file è valido, False altrimenti
    """
    valid_extensions = {'.md', '.pdf', '.txt', '.docx', '.rst', '.html'}
    return file_path.is_file() and file_path.suffix.lower() in valid_extensions


def request_documentation_path() -> Optional[str]:
    """
    Richiede all'utente un path alla documentazione con loop di validazione
    
    Returns:
        Path valido o None se l'utente annulla
    """
    print("\n📚 Enter the path to the DSL documentation")
    print("Supported formats: .md, .pdf, .txt, .docx, .rst, .html")
    print("(Press Ctrl+C to cancel)\n")
    
    max_attempts = 3
    attempt = 0
    
    while attempt < max_attempts:
        try:
            path_input = input(f"Documentation path (attempt {attempt + 1}/{max_attempts}): ").strip()
            
            if not path_input:
                print("❌ Empty path, try again.\n")
                attempt += 1
                continue
            
            doc_path = Path(path_input)
            
            if not doc_path.exists():
                print(f"❌ File does not exist: {path_input}\n")
                attempt += 1
                continue
            
            if not is_valid_documentation(doc_path):
                print(f"❌ Unsupported file format: {doc_path.suffix}")
                print("Valid formats: .md, .pdf, .txt, .docx, .rst, .html\n")
                attempt += 1
                continue
            
            # Path valido
            return str(doc_path)
            
        except KeyboardInterrupt:
            print("\n\n👋 User interruption")
            return None
    
    print(f"\n❌ Maximum number of attempts exceeded ({max_attempts})")
    return None


def main():
    # Get the script's directory for resolving relative paths
    script_dir = Path(__file__).parent
    default_config = script_dir / "config" / "config.yaml"
    
    parser = argparse.ArgumentParser(
        description="Generate DSL from technical documentation",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Generate DSL from a document
  python generate_dsl.py ../SpaceOBC_DSL/spaceOBC1_manual.md

  # Specify custom output
  python generate_dsl.py ../SpaceOBC_DSL/spaceOBC1_manual.md -o my_output.dsl

  # Use custom configuration
  python generate_dsl.py ../SpaceOBC_DSL/spaceOBC1_manual.md -c my_config.yaml

  # Generate batch from directory
  python generate_dsl.py ../SpaceOBC_DSL/ --batch

  # Index documentation (for RAG)
  python generate_dsl.py ../SpaceOBC_DSL/ --index-only
  
  # Generate DSL with completeness check (default)
  python generate_dsl.py documenti/my_spec.md
  
  # Generate DSL without completeness check
  python generate_dsl.py documenti/my_spec.md --no-check
  
  # Generate DSL with check but without interaction
  python generate_dsl.py documenti/my_spec.md --no-interactive
        """
    )
    
    parser.add_argument(
        "input",
        help="Path to documentation file or directory"
    )
    
    parser.add_argument(
        "-o", "--output",
        help="Path for the output DSL file (default: auto)"
    )
    
    parser.add_argument(
        "-c", "--config",
        default=str(default_config),
        help="Path to configuration file (default: config/config.yaml)"
    )
    
    parser.add_argument(
        "--batch",
        action="store_true",
        help="Generate DSL for all files in directory"
    )
    
    parser.add_argument(
        "--pattern",
        default="*.md",
        help="File pattern for batch mode (default: *.md)"
    )
    
    parser.add_argument(
        "--index-only",
        action="store_true",
        help="Only index documentation without generating DSL"
    )
    
    parser.add_argument(
        "--no-rag",
        action="store_true",
        help="Disable RAG (faster but less accurate)"
    )
    
    parser.add_argument(
        "--reset",
        action="store_true",
        help="Reset vector store before indexing"
    )
    
    parser.add_argument(
        "--check-completeness",
        action="store_true",
        default=True,
        help="Verify that documentation contains all necessary information (default: True)"
    )
    
    parser.add_argument(
        "--no-check",
        action="store_true",
        help="Disable completeness check"
    )
    
    parser.add_argument(
        "--no-interactive",
        action="store_true",
        help="Disable interactive request for missing information"
    )
    
    args = parser.parse_args()
    
    # Verifica che input esista
    input_path = Path(args.input)
    if not input_path.exists():
        print(f"❌ Error: Path not found: {args.input}")
        return 1
    
    try:
        # Inizializza pipeline
        print("🔧 Initializing pipeline...")
        pipeline = DSLGeneratorPipeline(config_path=args.config)
        
        # Modalità index-only
        if args.index_only:
            print(f"\n📑 Indexing documentation from: {args.input}")
            count = pipeline.index_documentation(
                args.input,
                reset_collection=args.reset
            )
            print(f"✓ Indexed {count} documents")
            return 0
        
        # Modalità batch
        if args.batch:
            if not input_path.is_dir():
                print(f"❌ Error: --batch requires a directory, found file")
                return 1
            
            results = pipeline.generate_batch(
                input_dir=args.input,
                output_dir=args.output,
                file_pattern=args.pattern
            )
            
            # Riepilogo
            valid_count = sum(1 for r in results if r['validation']['is_valid'])
            print(f"\n✓ Completed: {valid_count}/{len(results)} valid DSLs")
            
            return 0 if valid_count == len(results) else 1
        
        # Modalità singolo file
        if input_path.is_dir():
            print(f"❌ Error: Directory specified but not --batch")
            print(f"   Use --batch to process directory")
            return 1
        
        # Genera DSL
        result = pipeline.generate_dsl(
            documentation_path=args.input,
            output_path=args.output,
            use_indexed=not args.no_rag,
            check_completeness=not args.no_check,
            interactive_completion=not args.no_interactive
        )
        
        # Risultato
        if result.get('success') is False:
            # Generazione annullata
            return 1
        
        if result['validation']['is_valid']:
            print("\n✅ DSL generated successfully!")
            return 0
        else:
            print(f"\n⚠️  DSL generated but with {len(result['validation']['errors'])} errors")
            return 1
    
    except KeyboardInterrupt:
        print("\n\n👋 User interruption")
        return 130
    
    except Exception as e:
        print(f"\n❌ Error: {e}")
        
        if "--debug" in sys.argv:
            import traceback
            traceback.print_exc()
        else:
            print("   (use --debug for details)")
        
        return 1


if __name__ == "__main__":
    sys.exit(main())
