"""
Completeness Checker - Verifica la completezza delle informazioni nella documentazione

Questo modulo verifica se la documentazione contiene tutte le informazioni necessarie
per generare un DSL valido, interrogando il vector store tramite RAG.
"""

from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass, field


@dataclass
class MissingInformation:
    """Rappresenta informazioni mancanti per generare il DSL"""
    category: str  # 'wsp', 'services', 'tasks', 'constraints'
    field: str     # Nome del campo mancante
    description: str  # Descrizione leggibile
    critical: bool = True  # Se True, il DSL non può essere generato senza questa info
    suggestion: str = ""  # Suggerimento per l'utente


@dataclass
class CompletenessReport:
    """Report sulla completezza della documentazione"""
    is_complete: bool
    missing_info: List[MissingInformation] = field(default_factory=list)
    found_info: Dict[str, bool] = field(default_factory=dict)
    confidence_score: float = 0.0  # 0-1, quanto siamo sicuri di aver trovato le info
    
    def get_critical_missing(self) -> List[MissingInformation]:
        """Ritorna solo le informazioni critiche mancanti"""
        return [info for info in self.missing_info if info.critical]
    
    def get_optional_missing(self) -> List[MissingInformation]:
        """Ritorna solo le informazioni opzionali mancanti"""
        return [info for info in self.missing_info if not info.critical]


