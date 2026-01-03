"""Prompt Builder - Costruisce prompt per il LLM"""

from typing import Optional, Dict, List
from pathlib import Path


class PromptBuilder:
    """Costruisce prompt strutturati per la generazione DSL"""
    
    def __init__(self, 
                 system_prompt_path: Optional[str] = None,
                 extraction_prompt_path: Optional[str] = None,
                 generation_prompt_path: Optional[str] = None):
        """
        Inizializza il prompt builder
        
        Args:
            system_prompt_path: Path al system prompt
            extraction_prompt_path: Path al prompt di estrazione
            generation_prompt_path: Path al prompt di generazione
        """
        self.system_prompt = self._load_prompt(system_prompt_path) if system_prompt_path else ""
        self.extraction_prompt_template = self._load_prompt(extraction_prompt_path) if extraction_prompt_path else ""
        self.generation_prompt_template = self._load_prompt(generation_prompt_path) if generation_prompt_path else ""
    
    def _load_prompt(self, path: str) -> str:
        """Carica un prompt da file"""
        try:
            with open(path, 'r', encoding='utf-8') as f:
                return f.read()
        except Exception as e:
            print(f"Warning: Impossibile caricare prompt da {path}: {e}")
            return ""
    
    def build_system_prompt(self) -> str:
        """
        Costruisce il system prompt
        
        Returns:
            System prompt
        """
        return self.system_prompt
    
    def build_extraction_prompt(self,
                               documentation: str,
                               rag_context: Optional[str] = None) -> str:
        """
        Costruisce il prompt per l'estrazione di informazioni
        
        Args:
            documentation: Documentazione da analizzare
            rag_context: Contesto aggiuntivo da RAG
            
        Returns:
            Prompt di estrazione
        """
        # Tronca documentazione se troppo lunga
        max_doc_length = 10000
        if len(documentation) > max_doc_length:
            documentation = documentation[:max_doc_length] + "\n\n[...documento troncato...]"
        
        # Usa contesto RAG se disponibile, altrimenti usa documentazione completa
        context = rag_context if rag_context else "No additional context available."
        
        prompt = self.extraction_prompt_template.format(
            documentation=documentation,
            rag_context=context
        )
        
        return prompt
    
    def build_generation_prompt(self, extracted_info: str) -> str:
        """
        Costruisce il prompt per la generazione DSL
        
        Args:
            extracted_info: Informazioni estratte dalla documentazione
            
        Returns:
            Prompt di generazione
        """
        prompt = self.generation_prompt_template.format(
            extracted_info=extracted_info
        )
        
        return prompt
    
    def build_validation_prompt(self, dsl_content: str, errors: List[str]) -> str:
        """
        Costruisce prompt per correggere errori di validazione
        
        Args:
            dsl_content: Contenuto DSL con errori
            errors: Lista di errori trovati
            
        Returns:
            Prompt per correzione
        """
        errors_text = "\n".join(f"- {error}" for error in errors)
        
        prompt = f"""The following DSL has validation errors that need to be fixed:

DSL CONTENT:
```yaml
{dsl_content}
```

VALIDATION ERRORS:
{errors_text}

Please fix these errors and provide the corrected DSL in valid YAML format.
Ensure all task IDs referenced in services and constraints exist in the tasks section.
Maintain proper YAML syntax with correct indentation.

Output ONLY the corrected YAML, no additional explanation."""
        
        return prompt
    
    def build_refinement_prompt(self,
                               dsl_content: str,
                               feedback: str) -> str:
        """
        Costruisce prompt per raffinare il DSL basato su feedback
        
        Args:
            dsl_content: Contenuto DSL corrente
            feedback: Feedback per il raffinamento
            
        Returns:
            Prompt di raffinamento
        """
        prompt = f"""Please refine the following DSL based on the feedback provided:

CURRENT DSL:
```yaml
{dsl_content}
```

FEEDBACK:
{feedback}

Generate an improved version of the DSL that addresses the feedback.
Output ONLY the refined YAML, no additional explanation."""
        
        return prompt
    
    def build_analysis_prompt(self, documentation: str) -> str:
        """
        Costruisce prompt per analisi preliminare della documentazione
        
        Args:
            documentation: Documentazione da analizzare
            
        Returns:
            Prompt di analisi
        """
        prompt = f"""Analyze the following technical documentation and provide a structured summary:

DOCUMENTATION:
{documentation[:5000]}

Please identify and summarize:
1. System name and global parameters
2. Number and types of services
3. Number and types of tasks
4. Key temporal constraints and dependencies
5. Any special characteristics or requirements

Provide a concise structured summary."""
        
        return prompt
    
    def add_examples_to_prompt(self, prompt: str, examples: List[Dict]) -> str:
        """
        Aggiunge esempi al prompt
        
        Args:
            prompt: Prompt base
            examples: Lista di esempi (dict con 'input' e 'output')
            
        Returns:
            Prompt con esempi
        """
        if not examples:
            return prompt
        
        examples_text = "\n\nEXAMPLES:\n"
        
        for i, example in enumerate(examples, 1):
            examples_text += f"\nExample {i}:\n"
            examples_text += f"Input: {example.get('input', 'N/A')}\n"
            examples_text += f"Output: {example.get('output', 'N/A')}\n"
        
        return prompt + examples_text
    
    def truncate_context(self, text: str, max_length: int = 8000) -> str:
        """
        Tronca il testo mantenendo le parti più importanti
        
        Args:
            text: Testo da troncare
            max_length: Lunghezza massima
            
        Returns:
            Testo troncato
        """
        if len(text) <= max_length:
            return text
        
        # Prendi inizio e fine
        half = max_length // 2
        
        start = text[:half]
        end = text[-half:]
        
        return f"{start}\n\n[... content truncated ...]\n\n{end}"


