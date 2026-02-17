#!/usr/bin/env python3
"""
Script per eseguire similarity_in_folder.py su tutte le cartelle DSL
e salvare i risultati aggregati in un CSV con:
- Nome cartella
- DSL-CodeBLEU medio
"""

import os
import sys
import csv
import subprocess
from pathlib import Path


def get_dsl_folders(base_path="DSL"):
    """
    Trova tutte le cartelle dentro DSL/
    
    Args:
        base_path: Path della cartella DSL
    
    Returns:
        list: Lista di Path delle cartelle trovate
    """
    dsl_dir = Path(base_path)
    
    if not dsl_dir.exists():
        raise ValueError(f"La cartella {base_path} non esiste")
    
    # Trova tutte le sottocartelle
    folders = [f for f in dsl_dir.iterdir() if f.is_dir()]
    folders.sort()
    
    return folders


def run_batch_similarity(folder_path):
    """
    Esegue similarity_in_folder.py per una cartella e estrae le medie
    Include sempre name/sig nel calcolo.
    
    Args:
        folder_path: Path della cartella da analizzare
    
    Returns:
        dict: Risultati con avg_codebleu
    """
    print(f"\n{'='*70}")
    print(f"Processando: {folder_path.name}")
    print(f"{'='*70}")
    
    # Costruisce il comando (include sempre name/sig)
    cmd = ["python", "similarity_in_folder.py", str(folder_path), "--no-txt"]
    
    # Esegue il comando
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=True
        )
        
        output = result.stdout
        print(output)
        
        # Estrae la media dall'output
        avg_codebleu = None
        
        for line in output.split('\n'):
            if 'DSL-CodeBLEU medio:' in line:
                # Estrae il valore numerico
                avg_codebleu = float(line.split(':')[1].strip())
        
        if avg_codebleu is None:
            print(f"⚠️  Impossibile estrarre la media per {folder_path.name}")
            return None
        
        return {
            'folder': folder_path.name,
            'avg_codebleu': avg_codebleu
        }
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Errore nell'esecuzione per {folder_path.name}")
        print(f"   stderr: {e.stderr}")
        return None
    except Exception as e:
        print(f"❌ Errore: {e}")
        return None


def save_aggregated_csv(results, output_path):
    """
    Salva i risultati aggregati in un CSV
    Include sempre name/sig nel calcolo.
    
    Args:
        results: Lista di dizionari con i risultati
        output_path: Path del file CSV di output
    """
    with open(output_path, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        
        # Header
        writer.writerow([
            'Folder Name',
            'DSL-CodeBLEU Average'
        ])
        
        # Data
        for r in results:
            writer.writerow([
                r['folder'],
                f"{r['avg_codebleu']:.4f}"
            ])
        
        # Calcola media globale
        if results:
            global_avg_codebleu = sum(r['avg_codebleu'] for r in results) / len(results)
            
            writer.writerow([])  # Riga vuota
            writer.writerow([
                'GLOBAL AVERAGE',
                f"{global_avg_codebleu:.4f}"
            ])


def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(
        description='Esegue similarity_in_folder.py su tutte le cartelle DSL',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Analizza tutte le cartelle (include sempre name/sig)
  python run_all_folders.py
  
  # Specifica cartella DSL personalizzata
  python run_all_folders.py --dsl-dir path/to/DSL
  
  # Output personalizzato
  python run_all_folders.py --output my_results.csv
        """
    )
    
    parser.add_argument('--dsl-dir', default='DSL', 
                       help='Path della cartella DSL (default: DSL)')
    parser.add_argument('--output', default='all_folders_similarity.csv',
                       help='Path del file CSV di output (default: all_folders_similarity.csv)')
    
    args = parser.parse_args()
    
    print("=" * 70)
    print("BATCH SIMILARITY - ALL FOLDERS")
    print("=" * 70)
    print(f"\n📁 Cartella DSL: {args.dsl_dir}")
    print(f"⚙️  Modalità: INCLUDE name/sig")
    print(f"💾 Output CSV: {args.output}\n")
    
    # Trova tutte le cartelle
    try:
        folders = get_dsl_folders(args.dsl_dir)
    except ValueError as e:
        print(f"❌ Errore: {e}")
        sys.exit(1)
    
    print(f"Trovate {len(folders)} cartelle da processare\n")
    
    # Processa ogni cartella
    results = []
    for i, folder in enumerate(folders, 1):
        print(f"\n[{i}/{len(folders)}] Processando cartella: {folder.name}")
        
        result = run_batch_similarity(folder)
        
        if result:
            results.append(result)
            print(f"✅ Completato: {folder.name}")
            print(f"   - DSL-CodeBLEU medio:  {result['avg_codebleu']:.4f}")
        else:
            print(f"⚠️  Saltato: {folder.name}")
    
    # Salva risultati aggregati
    if results:
        save_aggregated_csv(results, args.output)
        
        print("\n" + "=" * 70)
        print("📊 SUMMARY - ALL FOLDERS")
        print("=" * 70)
        print(f"\nCartelle processate con successo: {len(results)}/{len(folders)}")
        
        # Media globale
        global_avg_codebleu = sum(r['avg_codebleu'] for r in results) / len(results)
        
        print(f"\n📈 Media globale:")
        print(f"  - DSL-CodeBLEU medio (tutte le cartelle):  {global_avg_codebleu:.4f}")
        
        # Min/Max
        min_codebleu = min(results, key=lambda x: x['avg_codebleu'])
        max_codebleu = max(results, key=lambda x: x['avg_codebleu'])
        
        print(f"\n📉 Min DSL-CodeBLEU: {min_codebleu['avg_codebleu']:.4f} ({min_codebleu['folder']})")
        print(f"📈 Max DSL-CodeBLEU: {max_codebleu['avg_codebleu']:.4f} ({max_codebleu['folder']})")
        
        print(f"\n💾 Risultati salvati in: {args.output}")
        print("\n" + "=" * 70)
    else:
        print("\n❌ Nessun risultato da salvare")
        sys.exit(1)


if __name__ == "__main__":
    main()
