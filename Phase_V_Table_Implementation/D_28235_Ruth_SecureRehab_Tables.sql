-- ============================================================
-- PHASE V: Table Creation for SecureRehab System
-- Student: Umwizerwa Ruth (ID: 28235)
-- Database: D_28235_Ruth_SecureRehab_DB
-- ============================================================

-- Connect as: SecureRehab_Admin/Ruth@D_28235_Ruth_SecureRehab_DB

-- 1. OFFENDERS TABLE
CREATE TABLE offenders (
    offender_id      NUMBER(10)     PRIMARY KEY,
    national_id      VARCHAR2(20)   UNIQUE NOT NULL,
    first_name       VARCHAR2(50)   NOT NULL,
    last_name        VARCHAR2(50)   NOT NULL,
    gender           CHAR(1)        CHECK (gender IN ('M', 'F')),
    date_of_birth    DATE           NOT NULL,
    address          VARCHAR2(200),
    risk_score       NUMBER(3,2)    DEFAULT 0.5,
    status           VARCHAR2(20)   DEFAULT 'ACTIVE',
    created_date     DATE           DEFAULT SYSDATE
);

-- 2. OFFENSES TABLE  
CREATE TABLE offenses (
    offense_id       NUMBER(10)     PRIMARY KEY,
    offender_id      NUMBER(10)     REFERENCES offenders(offender_id),
    offense_type     VARCHAR2(100)  NOT NULL,
    date_committed   DATE           NOT NULL,
    severity         VARCHAR2(20)   CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH'))
);

-- 3. SENTENCES TABLE
CREATE TABLE sentences (
    sentence_id      NUMBER(10)     PRIMARY KEY,
    offender_id      NUMBER(10)     REFERENCES offenders(offender_id),
    start_date       DATE           NOT NULL,
    end_date         DATE,
    sentence_length  NUMBER(4)      NOT NULL,  -- in months
    status           VARCHAR2(20)   DEFAULT 'ACTIVE'
);

-- 4. REHABILITATION PROGRAMS
CREATE TABLE rehab_programs (
    program_id       NUMBER(10)     PRIMARY KEY,
    program_name     VARCHAR2(100)  NOT NULL,
    duration_months  NUMBER(3)      NOT NULL,
    capacity         NUMBER(3)
);

-- 5. PROGRAM PARTICIPATION
CREATE TABLE program_participation (
    participation_id NUMBER(10)     PRIMARY KEY,
    offender_id      NUMBER(10)     REFERENCES offenders(offender_id),
    program_id       NUMBER(10)     REFERENCES rehab_programs(program_id),
    enrollment_date  DATE           DEFAULT SYSDATE,
    completion_date  DATE,
    status           VARCHAR2(20)   DEFAULT 'ENROLLED'
);

-- 6. ALERTS TABLE
CREATE TABLE alerts (
    alert_id         NUMBER(10)     PRIMARY KEY,
    offender_id      NUMBER(10)     REFERENCES offenders(offender_id),
    alert_type       VARCHAR2(50)   NOT NULL,
    alert_date       DATE           DEFAULT SYSDATE,
    description      VARCHAR2(500)
);

-- 7. SEQUENCES FOR PRIMARY KEYS
CREATE SEQUENCE seq_offenders START WITH 1001;
CREATE SEQUENCE seq_offenses START WITH 2001;
CREATE SEQUENCE seq_sentences START WITH 3001;
CREATE SEQUENCE seq_programs START WITH 101;
CREATE SEQUENCE seq_participation START WITH 5001;
CREATE SEQUENCE seq_alerts START WITH 6001;

-- 8. INDEXES FOR PERFORMANCE
CREATE INDEX idx_offenders_risk ON offenders(risk_score);
CREATE INDEX idx_offenses_offender ON offenses(offender_id);
CREATE INDEX idx_sentences_dates ON sentences(start_date, end_date);

PROMPT === 7 TABLES CREATED SUCCESSFULLY ===