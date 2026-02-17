# Enhanced DSL - 28 Task Pipeline Experiment

# global configuration
wsp:
  name: "28tasks"
  h_start: 0
  h_end: 394
  r_max: 194

# Service definitions
services:
  - id: 1
    name: "Payment_Service"
    tasks_set: [1,9,21,22,23,24]
  - id: 2
    name: "Inventory_Service"
    tasks_set: [2,6,7,26]
  - id: 3
    name: "Order_Service"
    tasks_set: [4,8,10,12,20]
  - id: 4
    name: "Shipping_Service"
    tasks_set: [3]
  - id: 5
    name: "Notification_Service"
    tasks_set: [5]
  - id: 6
    name: "Security_Service"
    tasks_set: [11,13,17,18]
  - id: 7
    name: "Analytics_Service"
    tasks_set: [14,16]
  - id: 8
    name: "Infrastructure_Service"
    tasks_set: [15,19]
  - id: 9
    name: "Recommendation_Service"
    tasks_set: [25,28]
  - id: 10
    name: "Refund_Service"
    tasks_set: [27]

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
    dur: 9
    res_q: 5
    rc: 3
    rd: 0
    max_c: 5
  - id: 6
    name: "Warehouse_Allocation"
    sig: "WH_ALLOC"
    dur: 7
    res_q: 1
    rc: 0
    rd: 0
    max_c: 3
  - id: 7
    name: "Quality_Check"
    sig: "QC_CHK"
    dur: 8
    res_q: 3
    rc: 0
    rd: 0
    max_c: 2
  - id: 8
    name: "Final_Processing"
    sig: "FINAL_PROC"
    dur: 9
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1
  - id: 9
    name: "Tax_Calculation"
    sig: "TAX_CALC"
    dur: 6
    res_q: 4
    rc: 2
    rd: 0
    max_c: 3
  - id: 10
    name: "Document_Generation"
    sig: "DOC_GEN"
    dur: 5
    res_q: 3
    rc: 1
    rd: 10
    max_c: 5
  - id: 11
    name: "Compliance_Check"
    sig: "COMP_CHK"
    dur: 4
    res_q: 1
    rc: 0
    rd: 0
    max_c: 5
  - id: 12
    name: "Archive_Processing"
    sig: "ARCH_PROC"
    dur: 3
    res_q: 1
    rc: 1
    rd: 0
    max_c: 4
  - id: 13
    name: "Security_Validation"
    sig: "SEC_VAL"
    dur: 10
    res_q: 5
    rc: 2
    rd: 0
    max_c: 3
  - id: 14
    name: "Performance_Monitor"
    sig: "PERF_MON"
    dur: 6
    res_q: 5
    rc: 0
    rd: 0
    max_c: 4
  - id: 15
    name: "Backup_Creation"
    sig: "BCK_CREA"
    dur: 4
    res_q: 3
    rc: 3
    rd: 0
    max_c: 5
  - id: 16
    name: "Report_Generation"
    sig: "RPT_GEN"
    dur: 7
    res_q: 1
    rc: 0
    rd: 0
    max_c: 5
  - id: 17
    name: "Data_Encryption"
    sig: "DATA_ENCR"
    dur: 3
    res_q: 1
    rc: 0
    rd: 0
    max_c: 2
  - id: 18
    name: "Audit_Trail"
    sig: "AUD_TRL"
    dur: 5
    res_q: 3
    rc: 1
    rd: 0
    max_c: 1
  - id: 19
    name: "System_Cleanup"
    sig: "SYS_CLN"
    dur: 3
    res_q: 4
    rc: 2
    rd: 0
    max_c: 2
  - id: 20
    name: "Final_Validation"
    sig: "FINAL_VAL"
    dur: 9
    res_q: 5
    rc: 0
    rd: 11
    max_c: 1
  - id: 21
    name: "Risk_Assessment"
    sig: "RISK_ASMT"
    dur: 9
    res_q: 1
    rc: 2
    rd: 0
    max_c: 4
  - id: 22
    name: "Fraud_Detection"
    sig: "FRD_DET"
    dur: 4
    res_q: 3
    rc: 3
    rd: 0
    max_c: 5
  - id: 23
    name: "Currency_Conversion"
    sig: "CUR_CONV"
    dur: 9
    res_q: 4
    rc: 1
    rd: 0
    max_c: 4
  - id: 24
    name: "Price_Optimization"
    sig: "PRC_OPT"
    dur: 3
    res_q: 3
    rc: 0
    rd: 14
    max_c: 3
  - id: 25
    name: "Loyalty_Processing"
    sig: "LOY_PROC"
    dur: 4
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4
  - id: 26
    name: "Return_Handling"
    sig: "RET_HDL"
    dur: 9
    res_q: 5
    rc: 0
    rd: 0
    max_c: 3
  - id: 27
    name: "Refund_Processing"
    sig: "REF_PROC"
    dur: 8
    res_q: 2
    rc: 1
    rd: 0
    max_c: 1
  - id: 28
    name: "Product_Recommendation"
    sig: "PRD_REC"
    dur: 4
    res_q: 5
    rc: 3
    rd: 0
    max_c: 3

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
    delay: 6
    wait_all: true
  - from: 1
    to: 5
    delay: 9
    wait_all: true
  - from: 5
    to: 6
    delay: 7
    wait_all: true
  - from: 6
    to: 7
    delay: 12
    wait_all: false
  - from: 7
    to: 8
    delay: 15
    wait_all: false
  - from: 5
    to: 8
    delay: 15
    wait_all: false
  - from: 4
    to: 8
    delay: 7
    wait_all: false
  - from: 8
    to: 9
    delay: 12
    wait_all: false
  - from: 7
    to: 10
    delay: 6
    wait_all: false
  - from: 6
    to: 10
    delay: 12
    wait_all: false
  - from: 7
    to: 11
    delay: 6
    wait_all: true
  - from: 10
    to: 12
    delay: 13
    wait_all: true
  - from: 7
    to: 12
    delay: 12
    wait_all: true
  - from: 8
    to: 12
    delay: 10
    wait_all: false
  - from: 5
    to: 13
    delay: 10
    wait_all: true
  - from: 8
    to: 13
    delay: 13
    wait_all: true
  - from: 12
    to: 13
    delay: 5
    wait_all: true
  - from: 13
    to: 14
    delay: 14
    wait_all: true
  - from: 10
    to: 14
    delay: 10
    wait_all: false
  - from: 12
    to: 14
    delay: 9
    wait_all: false
  - from: 11
    to: 15
    delay: 5
    wait_all: false
  - from: 10
    to: 15
    delay: 6
    wait_all: false
  - from: 14
    to: 16
    delay: 9
    wait_all: false
  - from: 5
    to: 17
    delay: 14
    wait_all: true
  - from: 6
    to: 17
    delay: 10
    wait_all: false
  - from: 2
    to: 17
    delay: 15
    wait_all: false
  - from: 11
    to: 18
    delay: 9
    wait_all: false
  - from: 5
    to: 19
    delay: 15
    wait_all: false
  - from: 17
    to: 19
    delay: 13
    wait_all: false
  - from: 3
    to: 19
    delay: 5
    wait_all: false
  - from: 15
    to: 20
    delay: 12
    wait_all: true
  - from: 14
    to: 20
    delay: 8
    wait_all: true
  - from: 14
    to: 21
    delay: 13
    wait_all: true
  - from: 16
    to: 22
    delay: 7
    wait_all: true
  - from: 18
    to: 22
    delay: 7
    wait_all: true
  - from: 17
    to: 22
    delay: 16
    wait_all: false
  - from: 18
    to: 23
    delay: 12
    wait_all: false
  - from: 8
    to: 24
    delay: 12
    wait_all: true
  - from: 18
    to: 24
    delay: 10
    wait_all: false
  - from: 10
    to: 24
    delay: 12
    wait_all: false
  - from: 23
    to: 25
    delay: 8
    wait_all: true
  - from: 18
    to: 25
    delay: 9
    wait_all: true
  - from: 23
    to: 26
    delay: 16
    wait_all: true
  - from: 22
    to: 26
    delay: 9
    wait_all: true
  - from: 18
    to: 26
    delay: 7
    wait_all: false
  - from: 5
    to: 27
    delay: 6
    wait_all: true
  - from: 14
    to: 27
    delay: 12
    wait_all: false
  - from: 26
    to: 28
    delay: 13
    wait_all: false

