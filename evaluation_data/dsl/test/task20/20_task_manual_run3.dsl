wsp:
  name: "BizFlow20"
  h_start: 0
  h_end: 330
  r_max: 170

services:
  - id: 1
    name: Payment_Service
    tasks_set: [1, 9]

  - id: 2
    name: Inventory_Service
    tasks_set: [2, 6, 7]

  - id: 3
    name: Order_Service
    tasks_set: [4, 8, 10, 12, 20]

  - id: 4
    name: Shipping_Service
    tasks_set: [3]

  - id: 5
    name: Notification_Service
    tasks_set: [5]

  - id: 6
    name: Security_Service
    tasks_set: [11, 13, 17, 18]

  - id: 7
    name: Analytics_Service
    tasks_set: [14, 16]

  - id: 8
    name: Infrastructure_Service
    tasks_set: [15, 19]

tasks:
  - id: 1
    name: PAYMENT_VALIDATION
    sig: PAY_VAL
    service_id: 1
    dur: 5
    res_q: 4
    max_c: 4
    rc: 0
    rd: 0

  - id: 2
    name: INVENTORY_CHECK
    sig: INV_CHK
    service_id: 2
    dur: 4
    res_q: 5
    max_c: 5
    rc: 3
    rd: 0

  - id: 3
    name: SHIPPING_CALCULATION
    sig: SHIP_CALC
    service_id: 4
    dur: 10
    res_q: 3
    max_c: 3
    rc: 3
    rd: 0

  - id: 4
    name: ORDER_CONFIRMATION
    sig: ORD_CONF
    service_id: 3
    dur: 8
    res_q: 2
    max_c: 2
    rc: 0
    rd: 0

  - id: 5
    name: CUSTOMER_NOTIFICATION
    sig: CUST_NOTIF
    service_id: 5
    dur: 10
    res_q: 2
    max_c: 5
    rc: 0
    rd: 0

  - id: 6
    name: WAREHOUSE_ALLOCATION
    sig: WH_ALLOC
    service_id: 2
    dur: 8
    res_q: 1
    max_c: 2
    rc: 0
    rd: 9

  - id: 7
    name: QUALITY_CHECK
    sig: QC_CHK
    service_id: 2
    dur: 6
    res_q: 2
    max_c: 2
    rc: 0
    rd: 0

  - id: 8
    name: FINAL_PROCESSING
    sig: FINAL_PROC
    service_id: 3
    dur: 10
    res_q: 5
    max_c: 4
    rc: 0
    rd: 0

  - id: 9
    name: TAX_CALCULATION
    sig: TAX_CALC
    service_id: 1
    dur: 6
    res_q: 4
    max_c: 2
    rc: 2
    rd: 0

  - id: 10
    name: DOCUMENT_GENERATION
    sig: DOC_GEN
    service_id: 3
    dur: 5
    res_q: 1
    max_c: 2
    rc: 0
    rd: 0

  - id: 11
    name: COMPLIANCE_CHECK
    sig: COMP_CHK
    service_id: 6
    dur: 5
    res_q: 5
    max_c: 5
    rc: 2
    rd: 0

  - id: 12
    name: ARCHIVE_PROCESSING
    sig: ARCH_PROC
    service_id: 3
    dur: 6
    res_q: 1
    max_c: 4
    rc: 2
    rd: 0

  - id: 13
    name: SECURITY_VALIDATION
    sig: SEC_VAL
    service_id: 6
    dur: 8
    res_q: 4
    max_c: 4
    rc: 3
    rd: 16

  - id: 14
    name: PERFORMANCE_MONITOR
    sig: PERF_MON
    service_id: 7
    dur: 10
    res_q: 2
    max_c: 3
    rc: 2
    rd: 0

  - id: 15
    name: BACKUP_CREATION
    sig: BCK_CREA
    service_id: 8
    dur: 6
    res_q: 3
    max_c: 2
    rc: 3
    rd: 0

  - id: 16
    name: REPORT_GENERATION
    sig: RPT_GEN
    service_id: 7
    dur: 7
    res_q: 4
    max_c: 2
    rc: 0
    rd: 9

  - id: 17
    name: DATA_ENCRYPTION
    sig: DATA_ENCR
    service_id: 6
    dur: 7
    res_q: 3
    max_c: 2
    rc: 1
    rd: 2

  - id: 18
    name: AUDIT_TRAIL
    sig: AUD_TRL
    service_id: 6
    dur: 5
    res_q: 2
    max_c: 2
    rc: 2
    rd: 4

  - id: 19
    name: SYSTEM_CLEANUP
    sig: SYS_CLN
    service_id: 8
    dur: 4
    res_q: 4
    max_c: 5
    rc: 2
    rd: 0

  - id: 20
    name: FINAL_VALIDATION
    sig: FINAL_VAL
    service_id: 3
    dur: 10
    res_q: 4
    max_c: 4
    rc: 0
    rd: 0

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