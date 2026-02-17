wsp:
  name: "BizFlow20"
  h_start: 0
  h_end: 330
  r_max: 170

# Service definitions
services:
  - id: 1
    name: "Payment_Service"
    tasks_set: [1, 9]

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
    service_id: 1
    dur: 5
    res_q: 4
    max_c: 4
    rc: 0
    rd: 0

  - id: 2
    name: "INVENTORY_CHECK"
    sig: "inv_chk"
    service_id: 2
    dur: 4
    res_q: 5
    max_c: 5
    rc: 3
    rd: 0

  - id: 3
    name: "SHIPPING_CALCULATION"
    sig: "ship_calc"
    service_id: 4
    dur: 10
    res_q: 3
    max_c: 3
    rc: 3
    rd: 0

  - id: 4
    name: "ORDER_CONFIRMATION"
    sig: "ord_conf"
    service_id: 3
    dur: 8
    res_q: 2
    max_c: 2
    rc: 0
    rd: 0

  - id: 5
    name: "CUSTOMER_NOTIFICATION"
    sig: "cust_notif"
    service_id: 5
    dur: 10
    res_q: 2
    max_c: 5
    rc: 0
    rd: 0

  - id: 6
    name: "WAREHOUSE_ALLOCATION"
    sig: "wh_alloc"
    service_id: 2
    dur: 8
    res_q: 1
    max_c: 2
    rc: 0
    rd: 9

  - id: 7
    name: "QUALITY_CHECK"
    sig: "qc_chk"
    service_id: 2
    dur: 6
    res_q: 2
    max_c: 2
    rc: 0
    rd: 0

  - id: 8
    name: "FINAL_PROCESSING"
    sig: "final_proc"
    service_id: 3
    dur: 10
    res_q: 5
    max_c: 4
    rc: 0
    rd: 0

  - id: 9
    name: "TAX_CALCULATION"
    sig: "tax_calc"
    service_id: 1
    dur: 6
    res_q: 4
    max_c: 2
    rc: 2
    rd: 0

  - id: 10
    name: "DOCUMENT_GENERATION"
    sig: "doc_gen"
    service_id: 3
    dur: 5
    res_q: 1
    max_c: 2
    rc: 0
    rd: 0

  - id: 11
    name: "COMPLIANCE_CHECK"
    sig: "comp_chk"
    service_id: 6
    dur: 5
    res_q: 5
    max_c: 5
    rc: 2
    rd: 0

  - id: 12
    name: "ARCHIVE_PROCESSING"
    sig: "arch_proc"
    service_id: 3
    dur: 6
    res_q: 1
    max_c: 4
    rc: 2
    rd: 0

  - id: 13
    name: "SECURITY_VALIDATION"
    sig: "sec_val"
    service_id: 6
    dur: 8
    res_q: 4
    max_c: 4
    rc: 3
    rd: 16

  - id: 14
    name: "PERFORMANCE_MONITOR"
    sig: "perf_mon"
    service_id: 7
    dur: 10
    res_q: 2
    max_c: 3
    rc: 2
    rd: 0

  - id: 15
    name: "BACKUP_CREATION"
    sig: "bck_crea"
    service_id: 8
    dur: 6
    res_q: 3
    max_c: 2
    rc: 3
    rd: 0

  - id: 16
    name: "REPORT_GENERATION"
    sig: "rpt_gen"
    service_id: 7
    dur: 7
    res_q: 4
    max_c: 2
    rc: 0
    rd: 9

  - id: 17
    name: "DATA_ENCRYPTION"
    sig: "data_encr"
    service_id: 6
    dur: 7
    res_q: 3
    max_c: 2
    rc: 1
    rd: 2

  - id: 18
    name: "AUDIT_TRAIL"
    sig: "aud_trl"
    service_id: 6
    dur: 5
    res_q: 2
    max_c: 2
    rc: 2
    rd: 4

  - id: 19
    name: "SYSTEM_CLEANUP"
    sig: "sys_cln"
    service_id: 8
    dur: 4
    res_q: 4
    max_c: 5
    rc: 2
    rd: 0

  - id: 20
    name: "FINAL_VALIDATION"
    sig: "final_val"
    service_id: 3
    dur: 10
    res_q: 4
    max_c: 4
    rc: 0
    rd: 0

