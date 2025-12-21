# SecureRehab

### Security-Focused Criminal Rehabilitation & Early Release Management System

---

## Project Information

- **Student Name:** Umwizerwa Ruth
- **Student ID:** 28235
- **Group:** D
- **Course:** PL/SQL Practicum Project
- **Instructor:** Mr. Eric Maniraguha
- **University:** Adventist University of Central Africa (AUCA)
- **Academic Year:** 2025
- **Submission Date:** December 2025

## Project Overview

**SecureRehab** is a PL/SQL-based criminal rehabilitation management system designed to support correctional institutions in Rwanda.  
The system manages offender data, calculates risk scores, tracks rehabilitation program participation, and determines early release eligibility in order to promote rehabilitation while reducing prison overcrowding.

The project demonstrates advanced **Oracle Database and PL/SQL concepts**, including procedures, functions, cursors, triggers, auditing, and business intelligence components.

---

## Database Design Overview

### Core Tables

1. **offenders** – Stores offender personal details and risk scores
2. **offenses** – Criminal offense records
3. **sentences** – Sentence details and status
4. **rehab_programs** – Rehabilitation programs offered
5. **program_participation** – Tracks offender participation in programs
6. **alerts** – System-generated alerts and notifications

---

### PL/SQL Components Implemented

#### Procedures

- `add_offender`
- `enroll_in_program`
- `update_offender_status`

#### Functions

- `calculate_risk_score`
- `check_early_release_eligibility`
- `get_program_availability`
- `generate_risk_view_reports` **(Cursor implementation)**

#### Triggers

- Simple triggers
- Compound triggers
- System triggers

#### Views

- `program_enrollment_status_view`

---

## Project Directory Structure

```

Thurs_28235_SecureRehab_PLSQL_Capstone/
│
├── Phase_I_Presentation/
├── Phase_II_BPM/
│   ├── README.md
│   ├── Rehabilitation and early release workflow.png
│   ├── SecureRehab_Phase2Explanation.pdf
│   └── SecureRehab_RPMN.pdf
│
├── Phase_II_Logical_Model/
│   ├── assumption.datadictionary.readme
│   └── secureRehabERDdigram
│
├── Phase_IV/
│   └── Phase_IV.sql
│
├── Phase_V_Database_Creation/
├── Phase_V_Table_Implementation/
│   ├── D_28235_Ruth_SecureRehab_Tables.sql
│   ├── D_28235_Ruth_SecureRehab_InsertData.sql
│   └── D_28235_Ruth_SecureRehab_ValidationQueries.sql
│
├── database/
│   ├── 01_Procedures/
│   ├── 01_Triggers/
│   ├── 02_Auditing/
│   └── 02_Functions/
│       └── generate_risk_view_reports.sql  ← Cursor implementation
│
├── queries/
├── business_intelligence/
├── screenshots/
└── README.md

```

---

## 🚀 Installation & Setup Guide

### Step 1: Create the Pluggable Database (PDB)

```sql
sqlplus / as sysdba

CREATE PLUGGABLE DATABASE D_28235_Ruth_SecureRehab_DB
ADMIN USER SecureRehab_Admin IDENTIFIED BY Ruth;

ALTER PLUGGABLE DATABASE D_28235_Ruth_SecureRehab_DB OPEN;
```

---

### Step 2: Connect to the PDB

```sql
sqlplus SecureRehab_Admin/Ruth@localhost/D_28235_Ruth_SecureRehab_DB
```

---

### Step 3: Create Tables

```sql
@Phase_V_Table_Implementation/D_28235_Ruth_SecureRehab_Tables.sql
```

---

### Step 4: Insert Sample Data

```sql
@Phase_V_Table_Implementation/D_28235_Ruth_SecureRehab_InsertData.sql
```

---

### Step 5: Create PL/SQL Objects

#### Procedures

```sql
@database/01_Procedures/add_offender_proc.sql
@database/01_Procedures/enroll_in_program_proc.sql
@database/01_Procedures/update_offender_status_proc.sql
```

#### Functions

```sql
@database/02_Functions/calculate_risk_score.sql
@database/02_Functions/check_early_release_eligibility.sql
@database/02_Functions/generate_risk_view_reports.sql
```

#### Triggers

```sql
@database/01_Triggers/simple_triggers.sql
@database/01_Triggers/compound_triggers.sql
@database/01_Triggers/system_triggers.sql
```

---

## System Testing

### ✔ Validation Queries

```sql
@Phase_V_Table_Implementation/D_28235_Ruth_SecureRehab_ValidationQueries.sql
```

### ✔ Function Testing

```sql
@database/02_Functions/test_functions.sql
```

### ✔ Procedure Testing

```sql
@database/01_Procedures/test_enroll_fixed.sql
```

### ✔ Cursor Testing (Required Proof)

```sql
SET SERVEROUTPUT ON;
-- Execute generate_risk_view_reports function
```

---

## Project Phases Completion Status

| Phase | Description                | Status       |
| ----- | -------------------------- | ------------ |
| I     | Problem Statement          | ✅ Completed |
| II    | Business Process Modeling  | ✅ Completed |
| III   | Logical Design (ERD)       | ✅ Completed |
| IV    | Database Creation (PDB)    | ✅ Completed |
| V     | Table Implementation       | ✅ Completed |
| VI    | PL/SQL Development         | ✅ Completed |
| VII   | Advanced PL/SQL & Auditing | ✅ Completed |
| VIII  | Documentation & Submission | ✅ Completed |

---

## Required Screenshots

Stored in the `/screenshots/` directory:

1. PDB creation and connection
2. Cursor source code
3. Cursor execution output
4. Table list (`USER_TABLES`)
5. Sample offender data
6. GitHub commit history (28+ commits)
7. ER Diagram
8. Trigger execution proof
9. Function output
10. Validation error handling

---

## 🔗 GitHub Repository

- **Repository Name:** `Thurs_28235_SecureRehab_PLSQL_Capstone`
- **URL:** [https://github.com/Umwizer/Thurs_28235_SecureRehab_PLSQL_Capstone.git](https://github.com/Umwizer/Thurs_28235_SecureRehab_PLSQL_Capstone.git)
- **Branch:** main
-

---

## Contact Information

- **Name:** Umwizerwa Ruth
- **Student ID:** 28235
- **Group:** D
- **Course:** PL/SQL Practicum Project
- **University:** AUCA
