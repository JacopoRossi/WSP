wsp:
  name: "40tasks"
  h_start: 0
  h_end: 490
  r_max: 230
  n_constraints: 63

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
    name: "Infrastructure_Service"
    tasks_set: [15, 19, 30, 31, 32, 33, 34]

  - id: 9
    name: "Recommendation_Service"
    tasks_set: [25, 28]

  - id: 10
    name: "Refund_Service"
    tasks_set: [27]

tasks:
  - id: 1
    name: "PAYMENT_VALIDATION"
    sig: "pay_val"
    service: 1
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4

  - id: 2
    name: "INVENTORY_CHECK"
    sig: "inv_chk"
    service: 2
    dur: 4
    res_q: 5
    rc: 3
    rd: 0
    max_c: 5

  - id: 3
    name: "SHIPPING_CALCULATION"
    sig: "ship_calc"
    service: 4
    dur: 10
    res_q: 3
    rc: 3
    rd: 0
    max_c: 3

  - id: 4
    name: "ORDER_CONFIRMATION"
    sig: "ord_conf"
    service: 3
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 2

  - id: 5
    name: "CUSTOMER_NOTIFICATION"
    sig: "cust_notif"
    service: 5
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 5

  - id: 6
    name: "WAREHOUSE_ALLOCATION"
    sig: "wh_alloc"
    service: 2
    dur: 4
    res_q: 1
    rc: 1
    rd: 0
    max_c: 1

  - id: 7
    name: "QUALITY_CHECK"
    sig: "qc_chk"
    service: 2
    dur: 3
    res_q: 4
    rc: 3
    rd: 0
    max_c: 5

  - id: 8
    name: "FINAL_PROCESSING"
    sig: "final_proc"
    service: 3
    dur: 9
    res_q: 4
    rc: 2
    rd: 0
    max_c: 5

  - id: 9
    name: "TAX_CALCULATION"
    sig: "tax_calc"
    service: 1
    dur: 5
    res_q: 3
    rc: 0
    rd: 0
    max_c: 1

  - id: 10
    name: "DOCUMENT_GENERATION"
    sig: "doc_gen"
    service: 3
    dur: 6
    res_q: 2
    rc: 3
    rd: 0
    max_c: 4

  - id: 11
    name: "COMPLIANCE_CHECK"
    sig: "comp_chk"
    service: 6
    dur: 4
    res_q: 3
    rc: 2
    rd: 7
    max_c: 1

  - id: 12
    name: "ARCHIVE_PROCESSING"
    sig: "arch_proc"
    service: 3
    dur: 6
    res_q: 1
    rc: 2
    rd: 0
    max_c: 4

  - id: 13
    name: "SECURITY_VALIDATION"
    sig: "sec_val"
    service: 6
    dur: 3
    res_q: 3
    rc: 0
    rd: 0
    max_c: 1

  - id: 14
    name: "PERFORMANCE_MONITOR"
    sig: "perf_mon"
    service: 7
    dur: 5
    res_q: 1
    rc: 0
    rd: 0
    max_c: 3

  - id: 15
    name: "BACKUP_CREATION"
    sig: "bck_crea"
    service: 8
    dur: 7
    res_q: 2
    rc: 1
    rd: 0
    max_c: 3

  - id: 16
    name: "REPORT_GENERATION"
    sig: "rpt_gen"
    service: 7
    dur: 4
    res_q: 1
    rc: 1
    rd: 0
    max_c: 3

  - id: 17
    name: "DATA_ENCRYPTION"
    sig: "data_encr"
    service: 6
    dur: 4
    res_q: 3
    rc: 3
    rd: 2
    max_c: 4

  - id: 18
    name: "AUDIT_TRAIL"
    sig: "aud_trl"
    service: 6
    dur: 10
    res_q: 5
    rc: 1
    rd: 0
    max_c: 4

  - id: 19
    name: "SYSTEM_CLEANUP"
    sig: "sys_cln"
    service: 8
    dur: 5
    res_q: 3
    rc: 0
    rd: 0
    max_c: 1

  - id: 20
    name: "FINAL_VALIDATION"
    sig: "final_val"
    service: 3
    dur: 4
    res_q: 2
    rc: 3
    rd: 0
    max_c: 1

  - id: 21
    name: "RISK_ASSESSMENT"
    sig: "risk_asmt"
    service: 1
    dur: 3
    res_q: 2
    rc: 0
    rd: 0
    max_c: 3

  - id: 22
    name: "FRAUD_DETECTION"
    sig: "frd_det"
    service: 1
    dur: 9
    res_q: 2
    rc: 0
    rd: 0
    max_c: 5

  - id: 23
    name: "CURRENCY_CONVERSION"
    sig: "cur_conv"
    service: 1
    dur: 9
    res_q: 2
    rc: 1
    rd: 0
    max_c: 4

  - id: 24
    name: "PRICE_OPTIMIZATION"
    sig: "prc_opt"
    service: 1
    dur: 8
    res_q: 3
    rc: 0
    rd: 11
    max_c: 1

  - id: 25
    name: "LOYALTY_PROCESSING"
    sig: "loy_proc"
    service: 9
    dur: 3
    res_q: 2
    rc: 0
    rd: 1
    max_c: 4

  - id: 26
    name: "RETURN_HANDLING"
    sig: "ret_hdl"
    service: 2
    dur: 4
    res_q: 4
    rc: 1
    rd: 0
    max_c: 3

  - id: 27
    name: "REFUND_PROCESSING"
    sig: "ref_proc"
    service: 10
    dur: 4
    res_q: 5
    rc: 2
    rd: 0
    max_c: 3

  - id: 28
    name: "PRODUCT_RECOMMENDATION"
    sig: "prd_rec"
    service: 9
    dur: 6
    res_q: 3
    rc: 3
    rd: 0
    max_c: 5

  - id: 29
    name: "ANALYTICS_UPDATE"
    sig: "anly_upd"
    service: 7
    dur: 6
    res_q: 4
    rc: 1
    rd: 15
    max_c: 2

  - id: 30
    name: "CACHE_REFRESH"
    sig: "cache_refr"
    service: 8
    dur: 6
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 31
    name: "LOG_PROCESSING"
    sig: "log_proc"
    service: 8
    dur: 6
    res_q: 5
    rc: 1
    rd: 0
    max_c: 3

  - id: 32
    name: "ERROR_HANDLING"
    sig: "err_hdl"
    service: 8
    dur: 3
    res_q: 4
    rc: 1
    rd: 0
    max_c: 2

  - id: 33
    name: "LOAD_BALANCING"
    sig: "load_bal"
    service: 8
    dur: 6
    res_q: 4
    rc: 2
    rd: 0
    max_c: 2

  - id: 34
    name: "DATABASE_SYNC"
    sig: "db_sync"
    service: 8
    dur: 7
    res_q: 1
    rc: 0
    rd: 0
    max_c: 5

  - id: 35
    name: "API_VALIDATION"
    sig: "api_val"
    service: 6
    dur: 9
    res_q: 3
    rc: 2
    rd: 2
    max_c: 5

  - id: 36
    name: "SESSION_MANAGEMENT"
    sig: "sess_mgt"
    service: 6
    dur: 4
    res_q: 5
    rc: 0
    rd: 12
    max_c: 1

  - id: 37
    name: "EMAIL_DISPATCH"
    sig: "email_disp"
    service: 5
    dur: 3
    res_q: 4
    rc: 0
    rd: 0
    max_c: 3

  - id: 38
    name: "SMS_NOTIFICATION"
    sig: "sms_notif"
    service: 5
    dur: 7
    res_q: 3
    rc: 2
    rd: 10
    max_c: 3

  - id: 39
    name: "PUSH_NOTIFICATION"
    sig: "push_notif"
    service: 5
    dur: 10
    res_q: 3
    rc: 0
    rd: 0
    max_c: 2

  - id: 40
    name: "WEBHOOK_TRIGGER"
    sig: "hook_trig"
    service: 5
    dur: 5
    res_q: 5
    rc: 0
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
    delay: 12
    wait_all: false

  - from: 1
    to: 6
    delay: 8
    wait_all: false

  - from: 3
    to: 6
    delay: 9
    wait_all: false

  - from: 1
    to: 7
    delay: 7
    wait_all: false

  - from: 6
    to: 7
    delay: 16
    wait_all: true

  - from: 7
    to: 8
    delay: 10
    wait_all: true

  - from: 4
    to: 9
    delay: 10
    wait_all: false

  - from: 6
    to: 10
    delay: 5
    wait_all: false

  - from: 4
    to: 10
    delay: 12
    wait_all: true

  - from: 3
    to: 10
    delay: 6
    wait_all: false

  - from: 3
    to: 11
    delay: 6
    wait_all: true

  - from: 4
    to: 12
    delay: 7
    wait_all: true

  - from: 4
    to: 13
    delay: 6
    wait_all: true

  - from: 7
    to: 13
    delay: 6
    wait_all: true

  - from: 6
    to: 14
    delay: 6
    wait_all: true

  - from: 5
    to: 14
    delay: 12
    wait_all: true

  - from: 9
    to: 14
    delay: 7
    wait_all: false

  - from: 5
    to: 15
    delay: 7
    wait_all: false

  - from: 11
    to: 15
    delay: 8
    wait_all: true

  - from: 13
    to: 15
    delay: 9
    wait_all: false

  - from: 1
    to: 16
    delay: 14
    wait_all: true

  - from: 10
    to: 16
    delay: 15
    wait_all: false

  - from: 15
    to: 17
    delay: 5
    wait_all: true

  - from: 14
    to: 17
    delay: 9
    wait_all: false

  - from: 16
    to: 18
    delay: 8
    wait_all: true

  - from: 14
    to: 19
    delay: 13
    wait_all: false

  - from: 16
    to: 19
    delay: 10
    wait_all: false

  - from: 10
    to: 20
    delay: 14
    wait_all: true

  - from: 15
    to: 20
    delay: 5
    wait_all: false

  - from: 16
    to: 21
    delay: 13
    wait_all: false

  - from: 6
    to: 22
    delay: 15
    wait_all: true

  - from: 4
    to: 22
    delay: 9
    wait_all: true

  - from: 8
    to: 22
    delay: 8
    wait_all: false

  - from: 6
    to: 23
    delay: 14
    wait_all: false

  - from: 8
    to: 23
    delay: 16
    wait_all: false

  - from: 19
    to: 24
    delay: 12
    wait_all: false

  - from: 16
    to: 24
    delay: 7
    wait_all: false

  - from: 17
    to: 24
    delay: 5
    wait_all: true

  - from: 18
    to: 25
    delay: 5
    wait_all: false

  - from: 25
    to: 26
    delay: 8
    wait_all: true

  - from: 22
    to: 27
    delay: 5
    wait_all: true

  - from: 17
    to: 27
    delay: 14
    wait_all: true

  - from: 12
    to: 28
    delay: 6
    wait_all: false

  - from: 13
    to: 29
    delay: 10
    wait_all: false

  - from: 19
    to: 29
    delay: 10
    wait_all: true

  - from: 4
    to: 29
    delay: 7
    wait_all: false

  - from: 21
    to: 30
    delay: 16
    wait_all: false

  - from: 11
    to: 30
    delay: 8
    wait_all: true

  - from: 6
    to: 30
    delay: 11
    wait_all: false

  - from: 23
    to: 31
    delay: 16
    wait_all: false

  - from: 30
    to: 31
    delay: 14
    wait_all: true

  - from: 21
    to: 31
    delay: 7
    wait_all: false

  - from: 31
    to: 32
    delay: 7
    wait_all: false

  - from: 23
    to: 32
    delay: 16
    wait_all: true

  - from: 29
    to: 32
    delay: 8
    wait_all: false

  - from: 24
    to: 33
    delay: 12
    wait_all: true

  - from: 28
    to: 33
    delay: 9
    wait_all: true

  - from: 29
    to: 34
    delay: 9
    wait_all: true

  - from: 31
    to: 35
    delay: 7
    wait_all: false

  - from: 32
    to: 35
    delay: 12
    wait_all: false

  - from: 34
    to: 35
    delay: 10
    wait_all: false

  - from: 15
    to: 36
    delay: 7
    wait_all: false

  - from: 27
    to: 37
    delay: 9
    wait_all: true

  - from: 29
    to: 38
    delay: 10
    wait_all: true

  - from: 37
    to: 38
    delay: 11
    wait_all: true

  - from: 30
    to: 39
    delay: 16
    wait_all: true

  - from: 34
    to: 39
    delay: 11
    wait_all: true

  - from: 36
    to: 39
    delay: 14
    wait_all: false

  - from: 35
    to: 40
    delay: 8
    wait_all: true