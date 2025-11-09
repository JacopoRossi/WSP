# Services vs Machines - DSL Syntax

## Overview
Il parser DSL supporta ora **due sintassi equivalenti** per definire i servizi/macchine:
- `services:` (sintassi originale)
- `machines:` (sintassi alternativa)

Entrambe le parole chiave sono completamente intercambiabili e producono lo stesso output.

## Esempi

### Usando 'services:'
```yaml
wsp:
  name: "my_project"
  h_start: 0
  h_end: 100
  r_max: 50

services:
  - id: 1
    name: "Payment_Service"
    tasks_set: [1]
  - id: 2
    name: "Processing_Service"
    tasks_set: [2, 3]

tasks:
  - id: 1
    name: "Payment_Task"
    sig: "PAY"
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 2
  # ... altri task
```

### Usando 'machines:'
```yaml
wsp:
  name: "my_project"
  h_start: 0
  h_end: 100
  r_max: 50

machines:
  - id: 1
    name: "Payment_Machine"
    tasks_set: [1]
  - id: 2
    name: "Processing_Machine"
    tasks_set: [2, 3]

tasks:
  - id: 1
    name: "Payment_Task"
    sig: "PAY"
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 2
  # ... altri task
```

## Output
Indipendentemente dalla sintassi utilizzata, il file `.dzn` generato conterrà sempre:
- `n_services` - numero di servizi/macchine
- `service_names` - nomi dei servizi/macchine
- `task_to_service` - mapping task -> servizio/macchina

## Note
- Non è possibile usare entrambe le parole chiave nello stesso file
- Se entrambe sono presenti, `services:` ha la priorità
- La struttura interna dei dati è identica per entrambe le sintassi
