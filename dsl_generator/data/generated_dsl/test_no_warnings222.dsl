# Global parameters
wsp:
  name: "SpaceOBC1"
  h_start: 0
  h_end: 33
  r_max: 8

# Service definitions
services:
  - id: 1
    name: "CoreService"
    tasks_set: [1, 2]

  - id: 2
    name: "ControlSyncService"
    tasks_set: [3, 4]

  - id: 3
    name: "AnalysisService"
    tasks_set: []

  - id: 4
    name: "ProcessingService"
    tasks_set: []

  - id: 5
    name: "OrbitService"
    tasks_set: []

  - id: 6
    name: "MonitorService"
    tasks_set: []

  - id: 7
    name: "SafeService"
    tasks_set: []

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

  - id: 3
    name: "CTRL_EXEC"
    sig: "ctlexe"
    dur: 3
    res_q: 1
    rc: 3
    rd: 8
    max_c: 1

  - id: 4
    name: "SYNC_PROC"
    sig: "synprc"
    dur: 2
    res_q: 1
    rc: 3
    rd: 8
    max_c: 1

# Start-to-start precedence constraints
start_constraints: []