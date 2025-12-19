# **SecureRehab Data Dictionary**

## **1. OFFENDERS**

| Column      | Type          | Constraints                | Description                 |
| ----------- | ------------- | -------------------------- | --------------------------- |
| offender_id | NUMBER(10)    | PK, NOT NULL               | Unique ID for each offender |
| name        | VARCHAR2(100) | NOT NULL                   | Full name of the offender   |
| age         | NUMBER(3)     | NOT NULL, CHECK(age>0)     | Age of offender             |
| gender      | CHAR(1)       | CHECK(gender IN ('M','F')) | Gender of offender          |
| address     | VARCHAR2(200) | NULL                       | Residential address         |
| risk_score  | NUMBER(3,1)   | DEFAULT 0                  | Calculated risk score       |

## **2. OFFENSES**

| Column         | Type         | Constraints                     | Description                    |
| -------------- | ------------ | ------------------------------- | ------------------------------ |
| offense_id     | NUMBER(10)   | PK, NOT NULL                    | Unique ID for each offense     |
| offender_id    | NUMBER(10)   | FK → OFFENDERS(offender_id)     | Offender who committed offense |
| offense_type   | VARCHAR2(50) | NOT NULL                        | Type of offense                |
| date_committed | DATE         | NOT NULL                        | Date offense happened          |
| severity       | NUMBER(1)    | CHECK(severity BETWEEN 1 AND 5) | Severity level (1=low,5=high)  |

## **3. SENTENCES**

| Column      | Type         | Constraints                                      | Description                   |
| ----------- | ------------ | ------------------------------------------------ | ----------------------------- |
| sentence_id | NUMBER(10)   | PK, NOT NULL                                     | Unique ID for sentence        |
| offender_id | NUMBER(10)   | FK → OFFENDERS(offender_id)                      | Offender serving the sentence |
| start_date  | DATE         | NOT NULL                                         | Sentence start date           |
| end_date    | DATE         | NOT NULL                                         | Sentence end date             |
| status      | VARCHAR2(20) | CHECK(status IN ('Active','Completed','Parole')) | Current sentence status       |

## **4. REHAB_PROGRAMS**

| Column      | Type          | Constraints  | Description               |
| ----------- | ------------- | ------------ | ------------------------- |
| program_id  | NUMBER(10)    | PK, NOT NULL | Unique ID for program     |
| name        | VARCHAR2(100) | NOT NULL     | Program name              |
| description | VARCHAR2(200) | NULL         | Short program description |
| duration    | NUMBER(3)     | NOT NULL     | Duration in weeks         |

## **5. PROGRAM_PARTICIPATION**

| Column            | Type         | Constraints                                                       | Description                     |
| ----------------- | ------------ | ----------------------------------------------------------------- | ------------------------------- |
| participation_id  | NUMBER(10)   | PK, NOT NULL                                                      | Unique ID for participation     |
| offender_id       | NUMBER(10)   | FK → OFFENDERS(offender_id)                                       | Participating offender          |
| program_id        | NUMBER(10)   | FK → REHAB_PROGRAMS(program_id)                                   | Program enrolled                |
| start_date        | DATE         | NOT NULL                                                          | Participation start date        |
| completion_status | VARCHAR2(20) | CHECK(completion_status IN ('Completed','In Progress','Dropped')) | Status of program participation |

## **6. ALERTS**

| Column      | Type          | Constraints                 | Description                  |
| ----------- | ------------- | --------------------------- | ---------------------------- |
| alert_id    | NUMBER(10)    | PK, NOT NULL                | Unique ID for each alert     |
| offender_id | NUMBER(10)    | FK → OFFENDERS(offender_id) | Offender related to alert    |
| alert_type  | VARCHAR2(50)  | NOT NULL                    | Type of alert (Risk/Release) |
| alert_date  | DATE          | NOT NULL                    | Date alert generated         |
| description | VARCHAR2(200) | NULL                        | Detailed alert message       |
