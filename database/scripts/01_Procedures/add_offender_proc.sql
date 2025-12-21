-- ============================================
-- PROCEDURE: add_offender
-- PURPOSE: Insert a new offender with validation

CREATE OR REPLACE PROCEDURE add_offender(
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
IS
    v_duplicate_exists NUMBER;
    
    invalid_risk_score EXCEPTION;
    invalid_gender     EXCEPTION;
    duplicate_id       EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(invalid_risk_score, -20001);
    PRAGMA EXCEPTION_INIT(invalid_gender, -20002);
    PRAGMA EXCEPTION_INIT(duplicate_id, -20003);
BEGIN
    -- 1. Validate risk score (0-1)
    IF p_risk_score < 0 OR p_risk_score > 1 THEN
        RAISE invalid_risk_score;
    END IF;
    
    -- 2. Validate gender (M/F)
    IF p_gender NOT IN ('M', 'F') THEN
        RAISE invalid_gender;
    END IF;
    
    -- 3. Check for duplicate national ID
    BEGIN
        SELECT 1 INTO v_duplicate_exists
        FROM offenders 
        WHERE national_id = p_national_id
        AND ROWNUM = 1;
        
        RAISE duplicate_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL; -- No duplicate, continue
    END;
    
    -- 4. Get next sequence value
    SELECT seq_offenders.NEXTVAL INTO p_offender_id FROM dual;
    
    -- 5. Insert offender
    INSERT INTO offenders (
        offender_id,
        national_id,
        first_name,
        last_name,
        gender,
        date_of_birth,
        address,
        risk_score,
        status,
        created_date
    ) VALUES (
        p_offender_id,
        p_national_id,
        p_first_name,
        p_last_name,
        p_gender,
        p_date_of_birth,
        p_address,
        p_risk_score,
        p_status,
        SYSDATE
    );
    
    -- 6. Commit and log
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Offender added successfully. ID: ' || p_offender_id);
    
EXCEPTION
    WHEN invalid_risk_score THEN
        DBMS_OUTPUT.PUT_LINE('Error: Risk score must be between 0 and 1');
        ROLLBACK;
        RAISE;
    WHEN invalid_gender THEN
        DBMS_OUTPUT.PUT_LINE('Error: Gender must be M or F');
        ROLLBACK;
        RAISE;
    WHEN duplicate_id THEN
        DBMS_OUTPUT.PUT_LINE('Error: Offender with national ID ' || p_national_id || ' already exists');
        ROLLBACK;
        RAISE;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END add_offender;
/