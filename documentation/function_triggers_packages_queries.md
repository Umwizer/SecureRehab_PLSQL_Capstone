# Complete PL/SQL Documentation

## FUNCTIONS WITH RETURN TYPES

### **1. calculate_risk_score**

```sql
FUNCTION calculate_risk_score(
    p_offender_id IN NUMBER
) RETURN NUMBER
-- Returns: Risk score between 0 and 1
-- Purpose: Calculates offender's risk based on offenses and rehabilitation
```

### **2. check_early_release_eligibility**

```sql
FUNCTION check_early_release_eligibility(
    p_offender_id IN NUMBER
) RETURN VARCHAR2
-- Returns: 'HIGHLY_ELIGIBLE', 'ELIGIBLE', 'CONDITIONAL', or 'NOT_ELIGIBLE'
-- Purpose: Determines if offender qualifies for early release
```

### **3. get_program_availability**

```sql
FUNCTION get_program_availability(
    p_program_id IN NUMBER
) RETURN VARCHAR2
-- Returns: 'FULL', 'LIMITED', 'MODERATE', or 'AVAILABLE'
-- Purpose: Checks available slots in rehabilitation program
```

### **4. calculate_offender_age**

```sql
FUNCTION calculate_offender_age(
    p_offender_id IN NUMBER
) RETURN NUMBER
-- Returns: Age in years
-- Purpose: Calculates offender's current age
```

### **5. validate_offender_status**

```sql
FUNCTION validate_offender_status(
    p_offender_id IN NUMBER,
    p_required_status IN VARCHAR2 DEFAULT 'ACTIVE'
) RETURN BOOLEAN
-- Returns: TRUE if status matches, FALSE otherwise
-- Purpose: Validates offender's current status
```

### **6. generate_risk_view_reports**

```sql
FUNCTION generate_risk_view_reports RETURN CLOB
-- Returns: CLOB containing formatted report
-- Purpose: Generates comprehensive risk reports using cursor
-- CONTAINS CURSOR: Processes multiple offenders sequentially
```

---

## TRIGGERS WITH LOGIC EXPLANATION

### **1. trg_offender_risk_alert**

**Table:** `offenders`  
**Timing:** `AFTER UPDATE OF risk_score`  
**Logic:** Creates automatic alert when offender's risk score exceeds 0.7

```sql
CREATE OR REPLACE TRIGGER trg_offender_risk_alert
AFTER UPDATE OF risk_score ON offenders
FOR EACH ROW
WHEN (NEW.risk_score > 0.7)
BEGIN
    INSERT INTO alerts (alert_id, offender_id, alert_type, description)
    VALUES (seq_alerts.NEXTVAL, :NEW.offender_id, 'HIGH_RISK',
            'Risk score increased to ' || :NEW.risk_score);
END;
```

### **2. trg_program_enrollment_limit**

**Table:** `program_participation`  
**Timing:** `BEFORE INSERT`  
**Logic:** Prevents enrollment if rehabilitation program is at full capacity

```sql
CREATE OR REPLACE TRIGGER trg_program_enrollment_limit
BEFORE INSERT ON program_participation
FOR EACH ROW
DECLARE
    v_current_count NUMBER;
    v_capacity NUMBER;
BEGIN
    -- Get program capacity
    SELECT capacity INTO v_capacity
    FROM rehab_programs
    WHERE program_id = :NEW.program_id;

    -- Count current enrollments
    SELECT COUNT(*) INTO v_current_count
    FROM program_participation
    WHERE program_id = :NEW.program_id
    AND status IN ('ENROLLED', 'IN_PROGRESS');

    -- Reject if full
    IF v_current_count >= v_capacity THEN
        RAISE_APPLICATION_ERROR(-20001, 'Program is at full capacity');
    END IF;
END;
```

### **3. trg_validate_offender_data**

**Table:** `offenders`  
**Timing:** `BEFORE INSERT OR UPDATE`  
**Logic:** Validates all data constraints before insert/update operations

```sql
CREATE OR REPLACE TRIGGER trg_validate_offender_data
BEFORE INSERT OR UPDATE ON offenders
FOR EACH ROW
BEGIN
    -- Validate risk_score range (0-1)
    IF :NEW.risk_score < 0 OR :NEW.risk_score > 1 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Risk score must be between 0 and 1');
    END IF;

    -- Validate gender values
    IF :NEW.gender NOT IN ('M', 'F') THEN
        RAISE_APPLICATION_ERROR(-20003, 'Gender must be M or F');
    END IF;

    -- Validate status values
    IF :NEW.status NOT IN ('ACTIVE', 'RELEASED', 'TRANSFERRED', 'DECEASED') THEN
        RAISE_APPLICATION_ERROR(-20004, 'Invalid status value');
    END IF;
END;
```

