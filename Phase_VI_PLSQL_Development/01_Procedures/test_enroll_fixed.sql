-- test_enroll_fixed.sql
SET SERVEROUTPUT ON;
SET FEEDBACK ON;



-- First, check current data
SELECT 'Before test - Total enrollments: ' || COUNT(*) FROM program_participation;

-- Test the procedure
DECLARE
    v_offender_id NUMBER;
    v_program_id NUMBER;
    v_test_offender_id NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Testing enroll_in_program ===');
    
    -- Test 1: Normal enrollment with program that has capacity
    -- Find program 103 (Adult Literacy) - shows 22 available slots
    v_program_id := 103;
    
    -- Get an active offender not in program 103
    BEGIN
        SELECT o.offender_id INTO v_offender_id
        FROM offenders o
        WHERE o.status = 'ACTIVE'
        AND NOT EXISTS (
            SELECT 1 FROM program_participation pp
            WHERE pp.offender_id = o.offender_id
            AND pp.program_id = v_program_id
        )
        AND ROWNUM = 1;
        
        DBMS_OUTPUT.PUT_LINE('Test 1 - Using offender ID: ' || v_offender_id);
        DBMS_OUTPUT.PUT_LINE('Test 1 - Using program ID: ' || v_program_id);
        
        enroll_in_program(v_offender_id, v_program_id);
        DBMS_OUTPUT.PUT_LINE('✓ Test 1 passed!');
        
        -- Save for duplicate test
        v_test_offender_id := v_offender_id;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No eligible offender found for program ' || v_program_id);
    END;
    
    -- Test 2: Try duplicate enrollment (should fail)
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test 2 - Trying duplicate enrollment...');
        enroll_in_program(v_test_offender_id, v_program_id);
        DBMS_OUTPUT.PUT_LINE('✗ Test 2 should have failed (duplicate)!');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('✓ Test 2 passed (correctly rejected duplicate)');
    END;
    
    -- Test 3: Try program that's full (program 102 shows -8 available)
    BEGIN
        v_program_id := 102; -- Anger Management (shows -8 available)
        
        -- Find an offender not in program 102
        SELECT o.offender_id INTO v_offender_id
        FROM offenders o
        WHERE o.status = 'ACTIVE'
        AND NOT EXISTS (
            SELECT 1 FROM program_participation pp
            WHERE pp.offender_id = o.offender_id
            AND pp.program_id = v_program_id
        )
        AND ROWNUM = 1;
        
        DBMS_OUTPUT.PUT_LINE('Test 3 - Trying full program ' || v_program_id);
        enroll_in_program(v_offender_id, v_program_id);
        DBMS_OUTPUT.PUT_LINE('✗ Test 3 should have failed (program full)!');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('✓ Test 3 passed (correctly rejected full program)');
    END;
    
    -- Test 4: Try with invalid offender ID
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test 4 - Trying invalid offender ID 99999');
        enroll_in_program(99999, 101);
        DBMS_OUTPUT.PUT_LINE('✗ Test 4 should have failed (invalid offender)!');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('✓ Test 4 passed (correctly rejected invalid offender)');
    END;
    
    -- Test 5: Try with invalid program ID
    BEGIN
        SELECT offender_id INTO v_offender_id
        FROM offenders 
        WHERE status = 'ACTIVE'
        AND ROWNUM = 1;
        
        DBMS_OUTPUT.PUT_LINE('Test 5 - Trying invalid program ID 999');
        enroll_in_program(v_offender_id, 999);
        DBMS_OUTPUT.PUT_LINE('✗ Test 5 should have failed (invalid program)!');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('✓ Test 5 passed (correctly rejected invalid program)');
    END;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error in test block: ' || SQLERRM);
END;
/

-- Check results
SELECT 'After test - Total enrollments: ' || COUNT(*) FROM program_participation;

-- Show recent enrollments
PROMPT Recent enrollments:
SELECT pp.participation_id, 
       o.first_name || ' ' || o.last_name as offender,
       rp.program_name, 
       pp.enrollment_date, 
       pp.status
FROM program_participation pp
JOIN offenders o ON pp.offender_id = o.offender_id
JOIN rehab_programs rp ON pp.program_id = rp.program_id
WHERE pp.participation_id >= 10000
ORDER BY pp.participation_id DESC;