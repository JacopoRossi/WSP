wsp:
  name: "32tasks"
  h_start: 0
  h_end: 426
  r_max: 206

# Service definitions
services:
  - id: 1
    name: "Payment_Service"
    tasks_set: [1, 9, 21, 22, 23, 24]

  - id: 2
    name: "Inventory_Service"
    tasks_set: [2, 6, 7, 26]

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
    tasks_set: [14, 16, 29]

  - id: 8
    name: "Infrastructure_Service"
    tasks_set: [15, 19, 30, 31, 32]

  - id: 9
    name: "Recommendation_Service"
    tasks_set: [25, 28]

  - id: 10
    name: "Refund_Service"
    tasks_set: [27]

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
    dur: 5
    res_q: 1
    rc: 2
    rd: 0
    max_c: 4

  - id: 6
    name: "WH_ALLOC"
    sig: "wh_alloc"
    dur: 4
    res_q: 3
    rc: 1
    rd: 2
    max_c: 5

  - id: 7
    name: "QC_CHK"
    sig: "qc_chk"
    dur: 7
    res_q: 3
    rc: 0
    rd: 5
    max_c: 3

  - id: 8
    name: "FINAL_PROC"
    sig: "final_proc"
    dur: 6
    res_q: 1
    rc: 0
    rd: 0
    max_c: 2

  - id: 9
    name: "TAX_CALC"
    sig: "tax_calc"
    dur: 10
    res_q: 1
    rc: 1
    rd: 11
    max_c: 4

  - id: 10
    name: "DOC_GEN"
    sig: "doc_gen"
    dur: 5
    res_q: 5
    rc: 0
    rd: 0
    max_c: 3

  - id: 11
    name: "COMP_CHK"
    sig: "comp_chk"
    dur: 9
    res_q: 4
    rc: 3
    rd: 0
    max_c: 4

  - id: 12
    name: "ARCH_PROC"
    sig: "arch_proc"
    dur: 4
    res_q: 2
    rc: 1
    rd: 2
    max_c: 4

  - id: 13
    name: "SEC_VAL"
    sig: "sec_val"
    dur: 10
    res_q: 5
    rc: 1
    rd: 0
    max_c: 5

  - id: 14
    name: "PERF_MON"
    sig: "perf_mon"
    dur: 5
    res_q: 2
    rc: 2
    rd: 1
    max_c: 1

  - id: 15
    name: "BCK_CREA"
    sig: "bck_crea"
    dur: 5
    res_q: 3
    rc: 0
    rd: 0
    max_c: 3

  - id: 16
    name: "RPT_GEN"
    sig: "rpt_gen"
    dur: 6
    res_q: 3
    rc: 3
    rd: 0
    max_c: 1

  - id: 17
    name: "DATA_ENCR"
    sig: "data_encr"
    dur: 7
    res_q: 2
    rc: 3
    rd: 0
    max_c: 2

  - id: 18
    name: "AUD_TRL"
    sig: "aud_trl"
    dur: 7
    res_q: 5
    rc: 3
    rd: 0
    max_c: 5

  - id: 19
    name: "SYS_CLN"
    sig: "sys_cln"
    dur: 5
    res_q: 5
    rc: 3
    rd: 0
    max_c: 2

  - id: 20
    name: "FINAL_VAL"
    sig: "final_val"
    dur: 8
    res_q: 5
    rc: 0
    rd: 0
    max_c: 1

  - id: 21
    name: "RISK_ASMT"
    sig: "risk_asmt"
    dur: 3
    res_q: 5
    rc: 1
    rd: 6
    max_c: 5

  - id: 22
    name: "FRD_DET"
    sig: "frd_det"
    dur: 9
    res_q: 5
    rc: 0
    rd: 0
    max_c: 5

  - id: 23
    name: "CUR_CONV"
    sig: "cur_conv"
    dur: 7
    res_q: 3
    rc: 2
    rd: 0
    max_c: 4

  - id: 24
    name: "PRC_OPT"
    sig: "prc_opt"
    dur: 7
    res_q: 4
    rc: 0
    rd: 1
    max_c: 2

  - id: 25
    name: "LOY_PROC"
    sig: "loy_proc"
    dur: 10
    res_q: 4
    rc: 2
    rd: 0
    max_c: 2

  - id: 26
    name: "RET_HDL"
    sig: "ret_hdl"
    dur: 8
    res_q: 5
    rc: 0
    rd: 0
    max_c: 3

  - id: 27
    name: "REF_PROC"
    sig: "ref_proc"
    dur: 8
    res_q: 4
    rc: 0
    rd: 0
    max_c: 5

  - id: 28
    name: "PRD_REC"
    sig: "prd_rec"
    dur: 4
    res_q: 3
    rc: 0
    rd: 0
    max_c: 1

  - id: 29
    name: "ANLY_UPD"
    sig: "anly_upd"
    dur: 7
    res_q: 4
    rc: 0
    rd: 0
    max_c: 1

  - id: 30
    name: "CACHE_REFR"
    sig: "cache_refr"
    dur: 3
    res_q: 3
    rc: 2
    rd: 13
    max_c: 2

  - id: 31
    name: "LOG_PROC"
    sig: "log_proc"
    dur: 5
    res_q: 3
    rc: 3
    rd: 10
    max_c: 2

  - id: 32
    name: "ERR_HDL"
    sig: "err_hdl"
    dur: 5
    res_q: 4
    rc: 3
    rd: 0
    max_c: 4

