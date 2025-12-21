-- ============================================================
-- PHASE V: Complete Data Insertion for SecureRehab System
-- Student: Umwizerwa Ruth (ID: 28235)
-- Database: D_28235_Ruth_SecureRehab_DB
-- Total Records: 150+ rows across all tables
-- ============================================================

-- 1. INSERT OFFENDERS (120 rows - more than required)
INSERT INTO offenders VALUES (seq_offenders.NEXTVAL, '119988001001', 'Jean', 'HABYARIMANA', 'M', 
    TO_DATE('1985-03-15', 'YYYY-MM-DD'), 'KG 123 St, Gasabo, Kigali', 0.35, 'ACTIVE', SYSDATE);

INSERT INTO offenders VALUES (seq_offenders.NEXTVAL, '119988001002', 'Marie', 'UWIMANA', 'F',
    TO_DATE('1990-07-22', 'YYYY-MM-DD'), 'Huye Town, Southern Province', 0.68, 'ACTIVE', SYSDATE);

INSERT INTO offenders VALUES (seq_offenders.NEXTVAL, '119988001003', 'Pierre', 'NDAYISABA', 'M',
    TO_DATE('1982-11-30', 'YYYY-MM-DD'), 'Musanze District, Northern Province', 0.42, 'ACTIVE', SYSDATE);

INSERT INTO offenders VALUES (seq_offenders.NEXTVAL, '119988001004', 'Annette', 'MUKAMANA', 'F',
    TO_DATE('1995-05-18', 'YYYY-MM-DD'), 'Rubavu, Western Province', 0.25, 'ACTIVE', SYSDATE);

INSERT INTO offenders VALUES (seq_offenders.NEXTVAL, '119988001005', 'Emmanuel', 'TWAHIRWA', 'M',
    TO_DATE('1978-12-10', 'YYYY-MM-DD'), 'Nyagatare, Eastern Province', 0.78, 'ACTIVE', SYSDATE);

INSERT INTO offenders VALUES (seq_offenders.NEXTVAL, '119988001006', 'Alice', 'MUTESI', 'F',
    TO_DATE('1988-04-25', 'YYYY-MM-DD'), 'Kicukiro, Kigali', 0.15, 'RELEASED', SYSDATE);

INSERT INTO offenders VALUES (seq_offenders.NEXTVAL, '119988001007', 'David', 'KAMANZI', 'M',
    TO_DATE('1992-09-12', 'YYYY-MM-DD'), 'Nyarugenge, Kigali', 0.82, 'ACTIVE', SYSDATE);

INSERT INTO offenders VALUES (seq_offenders.NEXTVAL, '119988001008', 'Grace', 'NYIRAHABINEZA', 'F',
    TO_DATE('1980-02-28', 'YYYY-MM-DD'), 'Bugesera, Eastern Province', 0.55, 'ACTIVE', SYSDATE);

INSERT INTO offenders VALUES (seq_offenders.NEXTVAL, '119988001009', 'Samuel', 'NSENGIYUMVA', 'M',
    TO_DATE('1975-08-05', 'YYYY-MM-DD'), 'Rusizi, Western Province', 0.38, 'ACTIVE', SYSDATE);

INSERT INTO offenders VALUES (seq_offenders.NEXTVAL, '119988001010', 'Chantal', 'UWERA', 'F',
    TO_DATE('1993-11-20', 'YYYY-MM-DD'), 'Karongi, Western Province', 0.29, 'ACTIVE', SYSDATE);

-- Batch insert for remaining 110 offenders
BEGIN
    FOR i IN 11..120 LOOP
        INSERT INTO offenders VALUES (
            seq_offenders.NEXTVAL,
            '119988001' || LPAD(i, 3, '0'),
            CASE MOD(i, 5) 
                WHEN 0 THEN 'Jean' WHEN 1 THEN 'Marie' WHEN 2 THEN 'Pierre' 
                WHEN 3 THEN 'Annette' ELSE 'Emmanuel' END,
            CASE MOD(i, 8) 
                WHEN 0 THEN 'HABYARIMANA' WHEN 1 THEN 'UWIMANA' WHEN 2 THEN 'NDAYISABA'
                WHEN 3 THEN 'MUKAMANA' WHEN 4 THEN 'TWAHIRWA' WHEN 5 THEN 'MUTESI'
                WHEN 6 THEN 'KAMANZI' ELSE 'NYIRAHABINEZA' END,
            CASE MOD(i, 2) WHEN 0 THEN 'M' ELSE 'F' END,
            TO_DATE(1980 + MOD(i, 25) || '-' || LPAD(MOD(i, 12)+1, 2, '0') || '-' || LPAD(MOD(i, 28)+1, 2, '0'), 'YYYY-MM-DD'),
            CASE MOD(i, 4)
                WHEN 0 THEN 'Kigali, Gasabo'
                WHEN 1 THEN 'Huye District'
                WHEN 2 THEN 'Musanze District'
                ELSE 'Rubavu District' END,
            ROUND(DBMS_RANDOM.VALUE(0.1, 0.9), 2),
            CASE MOD(i, 10) WHEN 0 THEN 'RELEASED' ELSE 'ACTIVE' END,
            SYSDATE - MOD(i, 365)
        );
    END LOOP;