class PromptTemplate:
    """Template riutilizzabile per prompt"""
    
    def __init__(self, template: str, required_vars: List[str]):
        """
        Inizializza il template
        
        Args:
            template: Stringa template con placeholder {var}
            required_vars: Lista di variabili richieste
        """
        self.template = template
        self.required_vars = required_vars
    
    def render(self, **kwargs) -> str:
        """
        Renderizza il template con le variabili fornite
        
        Args:
            **kwargs: Variabili per il template
            
        Returns:
            Template renderizzato
        """
        # Verifica che tutte le variabili richieste siano presenti
        missing = [var for var in self.required_vars if var not in kwargs]
        if missing:
            raise ValueError(f"Variabili mancanti nel template: {missing}")
        
        try:
            return self.template.format(**kwargs)
        except KeyError as e:
            raise ValueError(f"Errore nel rendering del template: {e}")


# Template predefiniti
EXTRACTION_TEMPLATE = PromptTemplate(
    template="""Extract structured information from the following documentation:

{documentation}

Focus on identifying:
- Global parameters (system name, time window, resources)
- Services and their associated tasks
- Task properties (duration, resources, repetitions)
- Temporal constraints between tasks

Provide the extracted information in a structured format.""",
    required_vars=["documentation"]
)

GENERATION_TEMPLATE = PromptTemplate(
    template="""Generate a complete DSL in YAML format based on this information:

{extracted_info}

Follow the standard DSL structure with sections:
1. wsp (global parameters)
2. services
3. tasks
4. start_constraints

Output valid YAML only.""",
    required_vars=["extracted_info"]
)


if __name__ == "__main__":
    # Test del prompt builder
    print("Test Prompt Builder\n")
    
    # Test con template
    print("1. Test template di estrazione...")
    prompt = EXTRACTION_TEMPLATE.render(
        documentation="SpaceOBC1 is a system with 8 resources..."
    )
    print(f"Prompt length: {len(prompt)} chars")
    print(f"Preview: {prompt[:200]}...\n")
    
    # Test con file
    print("2. Test caricamento da file...")
    builder = PromptBuilder(
        system_prompt_path="../../config/prompts/system_prompt.txt"
    )
    
    system_prompt = builder.build_system_prompt()
    if system_prompt:
        print(f"System prompt loaded: {len(system_prompt)} chars")
        print(f"Preview: {system_prompt[:200]}...\n")
    
    print("✓ Test completato")
