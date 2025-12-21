-- simple_triggers.sql - FIXED VERSION
-- Trigger for offenders table
CREATE OR REPLACE TRIGGER trg_offenders_restriction
BEFORE INSERT OR UPDATE OR DELETE ON offenders
FOR EACH ROW
DECLARE
    v_allowed BOOLEAN;
    v_audit_id NUMBER;
    v_error_code NUMBER;
    v_error_message VARCHAR2(500);
BEGIN
    -- Check if operation is allowed
    v_allowed := check_restriction_allowed;
    
    IF NOT v_allowed THEN
        -- Set error details based on operation type
        IF INSERTING THEN
            v_error_code := -20010;
            v_error_message := 'INSERT operations on OFFENDERS table are not allowed on weekdays or public holidays.';
        ELSIF UPDATING THEN
            v_error_code := -20011;
            v_error_message := 'UPDATE operations on OFFENDERS table are not allowed on weekdays or public holidays.';
        ELSE -- DELETING
            v_error_code := -20012;
            v_error_message := 'DELETE operations on OFFENDERS table are not allowed on weekdays or public holidays.';
        END IF;
        
        -- Log the attempted violation
        v_audit_id := log_audit_trail(
            p_table_name => 'OFFENDERS',
            p_operation_type => 
                CASE 
                    WHEN INSERTING THEN 'INSERT'
                    WHEN UPDATING THEN 'UPDATE'
                    WHEN DELETING THEN 'DELETE'
                END,
            p_offender_id => 
                CASE 
                    WHEN INSERTING OR UPDATING THEN :NEW.offender_id
                    ELSE :OLD.offender_id
                END,
            p_restriction_violated => 'Y',
            p_error_message => v_error_message
        );
        
        -- Raise application error
        RAISE_APPLICATION_ERROR(v_error_code, v_error_message);
    END IF;
    
    -- If allowed, log successful operation
    IF INSERTING THEN
        v_audit_id := log_audit_trail(
            p_table_name => 'OFFENDERS',
            p_operation_type => 'INSERT',
            p_offender_id => :NEW.offender_id,
            p_new_values => 
                'First: ' || :NEW.first_name || ', ' ||
                'Last: ' || :NEW.last_name || ', ' ||
                'Status: ' || :NEW.status
                -- Removed security_level and risk_score if they don't exist
        );
    ELSIF UPDATING THEN
        v_audit_id := log_audit_trail(
            p_table_name => 'OFFENDERS',
            p_operation_type => 'UPDATE',
            p_offender_id => :NEW.offender_id,
            p_old_values => 
                'Old Status: ' || :OLD.status,
            p_new_values => 
                'New Status: ' || :NEW.status
                -- Removed security_level and risk_score if they don't exist
        );
    ELSIF DELETING THEN
        v_audit_id := log_audit_trail(
            p_table_name => 'OFFENDERS',
            p_operation_type => 'DELETE',
            p_offender_id => :OLD.offender_id,
            p_old_values => 
                'Deleted Offender: ' || :OLD.first_name || ' ' || :OLD.last_name || ', ' ||
                'ID: ' || :OLD.offender_id || ', ' ||
                'Status: ' || :OLD.status
        );
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Trigger error: ' || SQLERRM);
        RAISE;
END;
/

-- Trigger for program_participation table
CREATE OR REPLACE TRIGGER trg_program_participation_restriction
BEFORE INSERT OR UPDATE OR DELETE ON program_participation
FOR EACH ROW
DECLARE
    v_allowed BOOLEAN;
    v_audit_id NUMBER;
    v_error_code NUMBER;
    v_error_message VARCHAR2(500);
