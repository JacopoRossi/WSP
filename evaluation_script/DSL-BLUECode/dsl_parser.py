#!/usr/bin/env python3
"""
Parser per DSL custom con calcolo di similarità strutturale
"""

import yaml
from typing import Dict, List, Any, Tuple
from collections import defaultdict


class DSLParser:
    """
    Parser per DSL di task scheduling
    """
    
    def __init__(self, dsl_content: str):
        """
        Inizializza il parser con il contenuto DSL
        
        Args:
            dsl_content: Stringa contenente il DSL
        """
        self.content = dsl_content
        self.parsed = None
        self.structure = None
    
    def parse(self):
        """
        Effettua il parsing del DSL
        
        Returns:
            True se parsing riuscito, False altrimenti
        """
        try:
            # Parse YAML
            self.parsed = yaml.safe_load(self.content)
            
            # Estrai struttura
            self.structure = self._extract_structure()
            
            return True
        except Exception as e:
            print(f"Errore durante il parsing: {e}")
            return False
    
    def _extract_structure(self) -> Dict[str, Any]:
        """
        Estrae la struttura del DSL in un formato normalizzato
        
        Returns:
            Dizionario con la struttura estratta
        """
        structure = {
            'workspace': {},
            'services': {},
            'tasks': {},
            'constraints': [],
            'task_graph': defaultdict(list)
        }
        
        # Estrai workspace
        if 'wsp' in self.parsed:
            structure['workspace'] = self.parsed['wsp']
        
        # Estrai servizi
        if 'services' in self.parsed:
            for service in self.parsed['services']:
                service_id = service['id']
                structure['services'][service_id] = {
                    'name': service['name'],
                    'tasks_set': service.get('tasks_set', [])
                }
        
        # Estrai task
        if 'tasks' in self.parsed:
            for task in self.parsed['tasks']:
                task_id = task['id']
                structure['tasks'][task_id] = {
                    'name': task['name'],
                    'sig': task.get('sig', ''),
                    'dur': task.get('dur', 0),
                    'res_q': task.get('res_q', 0),
                    'rc': task.get('rc', 0),
                    'rd': task.get('rd', 0),
                    'max_c': task.get('max_c', 0)
                }
        
        # Processa constraints (dataflow)
        for constraint in self.parsed.get('start_constraints', []):
            from_task = constraint['from']
            to_task = constraint['to']
            
            structure['constraints'].append({
                'from': from_task,
                'to': to_task,
                'delay': constraint.get('delay', 0),
                'wait_all': constraint.get('wait_all', False)
            })
            
            # Costruisci grafo delle dipendenze
            structure['task_graph'][from_task].append(to_task)
        
        return structure
    
    def get_ast_nodes(self) -> List[str]:
        """
        Estrae nodi dell'AST per il confronto sintattico
        
        Returns:
            Lista di nodi AST
        """
        nodes = []
        
        # Nodo workspace
        if self.structure and 'workspace' in self.structure:
            nodes.append('wsp')
            for key in self.structure['workspace'].keys():
                nodes.append(f'wsp.{key}')
        
        # Nodi servizi
        if self.structure and 'services' in self.structure:
            nodes.append('services')
            for service_id, service in self.structure['services'].items():
                nodes.append(f'service[{service_id}]')
                nodes.append(f'service[{service_id}].name')
                nodes.append(f'service[{service_id}].tasks_set')
        
        # Nodi tasks
        if self.structure and 'tasks' in self.structure:
            nodes.append('tasks')
            for task_id, task in self.structure['tasks'].items():
                nodes.append(f'task[{task_id}]')
                for attr in task.keys():
                    nodes.append(f'task[{task_id}].{attr}')
        
        # Nodi constraints
        if self.structure and 'constraints' in self.structure:
            nodes.append('start_constraints')
            for i, constraint in enumerate(self.structure['constraints']):
                nodes.append(f'constraint[{i}]')
                nodes.append(f'constraint[{i}].from')
                nodes.append(f'constraint[{i}].to')
                nodes.append(f'constraint[{i}].delay')
                nodes.append(f'constraint[{i}].wait_all')
        
        return nodes
    
    def get_dataflow_edges(self) -> List[Tuple[int, int]]:
        """
        Estrae archi del dataflow per il confronto
        
        Returns:
            Lista di tuple (from, to) rappresentanti le dipendenze
        """
        edges = []
        
        if self.structure and 'constraints' in self.structure:
            for constraint in self.structure['constraints']:
                edges.append((constraint['from'], constraint['to']))
        
        return edges