# Start-to-start precedence constraints
start_constraints:
  # --- Dependency Matrix 1 (high-level initial flow) ---
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

  # --- Dependency Matrix 2 (customer notification, inventory, order, tax, etc.) ---
  - from: 1   # PAYMENT_VALIDATION
    to: 5     # CUSTOMER_NOTIFICATION
    delay: 5
    wait_all: false

  - from: 3   # SHIPPING_CALCULATION
    to: 5     # CUSTOMER_NOTIFICATION
    delay: 9
    wait_all: false

  - from: 2   # INVENTORY_CHECK
    to: 5     # CUSTOMER_NOTIFICATION
    delay: 11
    wait_all: true

  - from: 4   # ORDER_CONFIRMATION
    to: 5     # CUSTOMER_NOTIFICATION
    delay: 12
    wait_all: true

  - from: 4   # ORDER_CONFIRMATION
    to: 6     # WAREHOUSE_ALLOCATION
    delay: 11
    wait_all: false

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 6     # WAREHOUSE_ALLOCATION
    delay: 15
    wait_all: false

  - from: 1   # PAYMENT_VALIDATION
    to: 6     # WAREHOUSE_ALLOCATION
    delay: 16
    wait_all: true

  - from: 2   # INVENTORY_CHECK
    to: 7     # QUALITY_CHECK
    delay: 14
    wait_all: true

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 7     # QUALITY_CHECK
    delay: 6
    wait_all: false

  - from: 1   # PAYMENT_VALIDATION
    to: 7     # QUALITY_CHECK
    delay: 7
    wait_all: false

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 7     # QUALITY_CHECK
    delay: 7
    wait_all: true

  - from: 4   # ORDER_CONFIRMATION
    to: 8     # FINAL_PROCESSING
    delay: 12
    wait_all: false

  - from: 3   # SHIPPING_CALCULATION
    to: 8     # FINAL_PROCESSING
    delay: 10
    wait_all: false

  - from: 2   # INVENTORY_CHECK
    to: 8     # FINAL_PROCESSING
    delay: 9
    wait_all: false

  - from: 2   # INVENTORY_CHECK
    to: 9     # TAX_CALCULATION
    delay: 16
    wait_all: true

  - from: 4   # ORDER_CONFIRMATION
    to: 9     # TAX_CALCULATION
    delay: 10
    wait_all: true

  - from: 1   # PAYMENT_VALIDATION
    to: 9     # TAX_CALCULATION
    delay: 15
    wait_all: true

  - from: 4   # ORDER_CONFIRMATION
    to: 10    # DOCUMENT_GENERATION
    delay: 8
    wait_all: true

  - from: 10  # DOCUMENT_GENERATION
    to: 11    # COMPLIANCE_CHECK
    delay: 6
    wait_all: true

  - from: 8   # FINAL_PROCESSING
    to: 11    # COMPLIANCE_CHECK
    delay: 12
    wait_all: false

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 12    # ARCHIVE_PROCESSING
    delay: 9
    wait_all: true

  - from: 10  # DOCUMENT_GENERATION
    to: 12    # ARCHIVE_PROCESSING
    delay: 14
    wait_all: true

  - from: 11  # COMPLIANCE_CHECK
    to: 12    # ARCHIVE_PROCESSING
    delay: 9
    wait_all: false

  - from: 4   # ORDER_CONFIRMATION
    to: 13    # SECURITY_VALIDATION
    delay: 6
    wait_all: false

  - from: 2   # INVENTORY_CHECK
    to: 13    # SECURITY_VALIDATION
    delay: 15
    wait_all: true

  - from: 10  # DOCUMENT_GENERATION
    to: 13    # SECURITY_VALIDATION
    delay: 14
    wait_all: true

  - from: 12  # ARCHIVE_PROCESSING
    to: 13    # SECURITY_VALIDATION
    delay: 10
    wait_all: false

  - from: 11  # COMPLIANCE_CHECK
    to: 14    # PERFORMANCE_MONITOR
    delay: 12
    wait_all: true

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 14    # PERFORMANCE_MONITOR
    delay: 11
    wait_all: false

  # --- Dependency Matrix 3 (analytics, security, infra, finalization) ---
  - from: 9   # TAX_CALCULATION
    to: 14    # PERFORMANCE_MONITOR
    delay: 15
    wait_all: false

  - from: 11  # COMPLIANCE_CHECK
    to: 15    # BACKUP_CREATION
    delay: 13
    wait_all: false

  - from: 14  # PERFORMANCE_MONITOR
    to: 15    # BACKUP_CREATION
    delay: 12
    wait_all: false

  - from: 11  # COMPLIANCE_CHECK
    to: 16    # REPORT_GENERATION
    delay: 9
    wait_all: false

  - from: 14  # PERFORMANCE_MONITOR
    to: 16    # REPORT_GENERATION
    delay: 8
    wait_all: false

  - from: 8   # FINAL_PROCESSING
    to: 16    # REPORT_GENERATION
    delay: 14
    wait_all: false

  - from: 14  # PERFORMANCE_MONITOR
    to: 17    # DATA_ENCRYPTION
    delay: 8
    wait_all: false

  - from: 10  # DOCUMENT_GENERATION
    to: 17    # DATA_ENCRYPTION
    delay: 9
    wait_all: false

  - from: 12  # ARCHIVE_PROCESSING
    to: 17    # DATA_ENCRYPTION
    delay: 9
    wait_all: false

  - from: 13  # SECURITY_VALIDATION
    to: 18    # AUDIT_TRAIL
    delay: 6
    wait_all: true

  - from: 14  # PERFORMANCE_MONITOR
    to: 19    # SYSTEM_CLEANUP
    delay: 12
    wait_all: true

  - from: 16  # REPORT_GENERATION
    to: 19    # SYSTEM_CLEANUP
    delay: 6
    wait_all: false

  - from: 18  # AUDIT_TRAIL
    to: 19    # SYSTEM_CLEANUP
    delay: 8
    wait_all: false

  - from: 17  # DATA_ENCRYPTION
    to: 19    # SYSTEM_CLEANUP
    delay: 16
    wait_all: true

  - from: 17  # DATA_ENCRYPTION
    to: 20    # FINAL_VALIDATION
    delay: 13
    wait_all: false

  - from: 15  # BACKUP_CREATION
    to: 20    # FINAL_VALIDATION
    delay: 11
    wait_all: false

  - from: 16  # REPORT_GENERATION
    to: 20    # FINAL_VALIDATION
    delay: 10
    wait_all: false