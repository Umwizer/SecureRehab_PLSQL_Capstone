CREATE OR REPLACE FUNCTION calculate_risk_score(
    p_offender_id IN NUMBER
) RETURN NUMBER
IS
    v_risk_score NUMBER := 0.5; 
    v_offense_severity_total NUMBER := 0;
BEGIN
    -- 1. Use cursor to process each offense and calculate severity impact
    DECLARE
        CURSOR offense_cursor IS
            SELECT severity, date_committed
            FROM offenses
            WHERE offender_id = p_offender_id
            ORDER BY date_committed DESC;
    BEGIN
        FOR offense_rec IN offense_cursor LOOP
            -- Recent offenses have more weight
            IF MONTHS_BETWEEN(SYSDATE, offense_rec.date_committed) <= 12 THEN
                v_offense_severity_total := v_offense_severity_total + (offense_rec.severity * 1.5);
            ELSE
                v_offense_severity_total := v_offense_severity_total + offense_rec.severity;
            END IF;
        END LOOP;
    END;
    
    -- Add severity impact to risk score
    v_risk_score := v_risk_score + (v_offense_severity_total * 0.05);
    
    -- 2. Use cursor to check rehab program completions
    DECLARE
        v_completed_count NUMBER := 0;
        v_total_programs NUMBER := 0;
        CURSOR rehab_cursor IS
            SELECT status, completion_date
            FROM program_participation
            WHERE offender_id = p_offender_id;
    BEGIN
        FOR rehab_rec IN rehab_cursor LOOP
            v_total_programs := v_total_programs + 1;
            IF rehab_rec.status = 'COMPLETED' THEN
                v_completed_count := v_completed_count + 1;
            END IF;
        END LOOP;
        
        IF v_total_programs > 0 THEN
            v_risk_score := v_risk_score - ((v_completed_count / v_total_programs) * 0.3);
        END IF;
    END;
    
    -- Ensure score is between 0 and 1
    IF v_risk_score < 0 THEN
        v_risk_score := 0;
    ELSIF v_risk_score > 1 THEN
        v_risk_score := 1;
    END IF;
    
    RETURN ROUND(v_risk_score, 2);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0.5;
    WHEN OTHERS THEN
        RETURN -1;
END;
/