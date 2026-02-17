#!/usr/bin/env python3
"""
Esempio di utilizzo della verifica di completezza informazioni DSL

Questo script dimostra come:
1. Verificare la completezza della documentazione
2. Ottenere un report dettagliato
3. Usare la modalità interattiva
4. Generare DSL con verifica automatica
"""

import sys
from pathlib import Path

# Aggiungi parent directory al path
sys.path.insert(0, str(Path(__file__).parent.parent))

from src.pipeline import DSLGeneratorPipeline
from src.dsl.completeness_checker import DocumentationCompletenessChecker
from src.dsl.interactive_completer import InteractiveCompleter


def example1_basic_completeness_check():
    """
    Esempio 1: Verifica base di completezza
    """
    print("\n" + "="*70)
    print("ESEMPIO 1: Verifica Base di Completezza")
    print("="*70 + "\n")
    
    # Setup
    pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")
    
    # Path documentazione
    doc_path = "../SpaceOBC_DSL/spaceOBC1_manual.md"
    
    if not Path(doc_path).exists():
        print(f"❌ File non trovato: {doc_path}")
        print("   Modifica il path nel codice per puntare a un file valido\n")
        return
    
    # Indicizza
    print(f"📑 Indicizzazione: {doc_path}")
    pipeline.index_documentation(doc_path, reset_collection=True)
    
    # Verifica completezza
    checker = DocumentationCompletenessChecker(pipeline.vector_store)
    report = checker.check_completeness(min_confidence=0.3)
    
    # Stampa report
    checker.print_report(report)
    
    # Analisi programmatica
    if report.is_complete:
        print("✅ La documentazione è completa - pronto per generare DSL\n")
    else:
        critical = report.get_critical_missing()
        optional = report.get_optional_missing()
        print(f"⚠️  Documet necessita integrazione:")
        print(f"   - {len(critical)} informazioni critiche mancanti")
        print(f"   - {len(optional)} informazioni opzionali mancanti")
        print(f"   - Confidence score: {report.confidence_score:.1%}\n")


def example2_programmatic_check_with_thresholds():
    """
    Esempio 2: Check programmatico con diverse soglie
    """
    print("\n" + "="*70)
    print("ESEMPIO 2: Test con Diverse Soglie di Confidence")
    print("="*70 + "\n")
    
    pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")
    doc_path = "../SpaceOBC_DSL/spaceOBC1_manual.md"
    
    if not Path(doc_path).exists():
        print(f"❌ File non trovato: {doc_path}\n")
        return
    
    # Indicizza
    pipeline.index_documentation(doc_path, reset_collection=True)
    checker = DocumentationCompletenessChecker(pipeline.vector_store)
    
    # Prova diverse soglie
    thresholds = [0.2, 0.3, 0.5, 0.7]
    
    print("Confronto risultati con diverse soglie di confidence:\n")
    print(f"{'Soglia':<10} {'Completo':<12} {'Info Trovate':<15} {'Critiche Mancanti'}")
    print("-" * 70)
    
    for threshold in thresholds:
        report = checker.check_completeness(min_confidence=threshold)
        found = sum(1 for v in report.found_info.values() if v)
        critical_missing = len(report.get_critical_missing())
        
        print(f"{threshold:<10.1f} "
              f"{'✓' if report.is_complete else '✗':<12} "
              f"{found:<15} "
              f"{critical_missing}")
    
    print("\n💡 Soglia più bassa = più permissivo (trova più informazioni)")
    print("💡 Soglia più alta = più stricto (richiede match più precisi)\n")


def example3_detailed_analysis():
    """
    Esempio 3: Analisi dettagliata di cosa è stato trovato
    """
    print("\n" + "="*70)
    print("ESEMPIO 3: Analisi Dettagliata Informazioni")
    print("="*70 + "\n")
    
    pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")
    doc_path = "../SpaceOBC_DSL/spaceOBC1_manual.md"
    
    if not Path(doc_path).exists():
        print(f"❌ File non trovato: {doc_path}\n")
        return
    
    pipeline.index_documentation(doc_path, reset_collection=True)
    checker = DocumentationCompletenessChecker(pipeline.vector_store)
    report = checker.check_completeness()
    
    print("📊 Analisi dettagliata per categoria:\n")
    
    # Raggruppa per categoria
    categories = {}
    for key, value in report.found_info.items():
        category = key.split('.')[0]
        if category not in categories:
            categories[category] = {'found': 0, 'missing': 0}
        if value:
            categories[category]['found'] += 1
        else:
            categories[category]['missing'] += 1
    
    # Stampa per categoria
    for category, stats in categories.items():
        total = stats['found'] + stats['missing']
        percentage = (stats['found'] / total * 100) if total > 0 else 0
        
        print(f"\n📌 {category.upper()}")
        print(f"   Trovate: {stats['found']}/{total} ({percentage:.0f}%)")
        
        # Dettagli cosa manca
        missing_in_cat = [
            info for info in report.missing_info 
            if info.category == category
        ]
        if missing_in_cat:
            print(f"   Mancanti:")
            for info in missing_in_cat:
                criticality = "CRITICO" if info.critical else "opzionale"
                print(f"      • {info.field} [{criticality}]")


