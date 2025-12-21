

-- system_triggers.sql
-- Database-level trigger for DDL operations
CREATE OR REPLACE TRIGGER trg_system_ddl_audit
AFTER DDL ON DATABASE
DECLARE
    v_event VARCHAR2(100);
    v_object_type VARCHAR2(100);
    v_object_name VARCHAR2(100);
    v_username VARCHAR2(100);
BEGIN
    -- Get DDL event details
    v_event := ORA_SYSEVENT;
    v_object_type := ORA_DICT_OBJ_TYPE;
    v_object_name := ORA_DICT_OBJ_NAME;
    v_username := ORA_DICT_OBJ_OWNER;
    
    -- Log DDL operations to audit log
    INSERT INTO audit_log (
        table_name,
        operation_type,
        user_name,
        old_values,
        new_values,
        restriction_violated
    ) VALUES (
        'SYSTEM',
        'DDL_' || v_event,
        v_username,
        'Object Type: ' || v_object_type,
        'Object Name: ' || v_object_name,
        'N'
    );
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Don't fail on audit errors
END;
/

-- Logon trigger to track user connections
CREATE OR REPLACE TRIGGER trg_user_logon_audit
AFTER LOGON ON DATABASE
DECLARE
    v_username VARCHAR2(100);
    v_ip_address VARCHAR2(50);
    v_host VARCHAR2(100);
BEGIN
    -- Get user session information
    v_username := USER;
    v_ip_address := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
    v_host := SYS_CONTEXT('USERENV', 'HOST');
    
    -- Log connection to audit log
    INSERT INTO audit_log (
        table_name,
        operation_type,
        user_name,
        old_values,
        new_values,
        ip_address,
        restriction_violated
    ) VALUES (
        'SYSTEM',
        'LOGON',
        v_username,
        'Connection from: ' || v_host,
        'IP Address: ' || v_ip_address,
        v_ip_address,
        'N'
    );
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Don't fail on audit errors
END;
/

-- Schema-level trigger to prevent dropping of critical tables
CREATE OR REPLACE TRIGGER trg_prevent_critical_drop
BEFORE DROP ON SCHEMA
DECLARE
    v_object_name VARCHAR2(100);
    v_object_type VARCHAR2(100);
BEGIN
    v_object_name := ORA_DICT_OBJ_NAME;
    v_object_type := ORA_DICT_OBJ_TYPE;
    
    -- Prevent dropping of critical tables
    IF v_object_type = 'TABLE' AND v_object_name IN (
        'OFFENDERS', 'PROGRAM_PARTICIPATION', 'REHAB_PROGRAMS', 
        'AUDIT_LOG', 'HOLIDAY_MANAGEMENT'
    ) THEN
        RAISE_APPLICATION_ERROR(-20099, 
            'Cannot drop critical table: ' || v_object_name || 
            '. Contact database administrator.'
        );
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
/

-- Trigger to maintain data integrity between related tables
CREATE OR REPLACE TRIGGER trg_offender_delete_cascade
BEFORE DELETE ON offenders
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Cascading delete for offender: ' || :OLD.offender_id);
    
    -- Log the cascade operation
    log_audit_trail(
        p_table_name => 'OFFENDERS',
        p_operation_type => 'CASCADE_DELETE',
        p_offender_id => :OLD.offender_id,
        p_old_values => 'Initiating cascade delete for offender: ' || :OLD.first_name || ' ' || :OLD.last_name
    );
    
    -- Delete related records (optional - can be handled by foreign key with CASCADE)
    -- DELETE FROM program_participation WHERE offender_id = :OLD.offender_id;
    -- DELETE FROM offenses WHERE offender_id = :OLD.offender_id;
    
    DBMS_OUTPUT.PUT_LINE('Cascade delete prepared for offender ' || :OLD.offender_id);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Cascade delete error: ' || SQLERRM);
        RAISE;
END;
/