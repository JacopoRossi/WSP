# Global parameters
wsp:
  name: "52tasks"
  h_start: 0
  h_end: 586
  r_max: 266

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
    tasks_set: [14, 16, 29, 46, 47, 48]

  - id: 8
    name: "Processing_Service"
    tasks_set: [41, 42, 43, 44, 45]

  - id: 9
    name: "Infrastructure_Service"
    tasks_set: [15, 19, 30, 31, 32, 33, 34, 52]

  - id: 10
    name: "Recommendation_Service"
    tasks_set: [25, 28, 49, 50, 51]

  - id: 11
    name: "Refund_Service"
    tasks_set: [27]

# Task definitions
tasks:
  - id: 1
    name: "PAYMENT_VALIDATION"
    sig: "payment_validation"
    dur: 5
    res_q: 4
    rc: 0
    rd: 0
    max_c: 4

  - id: 2
    name: "INVENTORY_CHECK"
    sig: "inventory_check"
    dur: 4
    res_q: 5
    rc: 3
    rd: 0
    max_c: 5

  - id: 3
    name: "SHIPPING_CALCULATION"
    sig: "shipping_calculation"
    dur: 10
    res_q: 3
    rc: 3
    rd: 0
    max_c: 3

  - id: 4
    name: "ORDER_CONFIRMATION"
    sig: "order_confirmation"
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 2

  - id: 5
    name: "CUSTOMER_NOTIFICATION"
    sig: "customer_notification"
    dur: 8
    res_q: 5
    rc: 0
    rd: 0
    max_c: 1

  - id: 6
    name: "WAREHOUSE_ALLOCATION"
    sig: "warehouse_allocation"
    dur: 9
    res_q: 4
    rc: 3
    rd: 16
    max_c: 1

  - id: 7
    name: "QUALITY_CHECK"
    sig: "quality_check"
    dur: 6
    res_q: 4
    rc: 1
    rd: 0
    max_c: 2

  - id: 8
    name: "FINAL_PROCESSING"
    sig: "final_processing"
    dur: 5
    res_q: 3
    rc: 0
    rd: 0
    max_c: 5

  - id: 9
    name: "TAX_CALCULATION"
    sig: "tax_calculation"
    dur: 3
    res_q: 5
    rc: 2
    rd: 0
    max_c: 1

  - id: 10
    name: "DOCUMENT_GENERATION"
    sig: "document_generation"
    dur: 9
    res_q: 5
    rc: 2
    rd: 4
    max_c: 2

  - id: 11
    name: "COMPLIANCE_CHECK"
    sig: "compliance_check"
    dur: 10
    res_q: 5
    rc: 0
    rd: 0
    max_c: 4

  - id: 12
    name: "ARCHIVE_PROCESSING"
    sig: "archive_processing"
    dur: 6
    res_q: 5
    rc: 3
    rd: 16
    max_c: 2

  - id: 13
    name: "SECURITY_VALIDATION"
    sig: "security_validation"
    dur: 6
    res_q: 1
    rc: 1
    rd: 0
    max_c: 3

  - id: 14
    name: "PERFORMANCE_MONITOR"
    sig: "performance_monitor"
    dur: 4
    res_q: 1
    rc: 2
    rd: 0
    max_c: 3

  - id: 15
    name: "BACKUP_CREATION"
    sig: "backup_creation"
    dur: 8
    res_q: 2
    rc: 1
    rd: 0
    max_c: 5

  - id: 16
    name: "REPORT_GENERATION"
    sig: "report_generation"
    dur: 3
    res_q: 3
    rc: 0
    rd: 0
    max_c: 5

  - id: 17
    name: "DATA_ENCRYPTION"
    sig: "data_encryption"
    dur: 10
    res_q: 5
    rc: 0
    rd: 0
    max_c: 1

  - id: 18
    name: "AUDIT_TRAIL"
    sig: "audit_trail"
    dur: 6
    res_q: 2
    rc: 1
    rd: 0
    max_c: 1

  - id: 19
    name: "SYSTEM_CLEANUP"
    sig: "system_cleanup"
    dur: 4
    res_q: 1
    rc: 0
    rd: 4
    max_c: 3

  - id: 20
    name: "FINAL_VALIDATION"
    sig: "final_validation"
    dur: 3
    res_q: 3
    rc: 0
    rd: 0
    max_c: 4

  - id: 21
    name: "RISK_ASSESSMENT"
    sig: "risk_assessment"
    dur: 10
    res_q: 1
    rc: 1
    rd: 0
    max_c: 5

  - id: 22
    name: "FRAUD_DETECTION"
    sig: "fraud_detection"
    dur: 6
    res_q: 2
    rc: 3
    rd: 8
    max_c: 5

  - id: 23
    name: "CURRENCY_CONVERSION"
    sig: "currency_conversion"
    dur: 10
    res_q: 5
    rc: 0
    rd: 0
    max_c: 4

  - id: 24
    name: "PRICE_OPTIMIZATION"
    sig: "price_optimization"
    dur: 3
    res_q: 3
    rc: 0
    rd: 0
    max_c: 3

  - id: 25
    name: "LOYALTY_PROCESSING"
    sig: "loyalty_processing"
    dur: 6
    res_q: 5
    rc: 1
    rd: 0
    max_c: 4

  - id: 26
    name: "RETURN_HANDLING"
    sig: "return_handling"
    dur: 3
    res_q: 1
    rc: 2
    rd: 8
    max_c: 3

  - id: 27
    name: "REFUND_PROCESSING"
    sig: "refund_processing"
    dur: 4
    res_q: 1
    rc: 1
    rd: 12
    max_c: 2

  - id: 28
    name: "PRODUCT_RECOMMENDATION"
    sig: "product_recommendation"
    dur: 9
    res_q: 5
    rc: 0
    rd: 0
    max_c: 4

  - id: 29
    name: "ANALYTICS_UPDATE"
    sig: "analytics_update"
    dur: 4
    res_q: 2
    rc: 0
    rd: 14
    max_c: 5

  - id: 30
    name: "CACHE_REFRESH"
    sig: "cache_refresh"
    dur: 3
    res_q: 1
    rc: 0
    rd: 9
    max_c: 3

  - id: 31
    name: "LOG_PROCESSING"
    sig: "log_processing"
    dur: 10
    res_q: 4
    rc: 0
    rd: 0
    max_c: 3

  - id: 32
    name: "ERROR_HANDLING"
    sig: "error_handling"
    dur: 8
    res_q: 3
    rc: 1
    rd: 0
    max_c: 5

  - id: 33
    name: "LOAD_BALANCING"
    sig: "load_balancing"
    dur: 7
    res_q: 1
    rc: 1
    rd: 0
    max_c: 1

  - id: 34
    name: "DATABASE_SYNC"
    sig: "database_sync"
    dur: 7
    res_q: 2
    rc: 0
    rd: 0
    max_c: 4

  - id: 35
    name: "API_VALIDATION"
    sig: "api_validation"
    dur: 5
    res_q: 1
    rc: 2
    rd: 7
    max_c: 4

  - id: 36
    name: "SESSION_MANAGEMENT"
    sig: "session_management"
    dur: 6
    res_q: 5
    rc: 0
    rd: 0
    max_c: 3

  - id: 37
    name: "EMAIL_DISPATCH"
    sig: "email_dispatch"
    dur: 8
    res_q: 4
    rc: 3
    rd: 0
    max_c: 2

  - id: 38
    name: "SMS_NOTIFICATION"
    sig: "sms_notification"
    dur: 5
    res_q: 5
    rc: 3
    rd: 6
    max_c: 2

  - id: 39
    name: "PUSH_NOTIFICATION"
    sig: "push_notification"
    dur: 7
    res_q: 5
    rc: 0
    rd: 0
    max_c: 2

  - id: 40
    name: "WEBHOOK_TRIGGER"
    sig: "webhook_trigger"
    dur: 5
    res_q: 3
    rc: 0
    rd: 3
    max_c: 2

  - id: 41
    name: "CONTENT_MODERATION"
    sig: "content_moderation"
    dur: 8
    res_q: 2
    rc: 0
    rd: 0
    max_c: 4

  - id: 42
    name: "IMAGE_PROCESSING"
    sig: "image_processing"
    dur: 9
    res_q: 3
    rc: 2
    rd: 8
    max_c: 2

  - id: 43
    name: "VIDEO_PROCESSING"
    sig: "video_processing"
    dur: 6
    res_q: 1
    rc: 0
    rd: 0
    max_c: 1

  - id: 44
    name: "FILE_UPLOAD"
    sig: "file_upload"
    dur: 7
    res_q: 5
    rc: 3
    rd: 7
    max_c: 5

  - id: 45
    name: "METADATA_EXTRACTION"
    sig: "metadata_extraction"
    dur: 6
    res_q: 2
    rc: 0
    rd: 0
    max_c: 1

  - id: 46
    name: "SEARCH_INDEXING"
    sig: "search_indexing"
    dur: 10
    res_q: 2
    rc: 3
    rd: 15
    max_c: 3

  - id: 47
    name: "RECOMMENDATION_ENGINE"
    sig: "recommendation_engine"
    dur: 5
    res_q: 4
    rc: 2
    rd: 0
    max_c: 2

  - id: 48
    name: "AB_TESTING"
    sig: "ab_testing"
    dur: 5
    res_q: 2
    rc: 0
    rd: 0
    max_c: 4

  - id: 49
    name: "FEATURE_TOGGLE"
    sig: "feature_toggle"
    dur: 3
    res_q: 3
    rc: 2
    rd: 0
    max_c: 2

  - id: 50
    name: "RATE_LIMITING"
    sig: "rate_limiting"
    dur: 6
    res_q: 1
    rc: 0
    rd: 0
    max_c: 5

  - id: 51
    name: "CIRCUIT_BREAKER"
    sig: "circuit_breaker"
    dur: 10
    res_q: 3
    rc: 2
    rd: 0
    max_c: 4

  - id: 52
    name: "HEALTH_CHECK"
    sig: "health_check"
    dur: 9
    res_q: 1
    rc: 3
    rd: 12
    max_c: 3