### **4. trg_audit_offender_changes**

**Table:** `offenders`  
**Timing:** `AFTER INSERT OR UPDATE OR DELETE`  
**Logic:** Logs all changes to offenders table for audit trail

```sql
CREATE OR REPLACE TRIGGER trg_audit_offender_changes
AFTER INSERT OR UPDATE OR DELETE ON offenders
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (log_id, table_name, action, user_name, timestamp, offender_id)
    VALUES (audit_seq.NEXTVAL, 'OFFENDERS',
            CASE
                WHEN INSERTING THEN 'INSERT'
                WHEN UPDATING THEN 'UPDATE'
                WHEN DELETING THEN 'DELETE'
            END,
            USER, SYSDATE,
            COALESCE(:NEW.offender_id, :OLD.offender_id));
END;
```

### **5. Compound Trigger (from compound_triggers.sql)**

**Purpose:** Handles complex business rules with multiple timing points

- **BEFORE STATEMENT:** Initial setup and validation
- **BEFORE EACH ROW:** Row-level validation
- **AFTER EACH ROW:** Immediate processing
- **AFTER STATEMENT:** Final cleanup and logging

---

## PACKAGES (SPECIFICATION & BODY)

### **Package: secure_rehab_pkg**

**Purpose:** Groups related functionality for better organization and performance

#### **Package Specification:**

```sql
CREATE OR REPLACE PACKAGE secure_rehab_pkg AS
    -- Offender Management
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
    );

    -- Program Management
    PROCEDURE enroll_in_program(
        p_offender_id IN NUMBER,
        p_program_id IN NUMBER
    );

    -- Risk Assessment
    FUNCTION calculate_risk_score(
        p_offender_id IN NUMBER
    ) RETURN NUMBER;

    FUNCTION check_early_release_eligibility(
        p_offender_id IN NUMBER
    ) RETURN VARCHAR2;

    -- Reporting
    PROCEDURE generate_risk_review_report;

    PROCEDURE generate_monthly_statistics(
        p_month IN NUMBER,
        p_year IN NUMBER
    );

    -- Constants
    c_high_risk_threshold CONSTANT NUMBER := 0.7;
    c_medium_risk_threshold CONSTANT NUMBER := 0.3;

END secure_rehab_pkg;
```

#### **Package Body:**

```sql
CREATE OR REPLACE PACKAGE BODY secure_rehab_pkg AS

    -- Implementation of add_offender procedure
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
    ) IS
    BEGIN
        -- Implementation code here
        NULL;
    END add_offender;

    -- Other procedure/function implementations...

END secure_rehab_pkg;
```

---

## ANALYTICS QUERIES

### **Window Functions**

#### **1. Risk Ranking with ROW_NUMBER, RANK, DENSE_RANK**

```sql
SELECT
    offender_id,
    first_name,
    last_name,
    risk_score,
    ROW_NUMBER() OVER (ORDER BY risk_score DESC) as row_num,
    RANK() OVER (ORDER BY risk_score DESC) as risk_rank,
    DENSE_RANK() OVER (ORDER BY risk_score DESC) as dense_rank,
    NTILE(4) OVER (ORDER BY risk_score DESC) as risk_quartile
FROM offenders
WHERE status = 'ACTIVE'
ORDER BY risk_score DESC;
```

#### **2. Risk Trend Analysis with LAG/LEAD**

```sql
SELECT
    offender_id,
    created_date,
    risk_score,
    LAG(risk_score, 1) OVER (PARTITION BY offender_id ORDER BY created_date) as previous_score,
    risk_score - LAG(risk_score, 1) OVER (PARTITION BY offender_id ORDER BY created_date) as score_change,
    LEAD(risk_score, 1) OVER (PARTITION BY offender_id ORDER BY created_date) as next_score
FROM offenders
ORDER BY offender_id, created_date;
```

#### **3. Running Totals and Moving Averages**

```sql
SELECT
    TO_CHAR(created_date, 'YYYY-MM') as month,
    COUNT(*) as new_offenders,
    SUM(COUNT(*)) OVER (ORDER BY TO_CHAR(created_date, 'YYYY-MM')) as running_total,
    AVG(COUNT(*)) OVER (ORDER BY TO_CHAR(created_date, 'YYYY-MM') ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg_3months
FROM offenders
GROUP BY TO_CHAR(created_date, 'YYYY-MM')
ORDER BY month;
```

### **Aggregation Queries**

#### **1. Risk Distribution Analysis**