def example4_interactive_completion_demo():
    """
    Esempio 4: Demo modalità interattiva (simulazione)
    """
    print("\n" + "="*70)
    print("ESEMPIO 4: Workflow con Interactive Completer")
    print("="*70 + "\n")
    
    pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")
    
    # Simula doc incompleta
    print("📝 Scenario: Documentazione parziale")
    print("   (Per demo non-interattiva, normalmente sarebbe interattivo)\n")
    
    # Crea un documento minimale
    minimal_doc = Path("data/generated_dsl/minimal_test.md")
    minimal_doc.parent.mkdir(parents=True, exist_ok=True)
    minimal_doc.write_text("""
# Test System

Il sistema si chiama TestSystem.

## Tasks

Abbiamo i seguenti task:
- TASK_A
- TASK_B
- TASK_C
    """)
    
    # Indicizza
    pipeline.index_documentation(str(minimal_doc), reset_collection=True)
    
    # Verifica
    completer = InteractiveCompleter(pipeline)
    checker = DocumentationCompletenessChecker(pipeline.vector_store)
    report = checker.check_completeness()
    
    print("📊 Report documentazione minimale:")
    checker.print_report(report)
    
    print("\n💡 In modalità interattiva, l'utente potrebbe ora:")
    print("   1. Aggiungere file con dettagli task (durate, risorse)")
    print("   2. Inserire manualmente i parametri mancanti")
    print("   3. Procedere comunque (rischio DSL invalido)")
    print("   4. Annullare e completare prima la documentazione\n")
    
    # Cleanup
    minimal_doc.unlink()


def example5_full_generation_with_check():
    """
    Esempio 5: Generazione completa con verifica
    """
    print("\n" + "="*70)
    print("ESEMPIO 5: Generazione DSL con Verifica Completezza")
    print("="*70 + "\n")
    
    pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")
    doc_path = "../SpaceOBC_DSL/spaceOBC1_manual.md"
    
    if not Path(doc_path).exists():
        print(f"❌ File non trovato: {doc_path}\n")
        return
    
    print("Generazione DSL con check completezza (non-interattivo)...\n")
    
    # Genera con check ma senza interazione
    result = pipeline.generate_dsl(
        documentation_path=doc_path,
        output_path="data/generated_dsl/example5_output.dsl",
        check_completeness=True,
        interactive_completion=False  # Non chiede input
    )
    
    if result.get('success') is False:
        print("❌ Generazione fallita o annullata")
        return
    
    if result['validation']['is_valid']:
        print("\n✅ DSL generato con successo!")
        print(f"   Output: data/generated_dsl/example5_output.dsl")
        print(f"   Tentativi: {result['validation']['attempts']}")
    else:
        print(f"\n⚠️  DSL generato con {len(result['validation']['errors'])} errori")
        print("   Probabilmente a causa di informazioni mancanti\n")


def example6_custom_validation():
    """
    Esempio 6: Validazione personalizzata
    """
    print("\n" + "="*70)
    print("ESEMPIO 6: Validazione Personalizzata")
    print("="*70 + "\n")
    
    pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")
    doc_path = "../SpaceOBC_DSL/spaceOBC1_manual.md"
    
    if not Path(doc_path).exists():
        print(f"❌ File non trovato: {doc_path}\n")
        return
    
    pipeline.index_documentation(doc_path, reset_collection=True)
    checker = DocumentationCompletenessChecker(pipeline.vector_store)
    
    print("🔍 Ricerca manuale di informazioni specifiche:\n")
    
    # Ricerca custom
    custom_queries = {
        'System Name': ['system name', 'workspace name', 'nome sistema'],
        'Time Period': ['time period', 'horizon', 'duration', 'periodo'],
        'Resource Count': ['resources', 'cpu', 'memory', 'risorse'],
        'Task List': ['tasks', 'activities', 'operations', 'processi']
    }
    
    for name, queries in custom_queries.items():
        found, confidence = checker._search_for_info(queries, top_k=2)
        status = "✓" if found else "✗"
        print(f"{status} {name:<20} - Confidence: {confidence:.1%}")
    
    print("\n💡 Puoi personalizzare le query in SEARCH_QUERIES")
    print("   per adattarle al tuo dominio specifico\n")


def main():
    """Esegue tutti gli esempi"""
    print("\n" + "="*70)
    print("🔍 ESEMPI DI VERIFICA COMPLETEZZA INFORMAZIONI DSL")
    print("="*70)
    
    try:
        # Menu esempi
        print("\nEsempi disponibili:")
        print("  1. Verifica base di completezza")
        print("  2. Test con diverse soglie di confidence")
        print("  3. Analisi dettagliata per categoria")
        print("  4. Workflow con interactive completer (demo)")
        print("  5. Generazione DSL completa con verifica")
        print("  6. Validazione personalizzata")
        print("  0. Esegui tutti\n")
        
        choice = input("Scegli esempio (0-6): ").strip()
        
        if choice == "0":
            example1_basic_completeness_check()
            input("\n⏸️  Premi ENTER per continuare...")
            
            example2_programmatic_check_with_thresholds()
            input("\n⏸️  Premi ENTER per continuare...")
            
            example3_detailed_analysis()
            input("\n⏸️  Premi ENTER per continuare...")
            
            example4_interactive_completion_demo()
            input("\n⏸️  Premi ENTER per continuare...")
            
            example5_full_generation_with_check()
            input("\n⏸️  Premi ENTER per continuare...")
            
            example6_custom_validation()
            
        elif choice == "1":
            example1_basic_completeness_check()
        elif choice == "2":
            example2_programmatic_check_with_thresholds()
        elif choice == "3":
            example3_detailed_analysis()
        elif choice == "4":
            example4_interactive_completion_demo()
        elif choice == "5":
            example5_full_generation_with_check()
        elif choice == "6":
            example6_custom_validation()
        else:
            print("❌ Scelta non valida")
            return 1
        
        print("\n" + "="*70)
        print("✅ ESEMPIO COMPLETATO")
        print("="*70 + "\n")
        
        return 0
        
    except KeyboardInterrupt:
        print("\n\n👋 Interruzione utente\n")
        return 130
    except Exception as e:
        print(f"\n❌ Errore: {e}\n")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())
