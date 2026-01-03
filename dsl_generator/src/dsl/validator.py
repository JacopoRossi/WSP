"""DSL Validator - Valida la sintassi e semantica dei DSL"""

from typing import List, Dict, Tuple, Optional
import yaml


class ValidationError:
    """Rappresenta un errore di validazione"""
    
    def __init__(self, error_type: str, message: str, location: Optional[str] = None):
        self.error_type = error_type
        self.message = message
        self.location = location
    
    def __str__(self):
        if self.location:
            return f"[{self.error_type}] {self.location}: {self.message}"
        return f"[{self.error_type}] {self.message}"


class DSLValidator:
    """Valida DSL per sintassi e semantica"""
    
    def __init__(self, strict_mode: bool = False):
        """
        Inizializza il validatore
        
        Args:
            strict_mode: Se True, applica validazioni più rigorose
        """
        self.strict_mode = strict_mode
        self.errors: List[ValidationError] = []
        self.warnings: List[ValidationError] = []
    
    def validate(self, dsl_content: str) -> Tuple[bool, List[ValidationError], List[ValidationError]]:
        """
        Valida un DSL completo
        
        Args:
            dsl_content: Contenuto DSL in formato YAML
            
        Returns:
            Tupla (is_valid, errors, warnings)
        """
        self.errors = []
        self.warnings = []
        
        # 1. Validazione sintassi YAML
        try:
            dsl_data = yaml.safe_load(dsl_content)
        except yaml.YAMLError as e:
            self.errors.append(ValidationError(
                "SYNTAX",
                f"YAML non valido: {str(e)}"
            ))
            return False, self.errors, self.warnings
        
        if not isinstance(dsl_data, dict):
            self.errors.append(ValidationError(
                "STRUCTURE",
                "DSL deve essere un dizionario YAML"
            ))
            return False, self.errors, self.warnings
        
        # 2. Validazione struttura
        self._validate_structure(dsl_data)
        
        # 3. Validazione sezioni
        if 'wsp' in dsl_data:
            self._validate_wsp(dsl_data['wsp'])
        
        if 'services' in dsl_data:
            self._validate_services(dsl_data['services'])
        
        if 'tasks' in dsl_data:
            self._validate_tasks(dsl_data['tasks'])
        
        # 4. Validazione cross-reference
        if 'services' in dsl_data and 'tasks' in dsl_data:
            self._validate_service_task_references(
                dsl_data['services'],
                dsl_data['tasks']
            )
        
        if 'start_constraints' in dsl_data and 'tasks' in dsl_data:
            self._validate_constraints(
                dsl_data['start_constraints'],
                dsl_data['tasks']
            )
        
        # 5. Validazioni semantiche
        if not self.errors:
            self._validate_semantics(dsl_data)
        
        is_valid = len(self.errors) == 0
        return is_valid, self.errors, self.warnings
    
    def _validate_structure(self, dsl_data: Dict):
        """Valida la struttura generale del DSL"""
        required_sections = ['wsp', 'services', 'tasks']
        
        for section in required_sections:
            if section not in dsl_data:
                self.errors.append(ValidationError(
                    "STRUCTURE",
                    f"Sezione richiesta mancante: {section}"
                ))
        
        # start_constraints è opzionale ma consigliato
        if 'start_constraints' not in dsl_data:
            self.warnings.append(ValidationError(
                "STRUCTURE",
                "Sezione 'start_constraints' non presente (opzionale ma consigliato)"
            ))
    
    def _validate_wsp(self, wsp: Dict):
        """Valida la sezione wsp (global parameters)"""
        required_fields = ['name', 'h_start', 'h_end', 'r_max']
        
        for field in required_fields:
            if field not in wsp:
                self.errors.append(ValidationError(
                    "WSP",
                    f"Campo richiesto mancante: {field}",
                    "wsp"
                ))
        
        # Validazione tipi
        if 'name' in wsp and not isinstance(wsp['name'], str):
            self.errors.append(ValidationError(
                "WSP",
                "Il campo 'name' deve essere una stringa",
                "wsp.name"
            ))
        
        for field in ['h_start', 'h_end', 'r_max']:
            if field in wsp and not isinstance(wsp[field], int):
                self.errors.append(ValidationError(
                    "WSP",
                    f"Il campo '{field}' deve essere un intero",
                    f"wsp.{field}"
                ))
        
        # Validazione valori
        if 'h_start' in wsp and 'h_end' in wsp:
            if wsp['h_start'] >= wsp['h_end']:
                self.errors.append(ValidationError(
                    "WSP",
                    f"h_start ({wsp['h_start']}) deve essere < h_end ({wsp['h_end']})",
                    "wsp"
                ))
        
        if 'r_max' in wsp and wsp['r_max'] <= 0:
            self.errors.append(ValidationError(
                "WSP",
                f"r_max deve essere > 0, trovato: {wsp['r_max']}",
                "wsp.r_max"
            ))
    
    def _validate_services(self, services: List):
        """Valida la sezione services"""
        if not isinstance(services, list):
            self.errors.append(ValidationError(
                "SERVICES",
                "La sezione 'services' deve essere una lista"
            ))
            return
        
        service_ids = set()
        
        for i, service in enumerate(services):
            if not isinstance(service, dict):
                self.errors.append(ValidationError(
                    "SERVICES",
                    f"Il servizio {i} deve essere un dizionario",
                    f"services[{i}]"
                ))
                continue
            
            # Campi richiesti
            required_fields = ['id', 'name', 'tasks_set']
            for field in required_fields:
                if field not in service:
                    self.errors.append(ValidationError(
                        "SERVICES",
                        f"Campo richiesto mancante: {field}",
                        f"services[{i}]"
                    ))
            
            # Validazione ID unico
            if 'id' in service:
                if service['id'] in service_ids:
                    self.errors.append(ValidationError(
                        "SERVICES",
                        f"ID servizio duplicato: {service['id']}",
                        f"services[{i}].id"
                    ))
                service_ids.add(service['id'])
            
            # Validazione tasks_set
            if 'tasks_set' in service:
                if not isinstance(service['tasks_set'], list):
                    self.errors.append(ValidationError(
                        "SERVICES",
                        "tasks_set deve essere una lista",
                        f"services[{i}].tasks_set"
                    ))
                elif len(service['tasks_set']) == 0:
                    self.warnings.append(ValidationError(
                        "SERVICES",
                        f"Servizio '{service.get('name', i)}' ha tasks_set vuoto",
                        f"services[{i}].tasks_set"
                    ))
    
    def _validate_tasks(self, tasks: List):
        """Valida la sezione tasks"""
        if not isinstance(tasks, list):
            self.errors.append(ValidationError(
                "TASKS",
                "La sezione 'tasks' deve essere una lista"
            ))
            return
        
        task_ids = set()
        required_fields = ['id', 'name', 'sig', 'dur', 'res_q', 'rc', 'rd', 'max_c']
        
        for i, task in enumerate(tasks):
            if not isinstance(task, dict):
                self.errors.append(ValidationError(
                    "TASKS",
                    f"Il task {i} deve essere un dizionario",
                    f"tasks[{i}]"
                ))
                continue
            
            # Campi richiesti
            for field in required_fields:
                if field not in task:
                    self.errors.append(ValidationError(
                        "TASKS",
                        f"Campo richiesto mancante: {field}",
                        f"tasks[{i}]"
                    ))
            
            # Validazione ID unico
            if 'id' in task:
                if task['id'] in task_ids:
                    self.errors.append(ValidationError(
                        "TASKS",
                        f"ID task duplicato: {task['id']}",
                        f"tasks[{i}].id"
                    ))
                task_ids.add(task['id'])
            
            # Validazione valori numerici
            numeric_fields = ['dur', 'res_q', 'rc', 'rd', 'max_c']
            for field in numeric_fields:
                if field in task:
                    if not isinstance(task[field], int):
                        self.errors.append(ValidationError(
                            "TASKS",
                            f"Il campo '{field}' deve essere un intero",
                            f"tasks[{i}].{field}"
                        ))
                    elif task[field] < 0:
                        self.errors.append(ValidationError(
                            "TASKS",
                            f"Il campo '{field}' non può essere negativo",
                            f"tasks[{i}].{field}"
                        ))
    
    def _validate_service_task_references(self, services: List, tasks: List):
        """Valida che i task referenziati nei servizi esistano"""
        task_ids = {task['id'] for task in tasks if 'id' in task}
        
        for i, service in enumerate(services):
            if 'tasks_set' in service and isinstance(service['tasks_set'], list):
                for task_id in service['tasks_set']:
                    if task_id not in task_ids:
                        self.errors.append(ValidationError(
                            "REFERENCE",
                            f"Task ID {task_id} referenziato ma non definito",
                            f"services[{i}].tasks_set"
                        ))
    
    def _validate_constraints(self, constraints: List, tasks: List):
        """Valida i vincoli di precedenza"""
        if not isinstance(constraints, list):
            self.errors.append(ValidationError(
                "CONSTRAINTS",
                "La sezione 'start_constraints' deve essere una lista"
            ))
            return
        
        task_ids = {task['id'] for task in tasks if 'id' in task}
        
        for i, constraint in enumerate(constraints):
            if not isinstance(constraint, dict):
                self.errors.append(ValidationError(
                    "CONSTRAINTS",
                    f"Il vincolo {i} deve essere un dizionario",
                    f"start_constraints[{i}]"
                ))
                continue
            
            # Campi richiesti
            required_fields = ['from', 'to', 'delay', 'wait_all']
            for field in required_fields:
                if field not in constraint:
                    self.errors.append(ValidationError(
                        "CONSTRAINTS",
                        f"Campo richiesto mancante: {field}",
                        f"start_constraints[{i}]"
                    ))
            
            # Validazione riferimenti task
            if 'from' in constraint and constraint['from'] not in task_ids:
                self.errors.append(ValidationError(
                    "CONSTRAINTS",
                    f"Task sorgente {constraint['from']} non esiste",
                    f"start_constraints[{i}].from"
                ))
            
            if 'to' in constraint and constraint['to'] not in task_ids:
                self.errors.append(ValidationError(
                    "CONSTRAINTS",
                    f"Task destinazione {constraint['to']} non esiste",
                    f"start_constraints[{i}].to"
                ))
            
            # Validazione delay
            if 'delay' in constraint:
                if not isinstance(constraint['delay'], int):
                    self.errors.append(ValidationError(
                        "CONSTRAINTS",
                        "Il campo 'delay' deve essere un intero",
                        f"start_constraints[{i}].delay"
                    ))
                elif constraint['delay'] < 0:
                    self.errors.append(ValidationError(
                        "CONSTRAINTS",
                        "Il delay non può essere negativo",
                        f"start_constraints[{i}].delay"
                    ))
            
            # Validazione wait_all
            if 'wait_all' in constraint and not isinstance(constraint['wait_all'], bool):
                self.errors.append(ValidationError(
                    "CONSTRAINTS",
                    "Il campo 'wait_all' deve essere booleano (true/false)",
                    f"start_constraints[{i}].wait_all"
                ))
    
    def _validate_semantics(self, dsl_data: Dict):
        """Validazioni semantiche avanzate"""
        # Controlla cicli nei vincoli
        if 'start_constraints' in dsl_data:
            self._check_circular_dependencies(dsl_data['start_constraints'])
        
        # Controlla uso risorse
        if 'wsp' in dsl_data and 'tasks' in dsl_data:
            self._check_resource_usage(dsl_data['wsp'], dsl_data['tasks'])
    
    def _check_circular_dependencies(self, constraints: List):
        """Controlla cicli nei vincoli di precedenza"""
        # Costruisci grafo
        graph = {}
        for constraint in constraints:
            if 'from' in constraint and 'to' in constraint:
                from_id = constraint['from']
                to_id = constraint['to']
                
                if from_id not in graph:
                    graph[from_id] = []
                graph[from_id].append(to_id)
        
        # DFS per trovare cicli
        def has_cycle(node, visited, rec_stack):
            visited.add(node)
            rec_stack.add(node)
            
            if node in graph:
                for neighbor in graph[node]:
                    if neighbor not in visited:
                        if has_cycle(neighbor, visited, rec_stack):
                            return True
                    elif neighbor in rec_stack:
                        return True
            
            rec_stack.remove(node)
            return False
        
        visited = set()
        for node in graph:
            if node not in visited:
                if has_cycle(node, visited, set()):
                    self.errors.append(ValidationError(
                        "SEMANTICS",
                        "Dipendenza circolare rilevata nei vincoli",
                        "start_constraints"
                    ))
                    break
    
    def _check_resource_usage(self, wsp: Dict, tasks: List):
        """Controlla che l'uso delle risorse sia ragionevole"""
        if 'r_max' not in wsp:
            return
        
        r_max = wsp['r_max']
        
        for task in tasks:
            if 'res_q' in task and 'max_c' in task:
                max_usage = task['res_q'] * task['max_c']
                
                if max_usage > r_max:
                    self.warnings.append(ValidationError(
                        "SEMANTICS",
                        f"Task '{task.get('name', task.get('id'))}' può richiedere "
                        f"{max_usage} risorse (res_q={task['res_q']} * max_c={task['max_c']}), "
                        f"ma il sistema ha solo {r_max} risorse disponibili",
                        f"tasks[{task.get('id')}]"
                    ))


if __name__ == "__main__":
    # Test del validatore
    print("Test DSL Validator\n")
    
    # DSL valido
    valid_dsl = """
wsp:
  name: "TestSystem"
  h_start: 0
  h_end: 10
  r_max: 4

services:
  - id: 1
    name: "TestService"
    tasks_set: [1, 2]

tasks:
  - id: 1
    name: "TASK_ONE"
    sig: "tsk1"
    dur: 5
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1
  
  - id: 2
    name: "TASK_TWO"
    sig: "tsk2"
    dur: 3
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

start_constraints:
  - from: 1
    to: 2
    delay: 2
    wait_all: false
"""
    
    validator = DSLValidator()
    is_valid, errors, warnings = validator.validate(valid_dsl)
    
    print(f"DSL valido: {is_valid}")
    print(f"Errori: {len(errors)}")
    print(f"Warning: {len(warnings)}")
    
    if errors:
        print("\nErrori:")
        for error in errors:
            print(f"  {error}")
    
    if warnings:
        print("\nWarning:")
        for warning in warnings:
            print(f"  {warning}")
    
    print("\n✓ Test completato")
