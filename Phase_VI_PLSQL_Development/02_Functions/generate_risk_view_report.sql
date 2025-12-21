CREATE OR REPLACE PROCEDURE generate_risk_review_report IS

    CURSOR offender_cursor IS
        SELECT offender_id, first_name, last_name, risk_score
        FROM offenders
        WHERE status = 'ACTIVE';

    v_new_risk_score NUMBER := 0;
    v_eligibility    VARCHAR2(50);

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== RISK REVIEW REPORT ===');

    FOR offender_rec IN offender_cursor LOOP

        v_new_risk_score := calculate_risk_score(offender_rec.offender_id);

        IF v_new_risk_score <= 3 THEN
            v_eligibility := 'ELIGIBLE';
        ELSE
            v_eligibility := 'NOT ELIGIBLE';
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            offender_rec.first_name || ' ' ||
            offender_rec.last_name || ' | Risk: ' ||
            v_new_risk_score || ' | ' || v_eligibility
        );

    END LOOP;

END generate_risk_review_report;
/
