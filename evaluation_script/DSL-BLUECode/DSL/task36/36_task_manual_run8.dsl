wsp:
  name: "36tasks"
  h_start: 0
  h_end: 458
  r_max: 218

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
    tasks_set: [11, 13, 17, 18, 35, 36]

  - id: 7
    name: "Analytics_Service"
    tasks_set: [14, 16, 29]

  - id: 8
    name: "Infrastructure_Service"
    tasks_set: [15, 19, 30, 31, 32, 33, 34]

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
    dur: 10
    res_q: 1
    rc: 3
    rd: 0
    max_c: 4

  - id: 6
    name: "WH_ALLOC"
    sig: "wh_alloc"
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 2

  - id: 7
    name: "QC_CHK"
    sig: "qc_chk"
    dur: 8
    res_q: 1
    rc: 2
    rd: 0
    max_c: 1

  - id: 8
    name: "FINAL_PROC"
    sig: "final_proc"
    dur: 6
    res_q: 1
    rc: 1
    rd: 0
    max_c: 5

  - id: 9
    name: "TAX_CALC"
    sig: "tax_calc"
    dur: 3
    res_q: 1
    rc: 0
    rd: 6
    max_c: 4

  - id: 10
    name: "DOC_GEN"
    sig: "doc_gen"
    dur: 6
    res_q: 3
    rc: 1
    rd: 0
    max_c: 2

  - id: 11
    name: "COMP_CHK"
    sig: "comp_chk"
    dur: 6
    res_q: 1
    rc: 2
    rd: 0
    max_c: 5

  - id: 12
    name: "ARCH_PROC"
    sig: "arch_proc"
    dur: 6
    res_q: 4
    rc: 0
    rd: 10
    max_c: 3

  - id: 13
    name: "SEC_VAL"
    sig: "sec_val"
    dur: 9
    res_q: 4
    rc: 3
    rd: 11
    max_c: 3

  - id: 14
    name: "PERF_MON"
    sig: "perf_mon"
    dur: 7
    res_q: 3
    rc: 3
    rd: 0
    max_c: 4

  - id: 15
    name: "BCK_CREA"
    sig: "bck_crea"
    dur: 4
    res_q: 4
    rc: 1
    rd: 0
    max_c: 3

  - id: 16
    name: "RPT_GEN"
    sig: "rpt_gen"
    dur: 8
    res_q: 4
    rc: 0
    rd: 7
    max_c: 2

  - id: 17
    name: "DATA_ENCR"
    sig: "data_encr"
    dur: 3
    res_q: 3
    rc: 3
    rd: 13
    max_c: 3

  - id: 18
    name: "AUD_TRL"
    sig: "aud_trl"
    dur: 5
    res_q: 2
    rc: 1
    rd: 0
    max_c: 4

  - id: 19
    name: "SYS_CLN"
    sig: "sys_cln"
    dur: 6
    res_q: 4
    rc: 3
    rd: 10
    max_c: 3

  - id: 20
    name: "FINAL_VAL"
    sig: "final_val"
    dur: 10
    res_q: 4
    rc: 2
    rd: 0
    max_c: 3

  - id: 21
    name: "RISK_ASMT"
    sig: "risk_asmt"
    dur: 5
    res_q: 2
    rc: 3
    rd: 0
    max_c: 2

  - id: 22
    name: "FRD_DET"
    sig: "frd_det"
    dur: 3
    res_q: 5
    rc: 0
    rd: 0
    max_c: 1

  - id: 23
    name: "CUR_CONV"
    sig: "cur_conv"
    dur: 3
    res_q: 4
    rc: 0
    rd: 7
    max_c: 1

  - id: 24
    name: "PRC_OPT"
    sig: "prc_opt"
    dur: 5
    res_q: 1
    rc: 0
    rd: 14
    max_c: 3

  - id: 25
    name: "LOY_PROC"
    sig: "loy_proc"
    dur: 3
    res_q: 5
    rc: 3
    rd: 0
    max_c: 4

  - id: 26
    name: "RET_HDL"
    sig: "ret_hdl"
    dur: 3
    res_q: 1
    rc: 3
    rd: 13
    max_c: 1

  - id: 27
    name: "REF_PROC"
    sig: "ref_proc"
    dur: 3
    res_q: 5
    rc: 1
    rd: 9
    max_c: 1

  - id: 28
    name: "PRD_REC"
    sig: "prd_rec"
    dur: 9
    res_q: 2
    rc: 0
    rd: 0
    max_c: 5

  - id: 29
    name: "ANLY_UPD"
    sig: "anly_upd"
    dur: 5
    res_q: 2
    rc: 0
    rd: 16
    max_c: 3

  - id: 30
    name: "CACHE_REFR"
    sig: "cache_refr"
    dur: 8
    res_q: 3
    rc: 2
    rd: 0
    max_c: 3

  - id: 31
    name: "LOG_PROC"
    sig: "log_proc"
    dur: 9
    res_q: 4
    rc: 3
    rd: 0
    max_c: 2

  - id: 32
    name: "ERR_HDL"
    sig: "err_hdl"
    dur: 7
    res_q: 1
    rc: 0
    rd: 0
    max_c: 4

  - id: 33
    name: "LOAD_BAL"
    sig: "load_bal"
    dur: 9
    res_q: 4
    rc: 3
    rd: 0
    max_c: 1

  - id: 34
    name: "DB_SYNC"
    sig: "db_sync"
    dur: 3
    res_q: 2
    rc: 0
    rd: 0
    max_c: 4

  - id: 35
    name: "API_VAL"
    sig: "api_val"
    dur: 8
    res_q: 5
    rc: 0
    rd: 1
    max_c: 2

  - id: 36
    name: "SESS_MGT"
    sig: "sess_mgt"
    dur: 6
    res_q: 5
    rc: 2
    rd: 0
    max_c: 1

