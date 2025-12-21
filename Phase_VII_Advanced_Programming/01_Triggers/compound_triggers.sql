-- compound_trigger_offenses.sql
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

PROMPT ============================================
PROMPT CREATING COMPOUND TRIGGER FOR OFFENSES TABLE
PROMPT ============================================

-- Drop existing trigger if it exists
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_offenses_compound';
    DBMS_OUTPUT.PUT_LINE('Dropped existing compound trigger');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No existing compound trigger to drop');
END;

PROMPT Creating compound trigger for offenses table...

CREATE OR REPLACE TRIGGER trg_offenses_compound
FOR INSERT OR UPDATE OR DELETE ON offenses
COMPOUND TRIGGER

    -- Type declarations for storing offense data
    TYPE t_offense_rec IS RECORD (
        offense_id NUMBER,
        offender_id NUMBER,
        offense_type VARCHAR2(100),
        severity VARCHAR2(20)
    );
    
    TYPE t_offense_table IS TABLE OF t_offense_rec;
    g_inserted_offenses t_offense_table := t_offense_table();
    g_updated_offenses t_offense_table := t_offense_table();
    g_deleted_offenses t_offense_table := t_offense_table();
    
    -- Constants for risk score adjustments (based on severity)
    c_low_severity_risk    CONSTANT NUMBER := 0.05;   -- 5% increase
    c_medium_severity_risk CONSTANT NUMBER := 0.15;   -- 15% increase  
    c_high_severity_risk   CONSTANT NUMBER := 0.30;   -- 30% increase
    
    -- Before each row: Check restrictions and collect data
    BEFORE EACH ROW IS
        v_allowed BOOLEAN;
    BEGIN
        -- Check weekday/holiday restriction
        v_allowed := check_restriction_allowed;
        
        IF NOT v_allowed THEN
            RAISE_APPLICATION_ERROR(-20040, 
                'Operation not permitted on OFFENSES table on weekdays or public holidays.'
            );
        END IF;
        
        -- Store data for bulk processing
        IF INSERTING THEN
            g_inserted_offenses.EXTEND;
            g_inserted_offenses(g_inserted_offenses.LAST).offense_id := :NEW.offense_id;
            g_inserted_offenses(g_inserted_offenses.LAST).offender_id := :NEW.offender_id;
            g_inserted_offenses(g_inserted_offenses.LAST).offense_type := :NEW.offense_type;
            g_inserted_offenses(g_inserted_offenses.LAST).severity := :NEW.severity;
            
        ELSIF UPDATING THEN
            g_updated_offenses.EXTEND;
            g_updated_offenses(g_updated_offenses.LAST).offense_id := :NEW.offense_id;
            g_updated_offenses(g_updated_offenses.LAST).offender_id := :NEW.offender_id;
            g_updated_offenses(g_updated_offenses.LAST).offense_type := :NEW.offense_type;
            g_updated_offenses(g_updated_offenses.LAST).severity := :NEW.severity;
            
        ELSIF DELETING THEN
            g_deleted_offenses.EXTEND;
            g_deleted_offenses(g_deleted_offenses.LAST).offense_id := :OLD.offense_id;
            g_deleted_offenses(g_deleted_offenses.LAST).offender_id := :OLD.offender_id;
            g_deleted_offenses(g_deleted_offenses.LAST).offense_type := :OLD.offense_type;
            g_deleted_offenses(g_deleted_offenses.LAST).severity := :OLD.severity;
        END IF;
    END BEFORE EACH ROW;
    
    -- After each row: Log individual operations
    AFTER EACH ROW IS
        v_audit_id NUMBER;
    BEGIN
        IF INSERTING THEN
            v_audit_id := log_audit_trail(
                p_table_name => 'OFFENSES',
                p_operation_type => 'INSERT',
                p_offender_id => :NEW.offender_id,
                p_new_values => 
                    'Offense Type: ' || :NEW.offense_type || ', ' ||
                    'Severity: ' || :NEW.severity || ', ' ||
                    'Date: ' || TO_CHAR(:NEW.date_committed, 'DD-MON-YYYY')
            );
        ELSIF UPDATING THEN
            v_audit_id := log_audit_trail(
                p_table_name => 'OFFENSES',
                p_operation_type => 'UPDATE',
                p_offender_id => :NEW.offender_id,
                p_old_values => 
                    'Old Type: ' || :OLD.offense_type || ', ' ||
                    'Old Severity: ' || :OLD.severity,
                p_new_values => 
                    'New Type: ' || :NEW.offense_type || ', ' ||
                    'New Severity: ' || :NEW.severity
            );
        ELSIF DELETING THEN
            v_audit_id := log_audit_trail(
                p_table_name => 'OFFENSES',
                p_operation_type => 'DELETE',
                p_offender_id => :OLD.offender_id,
                p_old_values => 
                    'Deleted Offense: ' || :OLD.offense_type || ', ' ||
                    'Severity: ' || :OLD.severity
            );
        END IF;
    END AFTER EACH ROW;
    
    -- After statement: Bulk processing - Update risk scores
    AFTER STATEMENT IS
        v_risk_adjustment NUMBER;
        v_total_adjustment NUMBER := 0;
        v_affected_offenders NUMBER := 0;
        v_current_risk NUMBER;
        v_new_risk NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== Compound Trigger Processing ===');
        DBMS_OUTPUT.PUT_LINE('Inserted offenses: ' || g_inserted_offenses.COUNT);
        DBMS_OUTPUT.PUT_LINE('Updated offenses: ' || g_updated_offenses.COUNT);
        DBMS_OUTPUT.PUT_LINE('Deleted offenses: ' || g_deleted_offenses.COUNT);
        
        -- Process INSERTED offenses: Increase risk scores
        IF g_inserted_offenses.COUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Processing inserted offenses...');
            FOR i IN 1..g_inserted_offenses.COUNT LOOP
                -- Determine risk increase based on severity
                CASE g_inserted_offenses(i).severity
                    WHEN 'LOW' THEN v_risk_adjustment := c_low_severity_risk;
                    WHEN 'MEDIUM' THEN v_risk_adjustment := c_medium_severity_risk;
                    WHEN 'HIGH' THEN v_risk_adjustment := c_high_severity_risk;
                    ELSE v_risk_adjustment := c_medium_severity_risk;
                END CASE;
                
                -- Get current risk score
                BEGIN
                    SELECT risk_score INTO v_current_risk
                    FROM offenders
                    WHERE offender_id = g_inserted_offenses(i).offender_id;
                    
                    -- Calculate new risk score (max 1.0)
                    v_new_risk := LEAST(1.0, v_current_risk + v_risk_adjustment);
                    
                    -- Update offender's risk score
                    UPDATE offenders 
                    SET risk_score = v_new_risk
                    WHERE offender_id = g_inserted_offenses(i).offender_id;
                    
                    v_total_adjustment := v_total_adjustment + v_risk_adjustment;
                    v_affected_offenders := v_affected_offenders + 1;
                    
                    DBMS_OUTPUT.PUT_LINE('  Offender ' || g_inserted_offenses(i).offender_id || 
                                       ': Risk +' || ROUND(v_risk_adjustment * 100, 1) || '% (' || 
                                       g_inserted_offenses(i).severity || ' offense)');
                    
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        DBMS_OUTPUT.PUT_LINE('  WARNING: Offender ' || g_inserted_offenses(i).offender_id || ' not found');
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('  ERROR updating offender ' || g_inserted_offenses(i).offender_id || ': ' || SQLERRM);
                END;
            END LOOP;
        END IF;
        
        -- Process DELETED offenses: Decrease risk scores
        IF g_deleted_offenses.COUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Processing deleted offenses...');
            FOR i IN 1..g_deleted_offenses.COUNT LOOP
                -- Determine risk decrease based on severity
                CASE g_deleted_offenses(i).severity
                    WHEN 'LOW' THEN v_risk_adjustment := c_low_severity_risk;
                    WHEN 'MEDIUM' THEN v_risk_adjustment := c_medium_severity_risk;
                    WHEN 'HIGH' THEN v_risk_adjustment := c_high_severity_risk;
                    ELSE v_risk_adjustment := c_medium_severity_risk;
                END CASE;
                
                -- Get current risk score
                BEGIN
                    SELECT risk_score INTO v_current_risk
                    FROM offenders
                    WHERE offender_id = g_deleted_offenses(i).offender_id;
                    
                    -- Calculate new risk score (min 0.0)
                    v_new_risk := GREATEST(0.0, v_current_risk - v_risk_adjustment);
                    
                    -- Update offender's risk score
                    UPDATE offenders 
                    SET risk_score = v_new_risk
                    WHERE offender_id = g_deleted_offenses(i).offender_id;
                    
                    v_total_adjustment := v_total_adjustment - v_risk_adjustment;
                    v_affected_offenders := v_affected_offenders + 1;
                    
                    DBMS_OUTPUT.PUT_LINE('  Offender ' || g_deleted_offenses(i).offender_id || 
                                       ': Risk -' || ROUND(v_risk_adjustment * 100, 1) || '% (' || 
                                       g_deleted_offenses(i).severity || ' offense deleted)');
                    
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        DBMS_OUTPUT.PUT_LINE('  WARNING: Offender ' || g_deleted_offenses(i).offender_id || ' not found');
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('  ERROR updating offender ' || g_deleted_offenses(i).offender_id || ': ' || SQLERRM);
                END;
            END LOOP;
        END IF;
        
        -- Log summary of bulk operation
        IF v_affected_offenders > 0 THEN
            DBMS_OUTPUT.PUT_LINE('=== Summary ===');
            DBMS_OUTPUT.PUT_LINE('Total offenders affected: ' || v_affected_offenders);
            DBMS_OUTPUT.PUT_LINE('Net risk adjustment: ' || ROUND(v_total_adjustment * 100, 1) || '%');
            
            -- Log bulk update to audit trail
            log_audit_trail(
                p_table_name => 'OFFENDERS',
                p_operation_type => 'BULK_UPDATE',
                p_old_values => 'Compound trigger processed ' || v_affected_offenders || ' offenders',
                p_new_values => 'Net risk adjustment: ' || ROUND(v_total_adjustment * 100, 1) || '%'
            );
        END IF;
        
        -- Clear collections
        g_inserted_offenses.DELETE;
        g_updated_offenses.DELETE;
        g_deleted_offenses.DELETE;
        
        DBMS_OUTPUT.PUT_LINE('=== Compound Trigger Processing Complete ===');
        
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Compound trigger error in AFTER STATEMENT: ' || SQLERRM);
            -- Clear collections on error too
            g_inserted_offenses.DELETE;
            g_updated_offenses.DELETE;
            g_deleted_offenses.DELETE;
    END AFTER STATEMENT;
    
