wsp:
  name: "52Tasks"
  h_start: 0
  h_end: 586
  r_max: 266
  n_constraints: 78

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
    tasks_set: [5, 37, 38, 39, 40]

  - id: 6
    name: "Security_Service"
    tasks_set: [11, 13, 17, 18, 35, 36]

  - id: 7
    name: "Analytics_Service"
    tasks_set: [14, 16, 29, 46, 47, 48]

  - id: 8
    name: "Processing_Service"
    tasks_set: [41, 42, 43, 44, 45]

  - id: 9
    name: "Infrastructure_Service"
    tasks_set: [15, 19, 30, 31, 32, 33, 34, 52]

  - id: 10
    name: "Recommendation_Service"
    tasks_set: [25, 28, 49, 50, 51]

  - id: 11
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
    dur: 8
    res_q: 5
    rc: 0
    rd: 0
    max_c: 1

  - id: 6
    name: "WH_ALLOC"
    sig: "wh_alloc"
    dur: 9
    res_q: 4
    rc: 3
    rd: 16
    max_c: 1

  - id: 7
    name: "QC_CHK"
    sig: "qc_chk"
    dur: 6
    res_q: 4
    rc: 1
    rd: 0
    max_c: 2

  - id: 8
    name: "FINAL_PROC"
    sig: "final_proc"
    dur: 5
    res_q: 3
    rc: 0
    rd: 0
    max_c: 5

  - id: 9
    name: "TAX_CALC"
    sig: "tax_calc"
    dur: 3
    res_q: 5
    rc: 2
    rd: 0
    max_c: 1

  - id: 10
    name: "DOC_GEN"
    sig: "doc_gen"
    dur: 9
    res_q: 5
    rc: 2
    rd: 4
    max_c: 2

  - id: 11
    name: "COMP_CHK"
    sig: "comp_chk"
    dur: 10
    res_q: 5
    rc: 0
    rd: 0
    max_c: 4

  - id: 12
    name: "ARCH_PROC"
    sig: "arch_proc"
    dur: 6
    res_q: 5
    rc: 3
    rd: 16
    max_c: 2

  - id: 13
    name: "SEC_VAL"
    sig: "sec_val"
    dur: 6
    res_q: 1
    rc: 1
    rd: 0
    max_c: 3

  - id: 14
    name: "PERF_MON"
    sig: "perf_mon"
    dur: 4
    res_q: 1
    rc: 2
    rd: 0
    max_c: 3

  - id: 15
    name: "BCK_CREA"
    sig: "bck_crea"
    dur: 8
    res_q: 2
    rc: 1
    rd: 0
    max_c: 5

  - id: 16
    name: "RPT_GEN"
    sig: "rpt_gen"
    dur: 3
    res_q: 3
    rc: 0
    rd: 0
    max_c: 5

  - id: 17
    name: "DATA_ENCR"
    sig: "data_encr"
    dur: 10
    res_q: 5
    rc: 0
    rd: 0
    max_c: 1

  - id: 18
    name: "AUD_TRL"
    sig: "aud_trl"
    dur: 6
    res_q: 2
    rc: 1
    rd: 0
    max_c: 1

  - id: 19
    name: "SYS_CLN"
    sig: "sys_cln"
    dur: 4
    res_q: 1
    rc: 0
    rd: 4
    max_c: 3

  - id: 20
    name: "FINAL_VAL"
    sig: "final_val"
    dur: 3
    res_q: 3
    rc: 0
    rd: 0
    max_c: 4

  - id: 21
    name: "RISK_ASMT"
    sig: "risk_asmt"
    dur: 10
    res_q: 1
    rc: 1
    rd: 0
    max_c: 5

  - id: 22
    name: "FRD_DET"
    sig: "frd_det"
    dur: 6
    res_q: 2
    rc: 3
    rd: 8
    max_c: 5

  - id: 23
    name: "CUR_CONV"
    sig: "cur_conv"
    dur: 10
    res_q: 5
    rc: 0
    rd: 0
    max_c: 4

  - id: 24
    name: "PRC_OPT"
    sig: "prc_opt"
    dur: 3
    res_q: 3
    rc: 0
    rd: 0
    max_c: 3

  - id: 25
    name: "LOY_PROC"
    sig: "loy_proc"
    dur: 6
    res_q: 5
    rc: 1
    rd: 0
    max_c: 4

  - id: 26
    name: "RET_HDL"
    sig: "ret_hdl"
    dur: 3
    res_q: 1
    rc: 2
    rd: 8
    max_c: 3

  - id: 27
    name: "REF_PROC"
    sig: "ref_proc"
    dur: 4
    res_q: 1
    rc: 1
    rd: 12
    max_c: 2

  - id: 28
    name: "PRD_REC"
    sig: "prd_rec"
    dur: 9
    res_q: 5
    rc: 0
    rd: 0
    max_c: 4

  - id: 29
    name: "ANLY_UPD"
    sig: "anly_upd"
    dur: 4
    res_q: 2
    rc: 0
    rd: 14
    max_c: 5

  - id: 30
    name: "CACHE_REFR"
    sig: "cache_refr"
    dur: 3
    res_q: 1
    rc: 0
    rd: 9
    max_c: 3

  - id: 31
    name: "LOG_PROC"
    sig: "log_proc"
    dur: 10
    res_q: 4
    rc: 0
    rd: 0
    max_c: 3

  - id: 32
    name: "ERR_HDL"
    sig: "err_hdl"
    dur: 8
    res_q: 3
    rc: 1
    rd: 0
    max_c: 5

  - id: 33
    name: "LOAD_BAL"
    sig: "load_bal"
    dur: 7
    res_q: 1
    rc: 1
    rd: 0
    max_c: 1

  - id: 34
    name: "DB_SYNC"
    sig: "db_sync"
    dur: 7
    res_q: 2
    rc: 0
    rd: 0
    max_c: 4

  - id: 35
    name: "API_VAL"
    sig: "api_val"
    dur: 5
    res_q: 1
    rc: 2
    rd: 7
    max_c: 4

  - id: 36
    name: "SESS_MGT"
    sig: "sess_mgt"
    dur: 6
    res_q: 5
    rc: 0
    rd: 0
    max_c: 3

  - id: 37
    name: "EMAIL_DISP"
    sig: "email_disp"
    dur: 8
    res_q: 4
    rc: 3
    rd: 0
    max_c: 2

  - id: 38
    name: "SMS_NOTIF"
    sig: "sms_notif"
    dur: 5
    res_q: 5
    rc: 3
    rd: 6
    max_c: 2

  - id: 39
    name: "PUSH_NOTIF"
    sig: "push_notif"
    dur: 7
    res_q: 5
    rc: 0
    rd: 0
    max_c: 2

  - id: 40
    name: "HOOK_TRIG"
    sig: "hook_trig"
    dur: 5
    res_q: 3
    rc: 0
    rd: 3
    max_c: 2

  - id: 41
    name: "CONT_MOD"
    sig: "cont_mod"
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 4

  - id: 42
    name: "IMG_PROC"
    sig: "img_proc"
    dur: 9
    res_q: 3
    rc: 2
    rd: 8
    max_c: 2

  - id: 43
    name: "VID_PROC"
    sig: "vid_proc"
    dur: 6
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

  - id: 44
    name: "FILE_UPL"
    sig: "file_upl"
    dur: 7
    res_q: 5
    rc: 3
    rd: 7
    max_c: 5

  - id: 45
    name: "META_EXTR"
    sig: "meta_extr"
    dur: 6
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 46
    name: "SRCH_IDX"
    sig: "srch_idx"
    dur: 10
    res_q: 2
    rc: 3
    rd: 15
    max_c: 3

  - id: 47
    name: "REC_ENG"
    sig: "rec_eng"
    dur: 5
    res_q: 4
    rc: 2
    rd: 0
    max_c: 2

  - id: 48
    name: "AB_TEST"
    sig: "ab_test"
    dur: 5
    res_q: 2
    rc: 0
    rd: 0
    max_c: 4

  - id: 49
    name: "FEAT_TGL"
    sig: "feat_tgl"
    dur: 3
    res_q: 3
    rc: 2
    rd: 0
    max_c: 2

  - id: 50
    name: "RATE_LMT"
    sig: "rate_lmt"
    dur: 6
    res_q: 1
    rc: 0
    rd: 0
    max_c: 5

  - id: 51
    name: "CIRC_BRK"
    sig: "circ_brk"
    dur: 10
    res_q: 3
    rc: 2
    rd: 0
    max_c: 4

  - id: 52
    name: "HLTH_CHK"
    sig: "hlth_chk"
    dur: 9
    res_q: 1
    rc: 3
    rd: 12
    max_c: 3

