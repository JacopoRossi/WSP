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
    max_c: 4
    rc: 0
    rd: 0

  - id: 2
    name: "INVENTORY_CHECK"
    sig: "inv_chk"
    dur: 4
    res_q: 5
    max_c: 5
    rc: 3
    rd: 0

  - id: 3
    name: "SHIPPING_CALCULATION"
    sig: "ship_calc"
    dur: 10
    res_q: 3
    max_c: 3
    rc: 3
    rd: 0

  - id: 4
    name: "ORDER_CONFIRMATION"
    sig: "ord_conf"
    dur: 8
    res_q: 2
    max_c: 2
    rc: 0
    rd: 0

  - id: 5
    name: "CUSTOMER_NOTIFICATION"
    sig: "cust_notif"
    dur: 10
    res_q: 1
    max_c: 4
    rc: 0
    rd: 9

  - id: 6
    name: "WAREHOUSE_ALLOCATION"
    sig: "wh_alloc"
    dur: 10
    res_q: 4
    max_c: 1
    rc: 1
    rd: 0

  - id: 7
    name: "QUALITY_CHECK"
    sig: "qc_chk"
    dur: 7
    res_q: 4
    max_c: 4
    rc: 0
    rd: 0

  - id: 8
    name: "FINAL_PROCESSING"
    sig: "final_proc"
    dur: 10
    res_q: 1
    max_c: 2
    rc: 3
    rd: 1

  - id: 9
    name: "TAX_CALCULATION"
    sig: "tax_calc"
    dur: 5
    res_q: 5
    max_c: 2
    rc: 1
    rd: 0

  - id: 10
    name: "DOCUMENT_GENERATION"
    sig: "doc_gen"
    dur: 4
    res_q: 5
    max_c: 5
    rc: 2
    rd: 7

  - id: 11
    name: "COMPLIANCE_CHECK"
    sig: "comp_chk"
    dur: 9
    res_q: 4
    max_c: 5
    rc: 2
    rd: 0

  - id: 12
    name: "ARCHIVE_PROCESSING"
    sig: "arch_proc"
    dur: 9
    res_q: 3
    max_c: 5
    rc: 3
    rd: 1

  - id: 13
    name: "SECURITY_VALIDATION"
    sig: "sec_val"
    dur: 4
    res_q: 2
    max_c: 1
    rc: 0
    rd: 0

  - id: 14
    name: "PERFORMANCE_MONITOR"
    sig: "perf_mon"
    dur: 5
    res_q: 2
    max_c: 2
    rc: 0
    rd: 2

  - id: 15
    name: "BACKUP_CREATION"
    sig: "bck_crea"
    dur: 3
    res_q: 4
    max_c: 3
    rc: 2
    rd: 15

  - id: 16
    name: "REPORT_GENERATION"
    sig: "rpt_gen"
    dur: 3
    res_q: 2
    max_c: 4
    rc: 1
    rd: 9

  - id: 17
    name: "DATA_ENCRYPTION"
    sig: "data_encr"
    dur: 4
    res_q: 2
    max_c: 4
    rc: 1
    rd: 6

  - id: 18
    name: "AUDIT_TRAIL"
    sig: "aud_trl"
    dur: 4
    res_q: 5
    max_c: 3
    rc: 0
    rd: 4

  - id: 19
    name: "SYSTEM_CLEANUP"
    sig: "sys_cln"
    dur: 5
    res_q: 1
    max_c: 3
    rc: 0
    rd: 0

  - id: 20
    name: "FINAL_VALIDATION"
    sig: "final_val"
    dur: 7
    res_q: 4
    max_c: 3
    rc: 0
    rd: 0

  - id: 21
    name: "RISK_ASSESSMENT"
    sig: "risk_asmt"
    dur: 9
    res_q: 3
    max_c: 4
    rc: 3
    rd: 15

  - id: 22
    name: "FRAUD_DETECTION"
    sig: "frd_det"
    dur: 4
    res_q: 5
    max_c: 3
    rc: 0
    rd: 0

  - id: 23
    name: "CURRENCY_CONVERSION"
    sig: "cur_conv"
    dur: 7
    res_q: 1
    max_c: 5
    rc: 0
    rd: 0

  - id: 24
    name: "PRICE_OPTIMIZATION"
    sig: "prc_opt"
    dur: 3
    res_q: 3
    max_c: 2
    rc: 3
    rd: 0

# Start-to-start precedence constraints
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
    delay: 7
    wait_all: false

  - from: 2   
    to: 5     
    delay: 15
    wait_all: false

  - from: 4   
    to: 6     
    delay: 10
    wait_all: false

  - from: 3   
    to: 7     
    delay: 7
    wait_all: false

  - from: 1   
    to: 7     
    delay: 11
    wait_all: false

  - from: 6   
    to: 8     
    delay: 13
    wait_all: true

  - from: 4   
    to: 8     
    delay: 12
    wait_all: true

  - from: 5   
    to: 9     
    delay: 6
    wait_all: false

  - from: 3   
    to: 9     
    delay: 13
    wait_all: true

  - from: 9   
    to: 10    
    delay: 5
    wait_all: true

  - from: 8   
    to: 10    
    delay: 13
    wait_all: false

  - from: 4   
    to: 10    
    delay: 14
    wait_all: false

  - from: 8   
    to: 11    
    delay: 9
    wait_all: true

  - from: 1   
    to: 11    
    delay: 9
    wait_all: false

  - from: 4   
    to: 11    
    delay: 16
    wait_all: false

  - from: 1   
    to: 12    
    delay: 15
    wait_all: true

  - from: 3   
    to: 13    
    delay: 5
    wait_all: false

  - from: 5   
    to: 13    
    delay: 6
    wait_all: true

  - from: 9   
    to: 13    
    delay: 6
    wait_all: false

  - from: 11  
    to: 14    
    delay: 7
    wait_all: false

  - from: 5   
    to: 15    
    delay: 9
    wait_all: false

  - from: 9   
    to: 15    
    delay: 12
    wait_all: false

  - from: 12  
    to: 15    
    delay: 8
    wait_all: false

  - from: 3   
    to: 16    
    delay: 14
    wait_all: true

  - from: 7   
    to: 16    
    delay: 6
    wait_all: false

  - from: 4   
    to: 16    
    delay: 11
    wait_all: false

  - from: 9   
    to: 17    
    delay: 9
    wait_all: false

  - from: 14  
    to: 17    
    delay: 14
    wait_all: false

  - from: 1   
    to: 17    
    delay: 7
    wait_all: false

  - from: 16  
    to: 18    
    delay: 13
    wait_all: false

  - from: 12  
    to: 18    
    delay: 12
    wait_all: false

  - from: 6   
    to: 18    
    delay: 8
    wait_all: true

  - from: 13  
    to: 19    
    delay: 5
    wait_all: false

  - from: 8   
    to: 19    
    delay: 16
    wait_all: false

  - from: 14  
    to: 19    
    delay: 16
    wait_all: false

  - from: 5   
    to: 20    
    delay: 5
    wait_all: true

  - from: 16  
    to: 20    
    delay: 13
    wait_all: false

  - from: 15  
    to: 21    
    delay: 6
    wait_all: false

  - from: 5   
    to: 22    
    delay: 11
    wait_all: true

  - from: 16  
    to: 23    
    delay: 9
    wait_all: false

  - from: 23  
    to: 24    
    delay: 6
    wait_all: false

  - from: 13  
    to: 24    
    delay: 15
    wait_all: false

  - from: 21  
    to: 24    
    delay: 10
    wait_all: false