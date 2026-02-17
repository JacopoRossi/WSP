wsp:
  name: "36tasks"
  h_start: 0
  h_end: 458
  r_max: 218

# Service definitions
services:
  - id: 1
    name: Payment_Service
    tasks_set: [1, 9, 21, 22, 23, 24]

  - id: 2
    name: Inventory_Service
    tasks_set: [2, 6, 7, 26]

  - id: 3
    name: Order_Service
    tasks_set: [4, 8, 10, 12, 20]

  - id: 4
    name: Shipping_Service
    tasks_set: [3]

  - id: 5
    name: Notification_Service
    tasks_set: [5]

  - id: 6
    name: Security_Service
    tasks_set: [11, 13, 17, 18, 35, 36]

  - id: 7
    name: Analytics_Service
    tasks_set: [14, 16, 29]

  - id: 8
    name: Infrastructure_Service
    tasks_set: [15, 19, 30, 31, 32, 33, 34]

  - id: 9
    name: Recommendation_Service
    tasks_set: [25, 28]

  - id: 10
    name: Refund_Service
    tasks_set: [27]

# Task definitions
tasks:
  - id: 1
    name: PAYMENT_VALIDATION
    sig: pay_val
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4

  - id: 2
    name: INVENTORY_CHECK
    sig: inv_chk
    dur: 4
    res_q: 5
    rc: 3
    rd: 0
    max_c: 5

  - id: 3
    name: SHIPPING_CALCULATION
    sig: ship_calc
    dur: 10
    res_q: 3
    rc: 3
    rd: 0
    max_c: 3

  - id: 4
    name: ORDER_CONFIRMATION
    sig: ord_conf
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 2

  - id: 5
    name: CUSTOMER_NOTIFICATION
    sig: cust_notif
    dur: 10
    res_q: 1
    rc: 3
    rd: 0
    max_c: 4

  - id: 6
    name: WAREHOUSE_ALLOCATION
    sig: wh_alloc
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 2

  - id: 7
    name: QUALITY_CHECK
    sig: qc_chk
    dur: 8
    res_q: 1
    rc: 2
    rd: 0
    max_c: 1

  - id: 8
    name: FINAL_PROCESSING
    sig: final_proc
    dur: 6
    res_q: 1
    rc: 1
    rd: 0
    max_c: 5

  - id: 9
    name: TAX_CALCULATION
    sig: tax_calc
    dur: 3
    res_q: 1
    rc: 0
    rd: 6
    max_c: 4

  - id: 10
    name: DOCUMENT_GENERATION
    sig: doc_gen
    dur: 6
    res_q: 3
    rc: 1
    rd: 0
    max_c: 2

  - id: 11
    name: COMPLIANCE_CHECK
    sig: comp_chk
    dur: 6
    res_q: 1
    rc: 2
    rd: 0
    max_c: 5

  - id: 12
    name: ARCHIVE_PROCESSING
    sig: arch_proc
    dur: 6
    res_q: 4
    rc: 0
    rd: 10
    max_c: 3

  - id: 13
    name: SECURITY_VALIDATION
    sig: sec_val
    dur: 9
    res_q: 4
    rc: 3
    rd: 11
    max_c: 3

  - id: 14
    name: PERFORMANCE_MONITOR
    sig: perf_mon
    dur: 7
    res_q: 3
    rc: 3
    rd: 0
    max_c: 4

  - id: 15
    name: BACKUP_CREATION
    sig: bck_crea
    dur: 4
    res_q: 4
    rc: 1
    rd: 0
    max_c: 3

  - id: 16
    name: REPORT_GENERATION
    sig: rpt_gen
    dur: 8
    res_q: 4
    rc: 0
    rd: 7
    max_c: 2

  - id: 17
    name: DATA_ENCRYPTION
    sig: data_encr
    dur: 3
    res_q: 3
    rc: 3
    rd: 13
    max_c: 3

  - id: 18
    name: AUDIT_TRAIL
    sig: aud_trl
    dur: 5
    res_q: 2
    rc: 1
    rd: 0
    max_c: 4

  - id: 19
    name: SYSTEM_CLEANUP
    sig: sys_cln
    dur: 6
    res_q: 4
    rc: 3
    rd: 10
    max_c: 3

  - id: 20
    name: FINAL_VALIDATION
    sig: final_val
    dur: 10
    res_q: 4
    rc: 2
    rd: 0
    max_c: 3

  - id: 21
    name: RISK_ASSESSMENT
    sig: risk_asmt
    dur: 5
    res_q: 2
    rc: 3
    rd: 0
    max_c: 2

  - id: 22
    name: FRAUD_DETECTION
    sig: frd_det
    dur: 3
    res_q: 5
    rc: 0
    rd: 0
    max_c: 1

  - id: 23
    name: CURRENCY_CONVERSION
    sig: cur_conv
    dur: 3
    res_q: 4
    rc: 0
    rd: 7
    max_c: 1

  - id: 24
    name: PRICE_OPTIMIZATION
    sig: prc_opt
    dur: 5
    res_q: 1
    rc: 0
    rd: 14
    max_c: 3

  - id: 25
    name: LOYALTY_PROCESSING
    sig: loy_proc
    dur: 3
    res_q: 5
    rc: 3
    rd: 0
    max_c: 4

  - id: 26
    name: RETURN_HANDLING
    sig: ret_hdl
    dur: 3
    res_q: 1
    rc: 3
    rd: 13
    max_c: 1

  - id: 27
    name: REFUND_PROCESSING
    sig: ref_proc
    dur: 3
    res_q: 5
    rc: 1
    rd: 9
    max_c: 1

  - id: 28
    name: PRODUCT_RECOMMENDATION
    sig: prd_rec
    dur: 9
    res_q: 2
    rc: 0
    rd: 0
    max_c: 5

  - id: 29
    name: ANALYTICS_UPDATE
    sig: anly_upd
    dur: 5
    res_q: 2
    rc: 0
    rd: 16
    max_c: 3

  - id: 30
    name: CACHE_REFRESH
    sig: cache_refr
    dur: 8
    res_q: 3
    rc: 2
    rd: 0
    max_c: 3

  - id: 31
    name: LOG_PROCESSING
    sig: log_proc
    dur: 9
    res_q: 4
    rc: 3
    rd: 0
    max_c: 2

  - id: 32
    name: ERROR_HANDLING
    sig: err_hdl
    dur: 7
    res_q: 1
    rc: 0
    rd: 0
    max_c: 4

  - id: 33
    name: LOAD_BALANCING
    sig: load_bal
    dur: 9
    res_q: 4
    rc: 3
    rd: 0
    max_c: 1

  - id: 34
    name: DATABASE_SYNC
    sig: db_sync
    dur: 3
    res_q: 2
    rc: 0
    rd: 0
    max_c: 4

  - id: 35
    name: API_VALIDATION
    sig: api_val
    dur: 8
    res_q: 5
    rc: 0
    rd: 1
    max_c: 2

  - id: 36
    name: SESSION_MANAGEMENT
    sig: sess_mgt
    dur: 6
    res_q: 5
    rc: 2
    rd: 0
    max_c: 1

