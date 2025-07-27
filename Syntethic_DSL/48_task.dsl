# Enhanced DSL - 48 Task Pipeline Experiment

# global configuration
wsp:
  name: "48tasks"
  h_start: 0
  h_end: 530
  r_max: 246

# Service definitions
services:
  - id: 1
    name: "Payment_Service"
    tasks_set: [1,9,21,22,23,24]
  - id: 2
    name: "Inventory_Service"
    tasks_set: [2,6,7,26]
  - id: 3
    name: "Order_Service"
    tasks_set: [4,8,10,12,20]
  - id: 4
    name: "Shipping_Service"
    tasks_set: [3]
  - id: 5
    name: "Notification_Service"
    tasks_set: [5,37,38,39,40]
  - id: 6
    name: "Security_Service"
    tasks_set: [11,13,17,18,35,36]
  - id: 7
    name: "Analytics_Service"
    tasks_set: [14,16,29,46,47,48]
  - id: 8
    name: "Processing_Service"
    tasks_set: [41,42,43,44,45]
  - id: 9
    name: "Infrastructure_Service"
    tasks_set: [15,19,30,31,32,33,34]
  - id: 10
    name: "Recommendation_Service"
    tasks_set: [25,28]
  - id: 11
    name: "Refund_Service"
    tasks_set: [27]

