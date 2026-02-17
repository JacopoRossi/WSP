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
    name: "PAYMENT_VALIDATION"
    sig: "pay_val"
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4

  - id: 2
    name: "INVENTORY_CHECK"
    sig: "inv_chk"
    dur: 4
    res_q: 5
    rc: 3
    rd: 0
    max_c: 5

  - id: 3
    name: "SHIPPING_CALCULATION"
    sig: "ship_calc"
    dur: 10
    res_q: 3
    rc: 3
    rd: 0
    max_c: 3

  - id: 4
    name: "ORDER_CONFIRMATION"
    sig: "ord_conf"
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 2

  - id: 5
    name: "CUSTOMER_NOTIFICATION"
    sig: "cust_notif"
    dur: 9
    res_q: 5
    rc: 3
    rd: 0
    max_c: 5

  - id: 6
    name: "WAREHOUSE_ALLOCATION"
    sig: "wh_alloc"
    dur: 7
    res_q: 1
    rc: 0
    rd: 0
    max_c: 3

  - id: 7
    name: "QUALITY_CHECK"
    sig: "qc_chk"
    dur: 8
    res_q: 3
    rc: 0
    rd: 0
    max_c: 2

  - id: 8
    name: "FINAL_PROCESSING"
    sig: "final_proc"
    dur: 9
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

  - id: 9
    name: "TAX_CALCULATION"
    sig: "tax_calc"
    dur: 6
    res_q: 4
    rc: 2
    rd: 0
    max_c: 3

  - id: 10
    name: "DOCUMENT_GENERATION"
    sig: "doc_gen"
    dur: 5
    res_q: 3
    rc: 1
    rd: 10
    max_c: 5

  - id: 11
    name: "COMPLIANCE_CHECK"
    sig: "comp_chk"
    dur: 4
    res_q: 1
    rc: 0
    rd: 0
    max_c: 5

  - id: 12
    name: "ARCHIVE_PROCESSING"
    sig: "arch_proc"
    dur: 3
    res_q: 1
    rc: 1
    rd: 0
    max_c: 4

  - id: 13
    name: "SECURITY_VALIDATION"
    sig: "sec_val"
    dur: 10
    res_q: 5
    rc: 2
    rd: 0
    max_c: 3

  - id: 14
    name: "PERFORMANCE_MONITOR"
    sig: "perf_mon"
    dur: 6
    res_q: 5
    rc: 0
    rd: 0
    max_c: 4

  - id: 15
    name: "BACKUP_CREATION"
    sig: "bck_crea"
    dur: 4
    res_q: 3
    rc: 3
    rd: 0
    max_c: 5

  - id: 16
    name: "REPORT_GENERATION"
    sig: "rpt_gen"
    dur: 7
    res_q: 1
    rc: 0
    rd: 0
    max_c: 5

  - id: 17
    name: "DATA_ENCRYPTION"
    sig: "data_encr"
    dur: 3
    res_q: 1
    rc: 0
    rd: 0
    max_c: 2

  - id: 18
    name: "AUDIT_TRAIL"
    sig: "aud_trl"
    dur: 5
    res_q: 3
    rc: 1
    rd: 0
    max_c: 1

  - id: 19
    name: "SYSTEM_CLEANUP"
    sig: "sys_cln"
    dur: 3
    res_q: 4
    rc: 2
    rd: 0
    max_c: 2

  - id: 20
    name: "FINAL_VALIDATION"
    sig: "final_val"
    dur: 9
    res_q: 5
    rc: 0
    rd: 11
    max_c: 1

  - id: 21
    name: "RISK_ASSESSMENT"
    sig: "risk_asmt"
    dur: 9
    res_q: 1
    rc: 2
    rd: 0
    max_c: 4

  - id: 22
    name: "FRAUD_DETECTION"
    sig: "frd_det"
    dur: 4
    res_q: 3
    rc: 3
    rd: 0
    max_c: 5

  - id: 23
    name: "CURRENCY_CONVERSION"
    sig: "cur_conv"
    dur: 9
    res_q: 4
    rc: 1
    rd: 0
    max_c: 4

  - id: 24
    name: "PRICE_OPTIMIZATION"
    sig: "prc_opt"
    dur: 3
    res_q: 3
    rc: 0
    rd: 14
    max_c: 3

  - id: 25
    name: "LOYALTY_PROCESSING"
    sig: "loy_proc"
    dur: 4
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4

  - id: 26
    name: "RETURN_HANDLING"
    sig: "ret_hdl"
    dur: 9
    res_q: 5
    rc: 0
    rd: 0
    max_c: 3

  - id: 27
    name: "REFUND_PROCESSING"
    sig: "ref_proc"
    dur: 8
    res_q: 2
    rc: 1
    rd: 0
    max_c: 1

  - id: 28
    name: "PRODUCT_RECOMMENDATION"
    sig: "prd_rec"
    dur: 4
    res_q: 5
    rc: 3
    rd: 0
    max_c: 3

