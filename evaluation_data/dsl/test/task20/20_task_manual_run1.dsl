wsp:
  name: "BizFlow20"
  h_start: 0
  h_end: 330
  r_max: 170

services:
  - id: 1
    name: "Payment_Service"
    tasks_set: [1, 9]

  - id: 2
    name: "Inventory_Service"
    tasks_set: [2, 6, 7]

  - id: 3
    name: "Order_Service"
    tasks_set: [4, 8, 10, 12, 20]

  - id: 4
    name: "Shipping_Service"
    tasks_set: [3]

  - id: 5
    name: "Notification_Service"
    tasks_set: [5]

  - id: 6
    name: "Security_Service"
    tasks_set: [11, 13, 17, 18]

  - id: 7
    name: "Analytics_Service"
    tasks_set: [14, 16]

  - id: 8
    name: "Infrastructure_Service"
    tasks_set: [15, 19]

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
    dur: 10
    res_q: 2
    rc: 0
    rd: 0
    max_c: 5

  - id: 6
    name: "WH_ALLOC"
    sig: "wh_alloc"
    dur: 8
    res_q: 1
    rc: 0
    rd: 9
    max_c: 2

  - id: 7
    name: "QC_CHK"
    sig: "qc_chk"
    dur: 6
    res_q: 2
    rc: 0
    rd: 0
    max_c: 2

  - id: 8
    name: "FINAL_PROC"
    sig: "final_proc"
    dur: 10
    res_q: 5
    rc: 0
    rd: 0
    max_c: 4

  - id: 9
    name: "TAX_CALC"
    sig: "tax_calc"
    dur: 6
    res_q: 4
    rc: 2
    rd: 0
    max_c: 2

  - id: 10
    name: "DOC_GEN"
    sig: "doc_gen"
    dur: 5
    res_q: 1
    rc: 0
    rd: 0
    max_c: 2

  - id: 11
    name: "COMP_CHK"
    sig: "comp_chk"
    dur: 5
    res_q: 5
    rc: 2
    rd: 0
    max_c: 5

  - id: 12
    name: "ARCH_PROC"
    sig: "arch_proc"
    dur: 6
    res_q: 1
    rc: 2
    rd: 0
    max_c: 4

  - id: 13
    name: "SEC_VAL"
    sig: "sec_val"
    dur: 8
    res_q: 4
    rc: 3
    rd: 16
    max_c: 4

  - id: 14
    name: "PERF_MON"
    sig: "perf_mon"
    dur: 10
    res_q: 2
    rc: 2
    rd: 0
    max_c: 3

  - id: 15
    name: "BCK_CREA"
    sig: "bck_crea"
    dur: 6
    res_q: 3
    rc: 3
    rd: 0
    max_c: 2

  - id: 16
    name: "RPT_GEN"
    sig: "rpt_gen"
    dur: 7
    res_q: 4
    rc: 0
    rd: 9
    max_c: 2

  - id: 17
    name: "DATA_ENCR"
    sig: "data_encr"
    dur: 7
    res_q: 3
    rc: 1
    rd: 2
    max_c: 2

  - id: 18
    name: "AUD_TRL"
    sig: "aud_trl"
    dur: 5
    res_q: 2
    rc: 2
    rd: 4
    max_c: 2

  - id: 19
    name: "SYS_CLN"
    sig: "sys_cln"
    dur: 4
    res_q: 4
    rc: 2
    rd: 0
    max_c: 5

  - id: 20
    name: "FINAL_VAL"
    sig: "final_val"
    dur: 10
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4

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

  - from: 1
    to: 5
    delay: 5
    wait_all: false

  - from: 3
    to: 5
    delay: 9
    wait_all: false

  - from: 2
    to: 5
    delay: 11
    wait_all: true

  - from: 4
    to: 5
    delay: 12
    wait_all: true

  - from: 4
    to: 6
    delay: 11
    wait_all: false

  - from: 5
    to: 6
    delay: 15
    wait_all: false

  - from: 1
    to: 6
    delay: 16
    wait_all: true

  - from: 2
    to: 7
    delay: 14
    wait_all: true

  - from: 5
    to: 7
    delay: 6
    wait_all: false

  - from: 1
    to: 7
    delay: 7
    wait_all: false

  - from: 6
    to: 7
    delay: 7
    wait_all: true

  - from: 4
    to: 8
    delay: 12
    wait_all: false

  - from: 3
    to: 8
    delay: 10
    wait_all: false

  - from: 2
    to: 8
    delay: 9
    wait_all: false

  - from: 2
    to: 9
    delay: 16
    wait_all: true

  - from: 4
    to: 9
    delay: 10
    wait_all: true

  - from: 1
    to: 9
    delay: 15
    wait_all: true

  - from: 4
    to: 10
    delay: 8
    wait_all: true

  - from: 10
    to: 11
    delay: 6
    wait_all: true

  - from: 8
    to: 11
    delay: 12
    wait_all: false

  - from: 5
    to: 12
    delay: 9
    wait_all: true

  - from: 10
    to: 12
    delay: 14
    wait_all: true

  - from: 11
    to: 12
    delay: 9
    wait_all: false

  - from: 4
    to: 13
    delay: 6
    wait_all: false

  - from: 2
    to: 13
    delay: 15
    wait_all: true

  - from: 10
    to: 13
    delay: 14
    wait_all: true

  - from: 12
    to: 13
    delay: 10
    wait_all: false

  - from: 11
    to: 14
    delay: 12
    wait_all: true

  - from: 6
    to: 14
    delay: 11
    wait_all: false

  - from: 9
    to: 14
    delay: 15
    wait_all: false

  - from: 11
    to: 15
    delay: 13
    wait_all: false

  - from: 14
    to: 15
    delay: 12
    wait_all: false

  - from: 11
    to: 16
    delay: 9
    wait_all: false

  - from: 14
    to: 16
    delay: 8
    wait_all: false

  - from: 8
    to: 16
    delay: 14
    wait_all: false

  - from: 14
    to: 17
    delay: 8
    wait_all: false

  - from: 10
    to: 17
    delay: 9
    wait_all: false

  - from: 12
    to: 17
    delay: 9
    wait_all: false

  - from: 13
    to: 18
    delay: 6
    wait_all: true

  - from: 14
    to: 19
    delay: 12
    wait_all: true

  - from: 16
    to: 19
    delay: 6
    wait_all: false

  - from: 18
    to: 19
    delay: 8
    wait_all: false

  - from: 17
    to: 19
    delay: 16
    wait_all: true

  - from: 17
    to: 20
    delay: 13
    wait_all: false

  - from: 15
    to: 20
    delay: 11
    wait_all: false

  - from: 16
    to: 20
    delay: 10
    wait_all: false