# Enhanced DSL - 16 Task Pipeline Experiment

# global configuration
wsp:
  name: "16tasks"
  h_start: 0
  h_end: 270
  r_max: 150

# Service definitions
services:
  - id: 1
    name: "Payment_Service"
    tasks_set: [1,9]
  - id: 2
    name: "Inventory_Service"
    tasks_set: [2,6,7]
  - id: 3
    name: "Order_Service"
    tasks_set: [4,8,10,12]
  - id: 4
    name: "Shipping_Service"
    tasks_set: [3]
  - id: 5
    name: "Notification_Service"
    tasks_set: [5]
  - id: 6
    name: "Security_Service"
    tasks_set: [11,13]
  - id: 7
    name: "Analytics_Service"
    tasks_set: [14,16]
  - id: 8
    name: "Infrastructure_Service"
    tasks_set: [15]

# Task definitions with new nomenclature
tasks:
  - id: 1
    name: "Payment_Validation"
    sig: "PAY_VAL"
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4
  - id: 2
    name: "Inventory_Check"
    sig: "INV_CHK"
    dur: 4
    res_q: 5
    rc: 3
    rd: 0
    max_c: 5
  - id: 3
    name: "Shipping_Calculation"
    sig: "SHIP_CALC"
    dur: 10
    res_q: 3
    rc: 3
    rd: 0
    max_c: 3
  - id: 4
    name: "Order_Confirmation"
    sig: "ORD_CONF"
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 2
  - id: 5
    name: "Customer_Notification"
    sig: "CUST_NOTIF"
    dur: 4
    res_q: 2
    rc: 0
    rd: 0
    max_c: 5
  - id: 6
    name: "Warehouse_Allocation"
    sig: "WH_ALLOC"
    dur: 10
    res_q: 2
    rc: 2
    rd: 0
    max_c: 3
  - id: 7
    name: "Quality_Check"
    sig: "QC_CHK"
    dur: 10
    res_q: 2
    rc: 0
    rd: 0
    max_c: 5
  - id: 8
    name: "Final_Processing"
    sig: "FINAL_PROC"
    dur: 4
    res_q: 1
    rc: 3
    rd: 0
    max_c: 1
  - id: 9
    name: "Tax_Calculation"
    sig: "TAX_CALC"
    dur: 6
    res_q: 2
    rc: 2
    rd: 0
    max_c: 4
  - id: 10
    name: "Document_Generation"
    sig: "DOC_GEN"
    dur: 6
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4
  - id: 11
    name: "Compliance_Check"
    sig: "COMP_CHK"
    dur: 3
    res_q: 4
    rc: 1
    rd: 0
    max_c: 3
  - id: 12
    name: "Archive_Processing"
    sig: "ARCH_PROC"
    dur: 9
    res_q: 5
    rc: 2
    rd: 0
    max_c: 2
  - id: 13
    name: "Security_Validation"
    sig: "SEC_VAL"
    dur: 7
    res_q: 2
    rc: 0
    rd: 1
    max_c: 3
  - id: 14
    name: "Performance_Monitor"
    sig: "PERF_MON"
    dur: 3
    res_q: 1
    rc: 3
    rd: 0
    max_c: 5
  - id: 15
    name: "Backup_Creation"
    sig: "BCK_CREA"
    dur: 5
    res_q: 1
    rc: 3
    rd: 0
    max_c: 2
  - id: 16
    name: "Report_Generation"
    sig: "RPT_GEN"
    dur: 4
    res_q: 5
    rc: 0
    rd: 7
    max_c: 4

# Start-to-start constraints (unchanged)
start_constraints:
  - from: 1
    to: 2
    delay: 5
    wait_all: false
  - from: 2
    to: 3
    delay: 9
    wait_all: true
  - from: 1
    to: 4
    delay: 21
    wait_all: false
  - from: 2
    to: 4
    delay: 16
    wait_all: true
  - from: 3
    to: 4
    delay: 10
    wait_all: true
  - from: 2
    to: 5
    delay: 14
    wait_all: true
  - from: 4
    to: 6
    delay: 15
    wait_all: false
  - from: 2
    to: 7
    delay: 9
    wait_all: false
  - from: 3
    to: 7
    delay: 7
    wait_all: false
  - from: 6
    to: 7
    delay: 12
    wait_all: false
  - from: 1
    to: 8
    delay: 12
    wait_all: true
  - from: 4
    to: 9
    delay: 13
    wait_all: false
  - from: 2
    to: 10
    delay: 10
    wait_all: false
  - from: 4
    to: 10
    delay: 7
    wait_all: false
  - from: 3
    to: 11
    delay: 9
    wait_all: true
  - from: 8
    to: 11
    delay: 7
    wait_all: false
  - from: 7
    to: 11
    delay: 6
    wait_all: true
  - from: 7
    to: 12
    delay: 10
    wait_all: true
  - from: 9
    to: 12
    delay: 15
    wait_all: false
  - from: 5
    to: 13
    delay: 9
    wait_all: true
  - from: 12
    to: 13
    delay: 5
    wait_all: false
  - from: 10
    to: 13
    delay: 7
    wait_all: false
  - from: 8
    to: 13
    delay: 7
    wait_all: false
  - from: 7
    to: 14
    delay: 13
    wait_all: true
  - from: 6
    to: 14
    delay: 10
    wait_all: true
  - from: 11
    to: 14
    delay: 11
    wait_all: true
  - from: 13
    to: 14
    delay: 5
    wait_all: false
  - from: 13
    to: 15
    delay: 8
    wait_all: true
  - from: 1
    to: 15
    delay: 15
    wait_all: true
  - from: 6
    to: 15
    delay: 10
    wait_all: false
  - from: 4
    to: 16
    delay: 7
    wait_all: true
  - from: 14
    to: 16
    delay: 11
    wait_all: true
