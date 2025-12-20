
-- Test the add_offender procedure
SET SERVEROUTPUT ON;
DECLARE
    v_offender_id NUMBER;
BEGIN
    -- Test 1: Valid data
    DBMS_OUTPUT.PUT_LINE('Test 1: Adding valid offender...');
    add_offender(
        p_national_id   => '119988001999',
        p_first_name    => 'Test',
        p_last_name     => 'User',
        p_gender        => 'M',
        p_date_of_birth => TO_DATE('1990-01-01', 'YYYY-MM-DD'),
        p_address       => 'Test Address',
        p_risk_score    => 0.45,
        p_offender_id   => v_offender_id
    );
    DBMS_OUTPUT.PUT_LINE('Success! Offender ID: ' || v_offender_id);
    
    -- Test 2: Invalid risk score (should fail)
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test 2: Testing invalid risk score...');
        add_offender(
            p_national_id   => '119988002000',
            p_first_name    => 'Invalid',
            p_last_name     => 'Risk',
            p_gender        => 'F',
            p_date_of_birth => TO_DATE('1995-01-01', 'YYYY-MM-DD'),
            p_address       => 'Test Address',
            p_risk_score    => 1.5,  -- Invalid (>1)
            p_offender_id   => v_offender_id
        );
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
    END;
    
    -- Test 3: Invalid gender (should fail)
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test 3: Testing invalid gender...');
        add_offender(
            p_national_id   => '119988002001',
            p_first_name    => 'Invalid',
            p_last_name     => 'Gender',
            p_gender        => 'X',  -- Invalid
            p_date_of_birth => TO_DATE('1995-01-01', 'YYYY-MM-DD'),
            p_address       => 'Test Address',
            p_risk_score    => 0.3,
            p_offender_id   => v_offender_id
        );
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
    END;
    
    -- Verify data
    DBMS_OUTPUT.PUT_LINE('Verifying data...');
    SELECT COUNT(*) INTO v_offender_id 
    FROM offenders 
    WHERE national_id = '119988001999';
    
    DBMS_OUTPUT.PUT_LINE('Offender found: ' || CASE WHEN v_offender_id > 0 THEN 'YES' ELSE 'NO' END);
    
END;
/