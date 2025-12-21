CREATE OR REPLACE FUNCTION check_early_release_eligibility(
    p_offender_id IN NUMBER
) RETURN VARCHAR2
IS
    v_risk_score NUMBER;
    v_sentence_completion_percentage NUMBER;
    v_rehab_completion_count NUMBER;
    v_eligibility VARCHAR2(50);
    v_has_active_sentence BOOLEAN := FALSE;
BEGIN
    -- First, check if calculate_risk_score function exists
    BEGIN
        v_risk_score := calculate_risk_score(p_offender_id);
    EXCEPTION
        WHEN OTHERS THEN
            -- If function doesn't exist, use default
            v_risk_score := 0.5;
    END;
    
    -- Calculate sentence completion percentage
    DECLARE
        v_days_served NUMBER;
        v_total_sentence_days NUMBER;
    BEGIN
        -- Check if sentences table exists and has data
        SELECT 
            CASE 
                WHEN TRUNC(SYSDATE) - TRUNC(start_date) < 0 THEN 0
                ELSE TRUNC(SYSDATE) - TRUNC(start_date)
            END,
            CASE 
                WHEN TRUNC(end_date) - TRUNC(start_date) <= 0 THEN 1
                ELSE TRUNC(end_date) - TRUNC(start_date)
            END
        INTO v_days_served, v_total_sentence_days
        FROM sentences
        WHERE offender_id = p_offender_id
        AND status = 'ACTIVE'
        AND ROWNUM = 1;
        
        v_has_active_sentence := TRUE;
        
        IF v_total_sentence_days > 0 THEN
            v_sentence_completion_percentage := (v_days_served / v_total_sentence_days) * 100;
            -- Ensure percentage is between 0 and 100
            IF v_sentence_completion_percentage < 0 THEN
                v_sentence_completion_percentage := 0;
            ELSIF v_sentence_completion_percentage > 100 THEN
                v_sentence_completion_percentage := 100;
            END IF;
        ELSE
            v_sentence_completion_percentage := 0;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_sentence_completion_percentage := 0;
            v_has_active_sentence := FALSE;
    END;
    
    -- Count completed rehab programs
    BEGIN
        SELECT COUNT(*) INTO v_rehab_completion_count
        FROM program_participation
        WHERE offender_id = p_offender_id
        AND status = 'COMPLETED';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_rehab_completion_count := 0;
    END;
    
    -- Determine eligibility
    -- If no active sentence, not eligible
    IF NOT v_has_active_sentence THEN
        v_eligibility := 'NOT_ELIGIBLE - NO ACTIVE SENTENCE';
    ELSIF v_risk_score <= 0.3 
       AND v_sentence_completion_percentage >= 50 
       AND v_rehab_completion_count >= 2 THEN
        v_eligibility := 'HIGHLY_ELIGIBLE';
    ELSIF v_risk_score <= 0.5 
          AND v_sentence_completion_percentage >= 60 
          AND v_rehab_completion_count >= 1 THEN
        v_eligibility := 'ELIGIBLE';
    ELSIF v_risk_score <= 0.7 
          AND v_sentence_completion_percentage >= 75 THEN
        v_eligibility := 'CONDITIONAL';
    ELSE
        v_eligibility := 'NOT_ELIGIBLE';
    END IF;
    
    RETURN v_eligibility;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR: ' || SQLERRM;
END;
/