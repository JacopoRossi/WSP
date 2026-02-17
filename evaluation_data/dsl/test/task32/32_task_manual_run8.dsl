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
    dur: 5
    res_q: 1
    max_c: 4
    rc: 2
    rd: 0

  - id: 6
    name: "WH_ALLOC"
    sig: "wh_alloc"
    dur: 4
    res_q: 3
    max_c: 5
    rc: 1
    rd: 2

  - id: 7
    name: "QC_CHK"
    sig: "qc_chk"
    dur: 7
    res_q: 3
    max_c: 3
    rc: 0
    rd: 5

  - id: 8
    name: "FINAL_PROC"
    sig: "final_proc"
    dur: 6
    res_q: 1
    max_c: 2
    rc: 0
    rd: 0

  - id: 9
    name: "TAX_CALC"
    sig: "tax_calc"
    dur: 10
    res_q: 1
    max_c: 4
    rc: 1
    rd: 11

  - id: 10
    name: "DOC_GEN"
    sig: "doc_gen"
    dur: 5
    res_q: 5
    max_c: 3
    rc: 0
    rd: 0

  - id: 11
    name: "COMP_CHK"
    sig: "comp_chk"
    dur: 9
    res_q: 4
    max_c: 4
    rc: 3
    rd: 0

  - id: 12
    name: "ARCH_PROC"
    sig: "arch_proc"
    dur: 4
    res_q: 2
    max_c: 4
    rc: 1
    rd: 2

  - id: 13
    name: "SEC_VAL"
    sig: "sec_val"
    dur: 10
    res_q: 5
    max_c: 5
    rc: 1
    rd: 0

  - id: 14
    name: "PERF_MON"
    sig: "perf_mon"
    dur: 5
    res_q: 2
    max_c: 1
    rc: 2
    rd: 1

  - id: 15
    name: "BCK_CREA"
    sig: "bck_crea"
    dur: 5
    res_q: 3
    max_c: 3
    rc: 0
    rd: 0

  - id: 16
    name: "RPT_GEN"
    sig: "rpt_gen"
    dur: 6
    res_q: 3
    max_c: 1
    rc: 3
    rd: 0

  - id: 17
    name: "DATA_ENCR"
    sig: "data_encr"
    dur: 7
    res_q: 2
    max_c: 2
    rc: 3
    rd: 0

  - id: 18
    name: "AUD_TRL"
    sig: "aud_trl"
    dur: 7
    res_q: 5
    max_c: 5
    rc: 3
    rd: 0

  - id: 19
    name: "SYS_CLN"
    sig: "sys_cln"
    dur: 5
    res_q: 5
    max_c: 2
    rc: 3
    rd: 0

  - id: 20
    name: "FINAL_VAL"
    sig: "final_val"
    dur: 8
    res_q: 5
    max_c: 1
    rc: 0
    rd: 0

  - id: 21
    name: "RISK_ASMT"
    sig: "risk_asmt"
    dur: 3
    res_q: 5
    max_c: 5
    rc: 1
    rd: 6

  - id: 22
    name: "FRD_DET"
    sig: "frd_det"
    dur: 9
    res_q: 5
    max_c: 5
    rc: 0
    rd: 0

  - id: 23
    name: "CUR_CONV"
    sig: "cur_conv"
    dur: 7
    res_q: 3
    max_c: 4
    rc: 2
    rd: 0

  - id: 24
    name: "PRC_OPT"
    sig: "prc_opt"
    dur: 7
    res_q: 4
    max_c: 2
    rc: 0
    rd: 1

  - id: 25
    name: "LOY_PROC"
    sig: "loy_proc"
    dur: 10
    res_q: 4
    max_c: 2
    rc: 2
    rd: 0

  - id: 26
    name: "RET_HDL"
    sig: "ret_hdl"
    dur: 8
    res_q: 5
    max_c: 3
    rc: 0
    rd: 0

  - id: 27
    name: "REF_PROC"
    sig: "ref_proc"
    dur: 8
    res_q: 4
    max_c: 5
    rc: 0
    rd: 0

  - id: 28
    name: "PRD_REC"
    sig: "prd_rec"
    dur: 4
    res_q: 3
    max_c: 1
    rc: 0
    rd: 0

  - id: 29
    name: "ANLY_UPD"
    sig: "anly_upd"
    dur: 7
    res_q: 4
    max_c: 1
    rc: 0
    rd: 0

  - id: 30
    name: "CACHE_REFR"
    sig: "cache_refr"
    dur: 3
    res_q: 3
    max_c: 2
    rc: 2
    rd: 13

  - id: 31
    name: "LOG_PROC"
    sig: "log_proc"
    dur: 5
    res_q: 3
    max_c: 2
    rc: 3
    rd: 10

  - id: 32
    name: "ERR_HDL"
    sig: "err_hdl"
    dur: 5
    res_q: 4
    max_c: 4
    rc: 3
    rd: 0

