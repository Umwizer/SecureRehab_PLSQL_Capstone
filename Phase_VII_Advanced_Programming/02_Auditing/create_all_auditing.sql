-- create_all_auditing.sql
SET SERVEROUTPUT ON;
SET FEEDBACK ON;
SET PAGESIZE 50;

PROMPT ============================================
PROMPT CREATING AUDITING SYSTEM
PROMPT ============================================

-- First, run the setup script
PROMPT Running audit_setup.sql...
@audit_setup.sql

PROMPT
PROMPT ============================================
PROMPT VERIFICATION
PROMPT ============================================

PROMPT 1. Checking if audit_log table was created:
BEGIN
    FOR rec IN (SELECT table_name FROM user_tables WHERE table_name = 'AUDIT_LOG') LOOP
        DBMS_OUTPUT.PUT_LINE('✓ AUDIT_LOG table exists');
    END LOOP;
END;
/

PROMPT 2. Checking if functions were created:
BEGIN
    FOR rec IN (SELECT object_name, status FROM user_objects 
                WHERE object_name = 'LOG_AUDIT_TRAIL' 
                AND object_type = 'FUNCTION') LOOP
        DBMS_OUTPUT.PUT_LINE('✓ LOG_AUDIT_TRAIL function created - Status: ' || rec.status);
    END LOOP;
    
    FOR rec IN (SELECT object_name, status FROM user_objects 
                WHERE object_name = 'CHECK_RESTRICTION_ALLOWED' 
                AND object_type = 'FUNCTION') LOOP
        DBMS_OUTPUT.PUT_LINE('✓ CHECK_RESTRICTION_ALLOWED function created - Status: ' || rec.status);
    END LOOP;
END;
/

PROMPT 3. Showing audit table structure:
DESC audit_log;

PROMPT 4. Showing sample audit data:
SELECT 
    audit_id,
    table_name,
    operation_type,
    TO_CHAR(operation_date, 'DD-MON HH24:MI:SS') as timestamp,
    user_name,
    SUBSTR(old_values, 1, 30) || '...' as old_values_preview
FROM audit_log
ORDER BY audit_id DESC
FETCH FIRST 5 ROWS ONLY;

PROMPT 5. Counting total audit entries:
SELECT COUNT(*) as "Total Audit Entries" FROM audit_log;

PROMPT ============================================
PROMPT AUDITING SYSTEM CREATED SUCCESSFULLY!
PROMPT ============================================