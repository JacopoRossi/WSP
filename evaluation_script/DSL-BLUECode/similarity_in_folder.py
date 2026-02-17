#!/usr/bin/env python3
"""
Batch similarity calculator: confronta file principale con file di run
Genera report con DSL-CodeBLEU scores
"""

import os
import sys
import csv
from pathlib import Path
from calculate_similarity import calculate_dsl_similarity
from dsl_parser import DSLParser


def identify_files(folder_path):
    """
    Identifica il file principale e i file delle run
    
    Args:
        folder_path: Path della cartella
    
    Returns:
        tuple: (reference_file, run_files_list)
    """
    folder = Path(folder_path)
    
    if not folder.exists() or not folder.is_dir():
        raise ValueError(f"La cartella {folder_path} non esiste o non è una directory")
    
    # Trova tutti i file .dsl
    all_files = list(folder.glob("*.dsl"))
    
    if not all_files:
        raise ValueError(f"Nessun file .dsl trovato in {folder_path}")
    
    # Identifica il file principale (quello senza "run" nel nome)
    reference_file = None
    run_files = []
    
    for f in all_files:
        if "run" in f.name.lower():
            run_files.append(f)
        else:
            if reference_file is None:
                reference_file = f
            else:
                # Se ci sono più file senza "run", prendi quello con nome più corto
                if len(f.name) < len(reference_file.name):
                    reference_file = f
    
    if reference_file is None:
        raise ValueError(f"Nessun file principale trovato in {folder_path}")
    
    if not run_files:
        raise ValueError(f"Nessun file di run trovato in {folder_path}")
    
    # Ordina i file di run per nome
    run_files.sort()
    
    return reference_file, run_files


def calculate_batch_similarity(folder_path, output_csv=None, output_txt=None):
    """
    Calcola similarità per tutti i file in una cartella
    Include sempre name/sig nel calcolo della similarità.
    
    Args:
        folder_path: Path della cartella contenente i file
        output_csv: Path del file CSV di output (opzionale)
        output_txt: Path del file TXT di output (opzionale)
    
    Returns:
        list: Lista di dizionari con i risultati
    """
    print("=" * 70)
    print("BATCH SIMILARITY CALCULATOR")
    print("=" * 70)
    print(f"\n📁 Cartella: {folder_path}")
    print(f"⚙️  Modalità: INCLUDE name/sig\n")
    
    # Identifica i file
    try:
        reference_file, run_files = identify_files(folder_path)
    except ValueError as e:
        print(f"❌ Errore: {e}")
        sys.exit(1)
    
    print(f"📄 File principale (reference): {reference_file.name}")
    print(f"📊 File di run trovati: {len(run_files)}")
    print()
    
    # Carica il file di riferimento
    with open(reference_file, 'r', encoding='utf-8') as f:
        reference_content = f.read()
    
    # Risultati
    results = []
    
    # Calcola similarità per ogni file di run
    for i, run_file in enumerate(run_files, 1):
        print(f"[{i}/{len(run_files)}] Processando: {run_file.name}...")
        
        try:
            # Carica file di run
            with open(run_file, 'r', encoding='utf-8') as f:
                hypothesis_content = f.read()
            
            # Calcola similarità (include sempre name/sig)
            result = calculate_dsl_similarity(reference_content, hypothesis_content)
            
            if result is None:
                print(f"  ⚠️  Errore nel calcolo per {run_file.name}")
                continue
            
            # Estrai metrica DSL-CodeBLEU
            dsl_codebleu = result['codebleu']
            
            results.append({
                'filename': run_file.name,
                'dsl_codebleu': dsl_codebleu
            })
            
            print(f"  ✅ DSL-CodeBLEU: {dsl_codebleu:.4f}")
            
        except Exception as e:
            print(f"  ❌ Errore: {e}")
            continue
    
    print("\n" + "=" * 70)
    print("📈 SUMMARY")
    print("=" * 70)
    print(f"\nFile processati: {len(results)}/{len(run_files)}")
    
    if results:
        avg_codebleu = sum(r['dsl_codebleu'] for r in results) / len(results)
        
        print(f"\n📊 Media:")
        print(f"  - DSL-CodeBLEU medio:  {avg_codebleu:.4f}")
        
        # Min/Max
        min_codebleu = min(results, key=lambda x: x['dsl_codebleu'])
        max_codebleu = max(results, key=lambda x: x['dsl_codebleu'])
        
        print(f"\n📉 Min DSL-CodeBLEU: {min_codebleu['dsl_codebleu']:.4f} ({min_codebleu['filename']})")
        print(f"📈 Max DSL-CodeBLEU: {max_codebleu['dsl_codebleu']:.4f} ({max_codebleu['filename']})")
    
    # Salva CSV
    if output_csv and results:
        save_csv_report(results, reference_file.name, output_csv)
        print(f"\n💾 Report CSV salvato: {output_csv}")
    
    # Salva TXT
    if output_txt and results:
        save_txt_report(results, reference_file.name, output_txt)
        print(f"💾 Report TXT salvato: {output_txt}")
    
    print("\n" + "=" * 70)
    
    return results