# Start-to-start precedence constraints
start_constraints:
  # PAY_VAL -> INV_CHK
  - from: 1  # PAY_VAL
    to: 2    # INV_CHK
    delay: 5
    wait_all: false

  # INV_CHK -> SHIP_CALC
  - from: 2  # INV_CHK
    to: 3    # SHIP_CALC
    delay: 9
    wait_all: true

  # PAY_VAL -> ORD_CONF
  - from: 1  # PAY_VAL
    to: 4    # ORD_CONF
    delay: 21
    wait_all: false

  # INV_CHK -> ORD_CONF
  - from: 2  # INV_CHK
    to: 4    # ORD_CONF
    delay: 16
    wait_all: true

  # SHIP_CALC -> ORD_CONF
  - from: 3  # SHIP_CALC
    to: 4    # ORD_CONF
    delay: 10
    wait_all: true

  # SHIP_CALC -> CUST_NOTIF
  - from: 3  # SHIP_CALC
    to: 5    # CUST_NOTIF
    delay: 13
    wait_all: true

  # SHIP_CALC -> WH_ALLOC
  - from: 3  # SHIP_CALC
    to: 6    # WH_ALLOC
    delay: 5
    wait_all: true

  # INV_CHK -> QC_CHK
  - from: 2  # INV_CHK
    to: 7    # QC_CHK
    delay: 9
    wait_all: true

  # ORD_CONF -> QC_CHK
  - from: 4  # ORD_CONF
    to: 7    # QC_CHK
    delay: 14
    wait_all: true

  # PAY_VAL -> QC_CHK
  - from: 1  # PAY_VAL
    to: 7    # QC_CHK
    delay: 14
    wait_all: false

  # CUST_NOTIF -> FINAL_PROC
  - from: 5  # CUST_NOTIF
    to: 8    # FINAL_PROC
    delay: 16
    wait_all: true

  # SHIP_CALC -> FINAL_PROC
  - from: 3  # SHIP_CALC
    to: 8    # FINAL_PROC
    delay: 16
    wait_all: true

  # ORD_CONF -> FINAL_PROC
  - from: 4  # ORD_CONF
    to: 8    # FINAL_PROC
    delay: 13
    wait_all: false

  # INV_CHK -> TAX_CALC
  - from: 2  # INV_CHK
    to: 9    # TAX_CALC
    delay: 11
    wait_all: true

  # FINAL_PROC -> DOC_GEN
  - from: 8  # FINAL_PROC
    to: 10   # DOC_GEN
    delay: 10
    wait_all: true

  # DOC_GEN -> COMP_CHK
  - from: 10 # DOC_GEN
    to: 11   # COMP_CHK
    delay: 10
    wait_all: false

  # WH_ALLOC -> COMP_CHK
  - from: 6  # WH_ALLOC
    to: 11   # COMP_CHK
    delay: 11
    wait_all: true

  # ORD_CONF -> COMP_CHK
  - from: 4  # ORD_CONF
    to: 11   # COMP_CHK
    delay: 15
    wait_all: false

  # CUST_NOTIF -> ARCH_PROC
  - from: 5  # CUST_NOTIF
    to: 12   # ARCH_PROC
    delay: 8
    wait_all: true

  # COMP_CHK -> SEC_VAL
  - from: 11 # COMP_CHK
    to: 13   # SEC_VAL
    delay: 16
    wait_all: true

  # COMP_CHK -> PERF_MON
  - from: 11 # COMP_CHK
    to: 14   # PERF_MON
    delay: 5
    wait_all: false

  # WH_ALLOC -> PERF_MON
  - from: 6  # WH_ALLOC
    to: 14   # PERF_MON
    delay: 12
    wait_all: false

  # ARCH_PROC -> PERF_MON
  - from: 12 # ARCH_PROC
    to: 14   # PERF_MON
    delay: 9
    wait_all: true

  # SEC_VAL -> BCK_CREA
  - from: 13 # SEC_VAL
    to: 15   # BCK_CREA
    delay: 12
    wait_all: false

  # SEC_VAL -> RPT_GEN
  - from: 13 # SEC_VAL
    to: 16   # RPT_GEN
    delay: 13
    wait_all: true

  # PERF_MON -> DATA_ENCR
  - from: 14 # PERF_MON
    to: 17   # DATA_ENCR
    delay: 5
    wait_all: false

  # BCK_CREA -> DATA_ENCR
  - from: 15 # BCK_CREA
    to: 17   # DATA_ENCR
    delay: 11
    wait_all: false

  # ARCH_PROC -> DATA_ENCR
  - from: 12 # ARCH_PROC
    to: 17   # DATA_ENCR
    delay: 6
    wait_all: true

  # RPT_GEN -> AUD_TRL
  - from: 16 # RPT_GEN
    to: 18   # AUD_TRL
    delay: 9
    wait_all: false

  # COMP_CHK -> AUD_TRL
  - from: 11 # COMP_CHK
    to: 18   # AUD_TRL
    delay: 9
    wait_all: false

  # DATA_ENCR -> AUD_TRL
  - from: 17 # DATA_ENCR
    to: 18   # AUD_TRL
    delay: 7
    wait_all: true

  # DATA_ENCR -> SYS_CLN
  - from: 17 # DATA_ENCR
    to: 19   # SYS_CLN
    delay: 9
    wait_all: false

  # BCK_CREA -> FINAL_VAL
  - from: 15 # BCK_CREA
    to: 20   # FINAL_VAL
    delay: 16
    wait_all: false

  # FINAL_VAL -> RISK_ASMT
  - from: 20 # FINAL_VAL
    to: 21   # RISK_ASMT
    delay: 9
    wait_all: true

  # SEC_VAL -> RISK_ASMT
  - from: 13 # SEC_VAL
    to: 21   # RISK_ASMT
    delay: 11
    wait_all: false

  # PERF_MON -> RISK_ASMT
  - from: 14 # PERF_MON
    to: 21   # RISK_ASMT
    delay: 14
    wait_all: false

  # FINAL_VAL -> FRD_DET
  - from: 20 # FINAL_VAL
    to: 22   # FRD_DET
    delay: 15
    wait_all: true

  # RISK_ASMT -> FRD_DET
  - from: 21 # RISK_ASMT
    to: 22   # FRD_DET
    delay: 9
    wait_all: false

  # QC_CHK -> CUR_CONV
  - from: 7  # QC_CHK
    to: 23   # CUR_CONV
    delay: 7
    wait_all: false

  # RPT_GEN -> CUR_CONV
  - from: 16 # RPT_GEN
    to: 23   # CUR_CONV
    delay: 10
    wait_all: false

  # COMP_CHK -> CUR_CONV
  - from: 11 # COMP_CHK
    to: 23   # CUR_CONV
    delay: 16
    wait_all: false

  # COMP_CHK -> PRC_OPT
  - from: 11 # COMP_CHK
    to: 24   # PRC_OPT
    delay: 11
    wait_all: false

  # SEC_VAL -> PRC_OPT
  - from: 13 # SEC_VAL
    to: 24   # PRC_OPT
    delay: 6
    wait_all: true

  # TAX_CALC -> PRC_OPT
  - from: 9  # TAX_CALC
    to: 24   # PRC_OPT
    delay: 14
    wait_all: true

  # PAY_VAL -> LOY_PROC
  - from: 1  # PAY_VAL
    to: 25   # LOY_PROC
    delay: 16
    wait_all: true

  # PRC_OPT -> LOY_PROC
  - from: 24 # PRC_OPT
    to: 25   # LOY_PROC
    delay: 12
    wait_all: false

  # BCK_CREA -> LOY_PROC
  - from: 15 # BCK_CREA
    to: 25   # LOY_PROC
    delay: 16
    wait_all: true

  # FINAL_VAL -> RET_HDL
  - from: 20 # FINAL_VAL
    to: 26   # RET_HDL
    delay: 9
    wait_all: true

  # CUR_CONV -> RET_HDL
  - from: 23 # CUR_CONV
    to: 26   # RET_HDL
    delay: 9
    wait_all: true

  # LOY_PROC -> REF_PROC
  - from: 25 # LOY_PROC
    to: 27   # REF_PROC
    delay: 14
    wait_all: false

  # SYS_CLN -> REF_PROC
  - from: 19 # SYS_CLN
    to: 27   # REF_PROC
    delay: 14
    wait_all: false

  # FRD_DET -> REF_PROC
  - from: 22 # FRD_DET
    to: 27   # REF_PROC
    delay: 13
    wait_all: false

  # LOY_PROC -> PRD_REC
  - from: 25 # LOY_PROC
    to: 28   # PRD_REC
    delay: 14
    wait_all: true

  # REF_PROC -> PRD_REC
  - from: 27 # REF_PROC
    to: 28   # PRD_REC
    delay: 6
    wait_all: true

  # PRC_OPT -> PRD_REC
  - from: 24 # PRC_OPT
    to: 28   # PRD_REC
    delay: 15
    wait_all: false

  # RISK_ASMT -> ANLY_UPD
  - from: 21 # RISK_ASMT
    to: 29   # ANLY_UPD
    delay: 14
    wait_all: false

  # PERF_MON -> CACHE_REFR
  - from: 14 # PERF_MON
    to: 30   # CACHE_REFR
    delay: 5
    wait_all: true

  # ORD_CONF -> CACHE_REFR
  - from: 4  # ORD_CONF
    to: 30   # CACHE_REFR
    delay: 9
    wait_all: true

  # AUD_TRL -> LOG_PROC
  - from: 18 # AUD_TRL
    to: 31   # LOG_PROC
    delay: 14
    wait_all: true

  # SYS_CLN -> LOG_PROC
  - from: 19 # SYS_CLN
    to: 31   # LOG_PROC
    delay: 12
    wait_all: false

  # CUR_CONV -> LOG_PROC
  - from: 23 # CUR_CONV
    to: 31   # LOG_PROC
    delay: 11
    wait_all: false

  # RET_HDL -> ERR_HDL
  - from: 26 # RET_HDL
    to: 32   # ERR_HDL
    delay: 12
    wait_all: true

  # LOG_PROC -> ERR_HDL
  - from: 31 # LOG_PROC
    to: 32   # ERR_HDL
    delay: 9
    wait_all: false

  # PRC_OPT -> ERR_HDL
  - from: 24 # PRC_OPT
    to: 32   # ERR_HDL
    delay: 6
    wait_all: true

  # ANLY_UPD -> LOAD_BAL
  - from: 29 # ANLY_UPD
    to: 33   # LOAD_BAL
    delay: 8
    wait_all: false

  # REF_PROC -> LOAD_BAL
  - from: 27 # REF_PROC
    to: 33   # LOAD_BAL
    delay: 10
    wait_all: false

  # PRD_REC -> LOAD_BAL
  - from: 28 # PRD_REC
    to: 33   # LOAD_BAL
    delay: 6
    wait_all: false

  # LOG_PROC -> DB_SYNC
  - from: 31 # LOG_PROC
    to: 34   # DB_SYNC
    delay: 5
    wait_all: true

  # RET_HDL -> DB_SYNC
  - from: 26 # RET_HDL
    to: 34   # DB_SYNC
    delay: 5
    wait_all: false

  # PRD_REC -> DB_SYNC
  - from: 28 # PRD_REC
    to: 34   # DB_SYNC
    delay: 15
    wait_all: true

  # RPT_GEN -> API_VAL
  - from: 16 # RPT_GEN
    to: 35   # API_VAL
    delay: 13
    wait_all: true

  # DB_SYNC -> API_VAL
  - from: 34 # DB_SYNC
    to: 35   # API_VAL
    delay: 10
    wait_all: false

  # ARCH_PROC -> API_VAL
  - from: 12 # ARCH_PROC
    to: 35   # API_VAL
    delay: 12
    wait_all: true

  # CACHE_REFR -> SESS_MGT
  - from: 30 # CACHE_REFR
    to: 36   # SESS_MGT
    delay: 15
    wait_all: false

  # LOAD_BAL -> SESS_MGT
  - from: 33 # LOAD_BAL
    to: 36   # SESS_MGT
    delay: 11
    wait_all: true