END;
/

-- 2. INSERT OFFENSES (80 records)
INSERT INTO offenses VALUES (seq_offenses.NEXTVAL, 1001, 'Petty Theft', TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'LOW');
INSERT INTO offenses VALUES (seq_offenses.NEXTVAL, 1002, 'Assault', TO_DATE('2022-11-05', 'YYYY-MM-DD'), 'HIGH');
INSERT INTO offenses VALUES (seq_offenses.NEXTVAL, 1003, 'Fraud', TO_DATE('2023-03-22', 'YYYY-MM-DD'), 'MEDIUM');
INSERT INTO offenses VALUES (seq_offenses.NEXTVAL, 1004, 'Vandalism', TO_DATE('2023-02-10', 'YYYY-MM-DD'), 'LOW');
INSERT INTO offenses VALUES (seq_offenses.NEXTVAL, 1005, 'Drug Possession', TO_DATE('2022-09-18', 'YYYY-MM-DD'), 'HIGH');
INSERT INTO offenses VALUES (seq_offenses.NEXTVAL, 1006, 'Burglary', TO_DATE('2023-04-05', 'YYYY-MM-DD'), 'MEDIUM');
INSERT INTO offenses VALUES (seq_offenses.NEXTVAL, 1007, 'Robbery', TO_DATE('2022-12-20', 'YYYY-MM-DD'), 'HIGH');
INSERT INTO offenses VALUES (seq_offenses.NEXTVAL, 1008, 'Forgery', TO_DATE('2023-01-30', 'YYYY-MM-DD'), 'MEDIUM');
INSERT INTO offenses VALUES (seq_offenses.NEXTVAL, 1009, 'Trespassing', TO_DATE('2023-05-15', 'YYYY-MM-DD'), 'LOW');
INSERT INTO offenses VALUES (seq_offenses.NEXTVAL, 1010, 'Cyber Crime', TO_DATE('2023-06-10', 'YYYY-MM-DD'), 'HIGH');

-- Batch insert remaining offenses
BEGIN
    FOR i IN 11..80 LOOP
        INSERT INTO offenses VALUES (
            seq_offenses.NEXTVAL,
            1000 + MOD(i, 50) + 1,
            CASE MOD(i, 7)
                WHEN 0 THEN 'Petty Theft'
                WHEN 1 THEN 'Assault'
                WHEN 2 THEN 'Fraud'
                WHEN 3 THEN 'Vandalism'
                WHEN 4 THEN 'Drug Possession'
                WHEN 5 THEN 'Burglary'
                ELSE 'Robbery' END,
            SYSDATE - (MOD(i, 365) + 100),
            CASE MOD(i, 3)
                WHEN 0 THEN 'LOW'
                WHEN 1 THEN 'MEDIUM'
                ELSE 'HIGH' END
        );
    END LOOP;
END;
/

-- 3. INSERT SENTENCES (100 records)
INSERT INTO sentences VALUES (seq_sentences.NEXTVAL, 1001, TO_DATE('2023-03-15', 'YYYY-MM-DD'), 
    TO_DATE('2024-03-15', 'YYYY-MM-DD'), 12, 'ACTIVE');
INSERT INTO sentences VALUES (seq_sentences.NEXTVAL, 1002, TO_DATE('2023-01-25', 'YYYY-MM-DD'), 
    TO_DATE('2025-01-25', 'YYYY-MM-DD'), 24, 'ACTIVE');
INSERT INTO sentences VALUES (seq_sentences.NEXTVAL, 1003, TO_DATE('2023-06-20', 'YYYY-MM-DD'), 
    TO_DATE('2024-06-20', 'YYYY-MM-DD'), 12, 'ACTIVE');
INSERT INTO sentences VALUES (seq_sentences.NEXTVAL, 1004, TO_DATE('2023-04-10', 'YYYY-MM-DD'), 
    TO_DATE('2023-10-10', 'YYYY-MM-DD'), 6, 'COMPLETED');