# Start-to-start precedence constraints
start_constraints:
  # PAY_VAL -> INV_CHK
  - from: 1
    to: 2
    delay: 5
    wait_all: false  # PAY_VAL -> INV_CHK

  # PAY_VAL -> ORD_CONF
  - from: 1
    to: 4
    delay: 21
    wait_all: false  # PAY_VAL -> ORD_CONF

  # PAY_VAL -> CUST_NOTIF
  - from: 1
    to: 5
    delay: 13
    wait_all: false  # PAY_VAL -> CUST_NOTIF

  # PAY_VAL -> QC_CHK
  - from: 1
    to: 7
    delay: 9
    wait_all: false  # PAY_VAL -> QC_CHK

  # INV_CHK -> SHIP_CALC
  - from: 2
    to: 3
    delay: 9
    wait_all: true  # INV_CHK -> SHIP_CALC

  # INV_CHK -> ORD_CONF
  - from: 2
    to: 4
    delay: 16
    wait_all: true  # INV_CHK -> ORD_CONF

  # INV_CHK -> WH_ALLOC
  - from: 2
    to: 6
    delay: 14
    wait_all: false  # INV_CHK -> WH_ALLOC

  # SHIP_CALC -> ORD_CONF
  - from: 3
    to: 4
    delay: 10
    wait_all: true  # SHIP_CALC -> ORD_CONF

  # SHIP_CALC -> DOC_GEN
  - from: 3
    to: 10
    delay: 13
    wait_all: false  # SHIP_CALC -> DOC_GEN

  # SHIP_CALC -> COMP_CHK
  - from: 3
    to: 11
    delay: 7
    wait_all: true  # SHIP_CALC -> COMP_CHK

  # SHIP_CALC -> SEC_VAL
  - from: 3
    to: 13
    delay: 14
    wait_all: false  # SHIP_CALC -> SEC_VAL

  # ORD_CONF -> CUST_NOTIF
  - from: 4
    to: 5
    delay: 6
    wait_all: false  # ORD_CONF -> CUST_NOTIF

  # ORD_CONF -> FINAL_PROC
  - from: 4
    to: 8
    delay: 7
    wait_all: false  # ORD_CONF -> FINAL_PROC

  # ORD_CONF -> TAX_CALC
  - from: 4
    to: 9
    delay: 14
    wait_all: true  # ORD_CONF -> TAX_CALC

  # ORD_CONF -> COMP_CHK
  - from: 4
    to: 11
    delay: 11
    wait_all: false  # ORD_CONF -> COMP_CHK

  # ORD_CONF -> ARCH_PROC
  - from: 4
    to: 12
    delay: 7
    wait_all: false  # ORD_CONF -> ARCH_PROC

  # CUST_NOTIF -> DOC_GEN
  - from: 5
    to: 10
    delay: 13
    wait_all: false  # CUST_NOTIF -> DOC_GEN

  # CUST_NOTIF -> PRC_OPT
  - from: 5
    to: 24
    delay: 5
    wait_all: false  # CUST_NOTIF -> PRC_OPT

  # WH_ALLOC -> FINAL_PROC
  - from: 6
    to: 8
    delay: 6
    wait_all: false  # WH_ALLOC -> FINAL_PROC

  # WH_ALLOC -> TAX_CALC
  - from: 6
    to: 9
    delay: 10
    wait_all: true  # WH_ALLOC -> TAX_CALC

  # WH_ALLOC -> SEC_VAL
  - from: 6
    to: 13
    delay: 11
    wait_all: false  # WH_ALLOC -> SEC_VAL

  # QC_CHK -> FINAL_PROC
  - from: 7
    to: 8
    delay: 9
    wait_all: true  # QC_CHK -> FINAL_PROC

  # QC_CHK -> TAX_CALC
  - from: 7
    to: 9
    delay: 11
    wait_all: true  # QC_CHK -> TAX_CALC

  # QC_CHK -> BCK_CREA
  - from: 7
    to: 15
    delay: 12
    wait_all: false  # QC_CHK -> BCK_CREA

  # FINAL_PROC -> PERF_MON
  - from: 8
    to: 14
    delay: 5
    wait_all: false  # FINAL_PROC -> PERF_MON

  # TAX_CALC -> PERF_MON
  - from: 9
    to: 14
    delay: 9
    wait_all: false  # TAX_CALC -> PERF_MON

  # TAX_CALC -> RPT_GEN
  - from: 9
    to: 16
    delay: 7
    wait_all: true  # TAX_CALC -> RPT_GEN

  # TAX_CALC -> RISK_ASMT
  - from: 9
    to: 21
    delay: 13
    wait_all: false  # TAX_CALC -> RISK_ASMT

  # TAX_CALC -> LOY_PROC
  - from: 9
    to: 25
    delay: 8
    wait_all: true  # TAX_CALC -> LOY_PROC

  # DOC_GEN -> COMP_CHK
  - from: 10
    to: 11
    delay: 10
    wait_all: false  # DOC_GEN -> COMP_CHK

  # DOC_GEN -> ARCH_PROC
  - from: 10
    to: 12
    delay: 7
    wait_all: true  # DOC_GEN -> ARCH_PROC

  # DOC_GEN -> PERF_MON
  - from: 10
    to: 14
    delay: 10
    wait_all: true  # DOC_GEN -> PERF_MON

  # DOC_GEN -> FRD_DET
  - from: 10
    to: 22
    delay: 9
    wait_all: true  # DOC_GEN -> FRD_DET

  # DOC_GEN -> PRC_OPT
  - from: 10
    to: 24
    delay: 16
    wait_all: true  # DOC_GEN -> PRC_OPT

  # COMP_CHK -> ARCH_PROC
  - from: 11
    to: 12
    delay: 12
    wait_all: false  # COMP_CHK -> ARCH_PROC

  # COMP_CHK -> BCK_CREA
  - from: 11
    to: 15
    delay: 15
    wait_all: true  # COMP_CHK -> BCK_CREA

  # COMP_CHK -> FINAL_VAL
  - from: 11
    to: 20
    delay: 10
    wait_all: false  # COMP_CHK -> FINAL_VAL

  # COMP_CHK -> CUR_CONV
  - from: 11
    to: 23
    delay: 13
    wait_all: false  # COMP_CHK -> CUR_CONV

  # ARCH_PROC -> RPT_GEN
  - from: 12
    to: 16
    delay: 5
    wait_all: true  # ARCH_PROC -> RPT_GEN

  # ARCH_PROC -> CUR_CONV
  - from: 12
    to: 23
    delay: 14
    wait_all: false  # ARCH_PROC -> CUR_CONV

  # SEC_VAL -> SYS_CLN
  - from: 13
    to: 19
    delay: 10
    wait_all: true  # SEC_VAL -> SYS_CLN

  # SHIP_CALC -> SEC_VAL (duplicate in source, kept once)
  - from: 3
    to: 13
    delay: 14
    wait_all: false  # SHIP_CALC -> SEC_VAL

  # PERF_MON -> DATA_ENCR
  - from: 14
    to: 17
    delay: 11
    wait_all: true  # PERF_MON -> DATA_ENCR

  # PERF_MON -> AUD_TRL
  - from: 14
    to: 18
    delay: 16
    wait_all: true  # PERF_MON -> AUD_TRL

  # PERF_MON -> SYS_CLN
  - from: 14
    to: 19
    delay: 15
    wait_all: false  # PERF_MON -> SYS_CLN

  # BCK_CREA -> RPT_GEN
  - from: 15
    to: 16
    delay: 15
    wait_all: false  # BCK_CREA -> RPT_GEN

  # BCK_CREA -> SYS_CLN
  - from: 15
    to: 19
    delay: 13
    wait_all: false  # BCK_CREA -> SYS_CLN

  # RPT_GEN -> AUD_TRL
  - from: 16
    to: 18
    delay: 14
    wait_all: false  # RPT_GEN -> AUD_TRL

  # RPT_GEN -> CUR_CONV
  - from: 16
    to: 23
    delay: 9
    wait_all: true  # RPT_GEN -> CUR_CONV

  # AUD_TRL -> FINAL_VAL
  - from: 18
    to: 20
    delay: 14
    wait_all: false  # AUD_TRL -> FINAL_VAL

  # AUD_TRL -> RET_HDL
  - from: 18
    to: 26
    delay: 15
    wait_all: true  # AUD_TRL -> RET_HDL

  # SYS_CLN -> RET_HDL
  - from: 19
    to: 26
    delay: 8
    wait_all: true  # SYS_CLN -> RET_HDL

  # FINAL_VAL -> REF_PROC
  - from: 20
    to: 27
    delay: 16
    wait_all: false  # FINAL_VAL -> REF_PROC

  # RISK_ASMT -> LOY_PROC
  - from: 21
    to: 25
    delay: 16
    wait_all: false  # RISK_ASMT -> LOY_PROC

  # RISK_ASMT -> REF_PROC
  - from: 21
    to: 27
    delay: 5
    wait_all: true  # RISK_ASMT -> REF_PROC

  # FRD_DET -> RET_HDL
  - from: 22
    to: 26
    delay: 14
    wait_all: true  # FRD_DET -> RET_HDL

  # FRD_DET -> REF_PROC
  - from: 22
    to: 27
    delay: 6
    wait_all: true  # FRD_DET -> REF_PROC

  # FRD_DET -> ANLY_UPD
  - from: 22
    to: 29
    delay: 14
    wait_all: true  # FRD_DET -> ANLY_UPD

  # CUR_CONV -> PRD_REC
  - from: 23
    to: 28
    delay: 9
    wait_all: false  # CUR_CONV -> PRD_REC

  # CUR_CONV -> LOG_PROC
  - from: 23
    to: 31
    delay: 14
    wait_all: true  # CUR_CONV -> LOG_PROC

  # PRC_OPT -> CACHE_REFR
  - from: 24
    to: 30
    delay: 5
    wait_all: false  # PRC_OPT -> CACHE_REFR

  # LOY_PROC -> ERR_HDL
  - from: 25
    to: 32
    delay: 9
    wait_all: true  # LOY_PROC -> ERR_HDL

  # RET_HDL -> ANLY_UPD
  - from: 26
    to: 29
    delay: 13
    wait_all: true  # RET_HDL -> ANLY_UPD

  # REF_PROC -> PRD_REC
  - from: 27
    to: 28
    delay: 15
    wait_all: true  # REF_PROC -> PRD_REC

  # REF_PROC -> LOG_PROC
  - from: 27
    to: 31
    delay: 5
    wait_all: false  # REF_PROC -> LOG_PROC

  # LOG_PROC -> ERR_HDL
  - from: 31
    to: 32
    delay: 13
    wait_all: false  # LOG_PROC -> ERR_HDL