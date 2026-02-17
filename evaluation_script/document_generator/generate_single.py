#!/usr/bin/env python3
"""
Script per generare un singolo manuale da un file DSL specifico.
Utile per test rapidi senza processare tutti i file.

Uso:
    python generate_single.py <file_dsl> [--output <percorso>]
    
Esempio:
    python generate_single.py Syntethic_DSL/12_task.dsl
    python generate_single.py Syntethic_DSL/12_task.dsl --output mio_manuale.md
"""

import os
import sys
import argparse
from pathlib import Path
from generate_manuals import ManualGenerator


def main():
    parser = argparse.ArgumentParser(
        description='Genera un singolo manuale da un file DSL'
    )
    parser.add_argument(
        'dsl_file',
        type=str,
        help='Path al file DSL (es. Syntethic_DSL/12_task.dsl)'
    )
    parser.add_argument(
        '--output',
        type=str,
        default=None,
        help='Path di output (default: generated_manuals/)'
    )
    
    args = parser.parse_args()
    
    print("=" * 60)
    print("  GENERATORE SINGOLO MANUALE")
    print("=" * 60)
    
    # Verifica chiave API
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("\n✗ ERRORE: Variabile GEMINI_API_KEY non trovata!")
        print("Configura con: export GEMINI_API_KEY='la-tua-chiave'")
        sys.exit(1)
    
    # Configura percorsi
    base_dir = Path(__file__).parent
    template_dir = base_dir / "template"
    dsl_file = Path(args.dsl_file)
    
    if not dsl_file.exists():
        print(f"\n✗ File DSL non trovato: {dsl_file}")
        sys.exit(1)
    
    # Leggi il manuale template
    template_manual = template_dir / "temp.md"
    if not template_manual.exists():
        print(f"\n✗ Template non trovato: {template_manual}")
        print("Assicurati che esista il file template/temp.md")
        sys.exit(1)
    
    print(f"\n📖 Template: {template_manual.name}")
    print(f"📄 DSL: {dsl_file.name}\n")
    
    # Inizializza generatore
    try:
        generator = ManualGenerator(api_key)
    except Exception as e:
        print(f"✗ Errore nell'inizializzazione: {e}")
        sys.exit(1)
    
    # Leggi i file
    original_content = generator.read_file(template_manual)
    dsl_content = generator.read_file(dsl_file)
    
    if not original_content or not dsl_content:
        print("✗ Errore nella lettura dei file!")
        sys.exit(1)
    
    # Genera il manuale
    print("🔄 Generazione in corso...")
    generated_manual = generator.generate_manual(
        original_content,
        dsl_content,
        dsl_file.name
    )
    
    if generated_manual:
        # Determina percorso di output
        if args.output:
            output_path = Path(args.output)
        else:
            output_dir = base_dir / "generated_manuals"
            output_dir.mkdir(parents=True, exist_ok=True)
            output_path = output_dir / f"{dsl_file.stem}_manual.md"
        
        # Salva il manuale
        generator.write_file(output_path, generated_manual)
        print(f"\n✅ SUCCESSO!")
        print(f"📁 Manuale salvato in: {output_path}")
    else:
        print("\n✗ Generazione fallita!")
        sys.exit(1)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠ Operazione interrotta")
        sys.exit(1)
    except Exception as e:
        print(f"\n✗ Errore: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
