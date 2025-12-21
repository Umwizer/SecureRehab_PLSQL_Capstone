# DDL Documentation - CREATE TABLE Statements

## Table: offenders

```sql
CREATE TABLE offenders (
    offender_id NUMBER(10) PRIMARY KEY,
    national_id VARCHAR2(20) UNIQUE NOT NULL,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    date_of_birth DATE NOT NULL,
    address VARCHAR2(200),
    risk_score NUMBER(3,2) CHECK (risk_score BETWEEN 0 AND 1),
    status VARCHAR2(20) DEFAULT 'ACTIVE',
    created_date DATE DEFAULT SYSDATE
);


Table: offenses


CREATE TABLE offenses (
offense_id NUMBER(10) PRIMARY KEY,
offender_id NUMBER(10) NOT NULL,
offense_type VARCHAR2(100) NOT NULL,
date_committed DATE NOT NULL,
severity NUMBER(2) CHECK (severity BETWEEN 1 AND 10),
CONSTRAINT fk_offender FOREIGN KEY (offender_id)
REFERENCES offenders(offender_id) ON DELETE CASCADE
);

Table : Sentences
CREATE TABLE sentences (
    sentence_id NUMBER(10) PRIMARY KEY,
    offender_id NUMBER(10) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'ACTIVE',
    CONSTRAINT fk_sentence_offender FOREIGN KEY (offender_id)
        REFERENCES offenders(offender_id)
);

Table:Rehab Programs
CREATE TABLE rehab_programs (
    program_id NUMBER(10) PRIMARY KEY,
    program_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(500),
    duration_months NUMBER(3),
    capacity NUMBER(4) DEFAULT 50,
    created_date DATE DEFAULT SYSDATE
);
Table:Program_Participation
CREATE TABLE rehab_programs (
    program_id NUMBER(10) PRIMARY KEY,
    program_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(500),
    duration_months NUMBER(3),
    capacity NUMBER(4) DEFAULT 50,
    created_date DATE DEFAULT SYSDATE
);
Table:Alerts
CREATE TABLE alerts (
    alert_id NUMBER(10) PRIMARY KEY,
    offender_id NUMBER(10) NOT NULL,
    alert_type VARCHAR2(50) NOT NULL,
    alert_date DATE DEFAULT SYSDATE,
    description VARCHAR2(500),
    status VARCHAR2(20) DEFAULT 'ACTIVE',
    CONSTRAINT fk_alert_offender FOREIGN KEY (offender_id)
        REFERENCES offenders(offender_id)
);
Table:Sequences
CREATE SEQUENCE seq_offenders START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE seq_offenses START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE seq_sentences START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE seq_programs START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE seq_enrollments START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE seq_alerts START WITH 1000 INCREMENT BY 1;

Table:Indexes
CREATE INDEX idx_offenders_risk ON offenders(risk_score);
CREATE INDEX idx_offenses_offender ON offenses(offender_id);
CREATE INDEX idx_sentences_status ON sentences(status);
CREATE INDEX idx_program_participation_composite ON program_participation(offender_id, program_id);

```
