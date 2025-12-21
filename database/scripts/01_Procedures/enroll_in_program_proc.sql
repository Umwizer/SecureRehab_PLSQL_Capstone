
-- enroll_in_program_proc.sql - FIXED VERSION
CREATE OR REPLACE PROCEDURE enroll_in_program(
    p_offender_id IN NUMBER,
    p_program_id IN NUMBER
)
IS
    v_offender_status VARCHAR2(20);
    v_program_capacity NUMBER;
    v_current_enrolled NUMBER;
    v_already_enrolled NUMBER;
    v_participation_id NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Starting enrollment for offender ' || p_offender_id || ' in program ' || p_program_id);
    
    -- 1. Validate offender exists and is ACTIVE
    BEGIN
        SELECT status INTO v_offender_status
        FROM offenders
        WHERE offender_id = p_offender_id;
        
        IF v_offender_status != 'ACTIVE' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Offender is not ACTIVE. Current status: ' || v_offender_status);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'Offender ID ' || p_offender_id || ' not found');
    END;
    
    -- 2. Validate program exists
    BEGIN
        SELECT capacity INTO v_program_capacity
        FROM rehab_programs
        WHERE program_id = p_program_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'Program ID ' || p_program_id || ' not found');
    END;
    
    -- 3. Check current enrollment count
    SELECT COUNT(*) INTO v_current_enrolled
    FROM program_participation
    WHERE program_id = p_program_id
    AND status IN ('ENROLLED', 'ACTIVE');
    
    IF v_current_enrolled >= v_program_capacity THEN
        RAISE_APPLICATION_ERROR(-20004, 'Program ' || p_program_id || ' is at full capacity');
    END IF;
    
    -- 4. Check if already enrolled
    SELECT COUNT(*) INTO v_already_enrolled
    FROM program_participation
    WHERE offender_id = p_offender_id
    AND program_id = p_program_id
    AND status IN ('ENROLLED', 'ACTIVE');
    
    IF v_already_enrolled > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Offender ' || p_offender_id || ' is already enrolled in program ' || p_program_id);
    END IF;
    
    -- 5. Insert enrollment
    SELECT seq_enrollments.NEXTVAL INTO v_participation_id FROM DUAL;
    
    INSERT INTO program_participation (
        participation_id,
        offender_id,
        program_id,
        status,
        enrollment_date
    ) VALUES (
        v_participation_id,
        p_offender_id,
        p_program_id,
        'ENROLLED',
        SYSDATE
    );
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Enrollment successful! Participation ID: ' || v_participation_id);
    DBMS_OUTPUT.PUT_LINE('Program capacity: ' || v_program_capacity || ', Currently enrolled: ' || (v_current_enrolled + 1));
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;
/