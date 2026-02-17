wsp:
  name: "BizFlow20"
  sys_name: "BizFlow20"
  h_start: 0
  h_end: 330
  r_max: 170

# Service definitions
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

# Task definitions
tasks:
  - id: 1
    name: PAY_VAL
    sig: pay_val
    service_id: 1
    dur: 5
    res_q: 4
    max_c: 4
    rc: 0
    rd: 0

  - id: 2
    name: INV_CHK
    sig: inv_chk
    service_id: 2
    dur: 4
    res_q: 5
    max_c: 5
    rc: 3
    rd: 0

  - id: 3
    name: SHIP_CALC
    sig: ship_calc
    service_id: 4
    dur: 10
    res_q: 3
    max_c: 3
    rc: 3
    rd: 0

  - id: 4
    name: ORD_CONF
    sig: ord_conf
    service_id: 3
    dur: 8
    res_q: 2
    max_c: 2
    rc: 0
    rd: 0

  - id: 5
    name: CUST_NOTIF
    sig: cust_notif
    service_id: 5
    dur: 10
    res_q: 2
    max_c: 5
    rc: 0
    rd: 0

  - id: 6
    name: WH_ALLOC
    sig: wh_alloc
    service_id: 2
    dur: 8
    res_q: 1
    max_c: 2
    rc: 0
    rd: 9

  - id: 7
    name: QC_CHK
    sig: qc_chk
    service_id: 2
    dur: 6
    res_q: 2
    max_c: 2
    rc: 0
    rd: 0

  - id: 8
    name: FINAL_PROC
    sig: final_proc
    service_id: 3
    dur: 10
    res_q: 5
    max_c: 4
    rc: 0
    rd: 0

  - id: 9
    name: TAX_CALC
    sig: tax_calc
    service_id: 1
    dur: 6
    res_q: 4
    max_c: 2
    rc: 2
    rd: 0

  - id: 10
    name: DOC_GEN
    sig: doc_gen
    service_id: 3
    dur: 5
    res_q: 1
    max_c: 2
    rc: 0
    rd: 0

  - id: 11
    name: COMP_CHK
    sig: comp_chk
    service_id: 6
    dur: 5
    res_q: 5
    max_c: 5
    rc: 2
    rd: 0

  - id: 12
    name: ARCH_PROC
    sig: arch_proc
    service_id: 3
    dur: 6
    res_q: 1
    max_c: 4
    rc: 2
    rd: 0

  - id: 13
    name: SEC_VAL
    sig: sec_val
    service_id: 6
    dur: 8
    res_q: 4
    max_c: 4
    rc: 3
    rd: 16

  - id: 14
    name: PERF_MON
    sig: perf_mon
    service_id: 7
    dur: 10
    res_q: 2
    max_c: 3
    rc: 2
    rd: 0

  - id: 15
    name: BCK_CREA
    sig: bck_crea
    service_id: 8
    dur: 6
    res_q: 3
    max_c: 2
    rc: 3
    rd: 0

  - id: 16
    name: RPT_GEN
    sig: rpt_gen
    service_id: 7
    dur: 7
    res_q: 4
    max_c: 2
    rc: 0
    rd: 9

  - id: 17
    name: DATA_ENCR
    sig: data_encr
    service_id: 6
    dur: 7
    res_q: 3
    max_c: 2
    rc: 1
    rd: 2

  - id: 18
    name: AUD_TRL
    sig: aud_trl
    service_id: 6
    dur: 5
    res_q: 2
    max_c: 2
    rc: 2
    rd: 4

  - id: 19
    name: SYS_CLN
    sig: sys_cln
    service_id: 8
    dur: 4
    res_q: 4
    max_c: 5
    rc: 2
    rd: 0

  - id: 20
    name: FINAL_VAL
    sig: final_val
    service_id: 3
    dur: 10
    res_q: 4
    max_c: 4
    rc: 0
    rd: 0