def save_csv_report(results, reference_name, output_path):
    """Salva report in formato CSV"""
    with open(output_path, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        
        # Header
        writer.writerow([
            'Reference File',
            'Hypothesis File',
            'DSL-CodeBLEU'
        ])
        
        # Data
        for r in results:
            writer.writerow([
                reference_name,
                r['filename'],
                f"{r['dsl_codebleu']:.4f}"
            ])


def save_txt_report(results, reference_name, output_path):
    """Salva report in formato TXT leggibile"""
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write("=" * 70 + "\n")
        f.write("BATCH SIMILARITY REPORT\n")
        f.write("=" * 70 + "\n\n")
        f.write(f"Reference File: {reference_name}\n")
        f.write(f"Total Comparisons: {len(results)}\n\n")
        
        # Statistics
        if results:
            avg_codebleu = sum(r['dsl_codebleu'] for r in results) / len(results)
            
            f.write("SUMMARY STATISTICS\n")
            f.write("-" * 70 + "\n")
            f.write(f"Average DSL-CodeBLEU Score: {avg_codebleu:.4f}\n\n")
        
        # Detailed results
        f.write("DETAILED RESULTS\n")
        f.write("-" * 70 + "\n\n")
        
        for i, r in enumerate(results, 1):
            f.write(f"{i}. {r['filename']}\n")
            f.write(f"   🎯 DSL-CodeBLEU: {r['dsl_codebleu']:.4f}\n\n")


def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(
        description='Batch DSL similarity calculator',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Analizza una cartella (include sempre name/sig)
  python similarity_in_folder.py DSL/task52
  
  # Specifica output personalizzati
  python similarity_in_folder.py DSL/task52 --csv my_report.csv --txt my_report.txt
  
  # Analizza tutte le cartelle task*
  for dir in DSL/task*/; do python similarity_in_folder.py "$dir"; done
        """
    )
    
    parser.add_argument('folder', help='Cartella contenente i file DSL da analizzare')
    parser.add_argument('--csv', help='Path del file CSV di output (default: auto-generato)')
    parser.add_argument('--txt', help='Path del file TXT di output (default: auto-generato)')
    parser.add_argument('--no-csv', action='store_true', help='Non generare report CSV')
    parser.add_argument('--no-txt', action='store_true', help='Non generare report TXT')
    
    args = parser.parse_args()
    
    # Determina i path di output
    folder_name = Path(args.folder).name
    
    csv_output = None if args.no_csv else (args.csv or f"similarity_report_{folder_name}.csv")
    txt_output = None if args.no_txt else (args.txt or f"similarity_report_{folder_name}.txt")
    
    # Esegui batch similarity (include sempre name/sig)
    calculate_batch_similarity(args.folder, csv_output, txt_output)


if __name__ == "__main__":
    main()
