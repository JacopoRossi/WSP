"""Pipeline Principale - Integra tutti i componenti per la generazione DSL"""

import os
import sys
import warnings
import yaml
from pathlib import Path
from typing import Optional, Dict, List
from dotenv import load_dotenv

# Sopprimi tutti i warning di tiktoken e altri warning non critici
warnings.filterwarnings('ignore', category=UserWarning)
warnings.filterwarnings('ignore', message='.*model not found.*')
warnings.filterwarnings('ignore', message='.*Using cl100k_base encoding.*')

# Redirect stderr temporaneamente per catturare warning di tiktoken
import io
_original_stderr = sys.stderr

from .rag.document_loader import DocumentLoader
from .rag.embeddings import EmbeddingGenerator
from .rag.vector_store import VectorStore
from .llm.llm_client import LLMClient
from .llm.prompt_builder import PromptBuilder
from .dsl.generator import DSLGenerator
from .dsl.validator import DSLValidator


class DSLGeneratorPipeline:
    """Pipeline completa per generare DSL da documentazione"""
    
    def __init__(self, config_path: str = "config/config.yaml"):
        """
        Inizializza la pipeline
        
        Args:
            config_path: Path al file di configurazione
        """
        print("🔧 Inizializzazione DSL Generator Pipeline...")
        
        # Carica variabili d'ambiente
        load_dotenv()
        
        # Carica configurazione
        self.config = self._load_config(config_path)
        print(f"✓ Configurazione caricata da: {config_path}")
        
        # Inizializza componenti
        self._initialize_components()
        
        print("✓ Pipeline inizializzata con successo!\n")
    
    def _load_config(self, config_path: str) -> Dict:
        """Carica configurazione da file YAML"""
        with open(config_path, 'r') as f:
            config = yaml.safe_load(f)
        
        # Sostituisci variabili d'ambiente
        config = self._replace_env_vars(config)
        
        return config
    
    def _replace_env_vars(self, config: Dict) -> Dict:
        """Sostituisce variabili d'ambiente nella configurazione"""
        def replace_value(value):
            if isinstance(value, str) and value.startswith("${") and value.endswith("}"):
                env_var = value[2:-1]
                return os.getenv(env_var, value)
            elif isinstance(value, dict):
                return {k: replace_value(v) for k, v in value.items()}
            elif isinstance(value, list):
                return [replace_value(item) for item in value]
            return value
        
        return replace_value(config)
    
    def _initialize_components(self):
        """Inizializza tutti i componenti della pipeline"""
        # 1. Embedding Generator
        print("  📊 Inizializzazione Embedding Generator...")
        self.embedding_generator = EmbeddingGenerator(
            provider=self.config['rag']['embedding_provider'],
            model=self.config['rag']['embedding_model'],
            api_key=self.config['llm'].get('api_key')
        )
        
        # 2. Vector Store
        print("  🗄️  Inizializzazione Vector Store...")
        self.vector_store = VectorStore(
            store_path=self.config['rag']['vector_store_path'],
            collection_name=self.config['rag']['collection_name'],
            embedding_generator=self.embedding_generator
        )
        
        # 3. Document Loader
        print("  📚 Inizializzazione Document Loader...")
        self.document_loader = DocumentLoader(
            chunk_size=self.config['rag']['chunk_size'],
            chunk_overlap=self.config['rag']['chunk_overlap']
        )
        
        # 4. LLM Client
        print("  🤖 Inizializzazione LLM Client...")
        self.llm_client = LLMClient(
            provider=self.config['llm']['provider'],
            model=self.config['llm']['model'],
            api_key=self.config['llm'].get('api_key'),
            temperature=self.config['llm']['temperature'],
            max_tokens=self.config['llm']['max_tokens']
        )
        
        # 5. Prompt Builder
        print("  📝 Inizializzazione Prompt Builder...")
        self.prompt_builder = PromptBuilder(
            system_prompt_path=self.config['prompts']['system_prompt_path'],
            extraction_prompt_path=self.config['prompts']['extraction_prompt_path'],
            generation_prompt_path=self.config['prompts']['generation_prompt_path']
        )
        
        # 6. DSL Validator
        print("  ✅ Inizializzazione DSL Validator...")
        self.validator = DSLValidator(
            strict_mode=self.config['dsl'].get('strict_mode', False)
        )
        
        # 7. DSL Generator
        print("  ⚙️  Inizializzazione DSL Generator...")
        self.dsl_generator = DSLGenerator(
            llm_client=self.llm_client,
            prompt_builder=self.prompt_builder,
            vector_store=self.vector_store,
            validator=self.validator
        )
    
    def index_documentation(self, 
                          documentation_path: str,
                          reset_collection: bool = False) -> int:
        """
        Indicizza documentazione nel vector store
        
        Args:
            documentation_path: Path al file o directory con documentazione
            reset_collection: Se True, resetta la collection prima di indicizzare
            
        Returns:
            Numero di documenti indicizzati
        """
        print(f"\n📑 Indicizzazione documentazione da: {documentation_path}")
        
        # Reset collection se richiesto
        if reset_collection:
            print("  🔄 Reset collection...")
            self.vector_store.reset_collection()
        
        # Carica documenti
        path = Path(documentation_path)
        
        if path.is_file():
            documents = self.document_loader.load_document(str(path))
        elif path.is_dir():
            documents = self.document_loader.load_directory(str(path))
        else:
            raise ValueError(f"Path non valido: {documentation_path}")
        
        print(f"  ✓ Caricati {len(documents)} chunks")
        
        # Aggiungi al vector store
        count = self.vector_store.add_documents(documents, show_progress=True)
        
        print(f"✓ Indicizzazione completata: {count} documenti\n")
        
        return count
    
    def generate_dsl(self,
                    documentation_path: str,
                    output_path: Optional[str] = None,
                    use_indexed: bool = True) -> Dict:
        """
        Genera DSL da documentazione
        
        Args:
            documentation_path: Path alla documentazione
            output_path: Path per salvare il DSL (opzionale)
            use_indexed: Se True, usa documentazione già indicizzata per RAG.
                        Se il vector store è vuoto, indicizza automaticamente il file di input.
            
        Returns:
            Dizionario con risultati
        """
        print(f"\n{'='*60}")
        print(f"🚀 GENERAZIONE DSL")
        print(f"{'='*60}\n")
        
        # Controlla se il vector store è vuoto
        stats = self.vector_store.get_stats()
        vector_store_empty = stats['total_documents'] == 0
        
        # Se non usa indexed O se il vector store è vuoto, indicizza il file di input
        if not use_indexed or vector_store_empty:
            if vector_store_empty and use_indexed:
                print("📑 Vector store vuoto - indicizzazione automatica del file di input per RAG...")
            self.index_documentation(documentation_path, reset_collection=True)
        
        # Determina output path
        if output_path is None:
            doc_path = Path(documentation_path)
            output_dir = Path(self.config['pipeline']['output_dir'])
            output_dir.mkdir(parents=True, exist_ok=True)
            output_path = output_dir / f"{doc_path.stem}_generated.dsl"
        
        # Genera DSL
        result = self.dsl_generator.generate_and_save(
            documentation_path=documentation_path,
            output_path=str(output_path),
            max_retries=self.config['pipeline'].get('max_retries', 3)
        )
        
        # Stampa riepilogo
        print(f"\n{'='*60}")
        print(f"📊 RIEPILOGO GENERAZIONE")
        print(f"{'='*60}")
        print(f"Documentazione: {documentation_path}")
        print(f"Output: {output_path}")
        print(f"Valido: {'✓ Sì' if result['validation']['is_valid'] else '✗ No'}")
        print(f"Errori: {len(result['validation']['errors'])}")
        print(f"Warning: {len(result['validation']['warnings'])}")
        print(f"Tentativi: {result['validation']['attempts']}")
        print(f"{'='*60}\n")
        
        return result
    
    def generate_batch(self,
                      input_dir: str,
                      output_dir: Optional[str] = None,
                      file_pattern: str = "*.md") -> List[Dict]:
        """
        Genera DSL per tutti i file in una directory
        
        Args:
            input_dir: Directory con documentazione
            output_dir: Directory per output (opzionale)
            file_pattern: Pattern per file da processare
            
        Returns:
            Lista di risultati
        """
        print(f"\n{'='*60}")
        print(f"🔄 GENERAZIONE BATCH")
        print(f"{'='*60}\n")
        
        # Indicizza tutta la documentazione
        print("📑 Fase 1: Indicizzazione documentazione...")
        self.index_documentation(input_dir, reset_collection=True)
        
        # Trova tutti i file
        input_path = Path(input_dir)
        files = list(input_path.glob(file_pattern))
        
        print(f"\n📄 Fase 2: Generazione DSL per {len(files)} file...\n")
        
        # Determina output directory
        if output_dir is None:
            output_dir = Path(self.config['pipeline']['output_dir'])
        else:
            output_dir = Path(output_dir)
        
        output_dir.mkdir(parents=True, exist_ok=True)
        
        # Genera DSL per ogni file
        results = []
        
        for i, file_path in enumerate(files, 1):
            print(f"\n[{i}/{len(files)}] Processando: {file_path.name}")
            print("-" * 60)
            
            output_path = output_dir / f"{file_path.stem}_generated.dsl"
            
            try:
                result = self.generate_dsl(
                    documentation_path=str(file_path),
                    output_path=str(output_path),
                    use_indexed=True
                )
                
                result['input_file'] = str(file_path)
                result['output_file'] = str(output_path)
                results.append(result)
                
            except Exception as e:
                print(f"❌ Errore: {e}")
                results.append({
                    'input_file': str(file_path),
                    'error': str(e),
                    'validation': {'is_valid': False, 'errors': [str(e)]}
                })
        
        # Stampa riepilogo finale
        print(f"\n{'='*60}")
        print(f"📊 RIEPILOGO BATCH")
        print(f"{'='*60}")
        print(f"File processati: {len(results)}")
        
        valid_count = sum(1 for r in results if r['validation']['is_valid'])
        print(f"DSL validi: {valid_count}/{len(results)}")
        
        error_count = sum(1 for r in results if 'error' in r)
        print(f"Errori: {error_count}")
        print(f"{'='*60}\n")
        
        return results
    
    def get_stats(self) -> Dict:
        """Ottiene statistiche sulla pipeline"""
        return {
            'vector_store': self.vector_store.get_stats(),
            'llm': self.llm_client.get_model_info(),
            'embedding': self.embedding_generator.get_model_info()
        }


