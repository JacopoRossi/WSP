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
    name: "PAYMENT_VALIDATION"
    sig: "pay_val"
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4

  - id: 2
    name: "INVENTORY_CHECK"
    sig: "inv_chk"
    dur: 4
    res_q: 5
    rc: 3
    rd: 0
    max_c: 5

  - id: 3
    name: "SHIPPING_CALCULATION"
    sig: "ship_calc"
    dur: 10
    res_q: 3
    rc: 3
    rd: 0
    max_c: 3

  - id: 4
    name: "ORDER_CONFIRMATION"
    sig: "ord_conf"
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 2

  - id: 5
    name: "CUSTOMER_NOTIFICATION"
    sig: "cust_notif"
    dur: 9
    res_q: 3
    rc: 3
    rd: 0
    max_c: 3

  - id: 6
    name: "WAREHOUSE_ALLOCATION"
    sig: "wh_alloc"
    dur: 3
    res_q: 2
    rc: 0
    rd: 0
    max_c: 4

  - id: 7
    name: "QUALITY_CHECK"
    sig: "qc_chk"
    dur: 7
    res_q: 1
    rc: 0
    rd: 10
    max_c: 2

  - id: 8
    name: "FINAL_PROCESSING"
    sig: "final_proc"
    dur: 10
    res_q: 4
    rc: 2
    rd: 0
    max_c: 3

  - id: 9
    name: "TAX_CALCULATION"
    sig: "tax_calc"
    dur: 5
    res_q: 2
    rc: 3
    rd: 8
    max_c: 5

  - id: 10
    name: "DOCUMENT_GENERATION"
    sig: "doc_gen"
    dur: 9
    res_q: 5
    rc: 2
    rd: 0
    max_c: 2

  - id: 11
    name: "COMPLIANCE_CHECK"
    sig: "comp_chk"
    dur: 5
    res_q: 5
    rc: 2
    rd: 0
    max_c: 1

  - id: 12
    name: "ARCHIVE_PROCESSING"
    sig: "arch_proc"
    dur: 4
    res_q: 2
    rc: 0
    rd: 13
    max_c: 5

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