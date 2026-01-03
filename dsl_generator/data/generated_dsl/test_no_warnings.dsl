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
    tasks_set: [5, 6]

  - id: 4
    name: "ProcessingService"
    tasks_set: [7, 8]

  - id: 5
    name: "OrbitService"
    tasks_set: [9, 10]

  - id: 6
    name: "MonitorService"
    tasks_set: [11]

  - id: 7
    name: "SafeService"
    tasks_set: [12]

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

  - id: 5
    name: "ANALYSIS_FULL"
    sig: "anlful"
    dur: 14
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

  - id: 6
    name: "VERIFY_QUICK"
    sig: "verqck"
    dur: 7
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

  - id: 7
    name: "PREPROCESS_SVC"
    sig: "presvc"
    dur: 13
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

  - id: 8
    name: "POSTPROCESS_SVC"
    sig: "pstsvc"
    dur: 12
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

  - id: 9
    name: "ORBIT_CTRL"
    sig: "orbctl"
    dur: 13
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

  - id: 10
    name: "ORBIT_MGMT"
    sig: "orbmgt"
    dur: 14
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

  - id: 11
    name: "MONITOR_SYS"
    sig: "monsys"
    dur: 12
    res_q: 1
    rc: 0
    rd: 0
    max_c: 3

  - id: 12
    name: "SAFE_DIR"
    sig: "safdir"
    dur: 12
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

# Start-to-start precedence constraints
start_constraints:
  - from: 1   # INIT_CORE
    to: 3     # CTRL_EXEC
    delay: 2
    wait_all: false