# Task definitions with new nomenclature
tasks:
  - id: 1
    name: "Payment_Validation"
    sig: "PAY_VAL"
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4
  - id: 2
    name: "Inventory_Check"
    sig: "INV_CHK"
    dur: 4
    res_q: 5
    rc: 3
    rd: 0
    max_c: 5
  - id: 3
    name: "Shipping_Calculation"
    sig: "SHIP_CALC"
    dur: 10
    res_q: 3
    rc: 3
    rd: 0
    max_c: 3
  - id: 4
    name: "Order_Confirmation"
    sig: "ORD_CONF"
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 2
  - id: 5
    name: "Customer_Notification"
    sig: "CUST_NOTIF"
    dur: 5
    res_q: 4
    rc: 3
    rd: 2
    max_c: 4
  - id: 6
    name: "Warehouse_Allocation"
    sig: "WH_ALLOC"
    dur: 8
    res_q: 5
    rc: 0
    rd: 7
    max_c: 5
  - id: 7
    name: "Quality_Check"
    sig: "QC_CHK"
    dur: 5
    res_q: 5
    rc: 0
    rd: 0
    max_c: 2
  - id: 8
    name: "Final_Processing"
    sig: "FINAL_PROC"
    dur: 5
    res_q: 5
    rc: 3
    rd: 4
    max_c: 4
  - id: 9
    name: "Tax_Calculation"
    sig: "TAX_CALC"
    dur: 8
    res_q: 1
    rc: 0
    rd: 0
    max_c: 2
  - id: 10
    name: "Document_Generation"
    sig: "DOC_GEN"
    dur: 4
    res_q: 3
    rc: 1
    rd: 0
    max_c: 1
  - id: 11
    name: "Compliance_Check"
    sig: "COMP_CHK"
    dur: 6
    res_q: 5
    rc: 1
    rd: 0
    max_c: 4
  - id: 12
    name: "Archive_Processing"
    sig: "ARCH_PROC"
    dur: 10
    res_q: 1
    rc: 0
    rd: 10
    max_c: 1
  - id: 13
    name: "Security_Validation"
    sig: "SEC_VAL"
    dur: 7
    res_q: 3
    rc: 3
    rd: 5
    max_c: 4
  - id: 14
    name: "Performance_Monitor"
    sig: "PERF_MON"
    dur: 9
    res_q: 3
    rc: 3
    rd: 2
    max_c: 5
  - id: 15
    name: "Backup_Creation"
    sig: "BCK_CREA"
    dur: 7
    res_q: 4
    rc: 0
    rd: 12
    max_c: 3
  - id: 16
    name: "Report_Generation"
    sig: "RPT_GEN"
    dur: 8
    res_q: 4
    rc: 2
    rd: 0
    max_c: 5
  - id: 17
    name: "Data_Encryption"
    sig: "DATA_ENCR"
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 1
  - id: 18
    name: "Audit_Trail"
    sig: "AUD_TRL"
    dur: 7
    res_q: 2
    rc: 0
    rd: 0
    max_c: 2
  - id: 19
    name: "System_Cleanup"
    sig: "SYS_CLN"
    dur: 8
    res_q: 5
    rc: 0
    rd: 7
    max_c: 4
  - id: 20
    name: "Final_Validation"
    sig: "FINAL_VAL"
    dur: 8
    res_q: 1
    rc: 2
    rd: 15
    max_c: 4
  - id: 21
    name: "Risk_Assessment"
    sig: "RISK_ASMT"
    dur: 6
    res_q: 5
    rc: 0
    rd: 13
    max_c: 1
  - id: 22
    name: "Fraud_Detection"
    sig: "FRD_DET"
    dur: 6
    res_q: 1
    rc: 0
    rd: 5
    max_c: 2
  - id: 23
    name: "Currency_Conversion"
    sig: "CUR_CONV"
    dur: 3
    res_q: 5
    rc: 0
    rd: 0
    max_c: 2
  - id: 24
    name: "Price_Optimization"
    sig: "PRC_OPT"
    dur: 7
    res_q: 2
    rc: 3
    rd: 0
    max_c: 5
  - id: 25
    name: "Loyalty_Processing"
    sig: "LOY_PROC"
    dur: 3
    res_q: 3
    rc: 0
    rd: 0
    max_c: 4
  - id: 26
    name: "Return_Handling"
    sig: "RET_HDL"
    dur: 10
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4
  - id: 27
    name: "Refund_Processing"
    sig: "REF_PROC"
    dur: 5
    res_q: 5
    rc: 0
    rd: 16
    max_c: 3
  - id: 28
    name: "Product_Recommendation"
    sig: "PRD_REC"
    dur: 5
    res_q: 3
    rc: 2
    rd: 2
    max_c: 2
  - id: 29
    name: "Analytics_Update"
    sig: "ANLY_UPD"
    dur: 9
    res_q: 4
    rc: 0
    rd: 0
    max_c: 1
  - id: 30
    name: "Cache_Refresh"
    sig: "CACHE_REFR"
    dur: 6
    res_q: 5
    rc: 3
    rd: 13
    max_c: 2
  - id: 31
    name: "Log_Processing"
    sig: "LOG_PROC"
    dur: 4
    res_q: 2
    rc: 2
    rd: 1
    max_c: 5
  - id: 32
    name: "Error_Handling"
    sig: "ERR_HDL"
    dur: 4
    res_q: 1
    rc: 2
    rd: 4
    max_c: 5
  - id: 33
    name: "Load_Balancing"
    sig: "LOAD_BAL"
    dur: 3
    res_q: 4
    rc: 3
    rd: 0
    max_c: 3
  - id: 34
    name: "Database_Sync"
    sig: "DB_SYNC"
    dur: 3
    res_q: 5
    rc: 2
    rd: 0
    max_c: 4
  - id: 35
    name: "API_Validation"
    sig: "API_VAL"
    dur: 9
    res_q: 3
    rc: 3
    rd: 3
    max_c: 4
  - id: 36
    name: "Session_Management"
    sig: "SESS_MGT"
    dur: 5
    res_q: 3
    rc: 2
    rd: 0
    max_c: 1
  - id: 37
    name: "Email_Dispatch"
    sig: "EMAIL_DISP"
    dur: 7
    res_q: 5
    rc: 3
    rd: 0
    max_c: 3
  - id: 38
    name: "SMS_Notification"
    sig: "SMS_NOTIF"
    dur: 6
    res_q: 1
    rc: 0
    rd: 16
    max_c: 1
  - id: 39
    name: "Push_Notification"
    sig: "PUSH_NOTIF"
    dur: 3
    res_q: 4
    rc: 0
    rd: 10
    max_c: 4
  - id: 40
    name: "Webhook_Trigger"
    sig: "HOOK_TRIG"
    dur: 8
    res_q: 1
    rc: 0
    rd: 0
    max_c: 5
  - id: 41
    name: "Content_Moderation"
    sig: "CONT_MOD"
    dur: 7
    res_q: 3
    rc: 3
    rd: 0
    max_c: 5
  - id: 42
    name: "Image_Processing"
    sig: "IMG_PROC"
    dur: 8
    res_q: 5
    rc: 1
    rd: 12
    max_c: 2
  - id: 43
    name: "Video_Processing"
    sig: "VID_PROC"
    dur: 9
    res_q: 5
    rc: 3
    rd: 0
    max_c: 2
  - id: 44
    name: "File_Upload"
    sig: "FILE_UPL"
    dur: 8
    res_q: 5
    rc: 3
    rd: 0
    max_c: 3
  - id: 45
    name: "Metadata_Extraction"
    sig: "META_EXTR"
    dur: 7
    res_q: 5
    rc: 1
    rd: 12
    max_c: 2
  - id: 46
    name: "Search_Indexing"
    sig: "SRCH_IDX"
    dur: 4
    res_q: 2
    rc: 2
    rd: 5
    max_c: 1
  - id: 47
    name: "Recommendation_Engine"
    sig: "REC_ENG"
    dur: 6
    res_q: 5
    rc: 2
    rd: 0
    max_c: 5
  - id: 48
    name: "AB_Testing"
    sig: "AB_TEST"
    dur: 3
    res_q: 2
    rc: 2
    rd: 0
    max_c: 1

# Start-to-start constraints (unchanged)
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