# Start-to-start precedence constraints
start_constraints:
  # 5.2 Catena di Validazione Iniziale (Vincoli 1-5)
  - from: 1   # PAYMENT_VALIDATION
    to: 2     # INVENTORY_CHECK
    delay: 5
    wait_all: false   # Vincolo 1

  - from: 2   # INVENTORY_CHECK
    to: 3     # SHIPPING_CALCULATION
    delay: 9
    wait_all: true    # Vincolo 2

  - from: 1   # PAYMENT_VALIDATION
    to: 4     # ORDER_CONFIRMATION
    delay: 21
    wait_all: false   # Vincolo 3

  - from: 2   # INVENTORY_CHECK
    to: 4     # ORDER_CONFIRMATION
    delay: 16
    wait_all: true    # Vincolo 4

  - from: 3   # SHIPPING_CALCULATION
    to: 4     # ORDER_CONFIRMATION
    delay: 10
    wait_all: true    # Vincolo 5

  # 5.3 Gestione Notifiche e Comunicazioni (Vincoli 6-11)
  - from: 1   # PAYMENT_VALIDATION
    to: 5     # CUSTOMER_NOTIFICATION
    delay: 6
    wait_all: false   # Vincolo 6

  - from: 3   # SHIPPING_CALCULATION
    to: 5     # CUSTOMER_NOTIFICATION
    delay: 12
    wait_all: true    # Vincolo 7

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 6     # WAREHOUSE_ALLOCATION
    delay: 13
    wait_all: false   # Vincolo 8

  - from: 1   # PAYMENT_VALIDATION
    to: 7     # QUALITY_CHECK
    delay: 13
    wait_all: true    # Vincolo 9

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 7     # QUALITY_CHECK
    delay: 8
    wait_all: false   # Vincolo 10

  - from: 4   # ORDER_CONFIRMATION
    to: 7     # QUALITY_CHECK
    delay: 12
    wait_all: false   # Vincolo 11

  # 5.4 Elaborazione Finale e Documentazione (Vincoli 12-21)
  - from: 7   # QUALITY_CHECK
    to: 8     # FINAL_PROCESSING
    delay: 12
    wait_all: true    # Vincolo 12

  - from: 3   # SHIPPING_CALCULATION
    to: 8     # FINAL_PROCESSING
    delay: 11
    wait_all: false   # Vincolo 13

  - from: 1   # PAYMENT_VALIDATION
    to: 9     # TAX_CALCULATION
    delay: 7
    wait_all: false   # Vincolo 14

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 9     # TAX_CALCULATION
    delay: 15
    wait_all: false   # Vincolo 15

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 9     # TAX_CALCULATION
    delay: 6
    wait_all: true    # Vincolo 16

  - from: 9   # TAX_CALCULATION
    to: 10    # DOCUMENT_GENERATION
    delay: 7
    wait_all: false   # Vincolo 17

  - from: 3   # SHIPPING_CALCULATION
    to: 11    # COMPLIANCE_CHECK
    delay: 12
    wait_all: true    # Vincolo 18

  - from: 4   # ORDER_CONFIRMATION
    to: 11    # COMPLIANCE_CHECK
    delay: 12
    wait_all: true    # Vincolo 19

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 12    # ARCHIVE_PROCESSING
    delay: 16
    wait_all: true    # Vincolo 20

  - from: 9   # TAX_CALCULATION
    to: 12    # ARCHIVE_PROCESSING
    delay: 6
    wait_all: true    # Vincolo 21

  # 5.5 Sicurezza e Monitoring (Vincoli 22-31)
  - from: 10  # DOCUMENT_GENERATION
    to: 13    # SECURITY_VALIDATION
    delay: 16
    wait_all: false   # Vincolo 22

  - from: 5   # CUSTOMER_NOTIFICATION
    to: 13    # SECURITY_VALIDATION
    delay: 16
    wait_all: true    # Vincolo 23

  - from: 9   # TAX_CALCULATION
    to: 13    # SECURITY_VALIDATION
    delay: 11
    wait_all: false   # Vincolo 24

  - from: 6   # WAREHOUSE_ALLOCATION
    to: 14    # PERFORMANCE_MONITOR
    delay: 14
    wait_all: true    # Vincolo 25

  - from: 3   # SHIPPING_CALCULATION
    to: 15    # BACKUP_CREATION
    delay: 16
    wait_all: true    # Vincolo 26

  - from: 15  # BACKUP_CREATION
    to: 16    # REPORT_GENERATION
    delay: 15
    wait_all: true    # Vincolo 27

  - from: 10  # DOCUMENT_GENERATION
    to: 16    # REPORT_GENERATION
    delay: 6
    wait_all: true    # Vincolo 28

  - from: 13  # SECURITY_VALIDATION
    to: 17    # DATA_ENCRYPTION
    delay: 5
    wait_all: false   # Vincolo 29

  - from: 1   # PAYMENT_VALIDATION
    to: 18    # AUDIT_TRAIL
    delay: 8
    wait_all: true    # Vincolo 30

  - from: 16  # REPORT_GENERATION
    to: 18    # AUDIT_TRAIL
    delay: 14
    wait_all: false   # Vincolo 31

  # 5.6 Infrastruttura e Cleanup (Vincoli 32-40)
  - from: 12  # ARCHIVE_PROCESSING
    to: 19    # SYSTEM_CLEANUP
    delay: 14
    wait_all: true    # Vincolo 32

  - from: 15  # BACKUP_CREATION
    to: 19    # SYSTEM_CLEANUP
    delay: 8
    wait_all: false   # Vincolo 33

  - from: 15  # BACKUP_CREATION
    to: 20    # FINAL_VALIDATION
    delay: 7
    wait_all: true    # Vincolo 34

  - from: 12  # ARCHIVE_PROCESSING
    to: 20    # FINAL_VALIDATION
    delay: 15
    wait_all: false   # Vincolo 35

  - from: 13  # SECURITY_VALIDATION
    to: 20    # FINAL_VALIDATION
    delay: 5
    wait_all: true    # Vincolo 36

  - from: 17  # DATA_ENCRYPTION
    to: 21    # RISK_ASSESSMENT
    delay: 10
    wait_all: true    # Vincolo 37

  - from: 16  # REPORT_GENERATION
    to: 22    # FRAUD_DETECTION
    delay: 7
    wait_all: false   # Vincolo 38

  - from: 17  # DATA_ENCRYPTION
    to: 23    # CURRENCY_CONVERSION
    delay: 14
    wait_all: false   # Vincolo 39

  - from: 18  # AUDIT_TRAIL
    to: 23    # CURRENCY_CONVERSION
    delay: 5
    wait_all: true    # Vincolo 40

  # 5.7 Operazioni Finanziarie Avanzate (Vincoli 41-50)
  - from: 20  # FINAL_VALIDATION
    to: 23    # CURRENCY_CONVERSION
    delay: 9
    wait_all: false   # Vincolo 41

  - from: 3   # SHIPPING_CALCULATION
    to: 24    # PRICE_OPTIMIZATION
    delay: 13
    wait_all: true    # Vincolo 42

  - from: 14  # PERFORMANCE_MONITOR
    to: 24    # PRICE_OPTIMIZATION
    delay: 9
    wait_all: false   # Vincolo 43

  - from: 21  # RISK_ASSESSMENT
    to: 25    # LOYALTY_PROCESSING
    delay: 10
    wait_all: false   # Vincolo 44

  - from: 21  # RISK_ASSESSMENT
    to: 26    # RETURN_HANDLING
    delay: 6
    wait_all: true    # Vincolo 45

  - from: 22  # FRAUD_DETECTION
    to: 26    # RETURN_HANDLING
    delay: 12
    wait_all: false   # Vincolo 46

  - from: 18  # AUDIT_TRAIL
    to: 26    # RETURN_HANDLING
    delay: 11
    wait_all: false   # Vincolo 47

  - from: 24  # PRICE_OPTIMIZATION
    to: 27    # REFUND_PROCESSING
    delay: 14
    wait_all: false   # Vincolo 48

  - from: 20  # FINAL_VALIDATION
    to: 27    # REFUND_PROCESSING
    delay: 13
    wait_all: false   # Vincolo 49

  - from: 20  # FINAL_VALIDATION
    to: 28    # PRODUCT_RECOMMENDATION
    delay: 16
    wait_all: false   # Vincolo 50

  # 5.8 Analytics e Raccomandazioni (Vincoli 51-60)
  - from: 8   # FINAL_PROCESSING
    to: 28    # PRODUCT_RECOMMENDATION
    delay: 8
    wait_all: true    # Vincolo 51

  - from: 22  # FRAUD_DETECTION
    to: 29    # ANALYTICS_UPDATE
    delay: 16
    wait_all: true    # Vincolo 52

  - from: 14  # PERFORMANCE_MONITOR
    to: 30    # CACHE_REFRESH
    delay: 10
    wait_all: true    # Vincolo 53

  - from: 2   # INVENTORY_CHECK
    to: 30    # CACHE_REFRESH
    delay: 5
    wait_all: true    # Vincolo 54

  - from: 11  # COMPLIANCE_CHECK
    to: 30    # CACHE_REFRESH
    delay: 16
    wait_all: false   # Vincolo 55

  - from: 10  # DOCUMENT_GENERATION
    to: 31    # LOG_PROCESSING
    delay: 13
    wait_all: false   # Vincolo 56

  - from: 17  # DATA_ENCRYPTION
    to: 31    # LOG_PROCESSING
    delay: 5
    wait_all: true    # Vincolo 57

  - from: 30  # CACHE_REFRESH
    to: 32    # ERROR_HANDLING
    delay: 14
    wait_all: true    # Vincolo 58

  - from: 29  # ANALYTICS_UPDATE
    to: 32    # ERROR_HANDLING
    delay: 7
    wait_all: true    # Vincolo 59

  - from: 28  # PRODUCT_RECOMMENDATION
    to: 32    # ERROR_HANDLING
    delay: 10
    wait_all: false   # Vincolo 60

  # 5.9 Load Balancing e Sincronizzazione (Vincoli 61-70)
  - from: 32  # ERROR_HANDLING
    to: 33    # LOAD_BALANCING
    delay: 15
    wait_all: true    # Vincolo 61

  - from: 31  # LOG_PROCESSING
    to: 33    # LOAD_BALANCING
    delay: 12
    wait_all: true    # Vincolo 62

  - from: 25  # LOYALTY_PROCESSING
    to: 33    # LOAD_BALANCING
    delay: 15
    wait_all: false   # Vincolo 63

  - from: 30  # CACHE_REFRESH
    to: 34    # DATABASE_SYNC
    delay: 13
    wait_all: false   # Vincolo 64

  - from: 27  # REFUND_PROCESSING
    to: 34    # DATABASE_SYNC
    delay: 13
    wait_all: false   # Vincolo 65

  - from: 4   # ORDER_CONFIRMATION
    to: 34    # DATABASE_SYNC
    delay: 13
    wait_all: true    # Vincolo 66

  - from: 32  # ERROR_HANDLING
    to: 35    # API_VALIDATION
    delay: 10
    wait_all: true    # Vincolo 67

  - from: 28  # PRODUCT_RECOMMENDATION
    to: 36    # SESSION_MANAGEMENT
    delay: 10
    wait_all: false   # Vincolo 68

  - from: 31  # LOG_PROCESSING
    to: 37    # EMAIL_DISPATCH
    delay: 11
    wait_all: true    # Vincolo 69

  - from: 33  # LOAD_BALANCING
    to: 37    # EMAIL_DISPATCH
    delay: 14
    wait_all: true    # Vincolo 70

  - from: 35  # API_VALIDATION
    to: 37    # EMAIL_DISPATCH
    delay: 9
    wait_all: false   # Vincolo 71

  # 5.10 Notifiche Multi-Canale (Vincoli 72-80)
  - from: 36  # SESSION_MANAGEMENT
    to: 38    # SMS_NOTIFICATION
    delay: 8
    wait_all: false   # Vincolo 72

  - from: 30  # CACHE_REFRESH
    to: 38    # SMS_NOTIFICATION
    delay: 12
    wait_all: false   # Vincolo 73

  - from: 33  # LOAD_BALANCING
    to: 38    # SMS_NOTIFICATION
    delay: 8
    wait_all: false   # Vincolo 74

  - from: 31  # LOG_PROCESSING
    to: 39    # PUSH_NOTIFICATION
    delay: 8
    wait_all: true    # Vincolo 75

  - from: 39  # PUSH_NOTIFICATION
    to: 40    # WEBHOOK_TRIGGER
    delay: 7
    wait_all: true    # Vincolo 76

  - from: 36  # SESSION_MANAGEMENT
    to: 40    # WEBHOOK_TRIGGER
    delay: 10
    wait_all: false   # Vincolo 77

  - from: 20  # FINAL_VALIDATION
    to: 41    # CONTENT_MODERATION
    delay: 6
    wait_all: true    # Vincolo 78

  - from: 21  # RISK_ASSESSMENT
    to: 41    # CONTENT_MODERATION
    delay: 8
    wait_all: true    # Vincolo 79

  - from: 10  # DOCUMENT_GENERATION
    to: 41    # CONTENT_MODERATION
    delay: 12
    wait_all: false   # Vincolo 80

  # 5.11 Processing Multimediale (Vincoli 81-90)
  - from: 8   # FINAL_PROCESSING
    to: 42    # IMAGE_PROCESSING
    delay: 5
    wait_all: true    # Vincolo 81

  - from: 1   # PAYMENT_VALIDATION
    to: 42    # IMAGE_PROCESSING
    delay: 10
    wait_all: false   # Vincolo 82

  - from: 20  # FINAL_VALIDATION
    to: 42    # IMAGE_PROCESSING
    delay: 5
    wait_all: true    # Vincolo 83

  - from: 20  # FINAL_VALIDATION
    to: 43    # VIDEO_PROCESSING
    delay: 9
    wait_all: true    # Vincolo 84

  - from: 2   # INVENTORY_CHECK
    to: 43    # VIDEO_PROCESSING
    delay: 10
    wait_all: true    # Vincolo 85

  - from: 37  # EMAIL_DISPATCH
    to: 43    # VIDEO_PROCESSING
    delay: 8
    wait_all: false   # Vincolo 86

  - from: 43  # VIDEO_PROCESSING
    to: 44    # FILE_UPLOAD
    delay: 6
    wait_all: false   # Vincolo 87

  - from: 41  # CONTENT_MODERATION
    to: 44    # FILE_UPLOAD
    delay: 7
    wait_all: true    # Vincolo 88

  - from: 38  # SMS_NOTIFICATION
    to: 45    # METADATA_EXTRACTION
    delay: 13
    wait_all: false   # Vincolo 89

  - from: 44  # FILE_UPLOAD
    to: 45    # METADATA_EXTRACTION
    delay: 13
    wait_all: false   # Vincolo 90

  # 5.12 Search, Recommendations e Testing (Vincoli 91-102)
  - from: 42  # IMAGE_PROCESSING
    to: 46    # SEARCH_INDEXING
    delay: 8
    wait_all: true    # Vincolo 91

  - from: 45  # METADATA_EXTRACTION
    to: 46    # SEARCH_INDEXING
    delay: 6
    wait_all: false   # Vincolo 92

  - from: 35  # API_VALIDATION
    to: 47    # RECOMMENDATION_ENGINE
    delay: 7
    wait_all: true    # Vincolo 93

  - from: 29  # ANALYTICS_UPDATE
    to: 47    # RECOMMENDATION_ENGINE
    delay: 12
    wait_all: true    # Vincolo 94

  - from: 4   # ORDER_CONFIRMATION
    to: 47    # RECOMMENDATION_ENGINE
    delay: 6
    wait_all: false   # Vincolo 95

  - from: 46  # SEARCH_INDEXING
    to: 48    # AB_TESTING
    delay: 7
    wait_all: false   # Vincolo 96

  - from: 46  # SEARCH_INDEXING
    to: 49    # FEATURE_TOGGLE
    delay: 16
    wait_all: true    # Vincolo 97

  - from: 47  # RECOMMENDATION_ENGINE
    to: 49    # FEATURE_TOGGLE
    delay: 12
    wait_all: true    # Vincolo 98

  - from: 42  # IMAGE_PROCESSING
    to: 49    # FEATURE_TOGGLE
    delay: 6
    wait_all: false   # Vincolo 99

  - from: 49  # FEATURE_TOGGLE
    to: 50    # RATE_LIMITING
    delay: 12
    wait_all: true    # Vincolo 100

  - from: 47  # RECOMMENDATION_ENGINE
    to: 51    # CIRCUIT_BREAKER
    delay: 10
    wait_all: false   # Vincolo 101

  - from: 49  # FEATURE_TOGGLE
    to: 52    # HEALTH_CHECK
    delay: 10
    wait_all: false   # Vincolo 102