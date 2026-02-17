#!/usr/bin/env python3
"""
Script per verificare il numero di constraint generati nel DSL

Uso:
    python verify_constraints.py path/to/generated.dsl
"""

import sys
import yaml
from pathlib import Path


def count_constraints_in_dsl(dsl_path: str) -> dict:
    """
    Conta i constraint e altre statistiche in un file DSL
    
    Args:
        dsl_path: Path al file DSL
        
    Returns:
        Dizionario con statistiche
    """
    with open(dsl_path, 'r', encoding='utf-8') as f:
        dsl_data = yaml.safe_load(f)
    
    stats = {
        'services': len(dsl_data.get('services', [])),
        'tasks': len(dsl_data.get('tasks', [])),
        'start_constraints': len(dsl_data.get('start_constraints', [])),
        'wsp': dsl_data.get('wsp', {})
    }
    
    return stats


def main():
    if len(sys.argv) < 2:
        print("Uso: python verify_constraints.py path/to/generated.dsl")
        return 1
    
    dsl_path = sys.argv[1]
    
    if not Path(dsl_path).exists():
        print(f"❌ File non trovato: {dsl_path}")
        return 1
    
    try:
        stats = count_constraints_in_dsl(dsl_path)
        
        print("\n📊 STATISTICHE DSL")
        print("=" * 50)
        print(f"File: {dsl_path}")
        print(f"\nWorkspace: {stats['wsp'].get('name', 'N/A')}")
        print(f"Time window: {stats['wsp'].get('h_start', 0)} - {stats['wsp'].get('h_end', 0)}")
        print(f"Max resources: {stats['wsp'].get('r_max', 0)}")
        print(f"\n📦 Services: {stats['services']}")
        print(f"📋 Tasks: {stats['tasks']}")
        print(f"🔗 Start Constraints: {stats['start_constraints']}")
        print("=" * 50)
        
        print(f"\n✓ Il DSL contiene {stats['start_constraints']} constraint")
        print(f"  Verifica che questo numero corrisponda al manuale PDF!")
        
        return 0
        
    except Exception as e:
        print(f"❌ Errore nella lettura del DSL: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