# Start-to-start precedence constraints
start_constraints:
  # Group 1 (Payment / Inventory / Shipping / Order / Notification)
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

  - from: 4   # ORD_CONF -> CUST_NOTIF
    to: 5
    delay: 6
    wait_all: false

  - from: 1   # PAY_VAL -> CUST_NOTIF
    to: 5
    delay: 13
    wait_all: false

  # Group 2 (Inventory → Warehouse / Quality / Final_Processing / Tax / Doc / Compliance / Archive / Security)
  - from: 2   # INV_CHK -> WH_ALLOC
    to: 6
    delay: 14
    wait_all: false

  - from: 1   # PAY_VAL -> QC_CHK
    to: 7
    delay: 9
    wait_all: false

  - from: 7   # QC_CHK -> FINAL_PROC
    to: 8
    delay: 9
    wait_all: true

  - from: 6   # WH_ALLOC -> FINAL_PROC
    to: 8
    delay: 6
    wait_all: false

  - from: 4   # ORD_CONF -> FINAL_PROC
    to: 8
    delay: 7
    wait_all: false

  - from: 6   # WH_ALLOC -> TAX_CALC
    to: 9
    delay: 10
    wait_all: true

  - from: 7   # QC_CHK -> TAX_CALC
    to: 9
    delay: 11
    wait_all: true

  - from: 4   # ORD_CONF -> TAX_CALC
    to: 9
    delay: 14
    wait_all: true

  - from: 3   # SHIP_CALC -> DOC_GEN
    to: 10
    delay: 13
    wait_all: false

  - from: 5   # CUST_NOTIF -> DOC_GEN
    to: 10
    delay: 13
    wait_all: false

  - from: 4   # ORD_CONF -> COMP_CHK
    to: 11
    delay: 11
    wait_all: false

  - from: 10  # DOC_GEN -> COMP_CHK
    to: 11
    delay: 10
    wait_all: false

  - from: 3   # SHIP_CALC -> COMP_CHK
    to: 11
    delay: 7
    wait_all: true

  - from: 4   # ORD_CONF -> ARCH_PROC
    to: 12
    delay: 7
    wait_all: false

  - from: 11  # COMP_CHK -> ARCH_PROC
    to: 12
    delay: 12
    wait_all: false

  - from: 10  # DOC_GEN -> ARCH_PROC
    to: 12
    delay: 7
    wait_all: true

  - from: 6   # WH_ALLOC -> SEC_VAL
    to: 13
    delay: 11
    wait_all: false

  # Group 3 (Shipping → Security_Validation; Tax / Final_Processing / Doc → Perf_Mon; Backup / Report / Audit / System_Cleanup / Final_Validation / Risk_Assessment)
  - from: 3   # SHIP_CALC -> SEC_VAL
    to: 13
    delay: 14
    wait_all: false

  - from: 9   # TAX_CALC -> PERF_MON
    to: 14
    delay: 9
    wait_all: false

  - from: 8   # FINAL_PROC -> PERF_MON
    to: 14
    delay: 5
    wait_all: false

  - from: 10  # DOC_GEN -> PERF_MON
    to: 14
    delay: 10
    wait_all: true

  - from: 7   # QC_CHK -> BCK_CREA
    to: 15
    delay: 12
    wait_all: false

  - from: 11  # COMP_CHK -> BCK_CREA
    to: 15
    delay: 15
    wait_all: true

  - from: 15  # BCK_CREA -> RPT_GEN
    to: 16
    delay: 15
    wait_all: false

  - from: 9   # TAX_CALC -> RPT_GEN
    to: 16
    delay: 7
    wait_all: true

  - from: 12  # ARCH_PROC -> RPT_GEN
    to: 16
    delay: 5
    wait_all: true

  - from: 14  # PERF_MON -> DATA_ENCR
    to: 17
    delay: 11
    wait_all: true

  - from: 16  # RPT_GEN -> AUD_TRL
    to: 18
    delay: 14
    wait_all: false

  - from: 14  # PERF_MON -> AUD_TRL
    to: 18
    delay: 16
    wait_all: true

  - from: 14  # PERF_MON -> SYS_CLN
    to: 19
    delay: 15
    wait_all: false

  - from: 15  # BCK_CREA -> SYS_CLN
    to: 19
    delay: 13
    wait_all: false

  - from: 13  # SEC_VAL -> SYS_CLN
    to: 19
    delay: 10
    wait_all: true

  - from: 11  # COMP_CHK -> FINAL_VAL
    to: 20
    delay: 10
    wait_all: false

  - from: 18  # AUD_TRL -> FINAL_VAL
    to: 20
    delay: 14
    wait_all: false

  - from: 9   # TAX_CALC -> RISK_ASMT
    to: 21
    delay: 13
    wait_all: false

  # Group 4 (Doc → Fraud; Compliance / Report / Archive → Currency; Notification / Doc → Price_Opt; Risk / Tax → Loyalty; Fraud / System_Cleanup / Audit → Return; Final_Validation / Fraud / Risk → Refund; Refund / Currency → Product_Rec; Fraud / Return → Analytics_Update; Price_Opt → Cache_Refresh)
  - from: 10  # DOC_GEN -> FRD_DET
    to: 22
    delay: 9
    wait_all: true

  - from: 11  # COMP_CHK -> CUR_CONV
    to: 23
    delay: 13
    wait_all: false

  - from: 16  # RPT_GEN -> CUR_CONV
    to: 23
    delay: 9
    wait_all: true

  - from: 12  # ARCH_PROC -> CUR_CONV
    to: 23
    delay: 14
    wait_all: false

  - from: 5   # CUST_NOTIF -> PRC_OPT
    to: 24
    delay: 5
    wait_all: false

  - from: 10  # DOC_GEN -> PRC_OPT
    to: 24
    delay: 16
    wait_all: true

  - from: 21  # RISK_ASMT -> LOY_PROC
    to: 25
    delay: 16
    wait_all: false

  - from: 9   # TAX_CALC -> LOY_PROC
    to: 25
    delay: 8
    wait_all: true

  - from: 22  # FRD_DET -> RET_HDL
    to: 26
    delay: 14
    wait_all: true

  - from: 19  # SYS_CLN -> RET_HDL
    to: 26
    delay: 8
    wait_all: true

  - from: 18  # AUD_TRL -> RET_HDL
    to: 26
    delay: 15
    wait_all: true

  - from: 20  # FINAL_VAL -> REF_PROC
    to: 27
    delay: 16
    wait_all: false

  - from: 22  # FRD_DET -> REF_PROC
    to: 27
    delay: 6
    wait_all: true

  - from: 21  # RISK_ASMT -> REF_PROC
    to: 27
    delay: 5
    wait_all: true

  - from: 27  # REF_PROC -> PRD_REC
    to: 28
    delay: 15
    wait_all: true

  - from: 23  # CUR_CONV -> PRD_REC
    to: 28
    delay: 9
    wait_all: false

  - from: 22  # FRD_DET -> ANLY_UPD
    to: 29
    delay: 14
    wait_all: true

  - from: 26  # RET_HDL -> ANLY_UPD
    to: 29
    delay: 13
    wait_all: true

  - from: 24  # PRC_OPT -> CACHE_REFR
    to: 30
    delay: 5
    wait_all: false

  # Group 5 (Refund / Currency → Log_Processing; Log_Processing / Loyalty → Error_Handling)
  - from: 27  # REF_PROC -> LOG_PROC
    to: 31
    delay: 5
    wait_all: false

  - from: 23  # CUR_CONV -> LOG_PROC
    to: 31
    delay: 14
    wait_all: true

  - from: 31  # LOG_PROC -> ERR_HDL
    to: 32
    delay: 13
    wait_all: false

  - from: 25  # LOY_PROC -> ERR_HDL
    to: 32
    delay: 9
    wait_all: true