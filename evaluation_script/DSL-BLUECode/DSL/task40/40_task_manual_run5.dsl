# Global parameters
wsp:
  name: "40tasks"
  h_start: 0
  h_end: 490
  r_max: 230

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

# Start-to-start precedence constraints
start_constraints:
  # From Documento 12 / 1 – initial matrix
  - from: 1   # PAYMENT_VALIDATION
    to: 2     # INVENTORY_CHECK
    delay: 5
    wait_all: false

  - from: 2   # INVENTORY_CHECK
    to: 3     # SHIPPING_CALCULATION
    delay: 9
    wait_all: true

  - from: 1   # PAYMENT_VALIDATION
    to: 4     # ORDER_CONFIRMATION
    delay: 21
    wait_all: false

  - from: 2   # INVENTORY_CHECK
    to: 4     # ORDER_CONFIRMATION
    delay: 16
    wait_all: true

  - from: 3   # SHIPPING_CALCULATION
    to: 4     # ORDER_CONFIRMATION
    delay: 10
    wait_all: true

  - from: 4   # ORDER_CONFIRMATION
    to: 5     # CUSTOMER_NOTIFICATION
    delay: 12
    wait_all: false

  - from: 1   # PAYMENT_VALIDATION
    to: 6     # WAREHOUSE_ALLOCATION
    delay: 8
    wait_all: false

  # From Documento 7 / 3 – mid matrix (part 1)
  - from: 3   # SHIPPING_CALCULATION
    to: 6     # WAREHOUSE_ALLOCATION
    delay: 9
    wait_all: false

  - from: 1   # PAYMENT_VALIDATION
    to: 7     # QUALITY_CHECK
    delay: 7
    wait_all: false

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 7     # QUALITY_CHECK
    delay: 16
    wait_all: true

  - from: 7   # QUALITY_CHECK
    to: 8     # FINAL_PROCESSING
    delay: 10
    wait_all: true

  - from: 4   # ORDER_CONFIRMATION
    to: 9     # TAX_CALCULATION
    delay: 10
    wait_all: false

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 10    # DOCUMENT_GENERATION
    delay: 5
    wait_all: false

  - from: 4   # ORDER_CONFIRMATION
    to: 10    # DOCUMENT_GENERATION
    delay: 12
    wait_all: true

  - from: 3   # SHIPPING_CALCULATION
    to: 10    # DOCUMENT_GENERATION
    delay: 6
    wait_all: false

  - from: 3   # SHIPPING_CALCULATION
    to: 11    # COMPLIANCE_CHECK
    delay: 6
    wait_all: true

  - from: 4   # ORDER_CONFIRMATION
    to: 12    # ARCHIVE_PROCESSING
    delay: 7
    wait_all: true

  - from: 4   # ORDER_CONFIRMATION
    to: 13    # SECURITY_VALIDATION
    delay: 6
    wait_all: true

  - from: 7   # QUALITY_CHECK
    to: 13    # SECURITY_VALIDATION
    delay: 6
    wait_all: true

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 14    # PERFORMANCE_MONITOR
    delay: 6
    wait_all: true

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 14    # PERFORMANCE_MONITOR
    delay: 12
    wait_all: true

  - from: 9   # TAX_CALCULATION
    to: 14    # PERFORMANCE_MONITOR
    delay: 7
    wait_all: false

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 15    # BACKUP_CREATION
    delay: 7
    wait_all: false

  - from: 11  # COMPLIANCE_CHECK
    to: 15    # BACKUP_CREATION
    delay: 8
    wait_all: true

  - from: 13  # SECURITY_VALIDATION
    to: 15    # BACKUP_CREATION
    delay: 9
    wait_all: false

  - from: 1   # PAYMENT_VALIDATION
    to: 16    # REPORT_GENERATION
    delay: 14
    wait_all: true

  - from: 10  # DOCUMENT_GENERATION
    to: 16    # REPORT_GENERATION
    delay: 15
    wait_all: false

  - from: 15  # BACKUP_CREATION
    to: 17    # DATA_ENCRYPTION
    delay: 5
    wait_all: true

  - from: 14  # PERFORMANCE_MONITOR
    to: 17    # DATA_ENCRYPTION
    delay: 9
    wait_all: false

  - from: 16  # REPORT_GENERATION
    to: 18    # AUDIT_TRAIL
    delay: 8
    wait_all: true

  - from: 14  # PERFORMANCE_MONITOR
    to: 19    # SYSTEM_CLEANUP
    delay: 13
    wait_all: false

  - from: 16  # REPORT_GENERATION
    to: 19    # SYSTEM_CLEANUP
    delay: 10
    wait_all: false

  - from: 10  # DOCUMENT_GENERATION
    to: 20    # FINAL_VALIDATION
    delay: 14
    wait_all: true

  - from: 15  # BACKUP_CREATION
    to: 20    # FINAL_VALIDATION
    delay: 5
    wait_all: false

  - from: 16  # REPORT_GENERATION
    to: 21    # RISK_ASSESSMENT
    delay: 13
    wait_all: false

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 22    # FRAUD_DETECTION
    delay: 15
    wait_all: true

  # From Documento 9 / 5 – mid matrix (part 2)
  - from: 4   # ORDER_CONFIRMATION
    to: 22    # FRAUD_DETECTION
    delay: 9
    wait_all: true

  - from: 8   # FINAL_PROCESSING
    to: 22    # FRAUD_DETECTION
    delay: 8
    wait_all: false

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 23    # CURRENCY_CONVERSION
    delay: 14
    wait_all: false

  - from: 8   # FINAL_PROCESSING
    to: 23    # CURRENCY_CONVERSION
    delay: 16
    wait_all: false

  - from: 19  # SYSTEM_CLEANUP
    to: 24    # PRICE_OPTIMIZATION
    delay: 12
    wait_all: false

  - from: 16  # REPORT_GENERATION
    to: 24    # PRICE_OPTIMIZATION
    delay: 7
    wait_all: false

  - from: 17  # DATA_ENCRYPTION
    to: 24    # PRICE_OPTIMIZATION
    delay: 5
    wait_all: true

  - from: 18  # AUDIT_TRAIL
    to: 25    # LOYALTY_PROCESSING
    delay: 5
    wait_all: false

  - from: 25  # LOYALTY_PROCESSING
    to: 26    # RETURN_HANDLING
    delay: 8
    wait_all: true

  - from: 22  # FRAUD_DETECTION
    to: 27    # REFUND_PROCESSING
    delay: 5
    wait_all: true

  - from: 17  # DATA_ENCRYPTION
    to: 27    # REFUND_PROCESSING
    delay: 14
    wait_all: true

  - from: 12  # ARCHIVE_PROCESSING
    to: 28    # PRODUCT_RECOMMENDATION
    delay: 6
    wait_all: false

  - from: 13  # SECURITY_VALIDATION
    to: 29    # ANALYTICS_UPDATE
    delay: 10
    wait_all: false

  - from: 19  # SYSTEM_CLEANUP
    to: 29    # ANALYTICS_UPDATE
    delay: 10
    wait_all: true

  - from: 4   # ORDER_CONFIRMATION
    to: 29    # ANALYTICS_UPDATE
    delay: 7
    wait_all: false

  - from: 21  # RISK_ASSESSMENT
    to: 30    # CACHE_REFRESH
    delay: 16
    wait_all: false

  - from: 11  # COMPLIANCE_CHECK
    to: 30    # CACHE_REFRESH
    delay: 8
    wait_all: true

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 30    # CACHE_REFRESH
    delay: 11
    wait_all: false

  - from: 23  # CURRENCY_CONVERSION
    to: 31    # LOG_PROCESSING
    delay: 16
    wait_all: false

  - from: 30  # CACHE_REFRESH
    to: 31    # LOG_PROCESSING
    delay: 14
    wait_all: true

  - from: 21  # RISK_ASSESSMENT
    to: 31    # LOG_PROCESSING
    delay: 7
    wait_all: false

  - from: 31  # LOG_PROCESSING
    to: 32    # ERROR_HANDLING
    delay: 7
    wait_all: false

  - from: 23  # CURRENCY_CONVERSION
    to: 32    # ERROR_HANDLING
    delay: 16
    wait_all: true

  - from: 29  # ANALYTICS_UPDATE
    to: 32    # ERROR_HANDLING
    delay: 8
    wait_all: false

  - from: 24  # PRICE_OPTIMIZATION
    to: 33    # LOAD_BALANCING
    delay: 12
    wait_all: true

  - from: 28  # PRODUCT_RECOMMENDATION
    to: 33    # LOAD_BALANCING
    delay: 9
    wait_all: true

  - from: 29  # ANALYTICS_UPDATE
    to: 34    # DATABASE_SYNC
    delay: 9
    wait_all: true

  - from: 31  # LOG_PROCESSING
    to: 35    # API_VALIDATION
    delay: 7
    wait_all: false

  - from: 32  # ERROR_HANDLING
    to: 35    # API_VALIDATION
    delay: 12
    wait_all: false

  # From Documento 8 / 2 – final matrix
  - from: 34  # DATABASE_SYNC
    to: 35    # API_VALIDATION
    delay: 10
    wait_all: false

  - from: 15  # BACKUP_CREATION
    to: 36    # SESSION_MANAGEMENT
    delay: 7
    wait_all: false

  - from: 27  # REFUND_PROCESSING
    to: 37    # EMAIL_DISPATCH
    delay: 9
    wait_all: true

  - from: 29  # ANALYTICS_UPDATE
    to: 38    # SMS_NOTIFICATION
    delay: 10
    wait_all: true

  - from: 37  # EMAIL_DISPATCH
    to: 38    # SMS_NOTIFICATION
    delay: 11
    wait_all: true

  - from: 30  # CACHE_REFRESH
    to: 39    # PUSH_NOTIFICATION
    delay: 16
    wait_all: true

  - from: 34  # DATABASE_SYNC
    to: 39    # PUSH_NOTIFICATION
    delay: 11
    wait_all: true

  - from: 36  # SESSION_MANAGEMENT
    to: 39    # PUSH_NOTIFICATION
    delay: 14
    wait_all: false

  - from: 35  # API_VALIDATION
    to: 40    # WEBHOOK_TRIGGER
    delay: 8
    wait_all: true