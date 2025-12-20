
-- calculate_offender_age.sql
CREATE OR REPLACE FUNCTION calculate_offender_age(
    p_offender_id IN NUMBER
) RETURN NUMBER
IS
    v_date_of_birth DATE;
    v_age NUMBER;
BEGIN
    -- Get date of birth from offenders table
    -- Adjust column name based on your actual schema
    SELECT date_of_birth INTO v_date_of_birth
    FROM offenders
    WHERE offender_id = p_offender_id;
    
    -- Calculate age
    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, v_date_of_birth) / 12);
    
    RETURN v_age;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1; -- Error indicator
    WHEN OTHERS THEN
        RETURN -1;
END;
/