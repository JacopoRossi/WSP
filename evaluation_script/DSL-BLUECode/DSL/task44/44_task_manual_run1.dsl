# Global parameters
wsp:
  name: "44tasks"
  h_start: 0
  h_end: 510
  r_max: 238
  n_constraints: 52

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
    tasks_set: [14, 16, 29]

  - id: 8
    name: "Processing_Service"
    tasks_set: [41, 42, 43, 44]

  - id: 9
    name: "Infrastructure_Service"
    tasks_set: [15, 19, 30, 31, 32, 33, 34]

  - id: 10
    name: "Recommendation_Service"
    tasks_set: [25, 28]

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
    dur: 7
    res_q: 3
    rc: 1
    rd: 0
    max_c: 2

  - id: 6
    name: "WH_ALLOC"
    sig: "wh_alloc"
    dur: 6
    res_q: 1
    rc: 3
    rd: 0
    max_c: 3

  - id: 7
    name: "QC_CHK"
    sig: "qc_chk"
    dur: 5
    res_q: 1
    rc: 2
    rd: 0
    max_c: 3

  - id: 8
    name: "FINAL_PROC"
    sig: "final_proc"
    dur: 9
    res_q: 4
    rc: 2
    rd: 1
    max_c: 5

  - id: 9
    name: "TAX_CALC"
    sig: "tax_calc"
    dur: 6
    res_q: 3
    rc: 0
    rd: 15
    max_c: 3

  - id: 10
    name: "DOC_GEN"
    sig: "doc_gen"
    dur: 7
    res_q: 2
    rc: 3
    rd: 0
    max_c: 3

  - id: 11
    name: "COMP_CHK"
    sig: "comp_chk"
    dur: 4
    res_q: 4
    rc: 0
    rd: 8
    max_c: 5

  - id: 12
    name: "ARCH_PROC"
    sig: "arch_proc"
    dur: 5
    res_q: 3
    rc: 0
    rd: 0
    max_c: 3

  - id: 13
    name: "SEC_VAL"
    sig: "sec_val"
    dur: 6
    res_q: 3
    rc: 2
    rd: 0
    max_c: 3

  - id: 14
    name: "PERF_MON"
    sig: "perf_mon"
    dur: 7
    res_q: 5
    rc: 1
    rd: 0
    max_c: 1

  - id: 15
    name: "BCK_CREA"
    sig: "bck_crea"
    dur: 10
    res_q: 1
    rc: 3
    rd: 2
    max_c: 4

  - id: 16
    name: "RPT_GEN"
    sig: "rpt_gen"
    dur: 6
    res_q: 5
    rc: 0
    rd: 12
    max_c: 5

  - id: 17
    name: "DATA_ENCR"
    sig: "data_encr"
    dur: 7
    res_q: 4
    rc: 0
    rd: 0
    max_c: 2

  - id: 18
    name: "AUD_TRL"
    sig: "aud_trl"
    dur: 6
    res_q: 3
    rc: 2
    rd: 14
    max_c: 2

  - id: 19
    name: "SYS_CLN"
    sig: "sys_cln"
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 3

  - id: 20
    name: "FINAL_VAL"
    sig: "final_val"
    dur: 5
    res_q: 3
    rc: 0
    rd: 0
    max_c: 4

  - id: 21
    name: "RISK_ASMT"
    sig: "risk_asmt"
    dur: 7
    res_q: 2
    rc: 0
    rd: 5
    max_c: 4

  - id: 22
    name: "FRD_DET"
    sig: "frd_det"
    dur: 4
    res_q: 2
    rc: 3
    rd: 0
    max_c: 4

  - id: 23
    name: "CUR_CONV"
    sig: "cur_conv"
    dur: 9
    res_q: 4
    rc: 2
    rd: 0
    max_c: 1

  - id: 24
    name: "PRC_OPT"
    sig: "prc_opt"
    dur: 3
    res_q: 5
    rc: 0
    rd: 11
    max_c: 1

  - id: 25
    name: "LOY_PROC"
    sig: "loy_proc"
    dur: 8
    res_q: 5
    rc: 0
    rd: 0
    max_c: 1

  - id: 26
    name: "RET_HDL"
    sig: "ret_hdl"
    dur: 6
    res_q: 2
    rc: 1
    rd: 0
    max_c: 2

  - id: 27
    name: "REF_PROC"
    sig: "ref_proc"
    dur: 4
    res_q: 4
    rc: 3
    rd: 9
    max_c: 2

  - id: 28
    name: "PRD_REC"
    sig: "prd_rec"
    dur: 4
    res_q: 1
    rc: 1
    rd: 0
    max_c: 4

  - id: 29
    name: "ANLY_UPD"
    sig: "anly_upd"
    dur: 8
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4

  - id: 30
    name: "CACHE_REFR"
    sig: "cache_refr"
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 31
    name: "LOG_PROC"
    sig: "log_proc"
    dur: 6
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 32
    name: "ERR_HDL"
    sig: "err_hdl"
    dur: 5
    res_q: 1
    rc: 1
    rd: 1
    max_c: 4

  - id: 33
    name: "LOAD_BAL"
    sig: "load_bal"
    dur: 7
    res_q: 5
    rc: 3
    rd: 0
    max_c: 5

  - id: 34
    name: "DB_SYNC"
    sig: "db_sync"
    dur: 3
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

  - id: 35
    name: "API_VAL"
    sig: "api_val"
    dur: 9
    res_q: 4
    rc: 2
    rd: 0
    max_c: 5

  - id: 36
    name: "SESS_MGT"
    sig: "sess_mgt"
    dur: 7
    res_q: 4
    rc: 0
    rd: 0
    max_c: 1

  - id: 37
    name: "EMAIL_DISP"
    sig: "email_disp"
    dur: 7
    res_q: 4
    rc: 0
    rd: 16
    max_c: 3

  - id: 38
    name: "SMS_NOTIF"
    sig: "sms_notif"
    dur: 5
    res_q: 4
    rc: 0
    rd: 3
    max_c: 3

  - id: 39
    name: "PUSH_NOTIF"
    sig: "push_notif"
    dur: 4
    res_q: 1
    rc: 2
    rd: 0
    max_c: 5

  - id: 40
    name: "HOOK_TRIG"
    sig: "hook_trig"
    dur: 6
    res_q: 3
    rc: 3
    rd: 0
    max_c: 3

  - id: 41
    name: "CONT_MOD"
    sig: "cont_mod"
    dur: 9
    res_q: 3
    rc: 0
    rd: 0
    max_c: 5

  - id: 42
    name: "IMG_PROC"
    sig: "img_proc"
    dur: 10
    res_q: 2
    rc: 2
    rd: 0
    max_c: 2

  - id: 43
    name: "VID_PROC"
    sig: "vid_proc"
    dur: 3
    res_q: 1
    rc: 0
    rd: 0
    max_c: 5

  - id: 44
    name: "FILE_UPL"
    sig: "file_upl"
    dur: 10
    res_q: 2
    rc: 0
    rd: 2
    max_c: 1

