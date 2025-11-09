# Test DSL - Using 'machines' instead of 'services'

# global configuration
wsp:
  name: "test_machines"
  h_start: 0
  h_end: 100
  r_max: 50

# Machine definitions (using 'machines' keyword)
machines:
  - id: 1
    name: "Payment_Machine"
    tasks_set: [1]
  - id: 2
    name: "Processing_Machine"
    tasks_set: [2, 3]

# Task definitions
tasks:
  - id: 1
    name: "Payment_Task"
    sig: "PAY"
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 2
  - id: 2
    name: "Process_A"
    sig: "PROC_A"
    dur: 3
    res_q: 2
    rc: 0
    rd: 0
    max_c: 3
  - id: 3
    name: "Process_B"
    sig: "PROC_B"
    dur: 4
    res_q: 3
    rc: 0
    rd: 0
    max_c: 2

# Start-to-start constraints
start_constraints:
  - from: 1
    to: 2
    delay: 5
    wait_all: false