INSERT INTO sentences VALUES (seq_sentences.NEXTVAL, 1005, TO_DATE('2022-12-15', 'YYYY-MM-DD'), 
    TO_DATE('2027-12-15', 'YYYY-MM-DD'), 60, 'ACTIVE');
INSERT INTO sentences VALUES (seq_sentences.NEXTVAL, 1006, TO_DATE('2023-05-01', 'YYYY-MM-DD'), 
    TO_DATE('2024-05-01', 'YYYY-MM-DD'), 12, 'ACTIVE');
INSERT INTO sentences VALUES (seq_sentences.NEXTVAL, 1007, TO_DATE('2023-02-28', 'YYYY-MM-DD'), 
    TO_DATE('2025-02-28', 'YYYY-MM-DD'), 24, 'ACTIVE');
INSERT INTO sentences VALUES (seq_sentences.NEXTVAL, 1008, TO_DATE('2023-03-10', 'YYYY-MM-DD'), 
    TO_DATE('2023-09-10', 'YYYY-MM-DD'), 6, 'COMPLETED');
INSERT INTO sentences VALUES (seq_sentences.NEXTVAL, 1009, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 
    TO_DATE('2026-01-15', 'YYYY-MM-DD'), 36, 'ACTIVE');
INSERT INTO sentences VALUES (seq_sentences.NEXTVAL, 1010, TO_DATE('2023-04-01', 'YYYY-MM-DD'), 
    TO_DATE('2024-04-01', 'YYYY-MM-DD'), 12, 'ACTIVE');

-- Batch insert remaining sentences
BEGIN
    FOR i IN 11..100 LOOP
        INSERT INTO sentences VALUES (
            seq_sentences.NEXTVAL,
            1000 + MOD(i, 50) + 1,
            SYSDATE - (MOD(i, 365) + 50),
            SYSDATE + (MOD(i, 365) + 100),
            CASE MOD(i, 4)
                WHEN 0 THEN 6
                WHEN 1 THEN 12
                WHEN 2 THEN 24
                ELSE 36 END,
            CASE MOD(i, 10)
                WHEN 0 THEN 'COMPLETED'
                WHEN 1 THEN 'PAROLED'
                ELSE 'ACTIVE' END
        );
    END LOOP;
END;
/

-- 4. INSERT REHAB PROGRAMS (15 programs)
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Carpentry & Woodwork', 6, 30);
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Anger Management', 3, 20);
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Adult Literacy', 4, 50);
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Substance Abuse Counseling', 9, 25);
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Life Skills Training', 5, 40);
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Agriculture Training', 6, 35);
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Computer Basics', 3, 30);
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Vocational Tailoring', 5, 25);
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Entrepreneurship', 4, 40);
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Family Reintegration', 2, 30);
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Art Therapy', 3, 20);
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Sports Rehabilitation', 4, 40);
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Conflict Resolution', 3, 25);
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Financial Literacy', 2, 50);
INSERT INTO rehab_programs VALUES (seq_programs.NEXTVAL, 'Health & Wellness', 3, 40);

-- 5. INSERT PROGRAM PARTICIPATION (200 records)
BEGIN
    FOR i IN 1..200 LOOP
        INSERT INTO program_participation VALUES (
            seq_participation.NEXTVAL,
            1000 + MOD(i, 50) + 1,
            100 + MOD(i, 15) + 1,
            SYSDATE - MOD(i, 180),
            CASE MOD(i, 5)
                WHEN 0 THEN SYSDATE - MOD(i, 30)
                ELSE NULL END,
            CASE MOD(i, 10)
                WHEN 0 THEN 'COMPLETED'
                WHEN 1 THEN 'DROPPED'
                WHEN 2 THEN 'FAILED'
                WHEN 3 THEN 'IN_PROGRESS'
                ELSE 'ENROLLED' END
        );
    END LOOP;
END;
/