# Start-to-start precedence constraints
start_constraints:
  # Core order and initial fan-out
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

  - from: 3   # SHIP_CALC
    to: 4     # ORD_CONF
    delay: 10
    wait_all: true

  - from: 1   # PAY_VAL
    to: 5     # CUST_NOTIF
    delay: 6
    wait_all: false

  - from: 3   # SHIP_CALC
    to: 5     # CUST_NOTIF
    delay: 12
    wait_all: true

  - from: 5   # CUST_NOTIF
    to: 6     # WH_ALLOC
    delay: 13
    wait_all: false

  - from: 1   # PAY_VAL
    to: 7     # QC_CHK
    delay: 13
    wait_all: true

  - from: 5   # CUST_NOTIF
    to: 7     # QC_CHK
    delay: 8
    wait_all: false

  - from: 4   # ORD_CONF
    to: 7     # QC_CHK
    delay: 12
    wait_all: false

  # Mid-order processing, tax, compliance, archive, security
  - from: 7   # QC_CHK
    to: 8     # FINAL_PROC
    delay: 12
    wait_all: true

  - from: 3   # SHIP_CALC
    to: 8     # FINAL_PROC
    delay: 11
    wait_all: false

  - from: 1   # PAY_VAL
    to: 9     # TAX_CALC
    delay: 7
    wait_all: false

  - from: 6   # WH_ALLOC
    to: 9     # TAX_CALC
    delay: 15
    wait_all: false

  - from: 5   # CUST_NOTIF
    to: 9     # TAX_CALC
    delay: 6
    wait_all: true

  - from: 9   # TAX_CALC
    to: 10    # DOC_GEN
    delay: 7
    wait_all: false

  - from: 3   # SHIP_CALC
    to: 11    # COMP_CHK
    delay: 12
    wait_all: true

  - from: 4   # ORD_CONF
    to: 11    # COMP_CHK
    delay: 12
    wait_all: true

  - from: 6   # WH_ALLOC
    to: 12    # ARCH_PROC
    delay: 16
    wait_all: true

  - from: 9   # TAX_CALC
    to: 12    # ARCH_PROC
    delay: 6
    wait_all: true

  - from: 10  # DOC_GEN
    to: 13    # SEC_VAL
    delay: 16
    wait_all: false

  - from: 5   # CUST_NOTIF
    to: 13    # SEC_VAL
    delay: 16
    wait_all: true

  - from: 9   # TAX_CALC
    to: 13    # SEC_VAL
    delay: 11
    wait_all: false

  - from: 6   # WH_ALLOC
    to: 14    # PERF_MON
    delay: 14
    wait_all: true

  - from: 3   # SHIP_CALC
    to: 15    # BCK_CREA
    delay: 16
    wait_all: true

  - from: 15  # BCK_CREA
    to: 16    # RPT_GEN
    delay: 15
    wait_all: true

  - from: 10  # DOC_GEN
    to: 16    # RPT_GEN
    delay: 6
    wait_all: true

  - from: 13  # SEC_VAL
    to: 17    # DATA_ENCR
    delay: 5
    wait_all: false

  - from: 1   # PAY_VAL
    to: 18    # AUD_TRL
    delay: 8
    wait_all: true

  - from: 16  # RPT_GEN
    to: 18    # AUD_TRL
    delay: 14
    wait_all: false

  - from: 12  # ARCH_PROC
    to: 19    # SYS_CLN
    delay: 14
    wait_all: true

  - from: 15  # BCK_CREA
    to: 19    # SYS_CLN
    delay: 8
    wait_all: false

  - from: 15  # BCK_CREA
    to: 20    # FINAL_VAL
    delay: 7
    wait_all: true

  - from: 12  # ARCH_PROC
    to: 20    # FINAL_VAL
    delay: 15
    wait_all: false

  - from: 13  # SEC_VAL
    to: 20    # FINAL_VAL
    delay: 5
    wait_all: true

  - from: 17  # DATA_ENCR
    to: 21    # RISK_ASMT
    delay: 10
    wait_all: true

  - from: 16  # RPT_GEN
    to: 22    # FRD_DET
    delay: 7
    wait_all: false

  - from: 17  # DATA_ENCR
    to: 23    # CUR_CONV
    delay: 14
    wait_all: false

  - from: 18  # AUD_TRL
    to: 23    # CUR_CONV
    delay: 5
    wait_all: true

  # Final validation fan-out to payment & recommendation & refund
  - from: 20  # FINAL_VAL
    to: 23    # CUR_CONV
    delay: 9
    wait_all: false

  - from: 3   # SHIP_CALC
    to: 24    # PRC_OPT
    delay: 13
    wait_all: true

  - from: 14  # PERF_MON
    to: 24    # PRC_OPT
    delay: 9
    wait_all: false

  - from: 21  # RISK_ASMT
    to: 25    # LOY_PROC
    delay: 10
    wait_all: false

  - from: 21  # RISK_ASMT
    to: 26    # RET_HDL
    delay: 6
    wait_all: true

  - from: 22  # FRD_DET
    to: 26    # RET_HDL
    delay: 12
    wait_all: false

  - from: 18  # AUD_TRL
    to: 26    # RET_HDL
    delay: 11
    wait_all: false

  - from: 24  # PRC_OPT
    to: 27    # REF_PROC
    delay: 14
    wait_all: false

  - from: 20  # FINAL_VAL
    to: 27    # REF_PROC
    delay: 13
    wait_all: false

  - from: 20  # FINAL_VAL
    to: 28    # PRD_REC
    delay: 16
    wait_all: false

  - from: 8   # FINAL_PROC
    to: 28    # PRD_REC
    delay: 8
    wait_all: true

  - from: 22  # FRD_DET
    to: 29    # ANLY_UPD
    delay: 16
    wait_all: true

  - from: 14  # PERF_MON
    to: 30    # CACHE_REFR
    delay: 10
    wait_all: true

  - from: 2   # INV_CHK
    to: 30    # CACHE_REFR
    delay: 5
    wait_all: true

  - from: 11  # COMP_CHK
    to: 30    # CACHE_REFR
    delay: 16
    wait_all: false

  - from: 10  # DOC_GEN
    to: 31    # LOG_PROC
    delay: 13
    wait_all: false

  - from: 17  # DATA_ENCR
    to: 31    # LOG_PROC
    delay: 5
    wait_all: true

  - from: 30  # CACHE_REFR
    to: 32    # ERR_HDL
    delay: 14
    wait_all: true

  - from: 29  # ANLY_UPD
    to: 32    # ERR_HDL
    delay: 7
    wait_all: true

  - from: 28  # PRD_REC
    to: 32    # ERR_HDL
    delay: 10
    wait_all: false

  - from: 32  # ERR_HDL
    to: 33    # LOAD_BAL
    delay: 15
    wait_all: true

  - from: 31  # LOG_PROC
    to: 33    # LOAD_BAL
    delay: 12
    wait_all: true

  - from: 25  # LOY_PROC
    to: 33    # LOAD_BAL
    delay: 15
    wait_all: false

  - from: 30  # CACHE_REFR
    to: 34    # DB_SYNC
    delay: 13
    wait_all: false

  - from: 27  # REF_PROC
    to: 34    # DB_SYNC
    delay: 14
    wait_all: false

  - from: 4   # ORD_CONF
    to: 34    # DB_SYNC
    delay: 13
    wait_all: true

  - from: 32  # ERR_HDL
    to: 35    # API_VAL
    delay: 10
    wait_all: true

  - from: 28  # PRD_REC
    to: 36    # SESS_MGT
    delay: 10
    wait_all: false

  - from: 31  # LOG_PROC
    to: 37    # EMAIL_DISP
    delay: 11
    wait_all: true

  - from: 33  # LOAD_BAL
    to: 37    # EMAIL_DISP
    delay: 14
    wait_all: true

  - from: 35  # API_VAL
    to: 37    # EMAIL_DISP
    delay: 9
    wait_all: false

  - from: 36  # SESS_MGT
    to: 38    # SMS_NOTIF
    delay: 8
    wait_all: false

  - from: 30  # CACHE_REFR
    to: 38    # SMS_NOTIF
    delay: 12
    wait_all: false

  - from: 33  # LOAD_BAL
    to: 38    # SMS_NOTIF
    delay: 8
    wait_all: false

  - from: 31  # LOG_PROC
    to: 39    # PUSH_NOTIF
    delay: 8
    wait_all: true

  - from: 39  # PUSH_NOTIF
    to: 40    # HOOK_TRIG
    delay: 7
    wait_all: true

  - from: 36  # SESS_MGT
    to: 40    # HOOK_TRIG
    delay: 10
    wait_all: false

  - from: 20  # FINAL_VAL
    to: 41    # CONT_MOD
    delay: 6
    wait_all: true

  - from: 21  # RISK_ASMT
    to: 41    # CONT_MOD
    delay: 8
    wait_all: true

  - from: 10  # DOC_GEN
    to: 41    # CONT_MOD
    delay: 12
    wait_all: false

  - from: 8   # FINAL_PROC
    to: 42    # IMG_PROC
    delay: 5
    wait_all: true

  - from: 1   # PAY_VAL
    to: 42    # IMG_PROC
    delay: 10
    wait_all: false

  - from: 20  # FINAL_VAL
    to: 42    # IMG_PROC
    delay: 5
    wait_all: true

  - from: 20  # FINAL_VAL
    to: 43    # VID_PROC
    delay: 9
    wait_all: true

  - from: 2   # INV_CHK
    to: 43    # VID_PROC
    delay: 10
    wait_all: true

  - from: 37  # EMAIL_DISP
    to: 43    # VID_PROC
    delay: 8
    wait_all: false

  - from: 43  # VID_PROC
    to: 44    # FILE_UPL
    delay: 6
    wait_all: false

  - from: 41  # CONT_MOD
    to: 44    # FILE_UPL
    delay: 7
    wait_all: true

  - from: 38  # SMS_NOTIF
    to: 45    # META_EXTR
    delay: 13
    wait_all: false

  - from: 44  # FILE_UPL
    to: 45    # META_EXTR
    delay: 13
    wait_all: false

  - from: 42  # IMG_PROC
    to: 46    # SRCH_IDX
    delay: 8
    wait_all: true

  - from: 45  # META_EXTR
    to: 46    # SRCH_IDX
    delay: 6
    wait_all: false

  - from: 35  # API_VAL
    to: 47    # REC_ENG
    delay: 7
    wait_all: true

  - from: 29  # ANLY_UPD
    to: 47    # REC_ENG
    delay: 12
    wait_all: true

  - from: 4   # ORD_CONF
    to: 47    # REC_ENG
    delay: 6
    wait_all: false

  - from: 46  # SRCH_IDX
    to: 48    # AB_TEST
    delay: 7
    wait_all: false

  - from: 46  # SRCH_IDX
    to: 49    # FEAT_TGL
    delay: 16
    wait_all: true

  - from: 47  # REC_ENG
    to: 49    # FEAT_TGL
    delay: 12
    wait_all: true

  - from: 42  # IMG_PROC
    to: 49    # FEAT_TGL
    delay: 6
    wait_all: false

  - from: 49  # FEAT_TGL
    to: 50    # RATE_LMT
    delay: 12
    wait_all: true

  - from: 47  # REC_ENG
    to: 51    # CIRC_BRK
    delay: 10
    wait_all: false

  - from: 49  # FEAT_TGL
    to: 52    # HLTH_CHK
    delay: 10
    wait_all: false