wsp:
  name: "48tasks"
  h_start: 0
  h_end: 530
  r_max: 246
  n_constraints: 52

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
    tasks_set: [15, 19, 30, 31, 32, 33, 34]

  - id: 10
    name: "Recommendation_Service"
    tasks_set: [25, 28]

  - id: 11
    name: "Refund_Service"
    tasks_set: [27]

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
    res_q: 4
    rc: 3
    rd: 2
    max_c: 4

  - id: 6
    name: "WH_ALLOC"
    sig: "wh_alloc"
    dur: 8
    res_q: 5
    rc: 0
    rd: 7
    max_c: 5

  - id: 7
    name: "QC_CHK"
    sig: "qc_chk"
    dur: 5
    res_q: 5
    rc: 0
    rd: 0
    max_c: 2

  - id: 8
    name: "FINAL_PROC"
    sig: "final_proc"
    dur: 5
    res_q: 5
    rc: 3
    rd: 4
    max_c: 4

  - id: 9
    name: "TAX_CALC"
    sig: "tax_calc"
    dur: 8
    res_q: 1
    rc: 0
    rd: 0
    max_c: 2

  - id: 10
    name: "DOC_GEN"
    sig: "doc_gen"
    dur: 4
    res_q: 3
    rc: 1
    rd: 0
    max_c: 1

  - id: 11
    name: "COMP_CHK"
    sig: "comp_chk"
    dur: 6
    res_q: 5
    rc: 1
    rd: 0
    max_c: 4

  - id: 12
    name: "ARCH_PROC"
    sig: "arch_proc"
    dur: 10
    res_q: 1
    rc: 0
    rd: 10
    max_c: 1

  - id: 13
    name: "SEC_VAL"
    sig: "sec_val"
    dur: 7
    res_q: 3
    rc: 3
    rd: 5
    max_c: 4

  - id: 14
    name: "PERF_MON"
    sig: "perf_mon"
    dur: 9
    res_q: 3
    rc: 3
    rd: 2
    max_c: 5

  - id: 15
    name: "BCK_CREA"
    sig: "bck_crea"
    dur: 7
    res_q: 4
    rc: 0
    rd: 12
    max_c: 3

  - id: 16
    name: "RPT_GEN"
    sig: "rpt_gen"
    dur: 8
    res_q: 4
    rc: 2
    rd: 0
    max_c: 5

  - id: 17
    name: "DATA_ENCR"
    sig: "data_encr"
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 1

  - id: 18
    name: "AUD_TRL"
    sig: "aud_trl"
    dur: 7
    res_q: 2
    rc: 0
    rd: 0
    max_c: 2

  - id: 19
    name: "SYS_CLN"
    sig: "sys_cln"
    dur: 8
    res_q: 5
    rc: 0
    rd: 7
    max_c: 4

  - id: 20
    name: "FINAL_VAL"
    sig: "final_val"
    dur: 8
    res_q: 1
    rc: 2
    rd: 15
    max_c: 4

  - id: 21
    name: "RISK_ASMT"
    sig: "risk_asmt"
    dur: 6
    res_q: 5
    rc: 0
    rd: 13
    max_c: 1

  - id: 22
    name: "FRD_DET"
    sig: "frd_det"
    dur: 6
    res_q: 1
    rc: 0
    rd: 5
    max_c: 2

  - id: 23
    name: "CUR_CONV"
    sig: "cur_conv"
    dur: 3
    res_q: 5
    rc: 0
    rd: 0
    max_c: 2

  - id: 24
    name: "PRC_OPT"
    sig: "prc_opt"
    dur: 7
    res_q: 2
    rc: 3
    rd: 0
    max_c: 5

  - id: 25
    name: "LOY_PROC"
    sig: "loy_proc"
    dur: 3
    res_q: 3
    rc: 0
    rd: 0
    max_c: 4

  - id: 26
    name: "RET_HDL"
    sig: "ret_hdl"
    dur: 10
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4

  - id: 27
    name: "REF_PROC"
    sig: "ref_proc"
    dur: 5
    res_q: 5
    rc: 0
    rd: 16
    max_c: 3

  - id: 28
    name: "PRD_REC"
    sig: "prd_rec"
    dur: 5
    res_q: 3
    rc: 2
    rd: 2
    max_c: 2

  - id: 29
    name: "ANLY_UPD"
    sig: "anly_upd"
    dur: 9
    res_q: 4
    rc: 0
    rd: 0
    max_c: 1

  - id: 30
    name: "CACHE_REFR"
    sig: "cache_refr"
    dur: 6
    res_q: 5
    rc: 3
    rd: 13
    max_c: 2

  - id: 31
    name: "LOG_PROC"
    sig: "log_proc"
    dur: 4
    res_q: 2
    rc: 2
    rd: 1
    max_c: 5

  - id: 32
    name: "ERR_HDL"
    sig: "err_hdl"
    dur: 4
    res_q: 1
    rc: 2
    rd: 4
    max_c: 5

  - id: 33
    name: "LOAD_BAL"
    sig: "load_bal"
    dur: 3
    res_q: 4
    rc: 3
    rd: 0
    max_c: 3

  - id: 34
    name: "DB_SYNC"
    sig: "db_sync"
    dur: 3
    res_q: 5
    rc: 2
    rd: 0
    max_c: 4

  - id: 35
    name: "API_VAL"
    sig: "api_val"
    dur: 9
    res_q: 3
    rc: 3
    rd: 3
    max_c: 4

  - id: 36
    name: "SESS_MGT"
    sig: "sess_mgt"
    dur: 5
    res_q: 3
    rc: 2
    rd: 0
    max_c: 1

  - id: 37
    name: "EMAIL_DISP"
    sig: "email_disp"
    dur: 7
    res_q: 5
    rc: 3
    rd: 0
    max_c: 3

  - id: 38
    name: "SMS_NOTIF"
    sig: "sms_notif"
    dur: 6
    res_q: 1
    rc: 0
    rd: 16
    max_c: 1

  - id: 39
    name: "PUSH_NOTIF"
    sig: "push_notif"
    dur: 3
    res_q: 4
    rc: 0
    rd: 10
    max_c: 4

  - id: 40
    name: "HOOK_TRIG"
    sig: "hook_trig"
    dur: 8
    res_q: 1
    rc: 0
    rd: 0
    max_c: 5

  - id: 41
    name: "CONT_MOD"
    sig: "cont_mod"
    dur: 7
    res_q: 3
    rc: 3
    rd: 0
    max_c: 5

  - id: 42
    name: "IMG_PROC"
    sig: "img_proc"
    dur: 8
    res_q: 5
    rc: 1
    rd: 12
    max_c: 2

  - id: 43
    name: "VID_PROC"
    sig: "vid_proc"
    dur: 9
    res_q: 5
    rc: 3
    rd: 0
    max_c: 2

  - id: 44
    name: "FILE_UPL"
    sig: "file_upl"
    dur: 8
    res_q: 5
    rc: 3
    rd: 0
    max_c: 3

  - id: 45
    name: "META_EXTR"
    sig: "meta_extr"
    dur: 7
    res_q: 5
    rc: 1
    rd: 12
    max_c: 2

  - id: 46
    name: "SRCH_IDX"
    sig: "srch_idx"
    dur: 4
    res_q: 2
    rc: 2
    rd: 5
    max_c: 1

  - id: 47
    name: "REC_ENG"
    sig: "rec_eng"
    dur: 6
    res_q: 5
    rc: 2
    rd: 0
    max_c: 5

  - id: 48
    name: "AB_TEST"
    sig: "ab_test"
    dur: 3
    res_q: 2
    rc: 2
    rd: 0
    max_c: 1

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
    delay: 14
    wait_all: false

  - from: 1
    to: 6
    delay: 9
    wait_all: true

  - from: 1
    to: 7
    delay: 5
    wait_all: false

  - from: 5
    to: 7
    delay: 11
    wait_all: false

  - from: 7
    to: 8
    delay: 7
    wait_all: false

  - from: 1
    to: 9
    delay: 15
    wait_all: false

  - from: 2
    to: 9
    delay: 8
    wait_all: true

  - from: 2
    to: 10
    delay: 10
    wait_all: true

  - from: 2
    to: 11
    delay: 9
    wait_all: false

  - from: 8
    to: 12
    delay: 13
    wait_all: true

  - from: 5
    to: 12
    delay: 16
    wait_all: true

  - from: 11
    to: 13
    delay: 14
    wait_all: false

  - from: 5
    to: 14
    delay: 14
    wait_all: true

  - from: 4
    to: 14
    delay: 12
    wait_all: false

  - from: 11
    to: 15
    delay: 13
    wait_all: true

  - from: 11
    to: 16
    delay: 6
    wait_all: false

  - from: 13
    to: 17
    delay: 8
    wait_all: false

  - from: 14
    to: 17
    delay: 12
    wait_all: false

  - from: 12
    to: 18
    delay: 6
    wait_all: false

  - from: 12
    to: 19
    delay: 10
    wait_all: false

  - from: 10
    to: 20
    delay: 8
    wait_all: false

  - from: 14
    to: 20
    delay: 6
    wait_all: false

  - from: 13
    to: 21
    delay: 10
    wait_all: false

  - from: 18
    to: 21
    delay: 8
    wait_all: false

  - from: 7
    to: 22
    delay: 12
    wait_all: true

  - from: 17
    to: 23
    delay: 8
    wait_all: true

  - from: 20
    to: 24
    delay: 10
    wait_all: true

  - from: 16
    to: 25
    delay: 15
    wait_all: false

  - from: 24
    to: 26
    delay: 5
    wait_all: false

  - from: 24
    to: 27
    delay: 12
    wait_all: true

  - from: 21
    to: 27
    delay: 13
    wait_all: false

  - from: 27
    to: 28
    delay: 5
    wait_all: false

  - from: 20
    to: 28
    delay: 12
    wait_all: true

  - from: 21
    to: 29
    delay: 6
    wait_all: false

  - from: 26
    to: 29
    delay: 10
    wait_all: true

  - from: 26
    to: 30
    delay: 14
    wait_all: true

  - from: 25
    to: 31
    delay: 13
    wait_all: false

  - from: 23
    to: 31
    delay: 8
    wait_all: false

  - from: 11
    to: 32
    delay: 7
    wait_all: false

  - from: 12
    to: 32
    delay: 11
    wait_all: true

  - from: 28
    to: 33
    delay: 11
    wait_all: false

  - from: 32
    to: 33
    delay: 12
    wait_all: true

  - from: 15
    to: 34
    delay: 6
    wait_all: false

  - from: 31
    to: 35
    delay: 8
    wait_all: true

  - from: 26
    to: 36
    delay: 7
    wait_all: false

  - from: 35
    to: 37
    delay: 16
    wait_all: false

  - from: 36
    to: 37
    delay: 12
    wait_all: false

  - from: 37
    to: 38
    delay: 11
    wait_all: true

  - from: 28
    to: 38
    delay: 16
    wait_all: true

  - from: 33
    to: 39
    delay: 12
    wait_all: true

  - from: 34
    to: 40
    delay: 10
    wait_all: false

  - from: 35
    to: 40
    delay: 10
    wait_all: true

  - from: 40
    to: 41
    delay: 14
    wait_all: true

  - from: 34
    to: 41
    delay: 9
    wait_all: false

  - from: 39
    to: 42
    delay: 6
    wait_all: false

  - from: 41
    to: 42
    delay: 14
    wait_all: false

  - from: 35
    to: 43
    delay: 15
    wait_all: false

  - from: 42
    to: 43
    delay: 11
    wait_all: false

  - from: 39
    to: 44
    delay: 8
    wait_all: false

  - from: 39
    to: 45
    delay: 9
    wait_all: false

  - from: 41
    to: 45
    delay: 10
    wait_all: false

  - from: 36
    to: 46
    delay: 16
    wait_all: true

  - from: 38
    to: 46
    delay: 15
    wait_all: false

  - from: 43
    to: 47
    delay: 6
    wait_all: true

  - from: 31
    to: 48
    delay: 13
    wait_all: true