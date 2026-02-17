# Global parameters
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
    service_id: 1
    dur: 5
    res_q: 4
    max_c: 4
    rc: 0
    rd: 0

  - id: 2
    name: "INV_CHK"
    sig: "inv_chk"
    service_id: 2
    dur: 4
    res_q: 5
    max_c: 5
    rc: 3
    rd: 0

  - id: 3
    name: "SHIP_CALC"
    sig: "ship_calc"
    service_id: 4
    dur: 10
    res_q: 3
    max_c: 3
    rc: 3
    rd: 0

  - id: 4
    name: "ORD_CONF"
    sig: "ord_conf"
    service_id: 3
    dur: 8
    res_q: 2
    max_c: 2
    rc: 0
    rd: 0

  - id: 5
    name: "CUST_NOTIF"
    sig: "cust_notif"
    service_id: 5
    dur: 9
    res_q: 3
    max_c: 3
    rc: 3
    rd: 0

  - id: 6
    name: "WH_ALLOC"
    sig: "wh_alloc"
    service_id: 2
    dur: 3
    res_q: 2
    max_c: 4
    rc: 0
    rd: 0

  - id: 7
    name: "QC_CHK"
    sig: "qc_chk"
    service_id: 2
    dur: 7
    res_q: 1
    max_c: 2
    rc: 0
    rd: 10

  - id: 8
    name: "FINAL_PROC"
    sig: "final_proc"
    service_id: 3
    dur: 10
    res_q: 4
    max_c: 3
    rc: 2
    rd: 0

  - id: 9
    name: "TAX_CALC"
    sig: "tax_calc"
    service_id: 1
    dur: 5
    res_q: 2
    max_c: 5
    rc: 3
    rd: 8

  - id: 10
    name: "DOC_GEN"
    sig: "doc_gen"
    service_id: 3
    dur: 9
    res_q: 5
    max_c: 2
    rc: 2
    rd: 0

  - id: 11
    name: "COMP_CHK"
    sig: "comp_chk"
    service_id: 6
    dur: 5
    res_q: 5
    max_c: 1
    rc: 2
    rd: 0

  - id: 12
    name: "ARCH_PROC"
    sig: "arch_proc"
    service_id: 3
    dur: 4
    res_q: 2
    max_c: 5
    rc: 0
    rd: 13

# Start-to-start precedence constraints
start_constraints:
  - id: 1
    from: 1   # PAY_VAL
    to: 2     # INV_CHK
    delay: 5
    wait_all: false

  - id: 2
    from: 2   # INV_CHK
    to: 3     # SHIP_CALC
    delay: 9
    wait_all: true

  - id: 3
    from: 1   # PAY_VAL
    to: 4     # ORD_CONF
    delay: 21
    wait_all: false

  - id: 4
    from: 2   # INV_CHK
    to: 4     # ORD_CONF
    delay: 16
    wait_all: true

  - id: 5
    from: 3   # SHIP_CALC
    to: 4     # ORD_CONF
    delay: 10
    wait_all: true

  - id: 6
    from: 4   # ORD_CONF
    to: 5     # CUST_NOTIF
    delay: 11
    wait_all: false

  - id: 7
    from: 3   # SHIP_CALC
    to: 6     # WH_ALLOC
    delay: 16
    wait_all: true

  - id: 8
    from: 1   # PAY_VAL
    to: 6     # WH_ALLOC
    delay: 15
    wait_all: false

  - id: 9
    from: 5   # CUST_NOTIF
    to: 6     # WH_ALLOC
    delay: 15
    wait_all: false

  - id: 10
    from: 3   # SHIP_CALC
    to: 7     # QC_CHK
    delay: 11
    wait_all: true

  - id: 11
    from: 1   # PAY_VAL
    to: 8     # FINAL_PROC
    delay: 16
    wait_all: false

  - id: 12
    from: 6   # WH_ALLOC
    to: 8     # FINAL_PROC
    delay: 13
    wait_all: true

  - id: 13
    from: 2   # INV_CHK
    to: 9     # TAX_CALC
    delay: 9
    wait_all: true

  - id: 14
    from: 7   # QC_CHK
    to: 9     # TAX_CALC
    delay: 7
    wait_all: false

  - id: 15
    from: 6   # WH_ALLOC
    to: 9     # TAX_CALC
    delay: 7
    wait_all: true

  - id: 16
    from: 2   # INV_CHK
    to: 10    # DOC_GEN
    delay: 9
    wait_all: true

  - id: 17
    from: 9   # TAX_CALC
    to: 10    # DOC_GEN
    delay: 5
    wait_all: true

  - id: 18
    from: 4   # ORD_CONF
    to: 10    # DOC_GEN
    delay: 14
    wait_all: true

  - id: 19
    from: 2   # INV_CHK
    to: 11    # COMP_CHK
    delay: 13
    wait_all: true

  - id: 20
    from: 6   # WH_ALLOC
    to: 12    # ARCH_PROC
    delay: 9
    wait_all: false