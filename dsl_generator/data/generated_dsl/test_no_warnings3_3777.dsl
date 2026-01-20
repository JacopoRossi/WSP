# Global parameters
wsp:
  name: "SpaceOBC3"
  h_start: 0
  h_end: 33
  r_max: 12

# Service definitions
services:
  - id: 1
    name: "CoreService"
    tasks_set: [1, 2]
  - id: 2
    name: "ControlService"
    tasks_set: [3]
  - id: 3
    name: "OrbitService"
    tasks_set: [5, 6]
  - id: 4
    name: "ProcessingService"
    tasks_set: [7, 8]
  - id: 5
    name: "MonitorService"
    tasks_set: [4, 9]
  - id: 6
    name: "DataService"
    tasks_set: [10]

# Task definitions
tasks:
  - id: 1
    name: "INIT_CORE"
    sig: "init_core"
    dur: 14
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1
  - id: 2
    name: "COMM_PROTO"
    sig: "comm_proto"
    dur: 16
    res_q: 3
    rc: 0
    rd: 0
    max_c: 1
  - id: 3
    name: "CTRL_EXEC"
    sig: "ctrl_exec"
    dur: 3
    res_q: 1
    rc: 3
    rd: 5
    max_c: 1
  - id: 4
    name: "SYNC_PROC"
    sig: "sync_proc"
    dur: 2
    res_q: 1
    rc: 3
    rd: 6
    max_c: 1
  - id: 5
    name: "ORBIT_CTRL"
    sig: "orbit_ctrl"
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1
  - id: 6
    name: "ORBIT_MGMT"
    sig: "orbit_mgmt"
    dur: 10
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1
  - id: 7
    name: "PREPROCESS_SVC"
    sig: "preprocess_svc"
    dur: 9
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1
  - id: 8
    name: "POSTPROCESS_SVC"
    sig: "postprocess_svc"
    dur: 11
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1
  - id: 9
    name: "MONITOR_SYS"
    sig: "monitor_sys"
    dur: 20
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1
  - id: 10
    name: "DATA_DOWNLINK"
    sig: "data_downlink"
    dur: 5
    res_q: 2
    rc: 2
    rd: 5
    max_c: 1

# Start-to-start precedence constraints
start_constraints:
  - from: 1   # INIT_CORE
    to: 3     # CTRL_EXEC
    delay: 2
    wait_all: false
  - from: 1   # INIT_CORE
    to: 2     # COMM_PROTO
    delay: 2
    wait_all: true
  - from: 1   # INIT_CORE
    to: 9     # MONITOR_SYS
    delay: 4
    wait_all: true
  - from: 1   # INIT_CORE
    to: 5     # ORBIT_CTRL
    delay: 5
    wait_all: true
  - from: 2   # COMM_PROTO
    to: 3     # CTRL_EXEC
    delay: 2
    wait_all: true
  - from: 3   # CTRL_EXEC
    to: 4     # SYNC_PROC
    delay: 2
    wait_all: false
  - from: 5   # ORBIT_CTRL
    to: 6     # ORBIT_MGMT
    delay: 2
    wait_all: true
  - from: 9   # MONITOR_SYS
    to: 6     # ORBIT_MGMT
    delay: 6
    wait_all: true
  - from: 3   # CTRL_EXEC
    to: 7     # PREPROCESS_SVC
    delay: 4
    wait_all: false
  - from: 6   # ORBIT_MGMT
    to: 7     # PREPROCESS_SVC
    delay: 3
    wait_all: true
  - from: 7   # PREPROCESS_SVC
    to: 8     # POSTPROCESS_SVC
    delay: 1
    wait_all: true
  - from: 8   # POSTPROCESS_SVC
    to: 10    # DATA_DOWNLINK
    delay: 2
    wait_all: true
  - from: 2   # COMM_PROTO
    to: 10    # DATA_DOWNLINK
    delay: 8
    wait_all: true
  - from: 9   # MONITOR_SYS
    to: 10    # DATA_DOWNLINK
    delay: 12
    wait_all: true