BEGIN
    -- Check if operation is allowed
    v_allowed := check_restriction_allowed;
    
    IF NOT v_allowed THEN
        -- Set error details based on operation type
        IF INSERTING THEN
            v_error_code := -20020;
            v_error_message := 'INSERT operations on PROGRAM_PARTICIPATION table are not allowed on weekdays or public holidays.';
        ELSIF UPDATING THEN
            v_error_code := -20021;
            v_error_message := 'UPDATE operations on PROGRAM_PARTICIPATION table are not allowed on weekdays or public holidays.';
        ELSE -- DELETING
            v_error_code := -20022;
            v_error_message := 'DELETE operations on PROGRAM_PARTICIPATION table are not allowed on weekdays or public holidays.';
        END IF;
        
        -- Log the attempted violation
        v_audit_id := log_audit_trail(
            p_table_name => 'PROGRAM_PARTICIPATION',
            p_operation_type => 
                CASE 
                    WHEN INSERTING THEN 'INSERT'
                    WHEN UPDATING THEN 'UPDATE'
                    WHEN DELETING THEN 'DELETE'
                END,
            p_offender_id => 
                CASE 
                    WHEN INSERTING OR UPDATING THEN :NEW.offender_id
                    ELSE :OLD.offender_id
                END,
            p_program_id => 
                CASE 
                    WHEN INSERTING OR UPDATING THEN :NEW.program_id
                    ELSE :OLD.program_id
                END,
            p_restriction_violated => 'Y',
            p_error_message => v_error_message
        );
        
        RAISE_APPLICATION_ERROR(v_error_code, v_error_message);
    END IF;
    
    -- If allowed, log successful operation
    IF INSERTING THEN
        v_audit_id := log_audit_trail(
            p_table_name => 'PROGRAM_PARTICIPATION',
            p_operation_type => 'INSERT',
            p_offender_id => :NEW.offender_id,
            p_program_id => :NEW.program_id,
            p_new_values => 
                'Participation ID: ' || :NEW.participation_id || ', ' ||
                'Status: ' || :NEW.status || ', ' ||
                'Enrollment Date: ' || TO_CHAR(:NEW.enrollment_date, 'DD-MON-YYYY')
        );
    ELSIF UPDATING THEN
        v_audit_id := log_audit_trail(
            p_table_name => 'PROGRAM_PARTICIPATION',
            p_operation_type => 'UPDATE',
            p_offender_id => :NEW.offender_id,
            p_program_id => :NEW.program_id,
            p_old_values => 'Old Status: ' || :OLD.status,
            p_new_values => 'New Status: ' || :NEW.status
            -- Removed progress_percentage if it doesn't exist
        );
    ELSIF DELETING THEN
        v_audit_id := log_audit_trail(
            p_table_name => 'PROGRAM_PARTICIPATION',
            p_operation_type => 'DELETE',
            p_offender_id => :OLD.offender_id,
            p_program_id => :OLD.program_id,
            p_old_values => 
                'Deleted Participation ID: ' || :OLD.participation_id || ', ' ||
                'Offender ID: ' || :OLD.offender_id || ', ' ||
                'Program ID: ' || :OLD.program_id
        );
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Trigger error: ' || SQLERRM);
        RAISE;
END;
/

-- Trigger for rehab_programs table (simplified)
CREATE OR REPLACE TRIGGER trg_rehab_programs_restriction
BEFORE INSERT OR UPDATE OR DELETE ON rehab_programs
FOR EACH ROW
DECLARE
    v_allowed BOOLEAN;
    v_audit_id NUMBER;
    v_error_code NUMBER;
    v_error_message VARCHAR2(500);
