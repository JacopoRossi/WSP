wsp:
  name: "16tasks"
  h_start: 0
  h_end: 270
  r_max: 150

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
    tasks_set: [11, 13]

  - id: 7
    name: "Analytics_Service"
    tasks_set: [14, 16]

  - id: 8
    name: "Infrastructure_Service"
    tasks_set: [15]

tasks:
  - id: 1
    name: "PAY_VAL"
    sig: "pay_val"
    dur: 5
    res_q: 4
    max_c: 4
    rc: 0
    rd: 0

  - id: 2
    name: "INV_CHK"
    sig: "inv_chk"
    dur: 4
    res_q: 5
    max_c: 5
    rc: 3
    rd: 0

  - id: 3
    name: "SHIP_CALC"
    sig: "ship_calc"
    dur: 10
    res_q: 3
    max_c: 3
    rc: 3
    rd: 0

  - id: 4
    name: "ORD_CONF"
    sig: "ord_conf"
    dur: 8
    res_q: 2
    max_c: 2
    rc: 0
    rd: 0

  - id: 5
    name: "CUST_NOTIF"
    sig: "cust_notif"
    dur: 4
    res_q: 2
    max_c: 5
    rc: 0
    rd: 0

  - id: 6
    name: "WH_ALLOC"
    sig: "wh_alloc"
    dur: 10
    res_q: 2
    max_c: 3
    rc: 2
    rd: 0

  - id: 7
    name: "QC_CHK"
    sig: "qc_chk"
    dur: 10
    res_q: 2
    max_c: 5
    rc: 0
    rd: 0

  - id: 8
    name: "FINAL_PROC"
    sig: "final_proc"
    dur: 4
    res_q: 1
    max_c: 1
    rc: 3
    rd: 0

  - id: 9
    name: "TAX_CALC"
    sig: "tax_calc"
    dur: 6
    res_q: 2
    max_c: 4
    rc: 2
    rd: 0

  - id: 10
    name: "DOC_GEN"
    sig: "doc_gen"
    dur: 6
    res_q: 4
    max_c: 4
    rc: 0
    rd: 0

  - id: 11
    name: "COMP_CHK"
    sig: "comp_chk"
    dur: 3
    res_q: 4
    max_c: 3
    rc: 1
    rd: 0

  - id: 12
    name: "ARCH_PROC"
    sig: "arch_proc"
    dur: 9
    res_q: 5
    max_c: 2
    rc: 2
    rd: 0

  - id: 13
    name: "SEC_VAL"
    sig: "sec_val"
    dur: 7
    res_q: 2
    max_c: 3
    rc: 0
    rd: 1

  - id: 14
    name: "PERF_MON"
    sig: "perf_mon"
    dur: 3
    res_q: 1
    max_c: 5
    rc: 3
    rd: 0

  - id: 15
    name: "BCK_CREA"
    sig: "bck_crea"
    dur: 5
    res_q: 1
    max_c: 2
    rc: 3
    rd: 0

  - id: 16
    name: "RPT_GEN"
    sig: "rpt_gen"
    dur: 4
    res_q: 5
    max_c: 4
    rc: 0
    rd: 7

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