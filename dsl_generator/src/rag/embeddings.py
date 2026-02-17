"""Embedding Generator - Genera embeddings vettoriali per i documenti"""

import os
import warnings
from typing import List, Optional
import numpy as np
from dataclasses import dataclass

# Sopprimi warning di tiktoken
os.environ['TIKTOKEN_CACHE_DIR'] = ''
warnings.filterwarnings('ignore', message='.*model not found.*')

from langchain_openai import OpenAIEmbeddings
from langchain_community.embeddings import HuggingFaceEmbeddings


@dataclass
class EmbeddingResult:
    """Risultato di un embedding"""
    vector: List[float]
    dimension: int
    model: str


class EmbeddingGenerator:
    """Genera embeddings vettoriali usando vari provider"""
    
    def __init__(self, 
                 provider: str = "openai",
                 model: str = "text-embedding-3-large",
                 api_key: Optional[str] = None):
        """
        Inizializza il generatore di embeddings
        
        Args:
            provider: Provider di embeddings (openai, huggingface)
            model: Nome del modello
            api_key: API key (se necessaria)
        """
        self.provider = provider
        self.model = model
        
        # Inizializza il modello appropriato
        if provider == "openai":
            self.embeddings = OpenAIEmbeddings(
                model=model,
                openai_api_key=api_key
            )
            self.dimension = 3072  # Default per text-embedding-3-large
            
        elif provider == "huggingface":
            self.embeddings = HuggingFaceEmbeddings(
                model_name=model,
                model_kwargs={'device': 'cpu'},
                encode_kwargs={'normalize_embeddings': True}
            )
            # La dimensione dipende dal modello
            self.dimension = 384  # Default per all-MiniLM-L6-v2
            
        else:
            raise ValueError(f"Provider non supportato: {provider}")
    
    def embed_text(self, text: str) -> EmbeddingResult:
        """
        Genera embedding per un singolo testo
        
        Args:
            text: Testo da embeddare
            
        Returns:
            EmbeddingResult con il vettore
        """
        import sys
        import io
        
        # Cattura stderr per sopprimere warning tiktoken
        stderr_backup = sys.stderr
        try:
            sys.stderr = io.StringIO()
            vector = self.embeddings.embed_query(text)
            
            return EmbeddingResult(
                vector=vector,
                dimension=len(vector),
                model=self.model
            )
        except Exception as e:
            raise RuntimeError(f"Errore nella generazione embedding: {str(e)}")
        finally:
            sys.stderr = stderr_backup
    
    def embed_documents(self, texts: List[str], 
                       batch_size: int = 100,
                       show_progress: bool = True) -> List[EmbeddingResult]:
        """
        Genera embeddings per una lista di testi
        
        Args:
            texts: Lista di testi
            batch_size: Dimensione del batch per processing
            show_progress: Mostra progress bar
            
        Returns:
            Lista di EmbeddingResult
        """
        results = []
        
        import sys
        import io
        
        # Process in batches
        for i in range(0, len(texts), batch_size):
            batch = texts[i:i + batch_size]
            
            # Cattura stderr per sopprimere warning tiktoken
            stderr_backup = sys.stderr
            try:
                sys.stderr = io.StringIO()
                vectors = self.embeddings.embed_documents(batch)
                sys.stderr = stderr_backup
                
                for vector in vectors:
                    results.append(EmbeddingResult(
                        vector=vector,
                        dimension=len(vector),
                        model=self.model
                    ))
                
                if show_progress:
                    progress = min(i + batch_size, len(texts))
                    print(f"Embeddings generati: {progress}/{len(texts)}", end='\r')
                    
            except Exception as e:
                sys.stderr = stderr_backup
                print(f"\nErrore nel batch {i}-{i+batch_size}: {str(e)}")
                continue
        
        if show_progress:
            print(f"\nTotale embeddings generati: {len(results)}")
        
        return results
    
    def compute_similarity(self, vector1: List[float], 
                          vector2: List[float]) -> float:
        """
        Calcola similarità coseno tra due vettori
        
        Args:
            vector1: Primo vettore
            vector2: Secondo vettore
            
        Returns:
            Similarità coseno (0-1)
        """
        v1 = np.array(vector1)
        v2 = np.array(vector2)
        
        # Cosine similarity
        dot_product = np.dot(v1, v2)
        norm1 = np.linalg.norm(v1)
        norm2 = np.linalg.norm(v2)
        
        if norm1 == 0 or norm2 == 0:
            return 0.0
        
        return float(dot_product / (norm1 * norm2))
    
    def get_model_info(self) -> dict:
        """
        Restituisce informazioni sul modello
        
        Returns:
            Dizionario con info del modello
        """
        return {
            'provider': self.provider,
            'model': self.model,
            'dimension': self.dimension
        }


class CachedEmbeddingGenerator(EmbeddingGenerator):
    """Versione con cache degli embeddings per evitare ricalcoli"""
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.cache = {}
    
    def embed_text(self, text: str) -> EmbeddingResult:
        """Embed con cache"""
        # Usa hash del testo come chiave
        cache_key = hash(text)
        
        if cache_key in self.cache:
            return self.cache[cache_key]
        
        result = super().embed_text(text)
        self.cache[cache_key] = result
        
        return result
    
    def clear_cache(self):
        """Pulisce la cache"""
        self.cache.clear()
    
    def get_cache_stats(self) -> dict:
        """Statistiche sulla cache"""
        return {
            'cached_items': len(self.cache),
            'cache_size_mb': sum(len(str(v)) for v in self.cache.values()) / 1024 / 1024
        }


if __name__ == "__main__":
    # Test del generatore di embeddings
    print("Test Embedding Generator\n")
    
    # Test con HuggingFace (non richiede API key)
    print("1. Test con HuggingFace embeddings...")
    generator = EmbeddingGenerator(
        provider="huggingface",
        model="sentence-transformers/all-MiniLM-L6-v2"
    )
    
    # Test singolo testo
    text = "This is a test document about space systems."
    result = generator.embed_text(text)
    print(f"   Dimensione vettore: {result.dimension}")
    print(f"   Primi 5 valori: {result.vector[:5]}")
    
    # Test similarità
    text2 = "This document discusses spacecraft operations."
    result2 = generator.embed_text(text2)
    similarity = generator.compute_similarity(result.vector, result2.vector)
    print(f"   Similarità tra i due testi: {similarity:.4f}")
    
    print("\n✓ Test completato")
