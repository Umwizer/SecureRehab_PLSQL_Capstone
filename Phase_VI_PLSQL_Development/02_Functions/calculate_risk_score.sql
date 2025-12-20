
-- calculate_risk_score.sql
CREATE OR REPLACE FUNCTION calculate_risk_score(
    p_offender_id IN NUMBER
) RETURN NUMBER
IS
    v_risk_score NUMBER := 0.5; -- Default base score
    v_offense_count NUMBER;
    v_rehab_completion_rate NUMBER;
    v_behavior_score NUMBER;
BEGIN
    -- 1. Count number of offenses (more offenses = higher risk)
    SELECT COUNT(*) INTO v_offense_count
    FROM offenses
    WHERE offender_id = p_offender_id;
    
    v_risk_score := v_risk_score + (v_offense_count * 0.1);
    
    -- 2. Calculate rehab completion rate
    DECLARE
        v_total_programs NUMBER;
        v_completed_programs NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total_programs
        FROM program_participation
        WHERE offender_id = p_offender_id;
        
        SELECT COUNT(*) INTO v_completed_programs
        FROM program_participation
        WHERE offender_id = p_offender_id
        AND status = 'COMPLETED';
        
        IF v_total_programs > 0 THEN
            v_rehab_completion_rate := v_completed_programs / v_total_programs;
            -- Higher completion rate = lower risk
            v_risk_score := v_risk_score - (v_rehab_completion_rate * 0.3);
        END IF;
    END;
    
    -- 3. Check behavior incidents (if you have a behavior table)
    -- This is a placeholder - adjust based on your actual schema
    
    -- Ensure score is between 0 and 1
    IF v_risk_score < 0 THEN
        v_risk_score := 0;
    ELSIF v_risk_score > 1 THEN
        v_risk_score := 1;
    END IF;
    
    RETURN ROUND(v_risk_score, 2);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0.5; -- Default if no data
    WHEN OTHERS THEN
        RETURN -1; -- Error indicator
END;
/