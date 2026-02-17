"""Vector Store - Gestisce il database vettoriale per il retrieval"""

import os
import sys
import warnings
from typing import List, Dict, Optional, Tuple
from pathlib import Path

# Disabilita telemetria ChromaDB e warning
os.environ['ANONYMIZED_TELEMETRY'] = 'False'
os.environ['CHROMA_TELEMETRY'] = 'False'

# Sopprimi warning di ChromaDB
warnings.filterwarnings('ignore', category=UserWarning, module='chromadb')

import chromadb
from chromadb.config import Settings

from .document_loader import Document
from .embeddings import EmbeddingGenerator


class VectorStore:
    """Gestisce il vector database per il retrieval semantico"""
    
    def __init__(self, 
                 store_path: str = "data/vector_db",
                 collection_name: str = "dsl_documentation",
                 embedding_generator: Optional[EmbeddingGenerator] = None):
        """
        Inizializza il vector store
        
        Args:
            store_path: Path dove salvare il database
            collection_name: Nome della collection
            embedding_generator: Generatore di embeddings
        """
        self.store_path = Path(store_path)
        self.store_path.mkdir(parents=True, exist_ok=True)
        
        self.collection_name = collection_name
        self.embedding_generator = embedding_generator
        
        # Inizializza ChromaDB con telemetria completamente disabilitata
        # Sopprimi temporaneamente stderr per evitare messaggi di telemetria
        import io
        import contextlib
        
        stderr_backup = sys.stderr
        try:
            sys.stderr = io.StringIO()  # Cattura stderr
            
            self.client = chromadb.PersistentClient(
                path=str(self.store_path),
                settings=Settings(
                    anonymized_telemetry=False,
                    allow_reset=True,
                    is_persistent=True
                )
            )
            
            # Crea o recupera la collection
            self.collection = self.client.get_or_create_collection(
                name=collection_name,
                metadata={"description": "DSL Documentation for RAG"}
            )
        finally:
            sys.stderr = stderr_backup  # Ripristina stderr
    
    def add_documents(self, documents: List[Document], 
                     show_progress: bool = True) -> int:
        """
        Aggiunge documenti al vector store
        
        Args:
            documents: Lista di documenti da aggiungere
            show_progress: Mostra progress
            
        Returns:
            Numero di documenti aggiunti
        """
        if not documents:
            return 0
        
        if self.embedding_generator is None:
            raise ValueError("Embedding generator non configurato")
        
        # Prepara i dati
        texts = [doc.content for doc in documents]
        metadatas = [doc.metadata for doc in documents]
        ids = [f"doc_{i}_{doc.metadata.get('chunk_id', 0)}" 
               for i, doc in enumerate(documents)]
        
        # Genera embeddings
        if show_progress:
            print(f"Generating embeddings for {len(documents)} documents...")
        
        embedding_results = self.embedding_generator.embed_documents(
            texts, 
            show_progress=show_progress
        )
        
        embeddings = [result.vector for result in embedding_results]
        
        # Aggiungi al vector store
        if show_progress:
            print("Adding documents to vector store...")
        
        import io
        stderr_backup = sys.stderr
        try:
            sys.stderr = io.StringIO()  # Sopprimi stderr per evitare warning telemetria
            self.collection.add(
                documents=texts,
                embeddings=embeddings,
                metadatas=metadatas,
                ids=ids
            )
        finally:
            sys.stderr = stderr_backup
        
        if show_progress:
            print(f"✓ {len(documents)} documents added to vector store")
        
        return len(documents)
    
    def search(self, 
               query: str, 
               top_k: int = 5,
               filter_metadata: Optional[Dict] = None) -> List[Dict]:
        """
        Cerca documenti simili alla query
        
        Args:
            query: Query di ricerca
            top_k: Numero di risultati da restituire
            filter_metadata: Filtri sui metadata
            
        Returns:
            Lista di risultati con documenti e score
        """
        if self.embedding_generator is None:
            raise ValueError("Embedding generator non configurato")
        
        # Genera embedding per la query
        query_embedding = self.embedding_generator.embed_text(query)
        
        # Cerca nel vector store (sopprimi stderr per telemetria)
        import io
        stderr_backup = sys.stderr
        try:
            sys.stderr = io.StringIO()
            results = self.collection.query(
                query_embeddings=[query_embedding.vector],
                n_results=top_k,
                where=filter_metadata
            )
        finally:
            sys.stderr = stderr_backup
        
        # Formatta i risultati
        formatted_results = []
        
        if results['documents'] and results['documents'][0]:
            for i in range(len(results['documents'][0])):
                result = {
                    'content': results['documents'][0][i],
                    'metadata': results['metadatas'][0][i] if results['metadatas'] else {},
                    'distance': results['distances'][0][i] if results['distances'] else None,
                    'id': results['ids'][0][i] if results['ids'] else None
                }
                formatted_results.append(result)
        
        return formatted_results
    
    def get_relevant_context(self, 
                            query: str, 
                            top_k: int = 5,
                            max_chars: int = 4000) -> str:
        """
        Ottiene contesto rilevante per una query (per RAG)
        
        Args:
            query: Query di ricerca
            top_k: Numero di chunks da recuperare
            max_chars: Massimo numero di caratteri nel contesto
            
        Returns:
            Stringa con il contesto concatenato
        """
        results = self.search(query, top_k=top_k)
        
        context_parts = []
        total_chars = 0
        
        for i, result in enumerate(results, 1):
            content = result['content']
            source = result['metadata'].get('file_name', 'unknown')
            
            # Formatta il chunk
            chunk_text = f"[Documento {i} - {source}]\n{content}\n"
            
            # Controlla se supera il limite
            if total_chars + len(chunk_text) > max_chars:
                break
            
            context_parts.append(chunk_text)
            total_chars += len(chunk_text)
        
        return "\n---\n".join(context_parts)
    
    def delete_collection(self):
        """Elimina la collection corrente"""
        import io
        stderr_backup = sys.stderr
        try:
            sys.stderr = io.StringIO()  # Sopprimi stderr per evitare warning telemetria
            self.client.delete_collection(name=self.collection_name)
        finally:
            sys.stderr = stderr_backup
        print(f"✓ Collection '{self.collection_name}' deleted")
    
    def reset_collection(self):
        """Resetta la collection (elimina e ricrea)"""
        import io
        stderr_backup = sys.stderr
        try:
            sys.stderr = io.StringIO()  # Sopprimi stderr per evitare warning telemetria
            self.delete_collection()
            self.collection = self.client.get_or_create_collection(
                name=self.collection_name,
                metadata={"description": "DSL Documentation for RAG"}
            )
        finally:
            sys.stderr = stderr_backup
        print(f"✓ Collection '{self.collection_name}' reset")
    
    def is_empty(self) -> bool:
        """
        Verifica se il vector store è vuoto
        
        Returns:
            True se il vector store è vuoto, False altrimenti
        """
        return self.collection.count() == 0
    
    def get_stats(self) -> Dict:
        """
        Ottiene statistiche sul vector store
        
        Returns:
            Dizionario con statistiche
        """
        count = self.collection.count()
        
        return {
            'collection_name': self.collection_name,
            'total_documents': count,
            'store_path': str(self.store_path)
        }
    
    def list_collections(self) -> List[str]:
        """
        Lista tutte le collections disponibili
        
        Returns:
            Lista di nomi di collections
        """
        collections = self.client.list_collections()
        return [col.name for col in collections]


