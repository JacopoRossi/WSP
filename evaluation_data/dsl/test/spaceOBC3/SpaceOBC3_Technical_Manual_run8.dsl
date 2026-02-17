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

tasks:
  - id: 1
    name: "INIT_CORE"
    sig: "initcor"
    dur: 14
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 2
    name: "COMM_PROTO"
    sig: "comprt"
    dur: 16
    res_q: 3
    rc: 0
    rd: 0
    max_c: 1

  - id: 3
    name: "CTRL_EXEC"
    sig: "ctlexe"
    dur: 3
    res_q: 1
    rc: 3
    rd: 5
    max_c: 1

  - id: 4
    name: "SYNC_PROC"
    sig: "synprc"
    dur: 2
    res_q: 1
    rc: 3
    rd: 6
    max_c: 1

  - id: 5
    name: "ORBIT_CTRL"
    sig: "orbctl"
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 6
    name: "ORBIT_MGMT"
    sig: "orbmgt"
    dur: 10
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 7
    name: "PREPROCESS_SVC"
    sig: "presvc"
    dur: 9
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

  - id: 8
    name: "POSTPROCESS_SVC"
    sig: "pstsvc"
    dur: 11
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 9
    name: "MONITOR_SYS"
    sig: "monsys"
    dur: 20
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

  - id: 10
    name: "DATA_DOWNLINK"
    sig: "datadwn"
    dur: 5
    res_q: 2
    rc: 1
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

  - from: 3
    to: 4
    delay: 2
    wait_all: false

  - from: 1
    to: 9
    delay: 4
    wait_all: true

  - from: 2
    to: 3
    delay: 2
    wait_all: true

  - from: 1
    to: 5
    delay: 5
    wait_all: true

  - from: 5
    to: 6
    delay: 2
    wait_all: true

  - from: 7
    to: 8
    delay: 1
    wait_all: true

  - from: 3
    to: 7
    delay: 4
    wait_all: false

  - from: 8
    to: 10
    delay: 2
    wait_all: true

  - from: 2
    to: 10
    delay: 8
    wait_all: true

  - from: 9
    to: 6
    delay: 6
    wait_all: true

  - from: 9
    to: 10
    delay: 12
    wait_all: true

  - from: 6
    to: 7
    delay: 3
    wait_all: true