END trg_offenses_compound;
/

PROMPT ✓ Compound trigger created for OFFENSES table!

-- Test the trigger by inserting a sample offense
PROMPT Testing trigger with sample data...
DECLARE
    v_next_offense_id NUMBER;
    v_test_offender_id NUMBER;
BEGIN
    -- Get next offense ID
    SELECT seq_offenses.NEXTVAL INTO v_next_offense_id FROM dual;
    
    -- Get a test offender
    SELECT offender_id INTO v_test_offender_id
    FROM offenders
    WHERE ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('Testing with offender ID: ' || v_test_offender_id);
    
    -- Insert a test offense (this will trigger the compound trigger)
    INSERT INTO offenses (offense_id, offender_id, offense_type, date_committed, severity)
    VALUES (v_next_offense_id, v_test_offender_id, 'Test Offense', SYSDATE, 'MEDIUM');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ Test offense inserted. Check DBMS_OUTPUT for trigger messages.');
    
    -- Show updated risk score
    SELECT risk_score INTO v_next_offense_id
    FROM offenders
    WHERE offender_id = v_test_offender_id;
    
    DBMS_OUTPUT.PUT_LINE('Updated risk score: ' || v_next_offense_id);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Test failed: ' || SQLERRM);
        ROLLBACK;
END;
/

