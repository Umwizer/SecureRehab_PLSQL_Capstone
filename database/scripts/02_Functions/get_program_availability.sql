

-- get_program_availability.sql
CREATE OR REPLACE FUNCTION get_program_availability(
    p_program_id IN NUMBER
) RETURN VARCHAR2
IS
    v_capacity NUMBER;
    v_current_enrolled NUMBER;
    v_available_slots NUMBER;
    v_availability_status VARCHAR2(50);
BEGIN
    -- Get program capacity
    SELECT capacity INTO v_capacity
    FROM rehab_programs
    WHERE program_id = p_program_id;
    
    -- Count current enrollments
    SELECT COUNT(*) INTO v_current_enrolled
    FROM program_participation
    WHERE program_id = p_program_id
    AND status IN ('ENROLLED', 'ACTIVE');
    
    v_available_slots := v_capacity - v_current_enrolled;
    
    -- Determine availability status
    IF v_available_slots <= 0 THEN
        v_availability_status := 'FULL';
    ELSIF v_available_slots <= 2 THEN
        v_availability_status := 'LIMITED';
    ELSIF v_available_slots <= 5 THEN
        v_availability_status := 'MODERATE';
    ELSE
        v_availability_status := 'AVAILABLE';
    END IF;
    
    RETURN v_availability_status;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'PROGRAM_NOT_FOUND';
    WHEN OTHERS THEN
        RETURN 'ERROR';
END;
/