class DocumentationCompletenessChecker:
    """
    Verifica se la documentazione contiene informazioni sufficienti per generare un DSL
    """
    
    # Informazioni richieste per un DSL valido
    REQUIRED_FIELDS = {
        'wsp': {
            'name': {'description': 'Nome del sistema/workspace', 'critical': True},
            'h_start': {'description': 'Tempo di inizio (orizzonte temporale)', 'critical': True},
            'h_end': {'description': 'Tempo di fine (orizzonte temporale)', 'critical': True},
            'r_max': {'description': 'Numero massimo di risorse', 'critical': True}
        },
        'tasks': {
            'task_list': {'description': 'Lista dei task del sistema', 'critical': True},
            'task_duration': {'description': 'Durata di ogni task', 'critical': True},
            'task_resources': {'description': 'Risorse richieste per ogni task', 'critical': True},
            'task_release': {'description': 'Release time dei task', 'critical': False},
            'task_deadline': {'description': 'Deadline relativi dei task', 'critical': False},
            'task_max_completions': {'description': 'Numero massimo di completamenti', 'critical': False}
        },
        'services': {
            'service_list': {'description': 'Lista dei servizi del sistema', 'critical': False},
            'service_tasks': {'description': 'Task associati a ogni servizio', 'critical': False}
        },
        'constraints': {
            'precedence': {'description': 'Vincoli di precedenza tra task', 'critical': False},
            'temporal': {'description': 'Vincoli temporali', 'critical': False}
        }
    }
    
    # Query per cercare le informazioni nel vector store
    SEARCH_QUERIES = {
        'wsp_name': ['system name', 'workspace name', 'nome sistema', 'nome del workspace', 'instance identifier'],
        'wsp_horizon': [
            'time horizon', 'time window', 'operational window', 'operational time', 
            'h_start', 'h_end', 'start time', 'end time', 'time units',
            'orizzonte temporale', 'finestra temporale', 'periodo operativo'
        ],
        'wsp_resources': [
            'maximum resources', 'available resources', 'max resources', 'r_max',
            'resources allocable', 'processing units', 'computational resources',
            'risorse massime', 'risorse disponibili'
        ],
        'tasks': ['task list', 'tasks', 'task definitions', 'task registry', 'operational tasks', 'lista task', 'definizione task'],
        'task_properties': [
            'task duration', 'task resources', 'task deadline', 'task concurrency',
            'durata task', 'risorse task', 'max concurrent executions'
        ],
        'services': ['service', 'servizi', 'service definitions', 'service architecture', 'service modules'],
        'constraints': [
            'constraints', 'precedence', 'dependencies', 'dependency matrix',
            'temporal constraints', 'start-to-start', 'vincoli', 'precedenza', 'dipendenze'
        ]
    }
    
    def __init__(self, vector_store):
        """
        Inizializza il checker
        
        Args:
            vector_store: VectorStore per interrogare la documentazione
        """
        self.vector_store = vector_store
    
    def check_completeness(self, min_confidence: float = 0.3) -> CompletenessReport:
        """
        Verifica la completezza della documentazione nel vector store
        
        Args:
            min_confidence: Soglia minima di confidence per considerare un'informazione presente
            
        Returns:
            CompletenessReport con i risultati
        """
        report = CompletenessReport(is_complete=True)
        
        # Se vector store vuoto, tutto manca
        if self.vector_store.is_empty():
            report.is_complete = False
            report.confidence_score = 0.0
            self._add_all_missing(report)
            return report
        
        # Verifica ogni categoria di informazioni
        self._check_wsp_info(report, min_confidence)
        self._check_tasks_info(report, min_confidence)
        self._check_services_info(report, min_confidence)
        self._check_constraints_info(report, min_confidence)
        
        # Calcola score complessivo
        total_fields = sum(len(fields) for fields in self.REQUIRED_FIELDS.values())
        found_fields = sum(1 for v in report.found_info.values() if v)
        report.confidence_score = found_fields / total_fields if total_fields > 0 else 0.0
        
        # Determina se è completo (almeno le info critiche)
        critical_missing = report.get_critical_missing()
        report.is_complete = len(critical_missing) == 0
        
        return report
    
    def _search_for_info(self, queries: List[str], top_k: int = 5) -> Tuple[bool, float]:
        """
        Cerca informazioni usando multiple query
        
        Args:
            queries: Lista di query da provare
            top_k: Numero di risultati da considerare
            
        Returns:
            (found, confidence) - Se trovato e con che confidence
        """
        max_confidence = 0.0
        
        for query in queries:
            results = self.vector_store.search(query, top_k=top_k)
            
            if results and len(results) > 0:
                # Confidence basata su distance (più basso = migliore in ChromaDB)
                # Distance tipicamente 0-2, convertiamo in confidence 0-1
                # Usiamo il MIGLIOR risultato invece della media per essere più permissivi
                best_distance = min(r.get('distance', 2.0) for r in results)
                confidence = max(0.0, 1.0 - (best_distance / 2.0))
                max_confidence = max(max_confidence, confidence)
        
        # Soglia più bassa (0.2 invece di 0.3) per catturare anche match in tabelle
        return max_confidence > 0.2, max_confidence
    
    def _check_wsp_info(self, report: CompletenessReport, min_confidence: float):
        """Verifica informazioni WSP (parametri globali)"""
        # Nome sistema
        found, conf = self._search_for_info(self.SEARCH_QUERIES['wsp_name'])
        report.found_info['wsp.name'] = found and conf >= min_confidence
        if not report.found_info['wsp.name']:
            report.missing_info.append(MissingInformation(
                category='wsp',
                field='name',
                description='System/workspace name',
                critical=True,
                suggestion='Provide the system name (e.g., "SpaceOBC1")'
            ))
        
        # Orizzonte temporale
        found, conf = self._search_for_info(self.SEARCH_QUERIES['wsp_horizon'])
        report.found_info['wsp.horizon'] = found and conf >= min_confidence
        if not report.found_info['wsp.horizon']:
            report.missing_info.append(MissingInformation(
                category='wsp',
                field='h_start, h_end',
                description='Time horizon (start and end)',
                critical=True,
                suggestion='Specify the time period (e.g., from 0 to 100 time units)'
            ))
        
        # Risorse
        found, conf = self._search_for_info(self.SEARCH_QUERIES['wsp_resources'])
        report.found_info['wsp.resources'] = found and conf >= min_confidence
        if not report.found_info['wsp.resources']:
            report.missing_info.append(MissingInformation(
                category='wsp',
                field='r_max',
                description='Maximum number of available resources',
                critical=True,
                suggestion='Indicate how many resources are available (e.g., 8 resources)'
            ))
    
    def _check_tasks_info(self, report: CompletenessReport, min_confidence: float):
        """Verifica informazioni sui Task"""
        # Lista task
        found, conf = self._search_for_info(self.SEARCH_QUERIES['tasks'])
        report.found_info['tasks.list'] = found and conf >= min_confidence
        if not report.found_info['tasks.list']:
            report.missing_info.append(MissingInformation(
                category='tasks',
                field='task_list',
                description='List of system tasks',
                critical=True,
                suggestion='Provide the list of all tasks (e.g., INIT_CORE, COMM_PROTO, etc.)'
            ))
        
        # Proprietà task
        found, conf = self._search_for_info(self.SEARCH_QUERIES['task_properties'])
        report.found_info['tasks.properties'] = found and conf >= min_confidence
        if not report.found_info['tasks.properties']:
            report.missing_info.append(MissingInformation(
                category='tasks',
                field='task_properties',
                description='Task properties (duration, resources, deadline)',
                critical=True,
                suggestion='For each task specify: duration, required resources, release time, deadline'
            ))
    
    def _check_services_info(self, report: CompletenessReport, min_confidence: float):
        """Verifica informazioni sui Services"""
        found, conf = self._search_for_info(self.SEARCH_QUERIES['services'])
        report.found_info['services'] = found and conf >= min_confidence
        if not report.found_info['services']:
            report.missing_info.append(MissingInformation(
                category='services',
                field='service_list',
                description='List of services and associated tasks',
                critical=False,
                suggestion='(Optional) Specify services and which tasks belong to each service'
            ))
    
    def _check_constraints_info(self, report: CompletenessReport, min_confidence: float):
        """Verifica informazioni sui Constraints"""
        found, conf = self._search_for_info(self.SEARCH_QUERIES['constraints'])
        report.found_info['constraints'] = found and conf >= min_confidence
        if not report.found_info['constraints']:
            report.missing_info.append(MissingInformation(
                category='constraints',
                field='precedence',
                description='Precedence constraints between tasks',
                critical=False,
                suggestion='(Optional) Specify dependencies between tasks (e.g., TASK1 must start before TASK2)'
            ))
    
    def _add_all_missing(self, report: CompletenessReport):
        """Aggiunge tutte le informazioni come mancanti (vector store vuoto)"""
        for category, fields in self.REQUIRED_FIELDS.items():
            for field, props in fields.items():
                report.missing_info.append(MissingInformation(
                    category=category,
                    field=field,
                    description=props['description'],
                    critical=props['critical'],
                    suggestion=f'Provide information about: {props["description"]}'
                ))
                report.found_info[f'{category}.{field}'] = False
    
    def print_report(self, report: CompletenessReport):
        """Stampa un report leggibile"""
        print("\n" + "="*70)
        print("📊 DOCUMENTATION COMPLETENESS REPORT")
        print("="*70)
        
        print(f"\n✓ Completeness: {'YES' if report.is_complete else 'NO'}")
        print(f"\n")
        
        # Information found
        found = [k for k, v in report.found_info.items() if v]
        if found:
            print(f"\n✅ Information found ({len(found)}):")
            for info in found:
                print(f"   • {info}")
        
        # Critical information missing
        critical = report.get_critical_missing()
        if critical:
            print(f"\n❌ CRITICAL information missing ({len(critical)}):")
            for info in critical:
                print(f"\n   • {info.field} ({info.category})")
                print(f"     {info.description}")
                print(f"     💡 {info.suggestion}")
        
        # Informazioni opzionali mancanti
        optional = report.get_optional_missing()
        if optional:
            print(f"\n⚠️  OPTIONAL information missing ({len(optional)}):")
            for info in optional:
                print(f"   • {info.field}: {info.description}")
        
        print("\n" + "="*70 + "\n")
        
        return report


if __name__ == "__main__":
    # Test del checker
    print("Test Completeness Checker\n")
    
    from ..rag.vector_store import VectorStore
    from ..rag.embeddings import EmbeddingGenerator
    
    # Setup
    embedding_gen = EmbeddingGenerator(
        provider="huggingface",
        model="sentence-transformers/all-MiniLM-L6-v2"
    )
    
    vector_store = VectorStore(
        store_path="../../data/vector_db",
        collection_name="dsl_documentation",
        embedding_generator=embedding_gen
    )
    
    # Test
    checker = DocumentationCompletenessChecker(vector_store)
    report = checker.check_completeness()
    checker.print_report(report)