# Start-to-start precedence constraints
start_constraints:
  # From Payment_Validation and Inventory_Check initial segment
  - from: 1
    to: 2
    delay: 5
    wait_all: false  # PAYMENT_VALIDATION -> INVENTORY_CHECK
  - from: 2
    to: 3
    delay: 9
    wait_all: true   # INVENTORY_CHECK -> SHIPPING_CALCULATION
  - from: 1
    to: 4
    delay: 21
    wait_all: false  # PAYMENT_VALIDATION -> ORDER_CONFIRMATION
  - from: 2
    to: 4
    delay: 16
    wait_all: true   # INVENTORY_CHECK -> ORDER_CONFIRMATION

  # Shipping_Calculation fan-out and early pipeline
  - from: 3
    to: 4
    delay: 10
    wait_all: true   # SHIPPING_CALCULATION -> ORDER_CONFIRMATION
  - from: 3
    to: 5
    delay: 13
    wait_all: true   # SHIPPING_CALCULATION -> CUSTOMER_NOTIFICATION
  - from: 3
    to: 6
    delay: 5
    wait_all: true   # SHIPPING_CALCULATION -> WAREHOUSE_ALLOCATION

  # Quality_Check dependencies
  - from: 2
    to: 7
    delay: 9
    wait_all: true   # INVENTORY_CHECK -> QUALITY_CHECK
  - from: 4
    to: 7
    delay: 14
    wait_all: true   # ORDER_CONFIRMATION -> QUALITY_CHECK
  - from: 1
    to: 7
    delay: 14
    wait_all: false  # PAYMENT_VALIDATION -> QUALITY_CHECK

  # Final_Processing dependencies
  - from: 5
    to: 8
    delay: 16
    wait_all: true   # CUSTOMER_NOTIFICATION -> FINAL_PROCESSING
  - from: 3
    to: 8
    delay: 16
    wait_all: true   # SHIPPING_CALCULATION -> FINAL_PROCESSING
  - from: 4
    to: 8
    delay: 13
    wait_all: false  # ORDER_CONFIRMATION -> FINAL_PROCESSING

  # Tax_Calculation dependency
  - from: 2
    to: 9
    delay: 11
    wait_all: true   # INVENTORY_CHECK -> TAX_CALCULATION

  # Document_Generation dependency
  - from: 8
    to: 10
    delay: 10
    wait_all: true   # FINAL_PROCESSING -> DOCUMENT_GENERATION

  # Compliance_Check dependencies
  - from: 10
    to: 11
    delay: 10
    wait_all: false  # DOCUMENT_GENERATION -> COMPLIANCE_CHECK
  - from: 6
    to: 11
    delay: 11
    wait_all: true   # WAREHOUSE_ALLOCATION -> COMPLIANCE_CHECK
  - from: 4
    to: 11
    delay: 15
    wait_all: false  # ORDER_CONFIRMATION -> COMPLIANCE_CHECK

  # Archive_Processing dependency
  - from: 5
    to: 12
    delay: 8
    wait_all: true   # CUSTOMER_NOTIFICATION -> ARCHIVE_PROCESSING

  # Security_Validation dependency
  - from: 11
    to: 13
    delay: 16
    wait_all: true   # COMPLIANCE_CHECK -> SECURITY_VALIDATION

  # Performance_Monitor dependencies
  - from: 11
    to: 14
    delay: 5
    wait_all: false  # COMPLIANCE_CHECK -> PERFORMANCE_MONITOR
  - from: 6
    to: 14
    delay: 12
    wait_all: false  # WAREHOUSE_ALLOCATION -> PERFORMANCE_MONITOR
  - from: 12
    to: 14
    delay: 9
    wait_all: true   # ARCHIVE_PROCESSING -> PERFORMANCE_MONITOR

  # Backup_Creation dependencies
  - from: 13
    to: 15
    delay: 12
    wait_all: false  # SECURITY_VALIDATION -> BACKUP_CREATION

  # Report_Generation dependency
  - from: 13
    to: 16
    delay: 13
    wait_all: true   # SECURITY_VALIDATION -> REPORT_GENERATION

  # Data_Encryption dependencies
  - from: 14
    to: 17
    delay: 5
    wait_all: false  # PERFORMANCE_MONITOR -> DATA_ENCRYPTION
  - from: 15
    to: 17
    delay: 11
    wait_all: false  # BACKUP_CREATION -> DATA_ENCRYPTION
  - from: 12
    to: 17
    delay: 6
    wait_all: true   # ARCHIVE_PROCESSING -> DATA_ENCRYPTION

  # Audit_Trail dependencies
  - from: 16
    to: 18
    delay: 9
    wait_all: false  # REPORT_GENERATION -> AUDIT_TRAIL
  - from: 11
    to: 18
    delay: 9
    wait_all: false  # COMPLIANCE_CHECK -> AUDIT_TRAIL
  - from: 17
    to: 18
    delay: 7
    wait_all: true   # DATA_ENCRYPTION -> AUDIT_TRAIL

  # System_Cleanup dependency
  - from: 17
    to: 19
    delay: 9
    wait_all: false  # DATA_ENCRYPTION -> SYSTEM_CLEANUP

  # Final_Validation dependency
  - from: 15
    to: 20
    delay: 16
    wait_all: false  # BACKUP_CREATION -> FINAL_VALIDATION

  # Risk_Assessment dependencies
  - from: 20
    to: 21
    delay: 9
    wait_all: true   # FINAL_VALIDATION -> RISK_ASSESSMENT
  - from: 13
    to: 21
    delay: 11
    wait_all: false  # SECURITY_VALIDATION -> RISK_ASSESSMENT
  - from: 14
    to: 21
    delay: 14
    wait_all: false  # PERFORMANCE_MONITOR -> RISK_ASSESSMENT

  # Fraud_Detection dependencies
  - from: 20
    to: 22
    delay: 15
    wait_all: true   # FINAL_VALIDATION -> FRAUD_DETECTION
  - from: 21
    to: 22
    delay: 9
    wait_all: false  # RISK_ASSESSMENT -> FRAUD_DETECTION

  # Currency_Conversion dependencies
  - from: 7
    to: 23
    delay: 7
    wait_all: false  # QUALITY_CHECK -> CURRENCY_CONVERSION
  - from: 16
    to: 23
    delay: 10
    wait_all: false  # REPORT_GENERATION -> CURRENCY_CONVERSION
  - from: 11
    to: 23
    delay: 16
    wait_all: false  # COMPLIANCE_CHECK -> CURRENCY_CONVERSION

  # Price_Optimization dependencies
  - from: 11
    to: 24
    delay: 11
    wait_all: false  # COMPLIANCE_CHECK -> PRICE_OPTIMIZATION
  - from: 13
    to: 24
    delay: 6
    wait_all: true   # SECURITY_VALIDATION -> PRICE_OPTIMIZATION
  - from: 9
    to: 24
    delay: 14
    wait_all: true   # TAX_CALCULATION -> PRICE_OPTIMIZATION

  # Loyalty_Processing dependencies
  - from: 1
    to: 25
    delay: 16
    wait_all: true   # PAYMENT_VALIDATION -> LOYALTY_PROCESSING
  - from: 24
    to: 25
    delay: 12
    wait_all: false  # PRICE_OPTIMIZATION -> LOYALTY_PROCESSING
  - from: 15
    to: 25
    delay: 16
    wait_all: true   # BACKUP_CREATION -> LOYALTY_PROCESSING

  # Return_Handling dependencies
  - from: 20
    to: 26
    delay: 9
    wait_all: true   # FINAL_VALIDATION -> RETURN_HANDLING
  - from: 23
    to: 26
    delay: 9
    wait_all: true   # CURRENCY_CONVERSION -> RETURN_HANDLING

  # Refund_Processing dependencies
  - from: 25
    to: 27
    delay: 14
    wait_all: false  # LOYALTY_PROCESSING -> REFUND_PROCESSING
  - from: 19
    to: 27
    delay: 14
    wait_all: false  # SYSTEM_CLEANUP -> REFUND_PROCESSING
  - from: 22
    to: 27
    delay: 13
    wait_all: false  # FRAUD_DETECTION -> REFUND_PROCESSING

  # Product_Recommendation dependencies
  - from: 25
    to: 28
    delay: 14
    wait_all: true   # LOYALTY_PROCESSING -> PRODUCT_RECOMMENDATION
  - from: 27
    to: 28
    delay: 6
    wait_all: true   # REFUND_PROCESSING -> PRODUCT_RECOMMENDATION
  - from: 24
    to: 28
    delay: 15
    wait_all: false  # PRICE_OPTIMIZATION -> PRODUCT_RECOMMENDATION

  # Analytics_Update dependency
  - from: 21
    to: 29
    delay: 14
    wait_all: false  # RISK_ASSESSMENT -> ANALYTICS_UPDATE

  # Cache_Refresh dependencies
  - from: 14
    to: 30
    delay: 5
    wait_all: true   # PERFORMANCE_MONITOR -> CACHE_REFRESH
  - from: 4
    to: 30
    delay: 9
    wait_all: true   # ORDER_CONFIRMATION -> CACHE_REFRESH

  # Log_Processing dependencies
  - from: 18
    to: 31
    delay: 14
    wait_all: true   # AUDIT_TRAIL -> LOG_PROCESSING
  - from: 19
    to: 31
    delay: 12
    wait_all: false  # SYSTEM_CLEANUP -> LOG_PROCESSING
  - from: 23
    to: 31
    delay: 11
    wait_all: false  # CURRENCY_CONVERSION -> LOG_PROCESSING

  # Error_Handling dependencies
  - from: 26
    to: 32
    delay: 12
    wait_all: true   # RETURN_HANDLING -> ERROR_HANDLING
  - from: 31
    to: 32
    delay: 9
    wait_all: false  # LOG_PROCESSING -> ERROR_HANDLING
  - from: 24
    to: 32
    delay: 6
    wait_all: true   # PRICE_OPTIMIZATION -> ERROR_HANDLING

  # Load_Balancing dependencies
  - from: 29
    to: 33
    delay: 8
    wait_all: false  # ANALYTICS_UPDATE -> LOAD_BALANCING
  - from: 27
    to: 33
    delay: 10
    wait_all: false  # REFUND_PROCESSING -> LOAD_BALANCING
  - from: 28
    to: 33
    delay: 6
    wait_all: false  # PRODUCT_RECOMMENDATION -> LOAD_BALANCING

  # Database_Sync dependencies
  - from: 31
    to: 34
    delay: 5
    wait_all: true   # LOG_PROCESSING -> DATABASE_SYNC
  - from: 26
    to: 34
    delay: 5
    wait_all: false  # RETURN_HANDLING -> DATABASE_SYNC
  - from: 28
    to: 34
    delay: 15
    wait_all: true   # PRODUCT_RECOMMENDATION -> DATABASE_SYNC

  # API_Validation dependencies
  - from: 16
    to: 35
    delay: 13
    wait_all: true   # REPORT_GENERATION -> API_VALIDATION
  - from: 34
    to: 35
    delay: 10
    wait_all: false  # DATABASE_SYNC -> API_VALIDATION
  - from: 12
    to: 35
    delay: 12
    wait_all: true   # ARCHIVE_PROCESSING -> API_VALIDATION

  # Session_Management dependencies
  - from: 30
    to: 36
    delay: 15
    wait_all: false  # CACHE_REFRESH -> SESSION_MANAGEMENT
  - from: 33
    to: 36
    delay: 11
    wait_all: true   # LOAD_BALANCING -> SESSION_MANAGEMENT