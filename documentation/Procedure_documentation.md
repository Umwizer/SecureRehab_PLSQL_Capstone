# Procedures Documentation

## Procedure: add_offender

**Purpose:** Insert a new offender with validation

```sql
PROCEDURE add_offender(
    p_national_id      IN VARCHAR2,
    p_first_name       IN VARCHAR2,
    p_last_name        IN VARCHAR2,
    p_gender           IN CHAR,
    p_date_of_birth    IN DATE,
    p_address          IN VARCHAR2,
    p_risk_score       IN NUMBER,
    p_status           IN VARCHAR2 DEFAULT 'ACTIVE',
    p_offender_id      OUT NUMBER
)
Procedure: update_offender_status
Purpose: Update offender's status
```

```sql
PROCEDURE update_offender_status(
    p_offender_id IN NUMBER,
    p_new_status IN VARCHAR2
)
```

```sql
Procedure: generate_risk_review_report
Purpose: Generate report using cursor (contains cursor)
PROCEDURE generate_risk_review_report
-- Contains cursor to process all offenders
TESTING PROCEDURES
-- Test procedure calls
EXEC add_offender('999888777', 'Test', 'User', 'M', SYSDATE-10000, 'Address', 0.4, 'ACTIVE', v_id);

EXEC enroll_in_program(1001, 101);

EXEC update_offender_status(1001, 'RELEASED');
```
