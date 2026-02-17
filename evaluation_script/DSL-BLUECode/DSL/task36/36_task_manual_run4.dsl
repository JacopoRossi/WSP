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
  # From Payment_Validation (1)
  - from: 1  # PAY_VAL -> INV_CHK
    to: 2
    delay: 5
    wait_all: false
  - from: 1  # PAY_VAL -> ORD_CONF
    to: 4
    delay: 21
    wait_all: false
  - from: 1  # PAY_VAL -> QC_CHK
    to: 7
    delay: 14
    wait_all: false
  - from: 1  # PAY_VAL -> LOY_PROC
    to: 25
    delay: 16
    wait_all: true

  # From Inventory_Check (2)
  - from: 2  # INV_CHK -> SHIP_CALC
    to: 3
    delay: 9
    wait_all: true
  - from: 2  # INV_CHK -> ORD_CONF
    to: 4
    delay: 16
    wait_all: true
  - from: 2  # INV_CHK -> QC_CHK
    to: 7
    delay: 9
    wait_all: true
  - from: 2  # INV_CHK -> TAX_CALC
    to: 9
    delay: 11
    wait_all: true

  # From Shipping_Calculation (3)
  - from: 3  # SHIP_CALC -> ORD_CONF
    to: 4
    delay: 10
    wait_all: true
  - from: 3  # SHIP_CALC -> CUST_NOTIF
    to: 5
    delay: 13
    wait_all: true
  - from: 3  # SHIP_CALC -> WH_ALLOC
    to: 6
    delay: 5
    wait_all: true
  - from: 3  # SHIP_CALC -> FINAL_PROC
    to: 8
    delay: 16
    wait_all: true

  # From Order_Confirmation (4)
  - from: 4  # ORD_CONF -> QC_CHK
    to: 7
    delay: 14
    wait_all: true
  - from: 4  # ORD_CONF -> FINAL_PROC
    to: 8
    delay: 13
    wait_all: false
  - from: 4  # ORD_CONF -> COMP_CHK
    to: 11
    delay: 15
    wait_all: false
  - from: 4  # ORD_CONF -> CACHE_REFR
    to: 30
    delay: 9
    wait_all: true

  # From Customer_Notification (5)
  - from: 5  # CUST_NOTIF -> FINAL_PROC
    to: 8
    delay: 16
    wait_all: true
  - from: 5  # CUST_NOTIF -> ARCH_PROC
    to: 12
    delay: 8
    wait_all: true

  # From Warehouse_Allocation (6)
  - from: 6  # WH_ALLOC -> COMP_CHK
    to: 11
    delay: 11
    wait_all: true
  - from: 6  # WH_ALLOC -> PERF_MON
    to: 14
    delay: 12
    wait_all: false

  # From Quality_Check (7)
  - from: 7  # QC_CHK -> CUR_CONV
    to: 23
    delay: 7
    wait_all: false

  # From Final_Processing (8)
  - from: 8  # FINAL_PROC -> DOC_GEN
    to: 10
    delay: 10
    wait_all: true

  # From Tax_Calculation (9)
  - from: 9  # TAX_CALC -> PRC_OPT
    to: 24
    delay: 14
    wait_all: true

  # From Document_Generation (10)
  - from: 10  # DOC_GEN -> COMP_CHK
    to: 11
    delay: 10
    wait_all: false

  # From Compliance_Check (11)
  - from: 11  # COMP_CHK -> SEC_VAL
    to: 13
    delay: 16
    wait_all: true
  - from: 11  # COMP_CHK -> PERF_MON
    to: 14
    delay: 5
    wait_all: false
  - from: 11  # COMP_CHK -> AUD_TRL
    to: 18
    delay: 9
    wait_all: false
  - from: 11  # COMP_CHK -> CUR_CONV
    to: 23
    delay: 16
    wait_all: false
  - from: 11  # COMP_CHK -> PRC_OPT
    to: 24
    delay: 11
    wait_all: false

  # From Archive_Processing (12)
  - from: 12  # ARCH_PROC -> PERF_MON
    to: 14
    delay: 9
    wait_all: true
  - from: 12  # ARCH_PROC -> DATA_ENCR
    to: 17
    delay: 6
    wait_all: true
  - from: 12  # ARCH_PROC -> API_VAL
    to: 35
    delay: 12
    wait_all: true

  # From Security_Validation (13)
  - from: 13  # SEC_VAL -> BCK_CREA
    to: 15
    delay: 12
    wait_all: false
  - from: 13  # SEC_VAL -> RPT_GEN
    to: 16
    delay: 13
    wait_all: true
  - from: 13  # SEC_VAL -> RISK_ASMT
    to: 21
    delay: 11
    wait_all: false
  - from: 13  # SEC_VAL -> PRC_OPT
    to: 24
    delay: 6
    wait_all: true

  # From Performance_Monitor (14)
  - from: 14  # PERF_MON -> DATA_ENCR
    to: 17
    delay: 5
    wait_all: false
  - from: 14  # PERF_MON -> RISK_ASMT
    to: 21
    delay: 14
    wait_all: false
  - from: 14  # PERF_MON -> CACHE_REFR
    to: 30
    delay: 5
    wait_all: true
  - from: 14  # PERF_MON -> ANLY_UPD
    to: 29
    delay: 14
    wait_all: false

  # From Backup_Creation (15)
  - from: 15  # BCK_CREA -> DATA_ENCR
    to: 17
    delay: 11
    wait_all: false
  - from: 15  # BCK_CREA -> FINAL_VAL
    to: 20
    delay: 16
    wait_all: false
  - from: 15  # BCK_CREA -> LOY_PROC
    to: 25
    delay: 16
    wait_all: true

  # From Report_Generation (16)
  - from: 16  # RPT_GEN -> AUD_TRL
    to: 18
    delay: 9
    wait_all: false
  - from: 16  # RPT_GEN -> CUR_CONV
    to: 23
    delay: 10
    wait_all: false
  - from: 16  # RPT_GEN -> API_VAL
    to: 35
    delay: 13
    wait_all: true

  # From Data_Encryption (17)
  - from: 17  # DATA_ENCR -> AUD_TRL
    to: 18
    delay: 7
    wait_all: true
  - from: 17  # DATA_ENCR -> SYS_CLN
    to: 19
    delay: 9
    wait_all: false

  # From Audit_Trail (18)
  - from: 18  # AUD_TRL -> LOG_PROC
    to: 31
    delay: 14
    wait_all: true

  # From System_Cleanup (19)
  - from: 19  # SYS_CLN -> REF_PROC
    to: 27
    delay: 14
    wait_all: false
  - from: 19  # SYS_CLN -> LOG_PROC
    to: 31
    delay: 12
    wait_all: false

  # From Final_Validation (20)
  - from: 20  # FINAL_VAL -> RISK_ASMT
    to: 21
    delay: 9
    wait_all: true
  - from: 20  # FINAL_VAL -> FRD_DET
    to: 22
    delay: 15
    wait_all: true
  - from: 20  # FINAL_VAL -> RET_HDL
    to: 26
    delay: 9
    wait_all: true

  # From Risk_Assessment (21)
  - from: 21  # RISK_ASMT -> FRD_DET
    to: 22
    delay: 9
    wait_all: false
  - from: 21  # RISK_ASMT -> ANLY_UPD
    to: 29
    delay: 14
    wait_all: false

  # From Fraud_Detection (22)
  - from: 22  # FRD_DET -> REF_PROC
    to: 27
    delay: 13
    wait_all: false

  # From Currency_Conversion (23)
  - from: 23  # CUR_CONV -> RET_HDL
    to: 26
    delay: 9
    wait_all: true
  - from: 23  # CUR_CONV -> LOG_PROC
    to: 31
    delay: 11
    wait_all: false

  # From Price_Optimization (24)
  - from: 24  # PRC_OPT -> LOY_PROC
    to: 25
    delay: 12
    wait_all: false
  - from: 24  # PRC_OPT -> PRD_REC
    to: 28
    delay: 15
    wait_all: false
  - from: 24  # PRC_OPT -> ERR_HDL
    to: 32
    delay: 6
    wait_all: true

  # From Loyalty_Processing (25)
  - from: 25  # LOY_PROC -> REF_PROC
    to: 27
    delay: 14
    wait_all: false
  - from: 25  # LOY_PROC -> PRD_REC
    to: 28
    delay: 14
    wait_all: true

  # From Return_Handling (26)
  - from: 26  # RET_HDL -> DB_SYNC
    to: 34
    delay: 5
    wait_all: false
  - from: 26  # RET_HDL -> ERR_HDL
    to: 32
    delay: 12
    wait_all: true

  # From Refund_Processing (27)
  - from: 27  # REF_PROC -> PRD_REC
    to: 28
    delay: 6
    wait_all: true
  - from: 27  # REF_PROC -> LOAD_BAL
    to: 33
    delay: 10
    wait_all: false

  # From Product_Recommendation (28)
  - from: 28  # PRD_REC -> DB_SYNC
    to: 34
    delay: 15
    wait_all: true
  - from: 28  # PRD_REC -> LOAD_BAL
    to: 33
    delay: 6
    wait_all: false

  # From Analytics_Update (29)
  - from: 29  # ANLY_UPD -> LOAD_BAL
    to: 33
    delay: 8
    wait_all: false

  # From Cache_Refresh (30)
  - from: 30  # CACHE_REFR -> SESS_MGT
    to: 36
    delay: 15
    wait_all: false

  # From Log_Processing (31)
  - from: 31  # LOG_PROC -> ERR_HDL
    to: 32
    delay: 9
    wait_all: false
  - from: 31  # LOG_PROC -> DB_SYNC
    to: 34
    delay: 5
    wait_all: true

  # From Error_Handling (32)
  # (no outgoing constraints)

  # From Load_Balancing (33)
  - from: 33  # LOAD_BAL -> SESS_MGT
    to: 36
    delay: 11
    wait_all: true

  # From Database_Sync (34)
  - from: 34  # DB_SYNC -> API_VAL
    to: 35
    delay: 10
    wait_all: false

  # From API_Validation (35)
  # (no outgoing constraints)

  # From Session_Management (36)
  # (no outgoing constraints)