# Start-to-start precedence constraints
start_constraints:
  # 5.2 Dependency Matrix (initial branching and convergence at Order_Confirmation)
  - from: 1   # PAY_VAL -> INV_CHK
    to: 2
    delay: 5
    wait_all: false

  - from: 2   # INV_CHK -> SHIP_CALC
    to: 3
    delay: 9
    wait_all: true

  - from: 1   # PAY_VAL -> ORD_CONF
    to: 4
    delay: 21
    wait_all: false

  - from: 2   # INV_CHK -> ORD_CONF
    to: 4
    delay: 16
    wait_all: true

  - from: 3   # SHIP_CALC -> ORD_CONF
    to: 4
    delay: 10
    wait_all: true

  # Customer_Notification, Warehouse_Allocation, Quality_Check, Final_Processing, Tax_Calculation, Document_Generation, Compliance_Check, Archive_Processing, Security_Validation
  - from: 1   # PAY_VAL -> CUST_NOTIF
    to: 5
    delay: 5
    wait_all: false

  - from: 3   # SHIP_CALC -> CUST_NOTIF
    to: 5
    delay: 9
    wait_all: false

  - from: 2   # INV_CHK -> CUST_NOTIF
    to: 5
    delay: 11
    wait_all: true

  - from: 4   # ORD_CONF -> CUST_NOTIF
    to: 5
    delay: 12
    wait_all: true

  - from: 4   # ORD_CONF -> WH_ALLOC
    to: 6
    delay: 11
    wait_all: false

  - from: 5   # CUST_NOTIF -> WH_ALLOC
    to: 6
    delay: 15
    wait_all: false

  - from: 1   # PAY_VAL -> WH_ALLOC
    to: 6
    delay: 16
    wait_all: true

  - from: 2   # INV_CHK -> QC_CHK
    to: 7
    delay: 14
    wait_all: true

  - from: 5   # CUST_NOTIF -> QC_CHK
    to: 7
    delay: 6
    wait_all: false

  - from: 1   # PAY_VAL -> QC_CHK
    to: 7
    delay: 7
    wait_all: false

  - from: 6   # WH_ALLOC -> QC_CHK
    to: 7
    delay: 7
    wait_all: true

  - from: 4   # ORD_CONF -> FINAL_PROC
    to: 8
    delay: 12
    wait_all: false

  - from: 3   # SHIP_CALC -> FINAL_PROC
    to: 8
    delay: 10
    wait_all: false

  - from: 2   # INV_CHK -> FINAL_PROC
    to: 8
    delay: 9
    wait_all: false

  - from: 2   # INV_CHK -> TAX_CALC
    to: 9
    delay: 16
    wait_all: true

  - from: 4   # ORD_CONF -> TAX_CALC
    to: 9
    delay: 10
    wait_all: true

  - from: 1   # PAY_VAL -> TAX_CALC
    to: 9
    delay: 15
    wait_all: true

  - from: 4   # ORD_CONF -> DOC_GEN
    to: 10
    delay: 8
    wait_all: true

  - from: 10  # DOC_GEN -> COMP_CHK
    to: 11
    delay: 6
    wait_all: true

  - from: 8   # FINAL_PROC -> COMP_CHK
    to: 11
    delay: 12
    wait_all: false

  - from: 5   # CUST_NOTIF -> ARCH_PROC
    to: 12
    delay: 9
    wait_all: true

  - from: 10  # DOC_GEN -> ARCH_PROC
    to: 12
    delay: 14
    wait_all: true

  - from: 11  # COMP_CHK -> ARCH_PROC
    to: 12
    delay: 9
    wait_all: false

  - from: 4   # ORD_CONF -> SEC_VAL
    to: 13
    delay: 6
    wait_all: false

  - from: 2   # INV_CHK -> SEC_VAL
    to: 13
    delay: 15
    wait_all: true

  - from: 10  # DOC_GEN -> SEC_VAL
    to: 13
    delay: 14
    wait_all: true

  - from: 12  # ARCH_PROC -> SEC_VAL
    to: 13
    delay: 10
    wait_all: false

  - from: 11  # COMP_CHK -> PERF_MON
    to: 14
    delay: 12
    wait_all: true

  - from: 6   # WH_ALLOC -> PERF_MON
    to: 14
    delay: 11
    wait_all: false

  # Analytics, Security, Infrastructure, Finalization chain
  - from: 9   # TAX_CALC -> PERF_MON
    to: 14
    delay: 15
    wait_all: false

  - from: 11  # COMP_CHK -> BCK_CREA
    to: 15
    delay: 13
    wait_all: false

  - from: 14  # PERF_MON -> BCK_CREA
    to: 15
    delay: 12
    wait_all: false

  - from: 11  # COMP_CHK -> RPT_GEN
    to: 16
    delay: 9
    wait_all: false

  - from: 14  # PERF_MON -> RPT_GEN
    to: 16
    delay: 8
    wait_all: false

  - from: 8   # FINAL_PROC -> RPT_GEN
    to: 16
    delay: 14
    wait_all: false

  - from: 14  # PERF_MON -> DATA_ENCR
    to: 17
    delay: 8
    wait_all: false

  - from: 10  # DOC_GEN -> DATA_ENCR
    to: 17
    delay: 9
    wait_all: false

  - from: 12  # ARCH_PROC -> DATA_ENCR
    to: 17
    delay: 9
    wait_all: false

  - from: 13  # SEC_VAL -> AUD_TRL
    to: 18
    delay: 6
    wait_all: true

  - from: 14  # PERF_MON -> SYS_CLN
    to: 19
    delay: 12
    wait_all: true

  - from: 16  # RPT_GEN -> SYS_CLN
    to: 19
    delay: 6
    wait_all: false

  - from: 18  # AUD_TRL -> SYS_CLN
    to: 19
    delay: 8
    wait_all: false

  - from: 17  # DATA_ENCR -> SYS_CLN
    to: 19
    delay: 16
    wait_all: true

  - from: 17  # DATA_ENCR -> FINAL_VAL
    to: 20
    delay: 13
    wait_all: false

  - from: 15  # BCK_CREA -> FINAL_VAL
    to: 20
    delay: 11
    wait_all: false

  - from: 16  # RPT_GEN -> FINAL_VAL
    to: 20
    delay: 10
    wait_all: false