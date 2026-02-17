"""
Interactive Completer - Sistema interattivo per completare informazioni mancanti

Questo modulo guida l'utente nel fornire le informazioni mancanti necessarie
per generare un DSL valido.
"""

import sys
from pathlib import Path
from typing import Optional, Dict, List, Any
from .completeness_checker import (
    DocumentationCompletenessChecker,
    CompletenessReport,
    MissingInformation
)


class InteractiveCompleter:
    """
    Sistema interattivo per guidare l'utente a completare le informazioni mancanti
    """
    
    def __init__(self, pipeline):
        """
        Inizializza il completer
        
        Args:
            pipeline: DSLGeneratorPipeline instance
        """
        self.pipeline = pipeline
        self.checker = DocumentationCompletenessChecker(pipeline.vector_store)
        self.additional_data = {}
    
    def check_and_request_missing_info(self, 
                                       documentation_path: str,
                                       min_confidence: float = 0.3,
                                       interactive: bool = True) -> tuple[bool, Dict]:
        """
        Verifica la completezza e richiede informazioni mancanti se necessario
        
        Args:
            documentation_path: Path alla documentazione già indicizzata
            min_confidence: Soglia minima di confidence
            interactive: Se True, chiede interattivamente all'utente
            
        Returns:
            (is_complete, additional_data) - Se completo e dati aggiuntivi raccolti
        """
        print("\n🔍 Checking information completeness...")
        
        # Controlla completezza
        report = self.checker.check_completeness(min_confidence)
        self.checker.print_report(report)
        
        # Se completo, tutto ok
        if report.is_complete:
            print("✅ Documentation contains all necessary critical information!")
            return True, {}
        
        # Se non interattivo, ritorna solo il report
        if not interactive:
            return False, {}
        
        # Modalità interattiva - chiedi all'utente
        return self._interactive_completion(report, documentation_path)
    
    def _interactive_completion(self, 
                               report: CompletenessReport,
                               original_doc_path: str) -> tuple[bool, Dict]:
        """
        Modalità interattiva per completare le informazioni
        
        Args:
            report: Report di completezza
            original_doc_path: Path al documento originale
            
        Returns:
            (success, additional_data)
        """
        critical_missing = report.get_critical_missing()
        
        if not critical_missing:
            print("\n✅ All critical information is present!")
            return True, {}
        
        print(f"\n⚠️  {len(critical_missing)} CRITICAL information missing")
        print("Without this information, the DSL may be incomplete or invalid.\n")
        
        print("Available options:")
        print("  1. Provide additional file(s) with missing documentation")
        print("  2. Manually enter missing information")
        print("  3. Proceed anyway (not recommended - may fail)")
        print("  4. Cancel generation\n")
        
        while True:
            try:
                choice = input("Choose an option (1/2/3/4): ").strip()
                
                if choice == "1":
                    return self._request_additional_files(critical_missing, original_doc_path)
                
                elif choice == "2":
                    return self._request_manual_input(critical_missing)
                
                elif choice == "3":
                    print("\n  WARNING: Proceeding without complete information")
                    print("   Generated DSL may be invalid!\n")
                    confirm = input("Are you sure? (yes/no): ").strip().lower()
                    if confirm in ['yes', 'y']:
                        return True, {}
                    else:
                        print("Operation cancelled. Choose another option.\n")
                
                elif choice == "4":
                    print("👋 Generation cancelled by user")
                    return False, {}
                
                else:
                    print("❌ Invalid option. Choose 1, 2, 3 or 4.\n")
            
            except KeyboardInterrupt:
                print("\n\n👋 User interruption")
                return False, {}
    
    def _request_additional_files(self, 
                                  missing_info: List[MissingInformation],
                                  original_doc_path: str) -> tuple[bool, Dict]:
        """
        Richiede file aggiuntivi con documentazione
        
        Args:
            missing_info: Lista di informazioni mancanti
            original_doc_path: Path al documento originale
            
        Returns:
            (success, additional_data)
        """
        print("\n📁 ADD SUPPLEMENTARY DOCUMENTATION")
        print("="*70)
        print("\nMissing information to provide:")
        for i, info in enumerate(missing_info, 1):
            print(f"  {i}. {info.description}")
            print(f"     💡 {info.suggestion}")
        
        print("\n" + "-"*70)
        print("Provide one or more files with this information.")
        print("Supported formats: .md, .pdf, .txt, .docx, .rst, .html")
        print("Enter 'done' when finished, 'cancel' to abort.\n")
        
        additional_files = []
        attempt = 0
        max_attempts = 5
        
        while attempt < max_attempts:
            try:
                file_path = input(f"File {len(additional_files) + 1} (or 'done'/'cancel'): ").strip()
                
                if file_path.lower() == 'done':
                    if additional_files:
                        break
                    else:
                        print("❌ You must provide at least one file. Use 'cancel' to abort.\n")
                        continue
                
                if file_path.lower() == 'cancel':
                    print("👋 Cancelled")
                    return False, {}
                
                path_obj = Path(file_path)
                
                if not path_obj.exists():
                    print(f"❌ File not found: {file_path}\n")
                    attempt += 1
                    continue
                
                if not self._is_valid_doc_file(path_obj):
                    print(f"❌ Unsupported format: {path_obj.suffix}")
                    print("Valid formats: .md, .pdf, .txt, .docx, .rst, .html\n")
                    attempt += 1
                    continue
                
                additional_files.append(str(path_obj))
                print(f"✓ Added: {file_path}")
                print(f"  Total files: {len(additional_files)}\n")
                attempt = 0  # Reset attempts on success
            
            except KeyboardInterrupt:
                print("\n\n👋 User interruption")
                return False, {}
        
        if not additional_files:
            print("❌ No valid files provided")
            return False, {}
        
        # Indicizza i nuovi file
        print(f"\n📑 Indexing {len(additional_files)} additional files...")
        try:
            total_indexed = 0
            for file_path in additional_files:
                count = self.pipeline.index_documentation(
                    file_path,
                    reset_collection=False  # Non resettare, aggiungi
                )
                total_indexed += count
                print(f"  ✓ {file_path}: {count} chunks")
            
            print(f"\n✅ Indexed {total_indexed} additional chunks")
            
            # Ricontrolla completezza
            print("\n🔍 Rechecking completeness...")
            new_report = self.checker.check_completeness()
            
            if new_report.is_complete:
                print("✅ Documentation is now complete!")
                return True, {'additional_files': additional_files}
            else:
                print("⚠️  Some information is still missing")
                still_missing = new_report.get_critical_missing()
                print(f"\nInformation still missing ({len(still_missing)}):")
                for info in still_missing:
                    print(f"  • {info.description}")
                
                print("\nDo you want to add more files or proceed anyway?")
                choice = input("(add/proceed/cancel): ").strip().lower()
                
                if choice == 'add':
                    return self._request_additional_files(still_missing, original_doc_path)
                elif choice == 'proceed':
                    return True, {'additional_files': additional_files}
                else:
                    return False, {}
        
        except Exception as e:
            print(f"❌ Error during indexing: {e}")
            return False, {}
    
    def _request_manual_input(self, 
                             missing_info: List[MissingInformation]) -> tuple[bool, Dict]:
        """
        Richiede input manuale per le informazioni mancanti
        
        Args:
            missing_info: Lista di informazioni mancanti
            
        Returns:
            (success, additional_data)
        """
        print("\n✏️  MANUAL INFORMATION INPUT")
        print("="*70)
        print("\nEnter missing information:")
        print("(Press Enter to skip a field, 'cancel' to abort)\n")
        
        manual_data = {}
        
        try:
            for info in missing_info:
                print(f"\n📌 {info.description}")
                print(f"   Categoria: {info.category} | Campo: {info.field}")
                print(f"   💡 {info.suggestion}")
                
                value = input(f"   Value: ").strip()
                
                if value.lower() == 'cancel':
                    print("👋 Cancelled")
                    return False, {}
                
                if value:
                    key = f"{info.category}.{info.field}"
                    manual_data[key] = value
                    print(f"   ✓ Saved")
                else:
                    print(f"   ⊚ Skipped")
            
            if not manual_data:
                print("\n⚠️  No data entered")
                return False, {}
            
            print(f"\n✅ Collected {len(manual_data)} information")
            
            # Crea un documento temporaneo con i dati manuali
            temp_doc = self._create_temp_document(manual_data)
            
            # Indicizza il documento temporaneo
            print("\n📑 Indexing manual data...")
            count = self.pipeline.index_documentation(
                temp_doc,
                reset_collection=False
            )
            print(f"✓ Indexed {count} chunks")
            
            # Cleanup
            Path(temp_doc).unlink()
            
            return True, {'manual_data': manual_data}
        
        except KeyboardInterrupt:
            print("\n\n👋 User interruption")
            return False, {}
    
    def _create_temp_document(self, data: Dict[str, str]) -> str:
        """
        Crea un documento temporaneo con i dati manuali
        
        Args:
            data: Dati manuali raccolti
            
        Returns:
            Path al documento temporaneo
        """
        temp_path = Path(self.pipeline.config['pipeline']['output_dir']) / "temp_manual_data.md"
        temp_path.parent.mkdir(parents=True, exist_ok=True)
        
        content = "# Manually Added Information\n\n"
        
        for key, value in data.items():
            category, field = key.split('.', 1)
            content += f"## {category.upper()} - {field}\n\n"
            content += f"{value}\n\n"
        
        temp_path.write_text(content, encoding='utf-8')
        return str(temp_path)
    
    def _is_valid_doc_file(self, path: Path) -> bool:
        """Verifica se il file è un formato valido"""
        valid_extensions = {'.md', '.pdf', '.txt', '.docx', '.rst', '.html'}
        return path.is_file() and path.suffix.lower() in valid_extensions


def demo_interactive_completion():
    """Demo della funzionalità interattiva"""
    print("\n" + "="*70)
    print("DEMO: Interactive Completeness Checker")
    print("="*70 + "\n")
    
    from ..pipeline import DSLGeneratorPipeline
    
    # Setup
    pipeline = DSLGeneratorPipeline(config_path="config/config.yaml")
    completer = InteractiveCompleter(pipeline)
    
    # Test con un documento
    doc_path = "../SpaceOBC_DSL/spaceOBC1_manual.md"
    
    if Path(doc_path).exists():
        # Indicizza
        pipeline.index_documentation(doc_path, reset_collection=True)
        
        # Controlla e richiedi
        success, data = completer.check_and_request_missing_info(
            doc_path,
            interactive=True
        )
        
        if success:
            print("\n✅ Pronto per generare DSL!")
            if data:
                print(f"Dati aggiuntivi raccolti: {data}")
        else:
            print("\n❌ Generazione annullata")
    else:
        print(f"❌ File non trovato: {doc_path}")


if __name__ == "__main__":
    demo_interactive_completion()