-- 6. INSERT ALERTS (50 records)
INSERT INTO alerts VALUES (seq_alerts.NEXTVAL, 1002, 'RISK_ESCALATION', SYSDATE, 'Risk score above 0.6 - needs monitoring');
INSERT INTO alerts VALUES (seq_alerts.NEXTVAL, 1001, 'PAROLE_ELIGIBILITY', SYSDATE-10, 'Eligible for parole review');
INSERT INTO alerts VALUES (seq_alerts.NEXTVAL, 1005, 'BEHAVIOR_INCIDENT', SYSDATE-5, 'Violation reported: fighting');
INSERT INTO alerts VALUES (seq_alerts.NEXTVAL, 1007, 'PROGRAM_COMPLETION', SYSDATE-15, 'Completed carpentry program successfully');
INSERT INTO alerts VALUES (seq_alerts.NEXTVAL, 1010, 'RELEASE_DATE', SYSDATE+30, 'Upcoming release in 30 days');
INSERT INTO alerts VALUES (seq_alerts.NEXTVAL, 1003, 'MEDICAL_ALERT', SYSDATE-2, 'Medical appointment scheduled');
INSERT INTO alerts VALUES (seq_alerts.NEXTVAL, 1008, 'RISK_REDUCTION', SYSDATE-20, 'Risk score improved to 0.3');
INSERT INTO alerts VALUES (seq_alerts.NEXTVAL, 1004, 'FAMILY_VISIT', SYSDATE-7, 'Family visit scheduled');
INSERT INTO alerts VALUES (seq_alerts.NEXTVAL, 1009, 'PROGRAM_ENROLLMENT', SYSDATE-3, 'Enrolled in anger management');
INSERT INTO alerts VALUES (seq_alerts.NEXTVAL, 1006, 'SECURITY_ALERT', SYSDATE-1, 'Security check required');

-- Batch insert remaining alerts
BEGIN
    FOR i IN 11..50 LOOP
        INSERT INTO alerts VALUES (
            seq_alerts.NEXTVAL,
            1000 + MOD(i, 50) + 1,
            CASE MOD(i, 6)
                WHEN 0 THEN 'RISK_ESCALATION'
                WHEN 1 THEN 'PAROLE_ELIGIBILITY'
                WHEN 2 THEN 'PROGRAM_COMPLETION'
                WHEN 3 THEN 'BEHAVIOR_INCIDENT'
                WHEN 4 THEN 'MEDICAL_ALERT'
                ELSE 'SECURITY_ALERT' END,
            SYSDATE - MOD(i, 30),
            'Alert ' || i || ': ' || CASE MOD(i, 4)
                WHEN 0 THEN 'Requires immediate attention'
                WHEN 1 THEN 'Schedule review meeting'
                WHEN 2 THEN 'Monitor closely'
                ELSE 'Routine check' END
        );
    END LOOP;
END;
/

COMMIT;

-- 7. VERIFICATION OF INSERTED DATA
PROMPT ============================================
PROMPT DATA INSERTION COMPLETE - VERIFICATION
PROMPT ============================================

SELECT 'OFFENDERS: ' || COUNT(*) || ' rows' FROM offenders;
SELECT 'OFFENSES: ' || COUNT(*) || ' rows' FROM offenses;
SELECT 'SENTENCES: ' || COUNT(*) || ' rows' FROM sentences;
SELECT 'REHAB PROGRAMS: ' || COUNT(*) || ' rows' FROM rehab_programs;
SELECT 'PROGRAM PARTICIPATION: ' || COUNT(*) || ' rows' FROM program_participation;
SELECT 'ALERTS: ' || COUNT(*) || ' rows' FROM alerts;

PROMPT 
PROMPT ============================================
PROMPT SAMPLE DATA (First 5 rows from each table):
PROMPT ============================================

PROMPT 1. OFFENDERS:
SELECT offender_id, first_name, last_name, risk_score, status 
FROM offenders WHERE ROWNUM <= 5 ORDER BY offender_id;

PROMPT 2. OFFENSES:
SELECT offense_id, offender_id, offense_type, severity 
FROM offenses WHERE ROWNUM <= 5 ORDER BY offense_id;

PROMPT 3. SENTENCES:
SELECT sentence_id, offender_id, sentence_length, status 
FROM sentences WHERE ROWNUM <= 5 ORDER BY sentence_id;

PROMPT 4. REHAB PROGRAMS:
SELECT program_id, program_name, duration_months, capacity 
FROM rehab_programs WHERE ROWNUM <= 5 ORDER BY program_id;

PROMPT 5. PROGRAM PARTICIPATION:
SELECT participation_id, offender_id, program_id, status 
FROM program_participation WHERE ROWNUM <= 5 ORDER BY participation_id;

PROMPT 6. ALERTS:
SELECT alert_id, offender_id, alert_type, alert_date 
FROM alerts WHERE ROWNUM <= 5 ORDER BY alert_id;

PROMPT 
PROMPT ============================================
PROMPT PHASE V DATA INSERTION COMPLETE!
PROMPT Total: 500+ realistic records inserted
PROMPT Ready for validation queries
PROMPT ============================================