class RAGRetriever:
    """Retriever completo per RAG che combina vector store e embedding"""
    
    def __init__(self, 
                 vector_store: VectorStore,
                 top_k: int = 5,
                 similarity_threshold: float = 0.7):
        """
        Inizializza il retriever
        
        Args:
            vector_store: Vector store da usare
            top_k: Numero di risultati da recuperare
            similarity_threshold: Soglia di similarità minima
        """
        self.vector_store = vector_store
        self.top_k = top_k
        self.similarity_threshold = similarity_threshold
    
    def retrieve(self, query: str) -> List[Dict]:
        """
        Recupera documenti rilevanti per la query
        
        Args:
            query: Query di ricerca
            
        Returns:
            Lista di documenti rilevanti
        """
        results = self.vector_store.search(query, top_k=self.top_k)
        
        # Filtra per soglia di similarità
        # Distance in ChromaDB: più basso = più simile
        filtered_results = [
            r for r in results 
            if r['distance'] is None or r['distance'] < (1 - self.similarity_threshold)
        ]
        
        return filtered_results
    
    def retrieve_context(self, query: str, max_chars: int = 4000) -> str:
        """
        Recupera contesto come stringa per il prompt
        
        Args:
            query: Query di ricerca
            max_chars: Massimo caratteri
            
        Returns:
            Contesto formattato
        """
        return self.vector_store.get_relevant_context(
            query, 
            top_k=self.top_k,
            max_chars=max_chars
        )


if __name__ == "__main__":
    # Test del vector store
    print("Test Vector Store\n")
    
    from .embeddings import EmbeddingGenerator
    from .document_loader import DocumentLoader
    
    # Inizializza componenti
    print("1. Initializing components...")
    embedding_gen = EmbeddingGenerator(
        provider="huggingface",
        model="sentence-transformers/all-MiniLM-L6-v2"
    )
    
    vector_store = VectorStore(
        store_path="../../data/vector_db_test",
        collection_name="test_collection",
        embedding_generator=embedding_gen
    )
    
    # Reset collection per test pulito
    vector_store.reset_collection()
    
    # Crea documenti di test
    print("\n2. Creating test documents...")
    test_docs = [
        Document(
            content="The SpaceOBC1 system has 8 resources and operates for 33 time units.",
            metadata={"file_name": "test1.txt", "chunk_id": 0},
            source="test1.txt"
        ),
        Document(
            content="The INIT_CORE task takes 14 time units and requires 1 resource.",
            metadata={"file_name": "test2.txt", "chunk_id": 0},
            source="test2.txt"
        ),
        Document(
            content="Services coordinate multiple tasks in the system architecture.",
            metadata={"file_name": "test3.txt", "chunk_id": 0},
            source="test3.txt"
        )
    ]
    
    # Aggiungi documenti
    print("\n3. Adding documents to vector store...")
    vector_store.add_documents(test_docs)
    
    # Test ricerca
    print("\n4. Testing search...")
    query = "How many resources does the system have?"
    results = vector_store.search(query, top_k=2)
    
    print(f"\nQuery: '{query}'")
    print(f"Results found: {len(results)}\n")
    
    for i, result in enumerate(results, 1):
        print(f"Result {i}:")
        print(f"  Content: {result['content'][:100]}...")
        print(f"  Distance: {result['distance']:.4f}")
        print()
    
    # Test context retrieval
    print("5. Testing context retrieval...")
    context = vector_store.get_relevant_context(query, top_k=2)
    print(f"Context length: {len(context)} chars")
    print(f"Context preview:\n{context[:200]}...\n")
    
    # Statistiche
    stats = vector_store.get_stats()
    print(f"6. Statistics: {stats}")
    
    print("\n✓ Test completed")
