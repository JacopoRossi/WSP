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
        print("🔧 Initializing DSL Generator Pipeline...")
        
        # Carica variabili d'ambiente
        load_dotenv()
        
        # Store config directory for resolving relative paths
        config_path_obj = Path(config_path).resolve()
        self.config_dir = config_path_obj.parent
        # dsl_generator root is parent of config dir
        self.root_dir = self.config_dir.parent
        
        # Carica configurazione
        self.config = self._load_config(str(config_path_obj))
        print(f"✓ Configuration loaded from: {config_path_obj}")
        
        # Inizializza componenti
        self._initialize_components()
        
        print("✓ Pipeline initialized successfully!\n")
    
    def _load_config(self, config_path: str) -> Dict:
        """Carica configurazione da file YAML"""
        with open(config_path, 'r') as f:
            config = yaml.safe_load(f)
        
        # Sostituisci variabili d'ambiente
        config = self._replace_env_vars(config)
        
        # Resolve prompt paths relative to config directory
        if 'prompts' in config:
            for key in ['system_prompt_path', 'extraction_prompt_path', 'generation_prompt_path']:
                if key in config['prompts']:
                    # Resolve relative to config directory
                    prompt_path = Path(config['prompts'][key])
                    if not prompt_path.is_absolute():
                        config['prompts'][key] = str(self.config_dir / prompt_path)
        
        # Resolve vector store path relative to dsl_generator root
        if 'rag' in config and 'vector_store_path' in config['rag']:
            vector_store_path = Path(config['rag']['vector_store_path'])
            if not vector_store_path.is_absolute():
                config['rag']['vector_store_path'] = str(self.root_dir / vector_store_path)
        
        # Resolve output directory relative to dsl_generator root
        if 'pipeline' in config and 'output_dir' in config['pipeline']:
            output_dir = Path(config['pipeline']['output_dir'])
            if not output_dir.is_absolute():
                config['pipeline']['output_dir'] = str(self.root_dir / output_dir)
        
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
        print("  📊 Initializing Embedding Generator...")
        self.embedding_generator = EmbeddingGenerator(
            provider=self.config['rag']['embedding_provider'],
            model=self.config['rag']['embedding_model'],
            api_key=self.config['llm'].get('api_key')
        )
        
        # 2. Vector Store
        print("  🗄️  Initializing Vector Store...")
        self.vector_store = VectorStore(
            store_path=self.config['rag']['vector_store_path'],
            collection_name=self.config['rag']['collection_name'],
            embedding_generator=self.embedding_generator
        )
        
        # 3. Document Loader
        print("  📚 Initializing Document Loader...")
        chunk_size = self.config['rag']['chunk_size']
        chunk_overlap = self.config['rag']['chunk_overlap']
        self.document_loader = DocumentLoader(
            chunk_size=chunk_size,
            chunk_overlap=chunk_overlap
        )
        print(f"     → chunk_size: {chunk_size}, chunk_overlap: {chunk_overlap}")
        
        # 4. LLM Client
        print("  🤖 Initializing LLM Client...")
        llm_model = self.config['llm']['model']
        llm_temp = self.config['llm']['temperature']
        llm_max_tokens = self.config['llm'].get('max_tokens')
        llm_seed = self.config['llm'].get('seed')
        self.llm_client = LLMClient(
            provider=self.config['llm']['provider'],
            model=llm_model,
            api_key=self.config['llm'].get('api_key'),
            temperature=llm_temp,
            max_tokens=llm_max_tokens,
            seed=llm_seed
        )
        max_tokens_str = llm_max_tokens if llm_max_tokens is not None else 'unlimited'
        print(f"     → model: {llm_model}, temperature: {llm_temp}, max_tokens: {max_tokens_str}, seed: {llm_seed}")
        
        # 5. Prompt Builder
        print("  📝 Initializing Prompt Builder...")
        self.prompt_builder = PromptBuilder(
            system_prompt_path=self.config['prompts']['system_prompt_path'],
            extraction_prompt_path=self.config['prompts']['extraction_prompt_path'],
            generation_prompt_path=self.config['prompts']['generation_prompt_path']
        )
        
        # 6. DSL Validator
        print("  ✅ Initializing DSL Validator...")
        self.validator = DSLValidator(
            strict_mode=self.config['dsl'].get('strict_mode', False)
        )
        
        # 7. DSL Generator
        print("  ⚙️  Initializing DSL Generator...")
        rag_top_k = self.config['rag']['top_k']
        rag_threshold = self.config['rag']['similarity_threshold']
        print(f"     → RAG: top_k={rag_top_k}, similarity_threshold={rag_threshold}")
        self.dsl_generator = DSLGenerator(
            llm_client=self.llm_client,
            prompt_builder=self.prompt_builder,
            vector_store=self.vector_store,
            validator=self.validator,
            chunk_size=self.config['rag']['chunk_size'],
            chunk_overlap=self.config['rag']['chunk_overlap']
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
        print(f"\n📑 Indexing documentation from: {documentation_path}")
        
        # Reset collection se richiesto
        if reset_collection:
            print("  🔄 Resetting collection...")
            self.vector_store.reset_collection()
        
        # Carica documenti
        path = Path(documentation_path)
        
        if path.is_file():
            documents = self.document_loader.load_document(str(path))
        elif path.is_dir():
            documents = self.document_loader.load_directory(str(path))
        else:
            raise ValueError(f"Invalid path: {documentation_path}")
        
        print(f"  ✓ Loaded {len(documents)} chunks")
        
        # Aggiungi al vector store
        count = self.vector_store.add_documents(documents, show_progress=True)
        
        print(f"✓ Indexing completed: {count} documents\n")
        
        return count
    
    def generate_dsl(self,
                    documentation_path: str,
                    output_path: Optional[str] = None,
                    use_indexed: bool = True,
                    check_completeness: bool = True,
                    interactive_completion: bool = True) -> Dict:
        """
        Genera DSL da documentazione
        
        Args:
            documentation_path: Path alla documentazione
            output_path: Path per salvare il DSL (opzionale)
            use_indexed: Se True, usa documentazione già indicizzata per RAG.
                        Se il vector store è vuoto, indicizza automaticamente il file di input.
            check_completeness: Se True, verifica che la documentazione contenga
                              tutte le informazioni necessarie
            interactive_completion: Se True e mancano informazioni, chiede all'utente
                                   di fornirle interattivamente
            
        Returns:
            Dizionario con risultati
        """
        print(f"\n{'='*60}")
        print(f"🚀 DSL GENERATION")
        print(f"{'='*60}\n")
        
        # Verifica se il vector store è vuoto
        if self.vector_store.is_empty():
            print("⚠️  Vector store is empty - no DSL data available")
            print("📑 Documentation indexing is required before proceeding\n")
        
        # SEMPRE resetta e reindicizza il file di input per garantire dati freschi
        print("📑 Resetting vector store and indexing input file...")
        self.index_documentation(documentation_path, reset_collection=True)
        
        # Verifica completezza delle informazioni (se richiesto)
        if check_completeness:
            from .dsl.interactive_completer import InteractiveCompleter
            
            completer = InteractiveCompleter(self)
            is_complete, additional_data = completer.check_and_request_missing_info(
                documentation_path=documentation_path,
                min_confidence=0.3,
                interactive=interactive_completion
            )
            
            # Se l'utente ha annullato, termina
            if not is_complete and interactive_completion:
                return {
                    'success': False,
                    'error': 'Generation cancelled: missing information',
                    'validation': {'is_valid': False, 'errors': ['Missing information'], 'warnings': [], 'attempts': 0}
                }
            
            # Se non è completo ma non siamo in modalità interattiva, avvisa
            if not is_complete and not interactive_completion:
                print("\n  WARNING: Documentation ") #may not contain all necessary information
                print("   Generated DSL may be incomplete or invalid\n")
        
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
        print(f"📊 GENERATION SUMMARY")
        print(f"{'='*60}")
        print(f"Documentation: {documentation_path}")
        print(f"Output: {output_path}")
        print(f"Valid: {'✓ Yes' if result['validation']['is_valid'] else '✗ No'}")
        print(f"Errors: {len(result['validation']['errors'])}")
        print(f"Warnings: {len(result['validation']['warnings'])}")
        print(f"Attempts: {result['validation']['attempts']}")
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
        print(f"🔄 BATCH GENERATION")
        print(f"{'='*60}\n")
        
        # Indicizza tutta la documentazione
        print("📑 Phase 1: Indexing documentation...")
        self.index_documentation(input_dir, reset_collection=True)
        
        # Trova tutti i file
        input_path = Path(input_dir)
        files = list(input_path.glob(file_pattern))
        
        print(f"\n📄 Phase 2: Generating DSL for {len(files)} files...\n")
        
        # Determina output directory
        if output_dir is None:
            output_dir = Path(self.config['pipeline']['output_dir'])
        else:
            output_dir = Path(output_dir)
        
        output_dir.mkdir(parents=True, exist_ok=True)
        
        # Genera DSL per ogni file
        results = []
        
        for i, file_path in enumerate(files, 1):
            print(f"\n[{i}/{len(files)}] Processing: {file_path.name}")
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
                print(f"❌ Error: {e}")
                results.append({
                    'input_file': str(file_path),
                    'error': str(e),
                    'validation': {'is_valid': False, 'errors': [str(e)]}
                })
        
        # Stampa riepilogo finale
        print(f"\n{'='*60}")
        print(f"📊 BATCH SUMMARY")
        print(f"{'='*60}")
        print(f"Files processed: {len(results)}")
        
        valid_count = sum(1 for r in results if r['validation']['is_valid'])
        print(f"Valid DSLs: {valid_count}/{len(results)}")
        
        error_count = sum(1 for r in results if 'error' in r)
        print(f"Errors: {error_count}")
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
            print("❌ Error: --input required for 'index' command")
        else:
            pipeline.index_documentation(args.input, reset_collection=args.reset)
    
    elif args.command == "generate":
        if not args.input:
            print("❌ Error: --input required for 'generate' command")
        else:
            pipeline.generate_dsl(args.input, output_path=args.output)
    
    elif args.command == "generate-batch":
        if not args.input:
            print("❌ Error: --input required for 'generate-batch' command")
        else:
            pipeline.generate_batch(args.input, output_dir=args.output, file_pattern=args.pattern)
    
    elif args.command == "stats":
        stats = pipeline.get_stats()
        print("\n📊 Pipeline Statistics:")
        print(yaml.dump(stats, default_flow_style=False))
