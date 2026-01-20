wsp:
  name: "SpaceOBC3"
  h_start: 0
  h_end: 33
  r_max: 12

services:
  - id: 1
    name: "CoreService"
    tasks_set: [1, 2]

  - id: 2
    name: "ControlService"
    tasks_set: [3, 4]

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
    tasks_set: [11]

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

  - id: 11
    name: "DATA_DOWNLINK"
    sig: "data_downlink"
    dur: 5
    res_q: 2
    rc: 2
    rd: 5
    max_c: 1

start_constraints:
  - from: 1
    to: 3
    delay: 2
    wait_all: false

  - from: 1
    to: 2
    delay: 2
    wait_all: true

  - from: 1
    to: 9
    delay: 4
    wait_all: true

  - from: 1
    to: 5
    delay: 5
    wait_all: true

  - from: 2
    to: 3
    delay: 2
    wait_all: true

  - from: 3
    to: 4
    delay: 2
    wait_all: false

  - from: 5
    to: 6
    delay: 2
    wait_all: true

  - from: 9
    to: 6
    delay: 6
    wait_all: true

  - from: 3
    to: 7
    delay: 4
    wait_all: false

  - from: 6
    to: 7
    delay: 3
    wait_all: true

  - from: 7
    to: 8
    delay: 1
    wait_all: true

  - from: 8
    to: 11
    delay: 2
    wait_all: true

  - from: 2
    to: 11
    delay: 8
    wait_all: true

  - from: 9
    to: 11
    delay: 12
    wait_all: true