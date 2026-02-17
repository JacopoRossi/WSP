wsp:
  name: "28tasks"
  h_start: 0
  h_end: 394
  r_max: 194

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
    tasks_set: [14, 16]

  - id: 8
    name: "Infrastructure_Service"
    tasks_set: [15, 19]

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
    service_id: 1
    dur: 5
    res_q: 4
    max_c: 4
    rc: 0
    rd: 0

  - id: 2
    name: "INV_CHK"
    sig: "inv_chk"
    service_id: 2
    dur: 4
    res_q: 5
    max_c: 5
    rc: 3
    rd: 0

  - id: 3
    name: "SHIP_CALC"
    sig: "ship_calc"
    service_id: 4
    dur: 10
    res_q: 3
    max_c: 3
    rc: 3
    rd: 0

  - id: 4
    name: "ORD_CONF"
    sig: "ord_conf"
    service_id: 3
    dur: 8
    res_q: 2
    max_c: 2
    rc: 0
    rd: 0

  - id: 5
    name: "CUST_NOTIF"
    sig: "cust_notif"
    service_id: 5
    dur: 9
    res_q: 5
    max_c: 5
    rc: 3
    rd: 0

  - id: 6
    name: "WH_ALLOC"
    sig: "wh_alloc"
    service_id: 2
    dur: 7
    res_q: 1
    max_c: 3
    rc: 0
    rd: 0

  - id: 7
    name: "QC_CHK"
    sig: "qc_chk"
    service_id: 2
    dur: 8
    res_q: 3
    max_c: 2
    rc: 0
    rd: 0

  - id: 8
    name: "FINAL_PROC"
    sig: "final_proc"
    service_id: 3
    dur: 9
    res_q: 1
    max_c: 1
    rc: 0
    rd: 0

  - id: 9
    name: "TAX_CALC"
    sig: "tax_calc"
    service_id: 1
    dur: 6
    res_q: 4
    max_c: 3
    rc: 2
    rd: 0

  - id: 10
    name: "DOC_GEN"
    sig: "doc_gen"
    service_id: 3
    dur: 5
    res_q: 3
    max_c: 5
    rc: 1
    rd: 10

  - id: 11
    name: "COMP_CHK"
    sig: "comp_chk"
    service_id: 6
    dur: 4
    res_q: 1
    max_c: 5
    rc: 0
    rd: 0

  - id: 12
    name: "ARCH_PROC"
    sig: "arch_proc"
    service_id: 3
    dur: 3
    res_q: 1
    max_c: 4
    rc: 1
    rd: 0

  - id: 13
    name: "SEC_VAL"
    sig: "sec_val"
    service_id: 6
    dur: 10
    res_q: 5
    max_c: 3
    rc: 2
    rd: 0

  - id: 14
    name: "PERF_MON"
    sig: "perf_mon"
    service_id: 7
    dur: 6
    res_q: 5
    max_c: 4
    rc: 0
    rd: 0

  - id: 15
    name: "BCK_CREA"
    sig: "bck_crea"
    service_id: 8
    dur: 4
    res_q: 3
    max_c: 5
    rc: 3
    rd: 0

  - id: 16
    name: "RPT_GEN"
    sig: "rpt_gen"
    service_id: 7
    dur: 7
    res_q: 1
    max_c: 5
    rc: 0
    rd: 0

  - id: 17
    name: "DATA_ENCR"
    sig: "data_encr"
    service_id: 6
    dur: 3
    res_q: 1
    max_c: 2
    rc: 0
    rd: 0

  - id: 18
    name: "AUD_TRL"
    sig: "aud_trl"
    service_id: 6
    dur: 5
    res_q: 3
    max_c: 1
    rc: 1
    rd: 0

  - id: 19
    name: "SYS_CLN"
    sig: "sys_cln"
    service_id: 8
    dur: 3
    res_q: 4
    max_c: 2
    rc: 2
    rd: 0

  - id: 20
    name: "FINAL_VAL"
    sig: "final_val"
    service_id: 3
    dur: 9
    res_q: 5
    max_c: 1
    rc: 0
    rd: 11

  - id: 21
    name: "RISK_ASMT"
    sig: "risk_asmt"
    service_id: 1
    dur: 9
    res_q: 1
    max_c: 4
    rc: 2
    rd: 0

  - id: 22
    name: "FRD_DET"
    sig: "frd_det"
    service_id: 1
    dur: 4
    res_q: 3
    max_c: 5
    rc: 3
    rd: 0

  - id: 23
    name: "CUR_CONV"
    sig: "cur_conv"
    service_id: 1
    dur: 9
    res_q: 4
    max_c: 4
    rc: 1
    rd: 0

  - id: 24
    name: "PRC_OPT"
    sig: "prc_opt"
    service_id: 1
    dur: 3
    res_q: 3
    max_c: 3
    rc: 0
    rd: 14

  - id: 25
    name: "LOY_PROC"
    sig: "loy_proc"
    service_id: 9
    dur: 4
    res_q: 4
    max_c: 4
    rc: 0
    rd: 0

  - id: 26
    name: "RET_HDL"
    sig: "ret_hdl"
    service_id: 2
    dur: 9
    res_q: 5
    max_c: 3
    rc: 0
    rd: 0

  - id: 27
    name: "REF_PROC"
    sig: "ref_proc"
    service_id: 10
    dur: 8
    res_q: 2
    max_c: 1
    rc: 1
    rd: 0

  - id: 28
    name: "PRD_REC"
    sig: "prd_rec"
    service_id: 9
    dur: 4
    res_q: 5
    max_c: 3
    rc: 3
    rd: 0

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
    delay: 6
    wait_all: true

  - from: 1   # PAY_VAL
    to: 5     # CUST_NOTIF
    delay: 9
    wait_all: true

  - from: 5   # CUST_NOTIF
    to: 6     # WH_ALLOC
    delay: 7
    wait_all: true

  - from: 6   # WH_ALLOC
    to: 7     # QC_CHK
    delay: 12
    wait_all: false

  - from: 7   # QC_CHK
    to: 8     # FINAL_PROC
    delay: 15
    wait_all: false

  - from: 5   # CUST_NOTIF
    to: 8     # FINAL_PROC
    delay: 15
    wait_all: false

  - from: 4   # ORD_CONF
    to: 8     # FINAL_PROC
    delay: 7
    wait_all: false

  - from: 8   # FINAL_PROC
    to: 9     # TAX_CALC
    delay: 12
    wait_all: false

  - from: 7   # QC_CHK
    to: 10    # DOC_GEN
    delay: 6
    wait_all: false

  - from: 6   # WH_ALLOC
    to: 10    # DOC_GEN
    delay: 12
    wait_all: false

  - from: 7   # QC_CHK
    to: 11    # COMP_CHK
    delay: 6
    wait_all: true

  - from: 10  # DOC_GEN
    to: 12    # ARCH_PROC
    delay: 13
    wait_all: true

  - from: 7   # QC_CHK
    to: 12    # ARCH_PROC
    delay: 12
    wait_all: true

  - from: 8   # FINAL_PROC
    to: 12    # ARCH_PROC
    delay: 10
    wait_all: false

  - from: 5   # CUST_NOTIF
    to: 13    # SEC_VAL
    delay: 10
    wait_all: true

  - from: 8   # FINAL_PROC
    to: 13    # SEC_VAL
    delay: 13
    wait_all: true

  - from: 12  # ARCH_PROC
    to: 13    # SEC_VAL
    delay: 5
    wait_all: true

  - from: 13  # SEC_VAL
    to: 14    # PERF_MON
    delay: 14
    wait_all: true

  - from: 10  # DOC_GEN
    to: 14    # PERF_MON
    delay: 10
    wait_all: false

  - from: 12  # ARCH_PROC
    to: 14    # PERF_MON
    delay: 9
    wait_all: false

  - from: 11  # COMP_CHK
    to: 15    # BCK_CREA
    delay: 5
    wait_all: false

  - from: 10  # DOC_GEN
    to: 15    # BCK_CREA
    delay: 6
    wait_all: false

  - from: 14  # PERF_MON
    to: 16    # RPT_GEN
    delay: 9
    wait_all: false

  - from: 5   # CUST_NOTIF
    to: 17    # DATA_ENCR
    delay: 14
    wait_all: true

  - from: 6   # WH_ALLOC
    to: 17    # DATA_ENCR
    delay: 10
    wait_all: false

  - from: 2   # INV_CHK
    to: 17    # DATA_ENCR
    delay: 15
    wait_all: false

  - from: 11  # COMP_CHK
    to: 18    # AUD_TRL
    delay: 9
    wait_all: false

  - from: 5   # CUST_NOTIF
    to: 19    # SYS_CLN
    delay: 15
    wait_all: false

  - from: 17  # DATA_ENCR
    to: 19    # SYS_CLN
    delay: 13
    wait_all: false

  - from: 3   # SHIP_CALC
    to: 19    # SYS_CLN
    delay: 5
    wait_all: false

  - from: 15  # BCK_CREA
    to: 20    # FINAL_VAL
    delay: 12
    wait_all: true

  - from: 14  # PERF_MON
    to: 20    # FINAL_VAL
    delay: 8
    wait_all: true

  - from: 14  # PERF_MON
    to: 21    # RISK_ASMT
    delay: 13
    wait_all: true

  - from: 16  # RPT_GEN
    to: 22    # FRD_DET
    delay: 7
    wait_all: true

  - from: 18  # AUD_TRL
    to: 22    # FRD_DET
    delay: 7
    wait_all: true

  - from: 17  # DATA_ENCR
    to: 22    # FRD_DET
    delay: 16
    wait_all: false

  - from: 18  # AUD_TRL
    to: 23    # CUR_CONV
    delay: 12
    wait_all: false

  - from: 8   # FINAL_PROC
    to: 24    # PRC_OPT
    delay: 12
    wait_all: true

  - from: 18  # AUD_TRL
    to: 24    # PRC_OPT
    delay: 10
    wait_all: false

  - from: 10  # DOC_GEN
    to: 24    # PRC_OPT
    delay: 12
    wait_all: false

  - from: 23  # CUR_CONV
    to: 25    # LOY_PROC
    delay: 8
    wait_all: true

  - from: 18  # AUD_TRL
    to: 25    # LOY_PROC
    delay: 9
    wait_all: true

  - from: 23  # CUR_CONV
    to: 26    # RET_HDL
    delay: 16
    wait_all: true

  - from: 22  # FRD_DET
    to: 26    # RET_HDL
    delay: 9
    wait_all: true

  - from: 18  # AUD_TRL
    to: 26    # RET_HDL
    delay: 7
    wait_all: false

  - from: 5   # CUST_NOTIF
    to: 27    # REF_PROC
    delay: 6
    wait_all: true

  - from: 14  # PERF_MON
    to: 27    # REF_PROC
    delay: 12
    wait_all: false

  - from: 26  # RET_HDL
    to: 28    # PRD_REC
    delay: 13
    wait_all: false