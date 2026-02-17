"""LLM Client - Client unificato per vari provider LLM"""

from typing import Optional, Dict, List
from dataclasses import dataclass

from langchain_openai import ChatOpenAI
from langchain.schema import HumanMessage, SystemMessage

# Import opzionali (solo se necessari)
try:
    from langchain_anthropic import ChatAnthropic
    HAS_ANTHROPIC = True
except ImportError:
    HAS_ANTHROPIC = False

try:
    from langchain_community.llms import Ollama
    HAS_OLLAMA = True
except ImportError:
    HAS_OLLAMA = False


@dataclass
class LLMResponse:
    """Risposta da un LLM"""
    content: str
    model: str
    tokens_used: Optional[int] = None
    metadata: Optional[Dict] = None


class LLMClient:
    """Client unificato per interagire con vari provider LLM"""
    
    def __init__(self,
                 provider: str = "openai",
                 model: str = "gpt-5.1",
                 api_key: Optional[str] = None,
                 temperature: float = 0,
                 max_tokens: Optional[int] = None,
                 seed: Optional[int] = None):
        """
        Inizializza il client LLM
        
        Args:
            provider: Provider LLM (openai, anthropic, ollama)
            model: Nome del modello
            api_key: API key (se necessaria)
            temperature: Temperatura per la generazione
            max_tokens: Massimo numero di token nella risposta (None = illimitato)
            seed: Seed per riproducibilità (solo OpenAI)
        """
        self.provider = provider
        self.model = model
        self.temperature = temperature
        self.max_tokens = max_tokens
        self.seed = seed
        
        # Inizializza il client appropriato
        if provider == "openai":
            # I modelli più recenti usano max_completion_tokens invece di max_tokens
            # Rileva automaticamente in base al nome del modello
            uses_completion_tokens = (
                model.startswith("gpt-4o") or  # gpt-4o, gpt-4o-mini
                model.startswith("gpt-5")     # gpt-5.x family
            )
            
            if uses_completion_tokens:
                # Parametri base
                openai_params = {
                    "model": model,
                    "openai_api_key": api_key,
                    "temperature": temperature
                }
                # Aggiungi max_completion_tokens solo se specificato
                if max_tokens is not None:
                    openai_params["max_completion_tokens"] = max_tokens
                # Aggiungi seed se specificato
                if seed is not None:
                    openai_params["model_kwargs"] = {"seed": seed}
                
                self.client = ChatOpenAI(**openai_params)
            else:
                # Parametri base
                openai_params = {
                    "model": model,
                    "openai_api_key": api_key,
                    "temperature": temperature
                }
                # Aggiungi max_tokens solo se specificato
                if max_tokens is not None:
                    openai_params["max_tokens"] = max_tokens
                # Aggiungi seed se specificato
                if seed is not None:
                    openai_params["model_kwargs"] = {"seed": seed}
                
                self.client = ChatOpenAI(**openai_params)
            
        elif provider == "anthropic":
            if not HAS_ANTHROPIC:
                raise ImportError(
                    "langchain_anthropic non installato. "
                    "Installa con: pip install langchain-anthropic"
                )
            self.client = ChatAnthropic(
                model=model,
                anthropic_api_key=api_key,
                temperature=temperature,
                max_tokens=max_tokens if max_tokens is not None else 4096  # Anthropic richiede max_tokens
            )
            
        elif provider == "ollama":
            if not HAS_OLLAMA:
                raise ImportError(
                    "Ollama non disponibile. "
                    "Installa langchain-community o usa provider='openai'"
                )
            self.client = Ollama(
                model=model,
                temperature=temperature
            )
            
        else:
            raise ValueError(f"Provider non supportato: {provider}")
    
    def generate(self,
                prompt: str,
                system_prompt: Optional[str] = None,
                **kwargs) -> LLMResponse:
        """
        Genera una risposta dal LLM
        
        Args:
            prompt: Prompt utente
            system_prompt: Prompt di sistema (opzionale)
            **kwargs: Parametri aggiuntivi
            
        Returns:
            LLMResponse con la risposta
        """
        try:
            # Prepara i messaggi
            messages = []
            
            if system_prompt:
                messages.append(SystemMessage(content=system_prompt))
            
            messages.append(HumanMessage(content=prompt))
            
            # Genera risposta
            response = self.client.invoke(messages)
            
            # Estrai contenuto
            if hasattr(response, 'content'):
                content = response.content
            else:
                content = str(response)
            
            # Estrai metadata se disponibili
            metadata = {}
            if hasattr(response, 'response_metadata'):
                metadata = response.response_metadata
            
            return LLMResponse(
                content=content,
                model=self.model,
                tokens_used=metadata.get('token_usage', {}).get('total_tokens'),
                metadata=metadata
            )
            
        except Exception as e:
            raise RuntimeError(f"Errore nella generazione LLM: {str(e)}")
    
    def generate_with_retry(self,
                           prompt: str,
                           system_prompt: Optional[str] = None,
                           max_retries: int = 3,
                           **kwargs) -> LLMResponse:
        """
        Genera con retry automatico in caso di errore
        
        Args:
            prompt: Prompt utente
            system_prompt: Prompt di sistema
            max_retries: Numero massimo di tentativi
            **kwargs: Parametri aggiuntivi
            
        Returns:
            LLMResponse con la risposta
        """
        last_error = None
        
        for attempt in range(max_retries):
            try:
                return self.generate(prompt, system_prompt, **kwargs)
            except Exception as e:
                last_error = e
                print(f"Tentativo {attempt + 1}/{max_retries} fallito: {str(e)}")
                
                if attempt < max_retries - 1:
                    import time
                    time.sleep(2 ** attempt)  # Exponential backoff
        
        raise RuntimeError(f"Tutti i tentativi falliti. Ultimo errore: {str(last_error)}")
    
    def generate_structured(self,
                          prompt: str,
                          system_prompt: Optional[str] = None,
                          output_format: str = "json",
                          **kwargs) -> Dict:
        """
        Genera output strutturato (JSON, YAML, etc.)
        
        Args:
            prompt: Prompt utente
            system_prompt: Prompt di sistema
            output_format: Formato output desiderato
            **kwargs: Parametri aggiuntivi
            
        Returns:
            Dizionario con output strutturato
        """
        # Aggiungi istruzioni per formato strutturato
        format_instruction = f"\n\nIMPORTANT: Output must be valid {output_format.upper()} format only, with no additional text or explanation."
        
        enhanced_prompt = prompt + format_instruction
        
        response = self.generate(enhanced_prompt, system_prompt, **kwargs)
        
        # Parse del formato
        if output_format == "json":
            import json
            try:
                # Cerca JSON nel contenuto
                content = response.content.strip()
                
                # Rimuovi markdown code blocks se presenti
                if content.startswith("```"):
                    lines = content.split("\n")
                    content = "\n".join(lines[1:-1])
                
                return json.loads(content)
            except json.JSONDecodeError as e:
                raise ValueError(f"Risposta non è JSON valido: {str(e)}\nContent: {response.content}")
        
        elif output_format == "yaml":
            import yaml
            try:
                content = response.content.strip()
                
                # Rimuovi markdown code blocks se presenti
                if content.startswith("```"):
                    lines = content.split("\n")
                    content = "\n".join(lines[1:-1])
                
                return yaml.safe_load(content)
            except yaml.YAMLError as e:
                raise ValueError(f"Risposta non è YAML valido: {str(e)}\nContent: {response.content}")
        
        else:
            raise ValueError(f"Formato non supportato: {output_format}")
    
    def get_model_info(self) -> Dict:
        """
        Restituisce informazioni sul modello
        
        Returns:
            Dizionario con info
        """
        return {
            'provider': self.provider,
            'model': self.model,
            'temperature': self.temperature,
            'max_tokens': self.max_tokens if self.max_tokens is not None else 'unlimited',
            'seed': self.seed
        }