BEGIN
    -- Check if operation is allowed
    v_allowed := check_restriction_allowed;
    
    IF NOT v_allowed THEN
        -- Set error details based on operation type
        IF INSERTING THEN
            v_error_code := -20030;
            v_error_message := 'INSERT operations on REHAB_PROGRAMS table are not allowed on weekdays or public holidays.';
        ELSIF UPDATING THEN
            v_error_code := -20031;
            v_error_message := 'UPDATE operations on REHAB_PROGRAMS table are not allowed on weekdays or public holidays.';
        ELSE -- DELETING
            v_error_code := -20032;
            v_error_message := 'DELETE operations on REHAB_PROGRAMS table are not allowed on weekdays or public holidays.';
        END IF;
        
        -- Log the attempted violation
        v_audit_id := log_audit_trail(
            p_table_name => 'REHAB_PROGRAMS',
            p_operation_type => 
                CASE 
                    WHEN INSERTING THEN 'INSERT'
                    WHEN UPDATING THEN 'UPDATE'
                    WHEN DELETING THEN 'DELETE'
                END,
            p_program_id => 
                CASE 
                    WHEN INSERTING OR UPDATING THEN :NEW.program_id
                    ELSE :OLD.program_id
                END,
            p_restriction_violated => 'Y',
            p_error_message => v_error_message
        );
        
        RAISE_APPLICATION_ERROR(v_error_code, v_error_message);
    END IF;
    
    -- If allowed, log successful operation
    IF INSERTING THEN
        v_audit_id := log_audit_trail(
            p_table_name => 'REHAB_PROGRAMS',
            p_operation_type => 'INSERT',
            p_program_id => :NEW.program_id,
            p_new_values => 
                'Program Name: ' || :NEW.program_name || ', ' ||
                'Capacity: ' || :NEW.capacity
                -- Removed duration_months and program_category if they don't exist
        );
    ELSIF UPDATING THEN
        v_audit_id := log_audit_trail(
            p_table_name => 'REHAB_PROGRAMS',
            p_operation_type => 'UPDATE',
            p_program_id => :NEW.program_id,
            p_old_values => 
                'Old Name: ' || :OLD.program_name || ', ' ||
                'Old Capacity: ' || :OLD.capacity,
            p_new_values => 
                'New Name: ' || :NEW.program_name || ', ' ||
                'New Capacity: ' || :NEW.capacity
        );
    ELSIF DELETING THEN
        v_audit_id := log_audit_trail(
            p_table_name => 'REHAB_PROGRAMS',
            p_operation_type => 'DELETE',
            p_program_id => :OLD.program_id,
            p_old_values => 
                'Deleted Program: ' || :OLD.program_name || ', ' ||
                'ID: ' || :OLD.program_id || ', ' ||
                'Capacity: ' || :OLD.capacity
        );
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Trigger error: ' || SQLERRM);
        RAISE;
END;
/

-- Additional trigger for auto-updating risk scores when programs are completed
-- NOTE: This requires offenders.risk_score column to exist
CREATE OR REPLACE TRIGGER trg_program_completion_risk_update
AFTER UPDATE OF status ON program_participation
FOR EACH ROW
WHEN (OLD.status != 'COMPLETED' AND NEW.status = 'COMPLETED')
DECLARE
    v_risk_reduction NUMBER := 0.05; -- 5% risk reduction per completed program
    v_new_risk_score NUMBER;
    v_has_risk_column BOOLEAN := FALSE;
BEGIN
    -- First check if risk_score column exists
    BEGIN
        SELECT 1 INTO v_has_risk_column
        FROM user_tab_columns
        WHERE table_name = 'OFFENDERS'
        AND column_name = 'RISK_SCORE'
        AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_has_risk_column := FALSE;
    END;
    
    IF v_has_risk_column THEN
        DBMS_OUTPUT.PUT_LINE('Program completed for offender ' || :NEW.offender_id);
        DBMS_OUTPUT.PUT_LINE('Reducing risk score by ' || (v_risk_reduction * 100) || '%');
        
        -- Calculate new risk score
        BEGIN
            SELECT risk_score INTO v_new_risk_score
            FROM offenders 
            WHERE offender_id = :NEW.offender_id;
            
            v_new_risk_score := v_new_risk_score - v_risk_reduction;
            
            -- Ensure risk score doesn't go below 0
            IF v_new_risk_score < 0 THEN
                v_new_risk_score := 0;
            END IF;
            
            -- Update offender's risk score
            UPDATE offenders 
            SET risk_score = v_new_risk_score
            WHERE offender_id = :NEW.offender_id;
            
            DBMS_OUTPUT.PUT_LINE('Updated risk score to: ' || v_new_risk_score);
            
            -- Log this automatic update
            log_audit_trail(
                p_table_name => 'OFFENDERS',
                p_operation_type => 'UPDATE',
                p_offender_id => :NEW.offender_id,
                p_old_values => 'Auto-update: Program ' || :NEW.program_id || ' completed',
                p_new_values => 'Risk score reduced to ' || v_new_risk_score
            );
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Offender not found: ' || :NEW.offender_id);
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error updating risk score: ' || SQLERRM);
        END;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Risk score column not found in offenders table. Skipping risk update.');
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in risk update trigger: ' || SQLERRM);
END;
/