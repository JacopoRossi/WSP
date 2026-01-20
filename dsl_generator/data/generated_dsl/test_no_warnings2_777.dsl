# Global parameters
wsp:
  name: "SpaceOBC2"
  h_start: 0
  h_end: 33
  r_max: 10

# Service definitions
services:
  - id: 1
    name: "CoreService"
    tasks_set: [1, 2]

  - id: 2
    name: "ControlService"
    tasks_set: [3, 4]

  - id: 3
    name: "AnalysisService"
    tasks_set: [5, 6]

  - id: 4
    name: "MonitorService"
    tasks_set: [7]

  - id: 5
    name: "SafeService"
    tasks_set: [8]

  - id: 6
    name: "ThrusterService"
    tasks_set: [9]

# Task definitions
tasks:
  - id: 1
    name: "INIT_CORE"
    sig: "init_core"
    dur: 10
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 2
    name: "COMM_PROTO"
    sig: "comm_proto"
    dur: 12
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 3
    name: "CTRL_EXEC"
    sig: "ctrl_exec"
    dur: 3
    res_q: 2
    rc: 2
    rd: 4
    max_c: 2

  - id: 4
    name: "SYNC_PROC"
    sig: "sync_proc"
    dur: 2
    res_q: 1
    rc: 2
    rd: 3
    max_c: 1

  - id: 5
    name: "ANALYSIS_FULL"
    sig: "analysis_full"
    dur: 14
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 6
    name: "VERIFY_QUICK"
    sig: "verify_quick"
    dur: 5
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 7
    name: "MONITOR_SYS"
    sig: "monitor_sys"
    dur: 13
    res_q: 1
    rc: 0
    rd: 0
    max_c: 3

  - id: 8
    name: "SAFE_DIR"
    sig: "safe_dir"
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 9
    name: "THRUSTER_CTRL"
    sig: "thruster_ctrl"
    dur: 3
    res_q: 3
    rc: 1
    rd: 3
    max_c: 2

# Start-to-start precedence constraints
start_constraints:
  # From INIT_CORE
  - from: 1        # INIT_CORE
    to: 7          # MONITOR_SYS
    delay: 2
    wait_all: false

  - from: 1        # INIT_CORE
    to: 2          # COMM_PROTO
    delay: 3
    wait_all: false

  - from: 1        # INIT_CORE
    to: 5          # ANALYSIS_FULL
    delay: 6
    wait_all: false

  # Control chain
  - from: 2        # COMM_PROTO
    to: 3          # CTRL_EXEC
    delay: 4
    wait_all: false

  - from: 3        # CTRL_EXEC
    to: 4          # SYNC_PROC
    delay: 2
    wait_all: false

  # Analysis dual-path activation
  - from: 4        # SYNC_PROC
    to: 5          # ANALYSIS_FULL
    delay: 2
    wait_all: false

  # VERIFY_QUICK after ANALYSIS_FULL
  - from: 5        # ANALYSIS_FULL
    to: 6          # VERIFY_QUICK
    delay: 4
    wait_all: false

  # Thruster control dual-path activation
  - from: 6        # VERIFY_QUICK
    to: 9          # THRUSTER_CTRL
    delay: 3
    wait_all: false

  - from: 7        # MONITOR_SYS
    to: 9          # THRUSTER_CTRL
    delay: 8
    wait_all: false

  # Safety dual-path activation
  - from: 7        # MONITOR_SYS
    to: 8          # SAFE_DIR
    delay: 6
    wait_all: false

  - from: 3        # CTRL_EXEC
    to: 8          # SAFE_DIR
    delay: 12
    wait_all: false