# Start-to-start precedence constraints
start_constraints:
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

  - from: 2   # INV_CHK
    to: 5     # CUST_NOTIF
    delay: 9
    wait_all: false

  - from: 4   # ORD_CONF
    to: 5     # CUST_NOTIF
    delay: 12
    wait_all: true

  - from: 2   # INV_CHK
    to: 6     # WH_ALLOC
    delay: 5
    wait_all: false

  - from: 6   # WH_ALLOC
    to: 7     # QC_CHK
    delay: 11
    wait_all: true

  - from: 3   # SHIP_CALC
    to: 7     # QC_CHK
    delay: 6
    wait_all: true

  - from: 7   # QC_CHK
    to: 8     # FINAL_PROC
    delay: 7
    wait_all: true

  - from: 6   # WH_ALLOC
    to: 9     # TAX_CALC
    delay: 14
    wait_all: false

  - from: 4   # ORD_CONF
    to: 9     # TAX_CALC
    delay: 16
    wait_all: true

  - from: 3   # SHIP_CALC
    to: 10    # DOC_GEN
    delay: 11
    wait_all: false

  - from: 2   # INV_CHK
    to: 10    # DOC_GEN
    delay: 12
    wait_all: false

  - from: 10  # DOC_GEN
    to: 11    # COMP_CHK
    delay: 11
    wait_all: true

  - from: 9   # TAX_CALC
    to: 11    # COMP_CHK
    delay: 6
    wait_all: true

  - from: 3   # SHIP_CALC
    to: 12    # ARCH_PROC
    delay: 6
    wait_all: false

  - from: 11  # COMP_CHK
    to: 13    # SEC_VAL
    delay: 7
    wait_all: false

  - from: 8   # FINAL_PROC
    to: 13    # SEC_VAL
    delay: 10
    wait_all: true

  - from: 11  # COMP_CHK
    to: 14    # PERF_MON
    delay: 6
    wait_all: false

  - from: 9   # TAX_CALC
    to: 15    # BCK_CREA
    delay: 5
    wait_all: true

  - from: 10  # DOC_GEN
    to: 15    # BCK_CREA
    delay: 15
    wait_all: false

  - from: 9   # TAX_CALC
    to: 16    # RPT_GEN
    delay: 12
    wait_all: false

  - from: 15  # BCK_CREA
    to: 17    # DATA_ENCR
    delay: 5
    wait_all: true

  - from: 7   # QC_CHK
    to: 17    # DATA_ENCR
    delay: 13
    wait_all: false

  - from: 3   # SHIP_CALC
    to: 18    # AUD_TRL
    delay: 10
    wait_all: true

  - from: 16  # RPT_GEN
    to: 18    # AUD_TRL
    delay: 10
    wait_all: false

  - from: 17  # DATA_ENCR
    to: 19    # SYS_CLN
    delay: 15
    wait_all: false

  - from: 3   # SHIP_CALC
    to: 20    # FINAL_VAL
    delay: 12
    wait_all: false

  - from: 15  # BCK_CREA
    to: 20    # FINAL_VAL
    delay: 6
    wait_all: false

  - from: 18  # AUD_TRL
    to: 21    # RISK_ASMT
    delay: 6
    wait_all: false

  - from: 11  # COMP_CHK
    to: 21    # RISK_ASMT
    delay: 11
    wait_all: true

  - from: 20  # FINAL_VAL
    to: 22    # FRD_DET
    delay: 14
    wait_all: false

  - from: 20  # FINAL_VAL
    to: 23    # CUR_CONV
    delay: 10
    wait_all: false

  - from: 15  # BCK_CREA
    to: 24    # PRC_OPT
    delay: 10
    wait_all: false

  - from: 16  # RPT_GEN
    to: 25    # LOY_PROC
    delay: 15
    wait_all: true

  - from: 24  # PRC_OPT
    to: 25    # LOY_PROC
    delay: 5
    wait_all: false

  - from: 10  # DOC_GEN
    to: 26    # RET_HDL
    delay: 13
    wait_all: false

  - from: 18  # AUD_TRL
    to: 26    # RET_HDL
    delay: 16
    wait_all: true

  - from: 16  # RPT_GEN
    to: 27    # REF_PROC
    delay: 7
    wait_all: false

  - from: 21  # RISK_ASMT
    to: 28    # PRD_REC
    delay: 8
    wait_all: true

  - from: 22  # FRD_DET
    to: 29    # ANLY_UPD
    delay: 6
    wait_all: false

  - from: 24  # PRC_OPT
    to: 29    # ANLY_UPD
    delay: 5
    wait_all: true

  - from: 29  # ANLY_UPD
    to: 30    # CACHE_REFR
    delay: 7
    wait_all: false

  - from: 28  # PRD_REC
    to: 30    # CACHE_REFR
    delay: 5
    wait_all: true

  - from: 16  # RPT_GEN
    to: 31    # LOG_PROC
    delay: 13
    wait_all: true

  - from: 30  # CACHE_REFR
    to: 31    # LOG_PROC
    delay: 16
    wait_all: true

  - from: 31  # LOG_PROC
    to: 32    # ERR_HDL
    delay: 14
    wait_all: false

  - from: 32  # ERR_HDL
    to: 33    # LOAD_BAL
    delay: 9
    wait_all: false

  - from: 26  # RET_HDL
    to: 33    # LOAD_BAL
    delay: 10
    wait_all: false

  - from: 9   # TAX_CALC
    to: 34    # DB_SYNC
    delay: 14
    wait_all: false

  - from: 27  # REF_PROC
    to: 34    # DB_SYNC
    delay: 16
    wait_all: false

  - from: 34  # DB_SYNC
    to: 35    # API_VAL
    delay: 16
    wait_all: false

  - from: 9   # TAX_CALC
    to: 36    # SESS_MGT
    delay: 13
    wait_all: false

  - from: 12  # ARCH_PROC
    to: 36    # SESS_MGT
    delay: 16
    wait_all: true

  - from: 36  # SESS_MGT
    to: 37    # EMAIL_DISP
    delay: 15
    wait_all: false

  - from: 33  # LOAD_BAL
    to: 37    # EMAIL_DISP
    delay: 11
    wait_all: true

  - from: 30  # CACHE_REFR
    to: 38    # SMS_NOTIF
    delay: 5
    wait_all: true

  - from: 31  # LOG_PROC
    to: 39    # PUSH_NOTIF
    delay: 9
    wait_all: false

  - from: 19  # SYS_CLN
    to: 40    # HOOK_TRIG
    delay: 8
    wait_all: true

  - from: 7   # QC_CHK
    to: 41    # CONT_MOD
    delay: 15
    wait_all: true

  - from: 40  # HOOK_TRIG
    to: 41    # CONT_MOD
    delay: 16
    wait_all: false

  - from: 36  # SESS_MGT
    to: 42    # IMG_PROC
    delay: 16
    wait_all: true

  - from: 38  # SMS_NOTIF
    to: 43    # VID_PROC
    delay: 5
    wait_all: true

  - from: 41  # CONT_MOD
    to: 43    # VID_PROC
    delay: 16
    wait_all: false

  - from: 41  # CONT_MOD
    to: 44    # FILE_UPL
    delay: 8
    wait_all: false