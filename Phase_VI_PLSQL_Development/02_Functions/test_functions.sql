

-- test_functions.sql
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

PROMPT ====================================
PROMPT TESTING PHASE VI FUNCTIONS
PROMPT ====================================

DECLARE
    v_result VARCHAR2(100);
    v_number_result NUMBER;
    v_boolean_result BOOLEAN;
    v_offender_id NUMBER;
BEGIN
    -- Get a test offender
    SELECT offender_id INTO v_offender_id
    FROM offenders
    WHERE ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('Testing with offender ID: ' || v_offender_id);
    DBMS_OUTPUT.PUT_LINE('============================================');
    
    -- Test 1: calculate_risk_score
    BEGIN
        v_number_result := calculate_risk_score(v_offender_id);
        DBMS_OUTPUT.PUT_LINE('1. calculate_risk_score: ' || v_number_result);
        DBMS_OUTPUT.PUT_LINE('   ✓ Test passed');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('1. calculate_risk_score: ERROR - ' || SQLERRM);
    END;
    
    -- Test 2: check_early_release_eligibility
    BEGIN
        v_result := check_early_release_eligibility(v_offender_id);
        DBMS_OUTPUT.PUT_LINE('2. check_early_release_eligibility: ' || v_result);
        DBMS_OUTPUT.PUT_LINE('   ✓ Test passed');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('2. check_early_release_eligibility: ERROR - ' || SQLERRM);
    END;
    
    -- Test 3: get_program_availability
    BEGIN
        v_result := get_program_availability(101);
        DBMS_OUTPUT.PUT_LINE('3. get_program_availability(101): ' || v_result);
        DBMS_OUTPUT.PUT_LINE('   ✓ Test passed');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('3. get_program_availability: ERROR - ' || SQLERRM);
    END;
    
    -- Test 4: calculate_offender_age
    BEGIN
        v_number_result := calculate_offender_age(v_offender_id);
        DBMS_OUTPUT.PUT_LINE('4. calculate_offender_age: ' || v_number_result || ' years');
        DBMS_OUTPUT.PUT_LINE('   ✓ Test passed');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('4. calculate_offender_age: ERROR - ' || SQLERRM);
    END;
    
    -- Test 5: validate_offender_status
    BEGIN
        v_boolean_result := validate_offender_status(v_offender_id, 'ACTIVE');
        IF v_boolean_result THEN
            DBMS_OUTPUT.PUT_LINE('5. validate_offender_status: TRUE (offender is ACTIVE)');
        ELSE
            DBMS_OUTPUT.PUT_LINE('5. validate_offender_status: FALSE');
        END IF;
        DBMS_OUTPUT.PUT_LINE('   ✓ Test passed');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('5. validate_offender_status: ERROR - ' || SQLERRM);
    END;
    
    -- Test 6: Test with invalid offender
    BEGIN
        v_result := check_early_release_eligibility(99999);
        DBMS_OUTPUT.PUT_LINE('6. Test with invalid offender: ' || v_result);
        DBMS_OUTPUT.PUT_LINE('   ✓ Test passed (handled gracefully)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('6. Test with invalid offender: ERROR - ' || SQLERRM);
    END;
    
END;
/

PROMPT ====================================
PROMPT FUNCTION DESCRIPTIONS
PROMPT ====================================

-- Show all functions created
SELECT object_name, object_type, status, created
FROM user_objects
WHERE object_type = 'FUNCTION'
AND object_name LIKE '%CALCULATE%'
   OR object_name LIKE '%CHECK%'
   OR object_name LIKE '%GET%'
   OR object_name LIKE '%VALIDATE%'
ORDER BY created;


