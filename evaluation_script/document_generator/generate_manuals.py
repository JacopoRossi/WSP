#!/usr/bin/env python3
"""
Script per generare varianti di manuali tecnici basati su file DSL usando l'API di Gemini.

Questo script:
1. Legge il manuale template da 'template/temp.md'
2. Legge i file DSL dalla cartella 'Syntethic_DSL/'
3. Usa l'API di Gemini per generare nuovi manuali che rispecchiano i DSL
4. Salva i manuali generati nella cartella 'generated_manuals/'
"""

import os
import sys
import json
import time
from pathlib import Path
from typing import List, Dict, Optional
from google import genai
from google.genai import types
from datetime import datetime


class ManualGenerator:
    """Classe per generare manuali tecnici basati su DSL usando Gemini."""
    
    def __init__(self, api_key: str, model_name: str = "models/gemini-2.5-pro"):
        """
        Inizializza il generatore.
        
        Args:
            api_key: Chiave API di Google Gemini
            model_name: Nome del modello Gemini da usare
        """
        self.client = genai.Client(api_key=api_key)
        self.model_name = model_name
        self.generation_config = types.GenerateContentConfig(
            temperature=0.7,
            top_p=0.95,
            top_k=40,
            max_output_tokens=32768,  # Aumentato per manuali completi senza omissioni
        )
        
    def read_file(self, filepath: Path) -> str:
        """Legge il contenuto di un file."""
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                return f.read()
        except Exception as e:
            print(f"Errore nella lettura di {filepath}: {e}")
            return ""
    
    def write_file(self, filepath: Path, content: str):
        """Scrive il contenuto in un file."""
        try:
            filepath.parent.mkdir(parents=True, exist_ok=True)
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"✓ Salvato: {filepath}")
        except Exception as e:
            print(f"✗ Errore nel salvare {filepath}: {e}")
    
    def create_prompt(self, original_manual: str, dsl_content: str, dsl_filename: str) -> str:
        """
        Crea il prompt per Gemini per generare un nuovo manuale.
        
        Args:
            original_manual: Contenuto del manuale originale
            dsl_content: Contenuto del file DSL
            dsl_filename: Nome del file DSL
            
        Returns:
            Prompt formattato per Gemini
        """
        prompt = f"""You are a technical expert in creating professional technical documentation.

Your task is to generate a NEW, comprehensive technical manual that:
1. Is based on the STRUCTURE and STYLE of the provided original manual.
2. Describes the system defined in the provided DSL file.
3. Maintains the same level of detail and professionalism as the original manual.

ORIGINAL MANUAL (to be used as a structure and style template):
---
{original_manual}
---

DSL FILE (system to be documented):
---
Filename: {dsl_filename}
{dsl_content}
---

DETAILED INSTRUCTIONS:
1. Analyze the DSL and understand:
   - The system name (wsp.name)
   - The defined services and their responsibilities
   - The tasks and their characteristics (duration, resources, constraints)
   - The temporal constraints and dependencies between tasks
   - The global configuration parameters

2. Generate a NEW comprehensive technical manual that:
   - Uses the same structure as the original manual (same sections, same format)
   - Adapts the content to the DSL system (changes names, descriptions, values)
   - Maintains the same level of technical detail
   - Uses professional and technical language
   - Includes tables for parameters, services, and tasks
   - Explains the architecture, temporal constraints, and dependencies

3. Elements to customize:
   - System name
   - Service names and their descriptions
   - Task names and their technical specifications
   - Parameter values (h_end, r_max, durations, resources, etc.)
   - Constraints and dependencies between tasks
   - Document date (use: {datetime.now().strftime('%B %d, %Y')})

4. Maintain:
   - The same Markdown structure
   - The same professional tone
   - The same sections (introduction, configuration, architecture, etc.)
   - The formatting of tables and lists

⚠️ CRITICAL RULES - CONTENT COMPLETENESS:
   - NEVER omit any information from the DSL.
   - Write ALL tables COMPLETELY with ALL rows.
   - Include ALL tasks defined in the DSL (none excluded).
   - Include ALL constraints and dependencies (complete start_constraints).
   - DO NOT use phrases like "truncated for brevity", "omitted for space", "etc.", "...".
   - DO NOT write "Note: The table is truncated" or similar.
   - If the DSL has 12 tasks, the table must have 12 rows.
   - If the DSL has 100 constraints, list all 100 constraints.
   - The manual must be COMPLETE and EXHAUSTIVE, not a summary.

GENERATE THE COMPLETE MANUAL IN MARKDOWN FORMAT, RETURN ONLY THE MANUAL WITHOUT ANY INTRODUCTORY PHRASES:
"""
    
        return prompt
    
    def generate_manual(
        self, 
        original_manual: str, 
        dsl_content: str, 
        dsl_filename: str,
        max_retries: int = 3
    ) -> Optional[str]:
        """
        Genera un nuovo manuale usando l'API di Gemini.
        
        Args:
            original_manual: Contenuto del manuale originale
            dsl_content: Contenuto del file DSL
            dsl_filename: Nome del file DSL
            max_retries: Numero massimo di tentativi in caso di errore
            
        Returns:
            Contenuto del manuale generato o None in caso di errore
        """
        prompt = self.create_prompt(original_manual, dsl_content, dsl_filename)
        
        for attempt in range(max_retries):
            try:
                print(f"  Generazione in corso (tentativo {attempt + 1}/{max_retries})...")
                response = self.client.models.generate_content(
                    model=self.model_name,
                    contents=prompt,
                    config=self.generation_config
                )
                
                # Accedi al testo della risposta correttamente
                response_text = None
                if hasattr(response, 'text') and response.text:
                    response_text = response.text
                elif hasattr(response, 'candidates') and response.candidates:
                    if response.candidates[0].content.parts:
                        response_text = response.candidates[0].content.parts[0].text
                
                if response_text:
                    return response_text
                else:
                    print(f"  ⚠ Risposta vuota, riprovo...")
                    time.sleep(2)
                    
            except Exception as e:
                print(f"  ⚠ Errore durante la generazione: {e}")
                if attempt < max_retries - 1:
                    wait_time = (attempt + 1) * 2
                    print(f"  Attendo {wait_time} secondi prima di riprovare...")
                    time.sleep(wait_time)
                else:
                    print(f"  ✗ Falliti tutti i tentativi per questo manuale")
                    return None
        
        return None
    
    def process_all(
        self,
        template_path: Path,
        dsl_dir: Path,
        output_dir: Path
    ):
        """
        Processa tutti i file DSL e genera i manuali corrispondenti.
        
        Args:
            template_path: Path al file template
            dsl_dir: Directory con i file DSL
            output_dir: Directory dove salvare i manuali generati
        """
        # Leggi il manuale template
        if not template_path.exists():
            print(f"✗ Template non trovato: {template_path}")
            return
            
        print(f"\n📖 Template manuale: {template_path.name}")
        original_content = self.read_file(template_path)
        
        if not original_content:
            print("✗ Impossibile leggere il manuale template!")
            return
        
        # Leggi i file DSL
        dsl_files = sorted(list(dsl_dir.glob("*.dsl")))
        if not dsl_files:
            print("✗ Nessun file DSL trovato!")
            return
        
        print(f"\n📋 Trovati {len(dsl_files)} file DSL da processare\n")
        
        # Crea la directory di output
        output_dir.mkdir(parents=True, exist_ok=True)
        
        # Processa ogni DSL
        for idx, dsl_file in enumerate(dsl_files, 1):
            print(f"\n[{idx}/{len(dsl_files)}] Processamento: {dsl_file.name}")
            print("-" * 60)
            
            # Leggi il DSL
            dsl_content = self.read_file(dsl_file)
            if not dsl_content:
                print(f"  ✗ Impossibile leggere il file DSL, salto...")
                continue
            
            # Genera il manuale
            generated_manual = self.generate_manual(
                original_content,
                dsl_content,
                dsl_file.name
            )
            
            if generated_manual:
                # Salva il manuale generato
                output_filename = f"{dsl_file.stem}_manual.md"
                output_path = output_dir / output_filename
                self.write_file(output_path, generated_manual)
                print(f"  ✓ Completato con successo!")
            else:
                print(f"  ✗ Generazione fallita per {dsl_file.name}")
            
            # Pausa tra le richieste per evitare rate limiting
            if idx < len(dsl_files):
                time.sleep(1)
        
        print(f"\n{'=' * 60}")
        print(f"✓ Processo completato!")
        print(f"📁 Manuali generati salvati in: {output_dir}")


