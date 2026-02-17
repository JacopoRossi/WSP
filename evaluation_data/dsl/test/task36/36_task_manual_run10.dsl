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
    dur: 10
    res_q: 1
    max_c: 4
    rc: 3
    rd: 0

  - id: 6
    name: "WH_ALLOC"
    sig: "wh_alloc"
    dur: 5
    res_q: 4
    max_c: 2
    rc: 0
    rd: 0

  - id: 7
    name: "QC_CHK"
    sig: "qc_chk"
    dur: 8
    res_q: 1
    max_c: 1
    rc: 2
    rd: 0

  - id: 8
    name: "FINAL_PROC"
    sig: "final_proc"
    dur: 6
    res_q: 1
    max_c: 5
    rc: 1
    rd: 0

  - id: 9
    name: "TAX_CALC"
    sig: "tax_calc"
    dur: 3
    res_q: 1
    max_c: 4
    rc: 0
    rd: 6

  - id: 10
    name: "DOC_GEN"
    sig: "doc_gen"
    dur: 6
    res_q: 3
    max_c: 2
    rc: 1
    rd: 0

  - id: 11
    name: "COMP_CHK"
    sig: "comp_chk"
    dur: 6
    res_q: 1
    max_c: 5
    rc: 2
    rd: 0

  - id: 12
    name: "ARCH_PROC"
    sig: "arch_proc"
    dur: 6
    res_q: 4
    max_c: 3
    rc: 0
    rd: 10

  - id: 13
    name: "SEC_VAL"
    sig: "sec_val"
    dur: 9
    res_q: 4
    max_c: 3
    rc: 3
    rd: 11

  - id: 14
    name: "PERF_MON"
    sig: "perf_mon"
    dur: 7
    res_q: 3
    max_c: 4
    rc: 3
    rd: 0

  - id: 15
    name: "BCK_CREA"
    sig: "bck_crea"
    dur: 4
    res_q: 4
    max_c: 3
    rc: 1
    rd: 0

  - id: 16
    name: "RPT_GEN"
    sig: "rpt_gen"
    dur: 8
    res_q: 4
    max_c: 2
    rc: 0
    rd: 7

  - id: 17
    name: "DATA_ENCR"
    sig: "data_encr"
    dur: 3
    res_q: 3
    max_c: 3
    rc: 3
    rd: 13

  - id: 18
    name: "AUD_TRL"
    sig: "aud_trl"
    dur: 5
    res_q: 2
    max_c: 4
    rc: 1
    rd: 0

  - id: 19
    name: "SYS_CLN"
    sig: "sys_cln"
    dur: 6
    res_q: 4
    max_c: 3
    rc: 3
    rd: 10

  - id: 20
    name: "FINAL_VAL"
    sig: "final_val"
    dur: 10
    res_q: 4
    max_c: 3
    rc: 2
    rd: 0

  - id: 21
    name: "RISK_ASMT"
    sig: "risk_asmt"
    dur: 5
    res_q: 2
    max_c: 2
    rc: 3
    rd: 0

  - id: 22
    name: "FRD_DET"
    sig: "frd_det"
    dur: 3
    res_q: 5
    max_c: 1
    rc: 0
    rd: 0

  - id: 23
    name: "CUR_CONV"
    sig: "cur_conv"
    dur: 3
    res_q: 4
    max_c: 1
    rc: 0
    rd: 7

  - id: 24
    name: "PRC_OPT"
    sig: "prc_opt"
    dur: 5
    res_q: 1
    max_c: 3
    rc: 0
    rd: 14

  - id: 25
    name: "LOY_PROC"
    sig: "loy_proc"
    dur: 3
    res_q: 5
    max_c: 4
    rc: 3
    rd: 0

  - id: 26
    name: "RET_HDL"
    sig: "ret_hdl"
    dur: 3
    res_q: 1
    max_c: 1
    rc: 3
    rd: 13

  - id: 27
    name: "REF_PROC"
    sig: "ref_proc"
    dur: 3
    res_q: 5
    max_c: 1
    rc: 1
    rd: 9

  - id: 28
    name: "PRD_REC"
    sig: "prd_rec"
    dur: 9
    res_q: 2
    max_c: 5
    rc: 0
    rd: 0

  - id: 29
    name: "ANLY_UPD"
    sig: "anly_upd"
    dur: 5
    res_q: 2
    max_c: 3
    rc: 0
    rd: 16

  - id: 30
    name: "CACHE_REFR"
    sig: "cache_refr"
    dur: 8
    res_q: 3
    max_c: 3
    rc: 2
    rd: 0

  - id: 31
    name: "LOG_PROC"
    sig: "log_proc"
    dur: 9
    res_q: 4
    max_c: 2
    rc: 3
    rd: 0

  - id: 32
    name: "ERR_HDL"
    sig: "err_hdl"
    dur: 7
    res_q: 1
    max_c: 4
    rc: 0
    rd: 0

  - id: 33
    name: "LOAD_BAL"
    sig: "load_bal"
    dur: 9
    res_q: 4
    max_c: 1
    rc: 3
    rd: 0

  - id: 34
    name: "DB_SYNC"
    sig: "db_sync"
    dur: 3
    res_q: 2
    max_c: 4
    rc: 0
    rd: 0

  - id: 35
    name: "API_VAL"
    sig: "api_val"
    dur: 8
    res_q: 5
    max_c: 2
    rc: 0
    rd: 1

  - id: 36
    name: "SESS_MGT"
    sig: "sess_mgt"
    dur: 6
    res_q: 5
    max_c: 1
    rc: 2
    rd: 0