def calculate_syntax_similarity(ref_parser: DSLParser, hyp_parser: DSLParser) -> float:
    """
    Calcola la similarità sintattica tra due DSL
    
    Args:
        ref_parser: Parser del DSL di riferimento
        hyp_parser: Parser del DSL ipotesi
    
    Returns:
        Score di similarità sintattica (0-1)
    """
    ref_nodes = set(ref_parser.get_ast_nodes())
    hyp_nodes = set(hyp_parser.get_ast_nodes())
    
    if not ref_nodes and not hyp_nodes:
        return 1.0
    
    # Calcola intersezione e unione
    intersection = len(ref_nodes & hyp_nodes)
    union = len(ref_nodes | hyp_nodes)
    
    if union == 0:
        return 0.0
    
    # Jaccard similarity
    return intersection / union


def calculate_dataflow_similarity(ref_parser: DSLParser, hyp_parser: DSLParser) -> float:
    """
    Calcola la similarità del dataflow tra due DSL
    
    Args:
        ref_parser: Parser del DSL di riferimento
        hyp_parser: Parser del DSL ipotesi
    
    Returns:
        Score di similarità del dataflow (0-1)
    """
    ref_edges = set(ref_parser.get_dataflow_edges())
    hyp_edges = set(hyp_parser.get_dataflow_edges())
    
    if not ref_edges and not hyp_edges:
        return 1.0
    
    # Calcola intersezione e unione
    intersection = len(ref_edges & hyp_edges)
    union = len(ref_edges | hyp_edges)
    
    if union == 0:
        return 0.0
    
    # Jaccard similarity per gli archi
    jaccard = intersection / union
    
    # Calcola anche similarità pesata considerando attributi
    weighted_score = 0.0
    matched_edges = 0
    
    for edge in ref_edges:
        if edge in hyp_edges:
            matched_edges += 1
            # Trova i constraint corrispondenti
            ref_constraint = None
            hyp_constraint = None
            
            for c in ref_parser.structure['constraints']:
                if (c['from'], c['to']) == edge:
                    ref_constraint = c
                    break
            
            for c in hyp_parser.structure['constraints']:
                if (c['from'], c['to']) == edge:
                    hyp_constraint = c
                    break
            
            if ref_constraint and hyp_constraint:
                # Confronta attributi
                delay_match = 1.0 if ref_constraint['delay'] == hyp_constraint['delay'] else 0.5
                wait_match = 1.0 if ref_constraint['wait_all'] == hyp_constraint['wait_all'] else 0.0
                weighted_score += (delay_match + wait_match) / 2
    
    if matched_edges > 0:
        weighted_score /= matched_edges
    
    # Combina Jaccard e weighted score
    return (jaccard * 0.7) + (weighted_score * 0.3)


def calculate_structural_similarity(ref_parser: DSLParser, hyp_parser: DSLParser) -> Dict[str, float]:
    """
    Calcola tutte le metriche di similarità strutturale
    
    Args:
        ref_parser: Parser del DSL di riferimento
        hyp_parser: Parser del DSL ipotesi
    
    Returns:
        Dizionario con le metriche di similarità
    """
    results = {}
    
    # Workspace similarity
    ref_wsp = ref_parser.structure.get('workspace', {})
    hyp_wsp = hyp_parser.structure.get('workspace', {})
    wsp_match = sum(1 for k in ref_wsp if k in hyp_wsp and ref_wsp[k] == hyp_wsp[k])
    wsp_total = max(len(ref_wsp), len(hyp_wsp))
    results['workspace_similarity'] = wsp_match / wsp_total if wsp_total > 0 else 1.0
    
    # Services similarity
    ref_services = set(ref_parser.structure.get('services', {}).keys())
    hyp_services = set(hyp_parser.structure.get('services', {}).keys())
    if ref_services or hyp_services:
        results['services_similarity'] = len(ref_services & hyp_services) / len(ref_services | hyp_services)
    else:
        results['services_similarity'] = 1.0
    
    # Tasks similarity
    ref_tasks = set(ref_parser.structure.get('tasks', {}).keys())
    hyp_tasks = set(hyp_parser.structure.get('tasks', {}).keys())
    if ref_tasks or hyp_tasks:
        results['tasks_similarity'] = len(ref_tasks & hyp_tasks) / len(ref_tasks | hyp_tasks)
    else:
        results['tasks_similarity'] = 1.0
    
    # Task attributes similarity
    common_tasks = ref_tasks & hyp_tasks
    if common_tasks:
        attr_scores = []
        for task_id in common_tasks:
            ref_task = ref_parser.structure['tasks'][task_id]
            hyp_task = hyp_parser.structure['tasks'][task_id]
            
            matches = sum(1 for k in ref_task if k in hyp_task and ref_task[k] == hyp_task[k])
            total = max(len(ref_task), len(hyp_task))
            attr_scores.append(matches / total if total > 0 else 0)
        
        results['task_attributes_similarity'] = sum(attr_scores) / len(attr_scores)
    else:
        results['task_attributes_similarity'] = 0.0
    
    # Syntax similarity
    results['syntax_similarity'] = calculate_syntax_similarity(ref_parser, hyp_parser)
    
    # Dataflow similarity
    results['dataflow_similarity'] = calculate_dataflow_similarity(ref_parser, hyp_parser)
    
    return results