PROMPT
PROMPT ============================================
PROMPT TRIGGER VERIFICATION
PROMPT ============================================

-- Show trigger status
-- Show trigger status
BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger Status:');
    FOR rec IN (
        SELECT trigger_name, table_name, trigger_type, status
        FROM user_triggers
        WHERE trigger_name = 'TRG_OFFENSES_COMPOUND'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('  Name: ' || rec.trigger_name);
        DBMS_OUTPUT.PUT_LINE('  Table: ' || rec.table_name);
        DBMS_OUTPUT.PUT_LINE('  Type: ' || rec.trigger_type);
        DBMS_OUTPUT.PUT_LINE('  Status: ' || rec.status);
    END LOOP;
END;
/
-- Show recent audit entries
PROMPT Recent audit entries from trigger:
SELECT 
    audit_id,
    table_name,
    operation_type,
    TO_CHAR(operation_date, 'DD-MON HH24:MI:SS') as timestamp,
    SUBSTR(new_values, 1, 50) as description
FROM audit_log
WHERE table_name IN ('OFFENSES', 'OFFENDERS')
AND operation_date >= SYSDATE - 1/24  -- Last hour
ORDER BY audit_id DESC
FETCH FIRST 3 ROWS ONLY;

PROMPT
PROMPT ============================================
PROMPT COMPOUND TRIGGER CREATED SUCCESSFULLY!
PROMPT ============================================