wsp:
  name: "12tasks"
  h_start: 0
  h_end: 210
  r_max: 130

# Service definitions
services:
  - id: 1
    name: "Payment_Service"
    tasks_set: [1, 9]

  - id: 2
    name: "Inventory_Service"
    tasks_set: [2, 6, 7]

  - id: 3
    name: "Order_Service"
    tasks_set: [4, 8, 10, 12]

  - id: 4
    name: "Shipping_Service"
    tasks_set: [3]

  - id: 5
    name: "Notification_Service"
    tasks_set: [5]

  - id: 6
    name: "Security_Service"
    tasks_set: [11]

# Task definitions
tasks:
  - id: 1
    name: "PAY_VAL"
    sig: "pay_val"
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4

  - id: 2
    name: "INV_CHK"
    sig: "inv_chk"
    dur: 4
    res_q: 5
    rc: 3
    rd: 0
    max_c: 5

  - id: 3
    name: "SHIP_CALC"
    sig: "ship_calc"
    dur: 10
    res_q: 3
    rc: 3
    rd: 0
    max_c: 3

  - id: 4
    name: "ORD_CONF"
    sig: "ord_conf"
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 2

  - id: 5
    name: "CUST_NOTIF"
    sig: "cust_notif"
    dur: 9
    res_q: 3
    rc: 3
    rd: 0
    max_c: 3

  - id: 6
    name: "WH_ALLOC"
    sig: "wh_alloc"
    dur: 3
    res_q: 2
    rc: 0
    rd: 0
    max_c: 4

  - id: 7
    name: "QC_CHK"
    sig: "qc_chk"
    dur: 7
    res_q: 1
    rc: 0
    rd: 10
    max_c: 2

  - id: 8
    name: "FINAL_PROC"
    sig: "final_proc"
    dur: 10
    res_q: 4
    rc: 2
    rd: 0
    max_c: 3

  - id: 9
    name: "TAX_CALC"
    sig: "tax_calc"
    dur: 5
    res_q: 2
    rc: 3
    rd: 8
    max_c: 5

  - id: 10
    name: "DOC_GEN"
    sig: "doc_gen"
    dur: 9
    res_q: 5
    rc: 2
    rd: 0
    max_c: 2

  - id: 11
    name: "COMP_CHK"
    sig: "comp_chk"
    dur: 5
    res_q: 5
    rc: 2
    rd: 0
    max_c: 1

  - id: 12
    name: "ARCH_PROC"
    sig: "arch_proc"
    dur: 4
    res_q: 2
    rc: 0
    rd: 13
    max_c: 5

# Start-to-start precedence constraints
start_constraints:
  - from: 1
    to: 2
    delay: 5
    wait_all: false  # PAY_VAL -> INV_CHK

  - from: 2
    to: 3
    delay: 9
    wait_all: true   # INV_CHK -> SHIP_CALC

  - from: 1
    to: 4
    delay: 21
    wait_all: false  # PAY_VAL -> ORD_CONF

  - from: 2
    to: 4
    delay: 16
    wait_all: true   # INV_CHK -> ORD_CONF

  - from: 3
    to: 4
    delay: 10
    wait_all: true   # SHIP_CALC -> ORD_CONF

  - from: 4
    to: 5
    delay: 11
    wait_all: false  # ORD_CONF -> CUST_NOTIF

  - from: 3
    to: 6
    delay: 16
    wait_all: true   # SHIP_CALC -> WH_ALLOC

  - from: 1
    to: 6
    delay: 15
    wait_all: false  # PAY_VAL -> WH_ALLOC

  - from: 5
    to: 6
    delay: 15
    wait_all: false  # CUST_NOTIF -> WH_ALLOC

  - from: 3
    to: 7
    delay: 11
    wait_all: true   # SHIP_CALC -> QC_CHK

  - from: 1
    to: 8
    delay: 16
    wait_all: false  # PAY_VAL -> FINAL_PROC

  - from: 6
    to: 8
    delay: 13
    wait_all: true   # WH_ALLOC -> FINAL_PROC

  - from: 2
    to: 9
    delay: 9
    wait_all: true   # INV_CHK -> TAX_CALC

  - from: 7
    to: 9
    delay: 7
    wait_all: false  # QC_CHK -> TAX_CALC

  - from: 6
    to: 9
    delay: 7
    wait_all: true   # WH_ALLOC -> TAX_CALC

  - from: 2
    to: 10
    delay: 9
    wait_all: true   # INV_CHK -> DOC_GEN

  - from: 9
    to: 10
    delay: 5
    wait_all: true   # TAX_CALC -> DOC_GEN

  - from: 4
    to: 10
    delay: 14
    wait_all: true   # ORD_CONF -> DOC_GEN

  - from: 2
    to: 11
    delay: 13
    wait_all: true   # INV_CHK -> COMP_CHK

  - from: 6
    to: 12
    delay: 9
    wait_all: false  # WH_ALLOC -> ARCH_PROC