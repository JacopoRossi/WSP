wsp:
  name: "SpaceOBC1"
  h_start: 0
  h_end: 33
  r_max: 8
  n_constraints: 11

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

tasks:
  - id: 1
    name: "INIT_CORE"
    sig: "initcor"
    service_id: 1
    dur: 14
    res_q: 1
    max_c: 1
    rc: 0
    rd: 0

  - id: 2
    name: "COMM_PROTO"
    sig: "comprt"
    service_id: 1
    dur: 16
    res_q: 1
    max_c: 1
    rc: 0
    rd: 0

  - id: 3
    name: "CTRL_EXEC"
    sig: "ctlexe"
    service_id: 2
    dur: 3
    res_q: 1
    max_c: 1
    rc: 3
    rd: 8

  - id: 4
    name: "SYNC_PROC"
    sig: "synprc"
    service_id: 2
    dur: 2
    res_q: 1
    max_c: 1
    rc: 3
    rd: 8

  - id: 5
    name: "ANALYSIS_FULL"
    sig: "anlful"
    service_id: 3
    dur: 14
    res_q: 1
    max_c: 1
    rc: 0
    rd: 0

  - id: 6
    name: "VERIFY_QUICK"
    sig: "verqck"
    service_id: 3
    dur: 7
    res_q: 1
    max_c: 1
    rc: 0
    rd: 0

  - id: 7
    name: "PREPROCESS_SVC"
    sig: "presvc"
    service_id: 4
    dur: 13
    res_q: 1
    max_c: 1
    rc: 0
    rd: 0

  - id: 8
    name: "POSTPROCESS_SVC"
    sig: "pstsvc"
    service_id: 4
    dur: 12
    res_q: 1
    max_c: 1
    rc: 0
    rd: 0

  - id: 9
    name: "ORBIT_CTRL"
    sig: "orbctl"
    service_id: 5
    dur: 13
    res_q: 1
    max_c: 1
    rc: 0
    rd: 0

  - id: 10
    name: "ORBIT_MGMT"
    sig: "orbmgt"
    service_id: 5
    dur: 14
    res_q: 1
    max_c: 1
    rc: 0
    rd: 0

  - id: 11
    name: "MONITOR_SYS"
    sig: "monsys"
    service_id: 6
    dur: 12
    res_q: 1
    max_c: 3
    rc: 0
    rd: 0

  - id: 12
    name: "SAFE_DIR"
    sig: "safdir"
    service_id: 7
    dur: 12
    res_q: 1
    max_c: 1
    rc: 0
    rd: 0

start_constraints:
  - from: 1
    to: 3
    delay: 2
    wait_all: false

  - from: 2
    to: 3
    delay: 2
    wait_all: false

  - from: 1
    to: 5
    delay: 4
    wait_all: false

  - from: 2
    to: 5
    delay: 4
    wait_all: false

  - from: 3
    to: 4
    delay: 2
    wait_all: false

  - from: 5
    to: 6
    delay: 8
    wait_all: false

  - from: 6
    to: 7
    delay: 6
    wait_all: false

  - from: 6
    to: 9
    delay: 6
    wait_all: false

  - from: 6
    to: 10
    delay: 6
    wait_all: false

  - from: 7
    to: 8
    delay: 2
    wait_all: false

  - from: 1
    to: 11
    delay: 10
    wait_all: false