# CLI Interface
if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="DSL Generator Pipeline")
    parser.add_argument("command", choices=["index", "generate", "generate-batch", "stats"],
                       help="Comando da eseguire")
    parser.add_argument("--config", default="config/config.yaml",
                       help="Path al file di configurazione")
    parser.add_argument("--input", help="Path input (file o directory)")
    parser.add_argument("--output", help="Path output")
    parser.add_argument("--reset", action="store_true",
                       help="Reset collection prima di indicizzare")
    parser.add_argument("--pattern", default="*.md",
                       help="Pattern per batch processing")
    
    args = parser.parse_args()
    
    # Inizializza pipeline
    pipeline = DSLGeneratorPipeline(config_path=args.config)
    
    # Esegui comando
    if args.command == "index":
        if not args.input:
            print("❌ Errore: --input richiesto per il comando 'index'")
        else:
            pipeline.index_documentation(args.input, reset_collection=args.reset)
    
    elif args.command == "generate":
        if not args.input:
            print("❌ Errore: --input richiesto per il comando 'generate'")
        else:
            pipeline.generate_dsl(args.input, output_path=args.output)
    
    elif args.command == "generate-batch":
        if not args.input:
            print("❌ Errore: --input richiesto per il comando 'generate-batch'")
        else:
            pipeline.generate_batch(args.input, output_dir=args.output, file_pattern=args.pattern)
    
    elif args.command == "stats":
        stats = pipeline.get_stats()
        print("\n📊 Statistiche Pipeline:")
        print(yaml.dump(stats, default_flow_style=False))
