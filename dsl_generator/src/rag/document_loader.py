"""Document Loader - Carica e preprocessa documenti in vari formati"""

import os
from pathlib import Path
from typing import List, Dict, Optional
from dataclasses import dataclass

from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import (
    TextLoader,
    PyPDFLoader,
    Docx2txtLoader
)

# Prova a importare UnstructuredMarkdownLoader, altrimenti usa TextLoader
try:
    from langchain_community.document_loaders import UnstructuredMarkdownLoader
    HAS_UNSTRUCTURED = True
except ImportError:
    HAS_UNSTRUCTURED = False


@dataclass
class Document:
    """Rappresenta un documento caricato"""
    content: str
    metadata: Dict
    source: str


class DocumentLoader:
    """Carica documenti da vari formati e li preprocessa"""
    
    def __init__(self, chunk_size: int = 1000, chunk_overlap: int = 200):
        """
        Inizializza il document loader
        
        Args:
            chunk_size: Dimensione dei chunk in caratteri
            chunk_overlap: Sovrapposizione tra chunk
        """
        self.chunk_size = chunk_size
        self.chunk_overlap = chunk_overlap
        
        self.text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=chunk_size,
            chunk_overlap=chunk_overlap,
            length_function=len,
            separators=["\n\n", "\n", " ", ""]
        )
        
        # Mapping estensioni -> loader
        # Usa UnstructuredMarkdownLoader se disponibile, altrimenti TextLoader
        markdown_loader = UnstructuredMarkdownLoader if HAS_UNSTRUCTURED else TextLoader
        
        self.loaders = {
            '.txt': TextLoader,
            '.md': markdown_loader,
            '.pdf': PyPDFLoader,
            '.docx': Docx2txtLoader
        }
    
    def load_document(self, file_path: str) -> List[Document]:
        """
        Carica un singolo documento
        
        Args:
            file_path: Path al file da caricare
            
        Returns:
            Lista di documenti (chunks)
        """
        path = Path(file_path)
        
        if not path.exists():
            raise FileNotFoundError(f"File non trovato: {file_path}")
        
        # Determina il loader appropriato
        extension = path.suffix.lower()
        if extension not in self.loaders:
            raise ValueError(f"Formato non supportato: {extension}")
        
        # Carica il documento
        loader_class = self.loaders[extension]
        loader = loader_class(str(path))
        
        try:
            documents = loader.load()
        except Exception as e:
            raise RuntimeError(f"Errore nel caricamento di {file_path}: {str(e)}")
        
        # Split in chunks
        chunks = self.text_splitter.split_documents(documents)
        
        # Converti in formato interno
        result = []
        for i, chunk in enumerate(chunks):
            doc = Document(
                content=chunk.page_content,
                metadata={
                    **chunk.metadata,
                    'chunk_id': i,
                    'source_file': str(path),
                    'file_name': path.name
                },
                source=str(path)
            )
            result.append(doc)
        
        return result
    
    def load_directory(self, directory_path: str, 
                      recursive: bool = True) -> List[Document]:
        """
        Carica tutti i documenti da una directory
        
        Args:
            directory_path: Path alla directory
            recursive: Se True, cerca ricorsivamente nelle sottodirectory
            
        Returns:
            Lista di tutti i documenti caricati
        """
        path = Path(directory_path)
        
        if not path.exists() or not path.is_dir():
            raise ValueError(f"Directory non valida: {directory_path}")
        
        all_documents = []
        
        # Pattern di ricerca
        pattern = "**/*" if recursive else "*"
        
        # Trova tutti i file supportati
        for ext in self.loaders.keys():
            for file_path in path.glob(f"{pattern}{ext}"):
                if file_path.is_file():
                    try:
                        docs = self.load_document(str(file_path))
                        all_documents.extend(docs)
                        print(f"✓ Caricato: {file_path.name} ({len(docs)} chunks)")
                    except Exception as e:
                        print(f"✗ Errore con {file_path.name}: {str(e)}")
        
        return all_documents
    
    def preprocess_text(self, text: str) -> str:
        """
        Preprocessa il testo (pulizia, normalizzazione)
        
        Args:
            text: Testo da preprocessare
            
        Returns:
            Testo preprocessato
        """
        # Rimuovi spazi multipli
        text = ' '.join(text.split())
        
        # Rimuovi caratteri speciali problematici
        text = text.replace('\x00', '')
        
        return text.strip()
    
    def get_document_stats(self, documents: List[Document]) -> Dict:
        """
        Calcola statistiche sui documenti caricati
        
        Args:
            documents: Lista di documenti
            
        Returns:
            Dizionario con statistiche
        """
        total_chars = sum(len(doc.content) for doc in documents)
        sources = set(doc.source for doc in documents)
        
        return {
            'total_documents': len(documents),
            'total_characters': total_chars,
            'average_chunk_size': total_chars / len(documents) if documents else 0,
            'unique_sources': len(sources),
            'sources': list(sources)
        }


if __name__ == "__main__":
    # Test del document loader
    loader = DocumentLoader(chunk_size=1000, chunk_overlap=200)
    
    # Test caricamento singolo file
    try:
        docs = loader.load_document("../../SpaceOBC_DSL/spaceOBC1_manual.md")
        print(f"\nCaricati {len(docs)} chunks dal documento")
        print(f"Primo chunk: {docs[0].content[:200]}...")
        
        stats = loader.get_document_stats(docs)
        print(f"\nStatistiche: {stats}")
    except Exception as e:
        print(f"Errore: {e}")