# Start-to-start precedence constraints
start_constraints:
  # From Payment_Validation and Inventory_Check initial segment
  - from: 1   # PAY_VAL
    to: 2     # INV_CHK
    delay: 5
    wait_all: false

  - from: 2   # INV_CHK
    to: 3     # SHIP_CALC
    delay: 9
    wait_all: true

  - from: 1   # PAY_VAL
    to: 4     # ORD_CONF
    delay: 21
    wait_all: false

  - from: 2   # INV_CHK
    to: 4     # ORD_CONF
    delay: 16
    wait_all: true

  # Shipping_Calculation fan-out and early graph
  - from: 3   # SHIP_CALC
    to: 4     # ORD_CONF
    delay: 10
    wait_all: true

  - from: 3   # SHIP_CALC
    to: 5     # CUST_NOTIF
    delay: 13
    wait_all: true

  - from: 3   # SHIP_CALC
    to: 6     # WH_ALLOC
    delay: 5
    wait_all: true

  - from: 2   # INV_CHK
    to: 7     # QC_CHK
    delay: 9
    wait_all: true

  - from: 4   # ORD_CONF
    to: 7     # QC_CHK
    delay: 14
    wait_all: true

  - from: 1   # PAY_VAL
    to: 7     # QC_CHK
    delay: 14
    wait_all: false

  - from: 5   # CUST_NOTIF
    to: 8     # FINAL_PROC
    delay: 16
    wait_all: true

  - from: 3   # SHIP_CALC
    to: 8     # FINAL_PROC
    delay: 16
    wait_all: true

  - from: 4   # ORD_CONF
    to: 8     # FINAL_PROC
    delay: 13
    wait_all: false

  - from: 2   # INV_CHK
    to: 9     # TAX_CALC
    delay: 11
    wait_all: true

  - from: 8   # FINAL_PROC
    to: 10    # DOC_GEN
    delay: 10
    wait_all: true

  - from: 10  # DOC_GEN
    to: 11    # COMP_CHK
    delay: 10
    wait_all: false

  - from: 6   # WH_ALLOC
    to: 11    # COMP_CHK
    delay: 11
    wait_all: true

  - from: 4   # ORD_CONF
    to: 11    # COMP_CHK
    delay: 15
    wait_all: false

  - from: 5   # CUST_NOTIF
    to: 12    # ARCH_PROC
    delay: 8
    wait_all: true

  - from: 11  # COMP_CHK
    to: 13    # SEC_VAL
    delay: 16
    wait_all: true

  - from: 11  # COMP_CHK
    to: 14    # PERF_MON
    delay: 5
    wait_all: false

  - from: 6   # WH_ALLOC
    to: 14    # PERF_MON
    delay: 12
    wait_all: false

  - from: 12  # ARCH_PROC
    to: 14    # PERF_MON
    delay: 9
    wait_all: true

  - from: 13  # SEC_VAL
    to: 15    # BCK_CREA
    delay: 12
    wait_all: false

  - from: 13  # SEC_VAL
    to: 16    # RPT_GEN
    delay: 13
    wait_all: true

  - from: 14  # PERF_MON
    to: 17    # DATA_ENCR
    delay: 5
    wait_all: false

  # Mid-graph: Data_Encryption, Audit_Trail, System_Cleanup, Final_Validation, Risk, Fraud, Currency, Price, Loyalty, Return
  - from: 15  # BCK_CREA
    to: 17    # DATA_ENCR
    delay: 11
    wait_all: false

  - from: 12  # ARCH_PROC
    to: 17    # DATA_ENCR
    delay: 6
    wait_all: true

  - from: 16  # RPT_GEN
    to: 18    # AUD_TRL
    delay: 9
    wait_all: false

  - from: 11  # COMP_CHK
    to: 18    # AUD_TRL
    delay: 9
    wait_all: false

  - from: 17  # DATA_ENCR
    to: 18    # AUD_TRL
    delay: 7
    wait_all: true

  - from: 17  # DATA_ENCR
    to: 19    # SYS_CLN
    delay: 9
    wait_all: false

  - from: 15  # BCK_CREA
    to: 20    # FINAL_VAL
    delay: 16
    wait_all: false

  - from: 20  # FINAL_VAL
    to: 21    # RISK_ASMT
    delay: 9
    wait_all: true

  - from: 13  # SEC_VAL
    to: 21    # RISK_ASMT
    delay: 11
    wait_all: false

  - from: 14  # PERF_MON
    to: 21    # RISK_ASMT
    delay: 14
    wait_all: false

  - from: 20  # FINAL_VAL
    to: 22    # FRD_DET
    delay: 15
    wait_all: true

  - from: 21  # RISK_ASMT
    to: 22    # FRD_DET
    delay: 9
    wait_all: false

  - from: 7   # QC_CHK
    to: 23    # CUR_CONV
    delay: 7
    wait_all: false

  - from: 16  # RPT_GEN
    to: 23    # CUR_CONV
    delay: 10
    wait_all: false

  - from: 11  # COMP_CHK
    to: 23    # CUR_CONV
    delay: 16
    wait_all: false

  - from: 11  # COMP_CHK
    to: 24    # PRC_OPT
    delay: 11
    wait_all: false

  - from: 13  # SEC_VAL
    to: 24    # PRC_OPT
    delay: 6
    wait_all: true

  - from: 9   # TAX_CALC
    to: 24    # PRC_OPT
    delay: 14
    wait_all: true

  - from: 1   # PAY_VAL
    to: 25    # LOY_PROC
    delay: 16
    wait_all: true

  - from: 24  # PRC_OPT
    to: 25    # LOY_PROC
    delay: 12
    wait_all: false

  - from: 15  # BCK_CREA
    to: 25    # LOY_PROC
    delay: 16
    wait_all: true

  - from: 20  # FINAL_VAL
    to: 26    # RET_HDL
    delay: 9
    wait_all: true

  - from: 23  # CUR_CONV
    to: 26    # RET_HDL
    delay: 9
    wait_all: true

  # Refund, Recommendation, Analytics, Cache, Logs, Errors, Load, DB, API, Session
  - from: 25  # LOY_PROC
    to: 27    # REF_PROC
    delay: 14
    wait_all: false

  - from: 19  # SYS_CLN
    to: 27    # REF_PROC
    delay: 14
    wait_all: false

  - from: 22  # FRD_DET
    to: 27    # REF_PROC
    delay: 13
    wait_all: false

  - from: 25  # LOY_PROC
    to: 28    # PRD_REC
    delay: 14
    wait_all: true

  - from: 27  # REF_PROC
    to: 28    # PRD_REC
    delay: 6
    wait_all: true

  - from: 24  # PRC_OPT
    to: 28    # PRD_REC
    delay: 15
    wait_all: false

  - from: 21  # RISK_ASMT
    to: 29    # ANLY_UPD
    delay: 14
    wait_all: false

  - from: 14  # PERF_MON
    to: 30    # CACHE_REFR
    delay: 5
    wait_all: true

  - from: 4   # ORD_CONF
    to: 30    # CACHE_REFR
    delay: 9
    wait_all: true

  - from: 18  # AUD_TRL
    to: 31    # LOG_PROC
    delay: 14
    wait_all: true

  - from: 19  # SYS_CLN
    to: 31    # LOG_PROC
    delay: 12
    wait_all: false

  - from: 23  # CUR_CONV
    to: 31    # LOG_PROC
    delay: 11
    wait_all: false

  - from: 26  # RET_HDL
    to: 32    # ERR_HDL
    delay: 12
    wait_all: true

  - from: 31  # LOG_PROC
    to: 32    # ERR_HDL
    delay: 9
    wait_all: false

  - from: 24  # PRC_OPT
    to: 32    # ERR_HDL
    delay: 6
    wait_all: true

  - from: 29  # ANLY_UPD
    to: 33    # LOAD_BAL
    delay: 8
    wait_all: false

  - from: 27  # REF_PROC
    to: 33    # LOAD_BAL
    delay: 10
    wait_all: false

  - from: 28  # PRD_REC
    to: 33    # LOAD_BAL
    delay: 6
    wait_all: false

  - from: 31  # LOG_PROC
    to: 34    # DB_SYNC
    delay: 5
    wait_all: true

  - from: 26  # RET_HDL
    to: 34    # DB_SYNC
    delay: 5
    wait_all: false

  - from: 28  # PRD_REC
    to: 34    # DB_SYNC
    delay: 15
    wait_all: true

  - from: 16  # RPT_GEN
    to: 35    # API_VAL
    delay: 13
    wait_all: true

  - from: 34  # DB_SYNC
    to: 35    # API_VAL
    delay: 10
    wait_all: false

  - from: 12  # ARCH_PROC
    to: 35    # API_VAL
    delay: 12
    wait_all: true

  - from: 30  # CACHE_REFR
    to: 36    # SESS_MGT
    delay: 15
    wait_all: false

  - from: 33  # LOAD_BAL
    to: 36    # SESS_MGT
    delay: 11
    wait_all: true