# Global parameters
wsp:
  name: "24tasks"
  h_start: 0
  h_end: 390
  r_max: 190

# Service definitions
services:
  - id: 1
    name: "Payment_Service"
    tasks_set: [1, 9, 21, 22, 23, 24]

  - id: 2
    name: "Inventory_Service"
    tasks_set: [2, 6, 7]

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
    dur: 10
    res_q: 1
    rc: 0
    rd: 9
    max_c: 4

  - id: 6
    name: "WAREHOUSE_ALLOCATION"
    sig: "wh_alloc"
    dur: 10
    res_q: 4
    rc: 1
    rd: 0
    max_c: 1

  - id: 7
    name: "QUALITY_CHECK"
    sig: "qc_chk"
    dur: 7
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4

  - id: 8
    name: "FINAL_PROCESSING"
    sig: "final_proc"
    dur: 10
    res_q: 1
    rc: 3
    rd: 1
    max_c: 2

  - id: 9
    name: "TAX_CALCULATION"
    sig: "tax_calc"
    dur: 5
    res_q: 5
    rc: 1
    rd: 0
    max_c: 2

  - id: 10
    name: "DOCUMENT_GENERATION"
    sig: "doc_gen"
    dur: 4
    res_q: 5
    rc: 2
    rd: 7
    max_c: 5

  - id: 11
    name: "COMPLIANCE_CHECK"
    sig: "comp_chk"
    dur: 9
    res_q: 4
    rc: 2
    rd: 0
    max_c: 5

  - id: 12
    name: "ARCHIVE_PROCESSING"
    sig: "arch_proc"
    dur: 9
    res_q: 3
    rc: 3
    rd: 1
    max_c: 5

  - id: 13
    name: "SECURITY_VALIDATION"
    sig: "sec_val"
    dur: 4
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 14
    name: "PERFORMANCE_MONITOR"
    sig: "perf_mon"
    dur: 5
    res_q: 2
    rc: 0
    rd: 2
    max_c: 2

  - id: 15
    name: "BACKUP_CREATION"
    sig: "bck_crea"
    dur: 3
    res_q: 4
    rc: 2
    rd: 15
    max_c: 3

  - id: 16
    name: "REPORT_GENERATION"
    sig: "rpt_gen"
    dur: 3
    res_q: 2
    rc: 1
    rd: 9
    max_c: 4

  - id: 17
    name: "DATA_ENCRYPTION"
    sig: "data_encr"
    dur: 4
    res_q: 2
    rc: 1
    rd: 6
    max_c: 4

  - id: 18
    name: "AUDIT_TRAIL"
    sig: "aud_trl"
    dur: 4
    res_q: 5
    rc: 0
    rd: 4
    max_c: 3

  - id: 19
    name: "SYSTEM_CLEANUP"
    sig: "sys_cln"
    dur: 5
    res_q: 1
    rc: 0
    rd: 0
    max_c: 3

  - id: 20
    name: "FINAL_VALIDATION"
    sig: "final_val"
    dur: 7
    res_q: 4
    rc: 0
    rd: 0
    max_c: 3

  - id: 21
    name: "RISK_ASSESSMENT"
    sig: "risk_asmt"
    dur: 9
    res_q: 3
    rc: 3
    rd: 15
    max_c: 4

  - id: 22
    name: "FRAUD_DETECTION"
    sig: "frd_det"
    dur: 4
    res_q: 5
    rc: 0
    rd: 0
    max_c: 3

  - id: 23
    name: "CURRENCY_CONVERSION"
    sig: "cur_conv"
    dur: 7
    res_q: 1
    rc: 0
    rd: 0
    max_c: 5

  - id: 24
    name: "PRICE_OPTIMIZATION"
    sig: "prc_opt"
    dur: 3
    res_q: 3
    rc: 3
    rd: 0
    max_c: 2

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

  - from: 4   # ORDER_CONFIRMATION
    to: 5     # CUSTOMER_NOTIFICATION
    delay: 7
    wait_all: false

  - from: 2   # INVENTORY_CHECK
    to: 5     # CUSTOMER_NOTIFICATION
    delay: 15
    wait_all: false

  - from: 4   # ORDER_CONFIRMATION
    to: 6     # WAREHOUSE_ALLOCATION
    delay: 10
    wait_all: false

  - from: 3   # SHIPPING_CALCULATION
    to: 7     # QUALITY_CHECK
    delay: 7
    wait_all: false

  - from: 1   # PAYMENT_VALIDATION
    to: 7     # QUALITY_CHECK
    delay: 11
    wait_all: false

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 8     # FINAL_PROCESSING
    delay: 13
    wait_all: true

  - from: 4   # ORDER_CONFIRMATION
    to: 8     # FINAL_PROCESSING
    delay: 12
    wait_all: true

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 9     # TAX_CALCULATION
    delay: 6
    wait_all: false

  - from: 3   # SHIPPING_CALCULATION
    to: 9     # TAX_CALCULATION
    delay: 13
    wait_all: true

  - from: 9   # TAX_CALCULATION
    to: 10    # DOCUMENT_GENERATION
    delay: 5
    wait_all: true

  - from: 8   # FINAL_PROCESSING
    to: 10    # DOCUMENT_GENERATION
    delay: 13
    wait_all: false

  - from: 4   # ORDER_CONFIRMATION
    to: 10    # DOCUMENT_GENERATION
    delay: 14
    wait_all: false

  - from: 8   # FINAL_PROCESSING
    to: 11    # COMPLIANCE_CHECK
    delay: 9
    wait_all: true

  - from: 1   # PAYMENT_VALIDATION
    to: 11    # COMPLIANCE_CHECK
    delay: 9
    wait_all: false

  - from: 4   # ORDER_CONFIRMATION
    to: 11    # COMPLIANCE_CHECK
    delay: 16
    wait_all: false

  - from: 1   # PAYMENT_VALIDATION
    to: 12    # ARCHIVE_PROCESSING
    delay: 15
    wait_all: true

  - from: 3   # SHIPPING_CALCULATION
    to: 13    # SECURITY_VALIDATION
    delay: 5
    wait_all: false

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 13    # SECURITY_VALIDATION
    delay: 6
    wait_all: true

  - from: 9   # TAX_CALCULATION
    to: 13    # SECURITY_VALIDATION
    delay: 6
    wait_all: false

  - from: 11  # COMPLIANCE_CHECK
    to: 14    # PERFORMANCE_MONITOR
    delay: 7
    wait_all: false

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 15    # BACKUP_CREATION
    delay: 9
    wait_all: false

  - from: 9   # TAX_CALCULATION
    to: 15    # BACKUP_CREATION
    delay: 12
    wait_all: false

  - from: 12  # ARCHIVE_PROCESSING
    to: 15    # BACKUP_CREATION
    delay: 8
    wait_all: false

  - from: 3   # SHIPPING_CALCULATION
    to: 16    # REPORT_GENERATION
    delay: 14
    wait_all: true

  - from: 7   # QUALITY_CHECK
    to: 16    # REPORT_GENERATION
    delay: 6
    wait_all: false

  - from: 4   # ORDER_CONFIRMATION
    to: 16    # REPORT_GENERATION
    delay: 11
    wait_all: false

  - from: 9   # TAX_CALCULATION
    to: 17    # DATA_ENCRYPTION
    delay: 9
    wait_all: false

  - from: 14  # PERFORMANCE_MONITOR
    to: 17    # DATA_ENCRYPTION
    delay: 14
    wait_all: false

  - from: 1   # PAYMENT_VALIDATION
    to: 17    # DATA_ENCRYPTION
    delay: 7
    wait_all: false

  - from: 16  # REPORT_GENERATION
    to: 18    # AUDIT_TRAIL
    delay: 13
    wait_all: false

  - from: 12  # ARCHIVE_PROCESSING
    to: 18    # AUDIT_TRAIL
    delay: 12
    wait_all: false

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 18    # AUDIT_TRAIL
    delay: 8
    wait_all: true

  - from: 13  # SECURITY_VALIDATION
    to: 19    # SYSTEM_CLEANUP
    delay: 5
    wait_all: false

  - from: 8   # FINAL_PROCESSING
    to: 19    # SYSTEM_CLEANUP
    delay: 16
    wait_all: false

  - from: 14  # PERFORMANCE_MONITOR
    to: 19    # SYSTEM_CLEANUP
    delay: 16
    wait_all: false

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 20    # FINAL_VALIDATION
    delay: 5
    wait_all: true

  - from: 16  # REPORT_GENERATION
    to: 20    # FINAL_VALIDATION
    delay: 13
    wait_all: false

  - from: 15  # BACKUP_CREATION
    to: 21    # RISK_ASSESSMENT
    delay: 6
    wait_all: false

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 22    # FRAUD_DETECTION
    delay: 11
    wait_all: true

  - from: 16  # REPORT_GENERATION
    to: 23    # CURRENCY_CONVERSION
    delay: 9
    wait_all: false

  - from: 23  # CURRENCY_CONVERSION
    to: 24    # PRICE_OPTIMIZATION
    delay: 6
    wait_all: false

  - from: 13  # SECURITY_VALIDATION
    to: 24    # PRICE_OPTIMIZATION
    delay: 15
    wait_all: false

  - from: 21  # RISK_ASSESSMENT
    to: 24    # PRICE_OPTIMIZATION
    delay: 10
    wait_all: false