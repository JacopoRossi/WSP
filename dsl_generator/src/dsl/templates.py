"""DSL Templates - Template e schemi per DSL"""

from typing import Dict, Any


class DSLTemplate:
    """Template per la struttura DSL"""
    
    # Schema completo del DSL
    SCHEMA = {
        "wsp": {
            "required": ["name", "h_start", "h_end", "r_max"],
            "types": {
                "name": str,
                "h_start": int,
                "h_end": int,
                "r_max": int
            },
            "description": "Global workspace parameters"
        },
        "services": {
            "required": ["id", "name", "tasks_set"],
            "types": {
                "id": int,
                "name": str,
                "tasks_set": list
            },
            "description": "Service definitions grouping related tasks"
        },
        "tasks": {
            "required": ["id", "name", "sig", "dur", "res_q", "rc", "rd", "max_c"],
            "types": {
                "id": int,
                "name": str,
                "sig": str,
                "dur": int,
                "res_q": int,
                "rc": int,
                "rd": int,
                "max_c": int
            },
            "description": "Task definitions with execution properties"
        },
        "start_constraints": {
            "required": ["from", "to", "delay", "wait_all"],
            "types": {
                "from": int,
                "to": int,
                "delay": int,
                "wait_all": bool
            },
            "description": "Start-to-start precedence constraints"
        }
    }
    
    # Template YAML di esempio
    EXAMPLE_TEMPLATE = """# Global parameters
wsp:
  name: "ExampleSystem"
  h_start: 0
  h_end: 33
  r_max: 8

# Service definitions
services:
  - id: 1
    name: "CoreService"
    tasks_set: [1, 2]

# Task definitions
tasks:
  - id: 1
    name: "INIT_CORE"
    sig: "initcor"
    dur: 14
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

  - id: 2
    name: "COMM_PROTO"
    sig: "comprt"
    dur: 16
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

# Start-to-start precedence constraints
start_constraints:
  - from: 1
    to: 2
    delay: 2
    wait_all: false
"""
    
    @classmethod
    def get_empty_template(cls) -> Dict[str, Any]:
        """
        Restituisce un template vuoto con la struttura corretta
        
        Returns:
            Dizionario con struttura DSL vuota
        """
        return {
            "wsp": {
                "name": "",
                "h_start": 0,
                "h_end": 0,
                "r_max": 0
            },
            "services": [],
            "tasks": [],
            "start_constraints": []
        }
    
    @classmethod
    def create_service(cls, service_id: int, name: str, tasks_set: list) -> Dict:
        """Crea un dizionario servizio"""
        return {
            "id": service_id,
            "name": name,
            "tasks_set": tasks_set
        }
    
    @classmethod
    def create_task(cls, 
                   task_id: int,
                   name: str,
                   sig: str,
                   dur: int,
                   res_q: int = 1,
                   rc: int = 0,
                   rd: int = 0,
                   max_c: int = 1) -> Dict:
        """Crea un dizionario task"""
        return {
            "id": task_id,
            "name": name,
            "sig": sig,
            "dur": dur,
            "res_q": res_q,
            "rc": rc,
            "rd": rd,
            "max_c": max_c
        }
    
    @classmethod
    def create_constraint(cls,
                         from_task: int,
                         to_task: int,
                         delay: int,
                         wait_all: bool = False) -> Dict:
        """Crea un dizionario constraint"""
        return {
            "from": from_task,
            "to": to_task,
            "delay": delay,
            "wait_all": wait_all
        }
    
    @classmethod
    def validate_schema(cls, dsl_data: Dict) -> bool:
        """
        Valida che i dati seguano lo schema
        
        Args:
            dsl_data: Dati DSL da validare
            
        Returns:
            True se valido
        """
        # Controlla sezioni richieste
        required_sections = ["wsp", "services", "tasks"]
        for section in required_sections:
            if section not in dsl_data:
                return False
        
        # Controlla campi wsp
        wsp_required = cls.SCHEMA["wsp"]["required"]
        for field in wsp_required:
            if field not in dsl_data["wsp"]:
                return False
        
        return True


# Template per diversi tipi di sistemi
SPACE_OBC_TEMPLATE = {
    "description": "Template for Space On-Board Computer systems",
    "typical_services": [
        "CoreService",
        "ControlService",
        "AnalysisService",
        "MonitorService",
        "SafeService"
    ],
    "typical_tasks": [
        {"name": "INIT_CORE", "sig": "initcor", "typical_dur": 10-15},
        {"name": "COMM_PROTO", "sig": "comprt", "typical_dur": 12-16},
        {"name": "CTRL_EXEC", "sig": "ctlexe", "typical_dur": 2-5},
        {"name": "MONITOR_SYS", "sig": "monsys", "typical_dur": 10-20}
    ]
}


if __name__ == "__main__":
    # Test dei template
    print("Test DSL Templates\n")
    
    # Test creazione elementi
    print("1. Creazione elementi DSL...")
    
    service = DSLTemplate.create_service(1, "TestService", [1, 2])
    print(f"Service: {service}")
    
    task = DSLTemplate.create_task(1, "TEST_TASK", "tsttsk", 10)
    print(f"Task: {task}")
    
    constraint = DSLTemplate.create_constraint(1, 2, 5, False)
    print(f"Constraint: {constraint}")
    
    # Test template vuoto
    print("\n2. Template vuoto...")
    empty = DSLTemplate.get_empty_template()
    print(f"Sezioni: {list(empty.keys())}")
    
    # Test validazione schema
    print("\n3. Validazione schema...")
    is_valid = DSLTemplate.validate_schema(empty)
    print(f"Template vuoto valido: {is_valid}")
    
    print("\n✓ Test completato")