def main():
    """Funzione principale."""
    print("=" * 60)
    print("  GENERATORE DI MANUALI TECNICI DA DSL")
    print("  Powered by Google Gemini API")
    print("=" * 60)
    
    # Ottieni la chiave API
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("\n✗ ERRORE: Variabile d'ambiente GEMINI_API_KEY non trovata!")
        print("\nPer configurare la chiave API:")
        print("  export GEMINI_API_KEY='la-tua-chiave-api'")
        print("\nOppure modifica questo script e inserisci la chiave direttamente.")
        sys.exit(1)
    
    # Configura i percorsi
    base_dir = Path(__file__).parent
    template_path = base_dir / "template" / "temp.md"
    dsl_dir = base_dir / "Syntethic_DSL"
    output_dir = base_dir / "generated_manuals"
    
    # Verifica che i path esistano
    if not template_path.exists():
        print(f"✗ Template non trovato: {template_path}")
        print("Assicurati che esista il file template/temp.md")
        sys.exit(1)
    
    if not dsl_dir.exists():
        print(f"✗ Directory non trovata: {dsl_dir}")
        sys.exit(1)
    
    # Inizializza il generatore
    try:
        generator = ManualGenerator(api_key)
    except Exception as e:
        print(f"✗ Errore nell'inizializzazione di Gemini: {e}")
        sys.exit(1)
    
    # Avvia la generazione
    try:
        generator.process_all(
            template_path,
            dsl_dir,
            output_dir
        )
    except KeyboardInterrupt:
        print("\n\n⚠ Processo interrotto dall'utente")
        sys.exit(1)
    except Exception as e:
        print(f"\n✗ Errore durante l'esecuzione: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