```sql
SELECT
    CASE
        WHEN risk_score < 0.3 THEN 'Low Risk (0-0.3)'
        WHEN risk_score < 0.7 THEN 'Medium Risk (0.4-0.6)'
        ELSE 'High Risk (0.7-1.0)'
    END as risk_category,
    COUNT(*) as offender_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM offenders WHERE status = 'ACTIVE'), 1) as percentage,
    ROUND(AVG(risk_score), 3) as average_risk,
    MIN(risk_score) as min_risk,
    MAX(risk_score) as max_risk,
    ROUND(STDDEV(risk_score), 3) as risk_std_dev
FROM offenders
WHERE status = 'ACTIVE'
GROUP BY
    CASE
        WHEN risk_score < 0.3 THEN 'Low Risk (0-0.3)'
        WHEN risk_score < 0.7 THEN 'Medium Risk (0.4-0.6)'
        ELSE 'High Risk (0.7-1.0)'
    END
ORDER BY risk_category;
```

#### **2. Program Effectiveness with Multiple Aggregates**

```sql
SELECT
    rp.program_name,
    COUNT(DISTINCT pp.offender_id) as total_participants,
    SUM(CASE WHEN pp.status = 'COMPLETED' THEN 1 ELSE 0 END) as completed,
    SUM(CASE WHEN pp.status IN ('ENROLLED', 'IN_PROGRESS') THEN 1 ELSE 0 END) as active,
    ROUND(AVG(o.risk_score), 3) as avg_risk_before,
    ROUND(AVG(o.risk_score - 0.15), 3) as estimated_risk_after,
    ROUND((AVG(o.risk_score) - AVG(o.risk_score - 0.15)) * 100, 1) as risk_reduction_percent,
    ROUND(COUNT(pp.participation_id) * 100.0 / rp.capacity, 1) as utilization_percent
FROM rehab_programs rp
LEFT JOIN program_participation pp ON rp.program_id = pp.program_id
LEFT JOIN offenders o ON pp.offender_id = o.offender_id
GROUP BY rp.program_name, rp.capacity
ORDER BY risk_reduction_percent DESC;
```

#### **3. Monthly Performance Dashboard**

```sql
SELECT
    TO_CHAR(created_date, 'YYYY-MM') as report_month,
    COUNT(*) as new_offenders,
    SUM(CASE WHEN risk_score > 0.7 THEN 1 ELSE 0 END) as high_risk_intake,
    ROUND(AVG(risk_score), 3) as avg_risk_score,
    (SELECT COUNT(*) FROM program_participation
     WHERE TO_CHAR(enrollment_date, 'YYYY-MM') = TO_CHAR(o.created_date, 'YYYY-MM')) as new_enrollments,
    (SELECT COUNT(*) FROM alerts
     WHERE TO_CHAR(alert_date, 'YYYY-MM') = TO_CHAR(o.created_date, 'YYYY-MM')) as alerts_generated
FROM offenders o
GROUP BY TO_CHAR(created_date, 'YYYY-MM')
ORDER BY report_month DESC;
```

#### **4. Complex Cross-Tab Analysis**

```sql
SELECT
    gender,
    COUNT(*) as total,
    SUM(CASE WHEN risk_score < 0.3 THEN 1 ELSE 0 END) as low_risk,
    SUM(CASE WHEN risk_score BETWEEN 0.3 AND 0.7 THEN 1 ELSE 0 END) as medium_risk,
    SUM(CASE WHEN risk_score > 0.7 THEN 1 ELSE 0 END) as high_risk,
    ROUND(AVG(risk_score), 3) as avg_risk,
    ROUND(AVG(calculate_offender_age(offender_id)), 1) as avg_age,
    (SELECT COUNT(*) FROM program_participation pp
     WHERE pp.offender_id = o.offender_id AND pp.status = 'COMPLETED') as avg_programs_completed
FROM offenders o
WHERE status = 'ACTIVE'
GROUP BY gender
ORDER BY gender;
```

#### **5. Early Release Eligibility Analysis**

```sql
SELECT
    check_early_release_eligibility(offender_id) as eligibility_status,
    COUNT(*) as offender_count,
    ROUND(AVG(risk_score), 3) as avg_risk_score,
    ROUND(AVG(calculate_offender_age(offender_id)), 1) as avg_age,
    ROUND(AVG((SELECT COUNT(*) FROM offenses WHERE offender_id = o.offender_id)), 1) as avg_offenses,
    ROUND(AVG((SELECT COUNT(*) FROM program_participation
              WHERE offender_id = o.offender_id AND status = 'COMPLETED')), 1) as avg_completed_programs
FROM offenders o
WHERE status = 'ACTIVE'
GROUP BY check_early_release_eligibility(offender_id)
ORDER BY
    CASE check_early_release_eligibility(offender_id)
        WHEN 'HIGHLY_ELIGIBLE' THEN 1
        WHEN 'ELIGIBLE' THEN 2
        WHEN 'CONDITIONAL' THEN 3
        ELSE 4
    END;
```
