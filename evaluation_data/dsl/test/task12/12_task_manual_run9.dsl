wsp:
  name: "12tasks"
  h_start: 0
  h_end: 210
  r_max: 130

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

  - from: 4
    to: 5
    delay: 11
    wait_all: false

  - from: 3
    to: 6
    delay: 16
    wait_all: true

  - from: 1
    to: 6
    delay: 15
    wait_all: false

  - from: 5
    to: 6
    delay: 15
    wait_all: false

  - from: 3
    to: 7
    delay: 11
    wait_all: true

  - from: 1
    to: 8
    delay: 16
    wait_all: false

  - from: 6
    to: 8
    delay: 13
    wait_all: true

  - from: 2
    to: 9
    delay: 9
    wait_all: true

  - from: 7
    to: 9
    delay: 7
    wait_all: false

  - from: 6
    to: 9
    delay: 7
    wait_all: true

  - from: 2
    to: 10
    delay: 9
    wait_all: true

  - from: 9
    to: 10
    delay: 5
    wait_all: true

  - from: 4
    to: 10
    delay: 14
    wait_all: true

  - from: 2
    to: 11
    delay: 13
    wait_all: true

  - from: 6
    to: 12
    delay: 9
    wait_all: false