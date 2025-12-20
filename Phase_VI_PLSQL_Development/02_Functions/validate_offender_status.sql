
-- validate_offender_status.sql
CREATE OR REPLACE FUNCTION validate_offender_status(
    p_offender_id IN NUMBER,
    p_required_status IN VARCHAR2 DEFAULT 'ACTIVE'
) RETURN BOOLEAN
IS
    v_current_status VARCHAR2(20);
BEGIN
    -- Get current status
    SELECT status INTO v_current_status
    FROM offenders
    WHERE offender_id = p_offender_id;
    
    -- Compare with required status
    RETURN v_current_status = p_required_status;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE; -- Offender not found
    WHEN OTHERS THEN
        RETURN FALSE;
END;
/