"""DSL Generator - Genera DSL da documentazione usando LLM e RAG"""

from typing import Optional, Dict
import yaml
from pathlib import Path

from ..llm.llm_client import LLMClient
from ..llm.prompt_builder import PromptBuilder
from ..rag.vector_store import VectorStore
from .validator import DSLValidator
from .templates import DSLTemplate


class DSLGenerator:
    """Genera DSL da documentazione tecnica"""
    
    def __init__(self,
                 llm_client: LLMClient,
                 prompt_builder: PromptBuilder,
                 vector_store: Optional[VectorStore] = None,
                 validator: Optional[DSLValidator] = None):
        """
        Inizializza il generatore DSL
        
        Args:
            llm_client: Client LLM per la generazione
            prompt_builder: Builder per i prompt
            vector_store: Vector store per RAG (opzionale)
            validator: Validatore DSL (opzionale)
        """
        self.llm_client = llm_client
        self.prompt_builder = prompt_builder
        self.vector_store = vector_store
        self.validator = validator or DSLValidator()
        
        self.use_rag = vector_store is not None
    
    def generate_from_documentation(self,
                                   documentation: str,
                                   max_retries: int = 3) -> Dict:
        """
        Genera DSL da documentazione
        
        Args:
            documentation: Testo della documentazione
            max_retries: Numero massimo di tentativi
            
        Returns:
            Dizionario con DSL generato e metadata
        """
        print("🚀 Avvio generazione DSL...")
        
        # Step 1: Estrazione informazioni
        print("\n📖 Step 1: Estrazione informazioni dalla documentazione...")
        extracted_info = self._extract_information(documentation)
        print(f"✓ Informazioni estratte ({len(extracted_info)} caratteri)")
        
        # Step 2: Generazione DSL
        print("\n⚙️  Step 2: Generazione DSL...")
        dsl_content = self._generate_dsl(extracted_info)
        print(f"✓ DSL generato ({len(dsl_content)} caratteri)")
        
        # Step 3: Validazione e correzione
        print("\n✅ Step 3: Validazione DSL...")
        dsl_content, validation_result = self._validate_and_fix(
            dsl_content,
            max_retries=max_retries
        )
        
        if validation_result['is_valid']:
            print("✓ DSL valido!")
        else:
            print(f"⚠️  DSL con {len(validation_result['errors'])} errori")
        
        # Parse YAML
        try:
            dsl_data = yaml.safe_load(dsl_content)
        except yaml.YAMLError as e:
            print(f"❌ Errore nel parsing YAML: {e}")
            dsl_data = None
        
        return {
            'dsl_content': dsl_content,
            'dsl_data': dsl_data,
            'validation': validation_result,
            'extracted_info': extracted_info
        }
    
    def _extract_information(self, documentation: str) -> str:
        """Estrae informazioni strutturate dalla documentazione"""
        # Ottieni contesto RAG se disponibile
        rag_context = ""
        if self.use_rag:
            print("  🔍 Recupero contesto rilevante con RAG...")
            queries = [
                "global parameters system configuration",
                "services and tasks definition",
                "temporal constraints dependencies"
            ]
            
            contexts = []
            for query in queries:
                ctx = self.vector_store.get_relevant_context(
                    query,
                    top_k=3,
                    max_chars=1500
                )
                if ctx:
                    contexts.append(ctx)
            
            rag_context = "\n\n".join(contexts)
            print(f"  ✓ Contesto RAG recuperato ({len(rag_context)} caratteri)")
        
        # Costruisci prompt di estrazione
        extraction_prompt = self.prompt_builder.build_extraction_prompt(
            documentation=documentation,
            rag_context=rag_context
        )
        
        # Genera con LLM
        system_prompt = self.prompt_builder.build_system_prompt()
        
        response = self.llm_client.generate_with_retry(
            prompt=extraction_prompt,
            system_prompt=system_prompt,
            max_retries=3
        )
        
        return response.content
    
    def _generate_dsl(self, extracted_info: str) -> str:
        """Genera DSL YAML dalle informazioni estratte"""
        # Costruisci prompt di generazione
        generation_prompt = self.prompt_builder.build_generation_prompt(
            extracted_info=extracted_info
        )
        
        # Genera con LLM
        system_prompt = self.prompt_builder.build_system_prompt()
        
        response = self.llm_client.generate_with_retry(
            prompt=generation_prompt,
            system_prompt=system_prompt,
            max_retries=3
        )
        
        # Pulisci output (rimuovi markdown code blocks se presenti)
        content = response.content.strip()
        
        if content.startswith("```yaml"):
            lines = content.split("\n")
            content = "\n".join(lines[1:-1])
        elif content.startswith("```"):
            lines = content.split("\n")
            content = "\n".join(lines[1:-1])
        
        return content
    
    def _validate_and_fix(self, 
                         dsl_content: str,
                         max_retries: int = 3) -> tuple:
        """
        Valida il DSL e tenta di correggere errori
        
        Args:
            dsl_content: Contenuto DSL da validare
            max_retries: Numero massimo di tentativi di correzione
            
        Returns:
            Tupla (dsl_content_corrected, validation_result)
        """
        current_content = dsl_content
        
        for attempt in range(max_retries + 1):
            # Valida
            is_valid, errors, warnings = self.validator.validate(current_content)
            
            validation_result = {
                'is_valid': is_valid,
                'errors': [str(e) for e in errors],
                'warnings': [str(w) for w in warnings],
                'attempts': attempt + 1
            }
            
            if is_valid:
                if warnings:
                    print(f"  ⚠️  {len(warnings)} warning(s)")
                    for warning in warnings[:3]:  # Mostra primi 3
                        print(f"     - {warning}")
                return current_content, validation_result
            
            # Se non valido e ci sono ancora tentativi
            if attempt < max_retries:
                print(f"  ❌ Trovati {len(errors)} errori, tentativo correzione {attempt + 1}/{max_retries}...")
                
                # Mostra primi errori
                for error in errors[:3]:
                    print(f"     - {error}")
                
                # Tenta correzione con LLM
                try:
                    current_content = self._fix_errors(current_content, errors)
                except Exception as e:
                    print(f"  ⚠️  Errore nella correzione: {e}")
                    break
            else:
                print(f"  ❌ Validazione fallita dopo {max_retries} tentativi")
                for error in errors:
                    print(f"     - {error}")
        
        return current_content, validation_result
    
    def _fix_errors(self, dsl_content: str, errors: list) -> str:
        """Tenta di correggere errori usando LLM"""
        # Costruisci prompt di correzione
        correction_prompt = self.prompt_builder.build_validation_prompt(
            dsl_content=dsl_content,
            errors=errors
        )
        
        system_prompt = self.prompt_builder.build_system_prompt()
        
        response = self.llm_client.generate(
            prompt=correction_prompt,
            system_prompt=system_prompt
        )
        
        # Pulisci output
        content = response.content.strip()
        
        if content.startswith("```yaml"):
            lines = content.split("\n")
            content = "\n".join(lines[1:-1])
        elif content.startswith("```"):
            lines = content.split("\n")
            content = "\n".join(lines[1:-1])
        
        return content
    
    def save_dsl(self, dsl_content: str, output_path: str):
        """
        Salva il DSL su file
        
        Args:
            dsl_content: Contenuto DSL
            output_path: Path del file output
        """
        path = Path(output_path)
        path.parent.mkdir(parents=True, exist_ok=True)
        
        with open(path, 'w', encoding='utf-8') as f:
            f.write(dsl_content)
        
        print(f"\n💾 DSL salvato in: {output_path}")
    
    def generate_and_save(self,
                         documentation_path: str,
                         output_path: str,
                         max_retries: int = 3) -> Dict:
        """
        Genera DSL da file documentazione e salva
        
        Args:
            documentation_path: Path al file documentazione
            output_path: Path per salvare il DSL
            max_retries: Numero massimo di tentativi
            
        Returns:
            Dizionario con risultati
        """
        # Carica documentazione
        print(f"📄 Caricamento documentazione da: {documentation_path}")
        
        with open(documentation_path, 'r', encoding='utf-8') as f:
            documentation = f.read()
        
        print(f"✓ Documentazione caricata ({len(documentation)} caratteri)")
        
        # Genera DSL
        result = self.generate_from_documentation(
            documentation=documentation,
            max_retries=max_retries
        )
        
        # Salva se valido o se richiesto
        if result['dsl_content']:
            self.save_dsl(result['dsl_content'], output_path)
        
        return result


if __name__ == "__main__":
    # Test del generatore (richiede configurazione LLM)
    print("Test DSL Generator\n")
    print("NOTA: Questo test richiede una configurazione LLM valida.")
    print("Per un test completo, usa lo script examples/example_usage.py\n")
    
    print("✓ Modulo DSL Generator pronto per l'uso")
