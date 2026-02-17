wsp:
  name: "8tasks"
  h_start: 0
  h_end: 150
  r_max: 110
  n_constraints: 14

services:
  - id: 1
    name: "Payment_Service"
    tasks_set: [1]

  - id: 2
    name: "Inventory_Service"
    tasks_set: [2, 6, 7]

  - id: 3
    name: "Order_Service"
    tasks_set: [4, 8]

  - id: 4
    name: "Shipping_Service"
    tasks_set: [3]

  - id: 5
    name: "Notification_Service"
    tasks_set: [5]

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
    dur: 4
    res_q: 1
    rc: 1
    rd: 0
    max_c: 2

  - id: 6
    name: "WAREHOUSE_ALLOCATION"
    sig: "wh_alloc"
    dur: 5
    res_q: 1
    rc: 3
    rd: 0
    max_c: 5

  - id: 7
    name: "QUALITY_CHECK"
    sig: "qc_chk"
    dur: 9
    res_q: 1
    rc: 0
    rd: 0
    max_c: 2

  - id: 8
    name: "FINAL_PROCESSING"
    sig: "final_proc"
    dur: 6
    res_q: 5
    rc: 3
    rd: 0
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
    delay: 8
    wait_all: false

  - from: 3
    to: 6
    delay: 16
    wait_all: false

  - from: 1
    to: 6
    delay: 10
    wait_all: false

  - from: 4
    to: 6
    delay: 7
    wait_all: true

  - from: 1
    to: 7
    delay: 11
    wait_all: true

  - from: 6
    to: 7
    delay: 10
    wait_all: false

  - from: 3
    to: 8
    delay: 13
    wait_all: true

  - from: 1
    to: 8
    delay: 11
    wait_all: true

  - from: 4
    to: 8
    delay: 13
    wait_all: false