# Start-to-start precedence constraints
start_constraints:
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

  - from: 2   # INVENTORY_CHECK
    to: 5     # CUSTOMER_NOTIFICATION
    delay: 6
    wait_all: true

  - from: 1   # PAYMENT_VALIDATION
    to: 5     # CUSTOMER_NOTIFICATION
    delay: 9
    wait_all: true

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 6     # WAREHOUSE_ALLOCATION
    delay: 7
    wait_all: true

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 7     # QUALITY_CHECK
    delay: 12
    wait_all: false

  - from: 7   # QUALITY_CHECK
    to: 8     # FINAL_PROCESSING
    delay: 15
    wait_all: false

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 8     # FINAL_PROCESSING
    delay: 15
    wait_all: false

  - from: 4   # ORDER_CONFIRMATION
    to: 8     # FINAL_PROCESSING
    delay: 7
    wait_all: false

  - from: 8   # FINAL_PROCESSING
    to: 9     # TAX_CALCULATION
    delay: 12
    wait_all: false

  - from: 7   # QUALITY_CHECK
    to: 10    # DOCUMENT_GENERATION
    delay: 6
    wait_all: false

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 10    # DOCUMENT_GENERATION
    delay: 12
    wait_all: false

  - from: 7   # QUALITY_CHECK
    to: 11    # COMPLIANCE_CHECK
    delay: 6
    wait_all: true

  - from: 10  # DOCUMENT_GENERATION
    to: 12    # ARCHIVE_PROCESSING
    delay: 13
    wait_all: true

  - from: 7   # QUALITY_CHECK
    to: 12    # ARCHIVE_PROCESSING
    delay: 12
    wait_all: true

  - from: 8   # FINAL_PROCESSING
    to: 12    # ARCHIVE_PROCESSING
    delay: 10
    wait_all: false

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 13    # SECURITY_VALIDATION
    delay: 10
    wait_all: true

  - from: 8   # FINAL_PROCESSING
    to: 13    # SECURITY_VALIDATION
    delay: 13
    wait_all: true

  - from: 12  # ARCHIVE_PROCESSING
    to: 13    # SECURITY_VALIDATION
    delay: 5
    wait_all: true

  - from: 13  # SECURITY_VALIDATION
    to: 14    # PERFORMANCE_MONITOR
    delay: 14
    wait_all: true

  - from: 10  # DOCUMENT_GENERATION
    to: 14    # PERFORMANCE_MONITOR
    delay: 10
    wait_all: false

  - from: 12  # ARCHIVE_PROCESSING
    to: 14    # PERFORMANCE_MONITOR
    delay: 9
    wait_all: false

  - from: 11  # COMPLIANCE_CHECK
    to: 15    # BACKUP_CREATION
    delay: 5
    wait_all: false

  - from: 10  # DOCUMENT_GENERATION
    to: 15    # BACKUP_CREATION
    delay: 6
    wait_all: false

  - from: 14  # PERFORMANCE_MONITOR
    to: 16    # REPORT_GENERATION
    delay: 9
    wait_all: false

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 17    # DATA_ENCRYPTION
    delay: 14
    wait_all: true

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 17    # DATA_ENCRYPTION
    delay: 10
    wait_all: false

  - from: 2   # INVENTORY_CHECK
    to: 17    # DATA_ENCRYPTION
    delay: 15
    wait_all: false

  - from: 11  # COMPLIANCE_CHECK
    to: 18    # AUDIT_TRAIL
    delay: 9
    wait_all: false

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 19    # SYSTEM_CLEANUP
    delay: 15
    wait_all: false

  - from: 17  # DATA_ENCRYPTION
    to: 19    # SYSTEM_CLEANUP
    delay: 13
    wait_all: false

  - from: 3   # SHIPPING_CALCULATION
    to: 19    # SYSTEM_CLEANUP
    delay: 5
    wait_all: false

  - from: 15  # BACKUP_CREATION
    to: 20    # FINAL_VALIDATION
    delay: 12
    wait_all: true

  - from: 14  # PERFORMANCE_MONITOR
    to: 20    # FINAL_VALIDATION
    delay: 8
    wait_all: true

  - from: 14  # PERFORMANCE_MONITOR
    to: 21    # RISK_ASSESSMENT
    delay: 13
    wait_all: true

  - from: 16  # REPORT_GENERATION
    to: 22    # FRAUD_DETECTION
    delay: 7
    wait_all: true

  - from: 18  # AUDIT_TRAIL
    to: 22    # FRAUD_DETECTION
    delay: 7
    wait_all: true

  - from: 17  # DATA_ENCRYPTION
    to: 22    # FRAUD_DETECTION
    delay: 16
    wait_all: false

  - from: 18  # AUDIT_TRAIL
    to: 23    # CURRENCY_CONVERSION
    delay: 12
    wait_all: false

  - from: 8   # FINAL_PROCESSING
    to: 24    # PRICE_OPTIMIZATION
    delay: 12
    wait_all: true

  - from: 18  # AUDIT_TRAIL
    to: 24    # PRICE_OPTIMIZATION
    delay: 10
    wait_all: false

  - from: 10  # DOCUMENT_GENERATION
    to: 24    # PRICE_OPTIMIZATION
    delay: 12
    wait_all: false

  - from: 23  # CURRENCY_CONVERSION
    to: 25    # LOYALTY_PROCESSING
    delay: 8
    wait_all: true

  - from: 18  # AUDIT_TRAIL
    to: 25    # LOYALTY_PROCESSING
    delay: 9
    wait_all: true

  - from: 23  # CURRENCY_CONVERSION
    to: 26    # RETURN_HANDLING
    delay: 16
    wait_all: true

  - from: 22  # FRAUD_DETECTION
    to: 26    # RETURN_HANDLING
    delay: 9
    wait_all: true

  - from: 18  # AUDIT_TRAIL
    to: 26    # RETURN_HANDLING
    delay: 7
    wait_all: false

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 27    # REFUND_PROCESSING
    delay: 6
    wait_all: true

  - from: 14  # PERFORMANCE_MONITOR
    to: 27    # REFUND_PROCESSING
    delay: 12
    wait_all: false

  - from: 26  # RETURN_HANDLING
    to: 28    # PRODUCT_RECOMMENDATION
    delay: 13
    wait_all: false