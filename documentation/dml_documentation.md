# DML Documentation - INSERT Scripts

## Sample INSERT statements for offenders

```sql
-- Insert sample offenders
INSERT INTO offenders (offender_id, national_id, first_name, last_name, gender, date_of_birth, risk_score)
VALUES (seq_offenders.NEXTVAL, '119988001999', 'John', 'Doe', 'M', TO_DATE('1990-01-15', 'YYYY-MM-DD'), 0.45);

INSERT INTO offenders (offender_id, national_id, first_name, last_name, gender, date_of_birth, risk_score)
VALUES (seq_offenders.NEXTVAL, '119988002000', 'Jane', 'Smith', 'F', TO_DATE('1985-06-20', 'YYYY-MM-DD'), 0.72);

INSERT INTO offenders (offender_id, national_id, first_name, last_name, gender, date_of_birth, risk_score)
VALUES (seq_offenders.NEXTVAL, '119988002001', 'Bob', 'Johnson', 'M', TO_DATE('1992-11-30', 'YYYY-MM-DD'), 0.28);

-- Sample test for Rehab_Programs
INSERT INTO rehab_programs (program_id, program_name, description, duration_months, capacity)
VALUES (101, 'Vocational Training', 'Skills development for employment', 6, 50);

INSERT INTO rehab_programs (program_id, program_name, description, duration_months, capacity)
VALUES (102, 'Anger Management', 'Emotional regulation techniques', 3, 30);

INSERT INTO rehab_programs (program_id, program_name, description, duration_months, capacity)
VALUES (103, 'Adult Literacy', 'Basic reading and writing skills', 4, 40);

INSERT INTO rehab_programs (program_id, program_name, description, duration_months, capacity)
VALUES (104, 'Drug Rehabilitation', 'Substance abuse recovery program', 8, 25);


-- Sample test for Program_Participation
INSERT INTO program_participation (participation_id, offender_id, program_id, enrollment_date, status)
VALUES (seq_enrollments.NEXTVAL, 1001, 101, SYSDATE - 30, 'IN_PROGRESS');

INSERT INTO program_participation (participation_id, offender_id, program_id, enrollment_date, status)
VALUES (seq_enrollments.NEXTVAL, 1002, 102, SYSDATE - 15, 'ENROLLED');

INSERT INTO program_participation (participation_id, offender_id, program_id, enrollment_date, status)
VALUES (seq_enrollments.NEXTVAL, 1003, 103, SYSDATE - 60, 'COMPLETED');

-- Data Validation Insert
-- This should fail due to CHECK constraint
INSERT INTO offenders (offender_id, risk_score) VALUES (99999, 1.5); -- INVALID

-- This should fail due to FOREIGN KEY constraint
INSERT INTO offenses (offense_id, offender_id) VALUES (99999, 99999); -- INVALID
```