class StreamingLLMClient(LLMClient):
    """Client LLM con supporto per streaming"""
    
    def generate_stream(self,
                       prompt: str,
                       system_prompt: Optional[str] = None,
                       callback=None):
        """
        Genera risposta in streaming
        
        Args:
            prompt: Prompt utente
            system_prompt: Prompt di sistema
            callback: Funzione chiamata per ogni chunk
        """
        messages = []
        
        if system_prompt:
            messages.append(SystemMessage(content=system_prompt))
        
        messages.append(HumanMessage(content=prompt))
        
        full_response = ""
        
        for chunk in self.client.stream(messages):
            if hasattr(chunk, 'content'):
                content = chunk.content
            else:
                content = str(chunk)
            
            full_response += content
            
            if callback:
                callback(content)
        
        return LLMResponse(
            content=full_response,
            model=self.model
        )


if __name__ == "__main__":
    # Test del client LLM
    print("Test LLM Client\n")
    
    # Test con un prompt semplice
    print("NOTA: Questo test richiede una API key valida.")
    print("Per testare senza API key, usa provider='ollama' con un modello locale.\n")
    
    # Esempio di utilizzo (commentato per evitare chiamate API non necessarie)
    """
    client = LLMClient(
        provider="openai",
        model="gpt-3.5-turbo",
        api_key="your-api-key-here",
        temperature=0.0
    )
    
    response = client.generate(
        prompt="What is a DSL in software engineering?",
        system_prompt="You are a helpful assistant."
    )
    
    print(f"Response: {response.content}")
    print(f"Tokens used: {response.tokens_used}")
    """
    
    print("✓ Modulo LLM Client pronto per l'uso")
