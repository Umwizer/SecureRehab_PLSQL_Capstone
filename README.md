# SecureRehab: Security-Focused Criminal Rehabilitation System

## Project Information

- **Student:** Umwizerwa Ruth
- **Student ID:** 28235
- **Group:** D
- **Course:** PL/SQL Practicum Project
- **Instructor:** Mr. Eric Maniraguha
- **University:** Adventist University of Central Africa (AUCA)
- **Submission Date:** December 2025

## Project Overview

SecureRehab is a PL/SQL-based database management system designed to track offender rehabilitation, calculate risk scores, and identify candidates for early release to reduce prison overcrowding in Rwanda.

## Database Features

### Core Tables

- `offenders` - Offender personal information and risk scores
- `offenses` - Criminal offense records
- `sentences` - Court sentences and status
- `rehab_programs` - Rehabilitation programs
- `program_participation` - Program enrollment tracking
- `alerts` - System alerts and notifications

### PL/SQL Components

- **Procedures:** `add_offender`, `enroll_in_program`, `generate_risk_review_report`
- **Functions:** `calculate_risk_score`, `check_early_release_eligibility`
- **Triggers:** Automatic alerts and validations
- **Cursors:** Batch processing of offenders
- **Packages:** Related functionality grouping

## Installation & Setup

1. **Create PDB:**
   ```sql
   @database/scripts/01_create_pdb.sql
   ```
2. @database/scripts/02_create_tables.sql
   @database/scripts/03_insert_data.sql
   @database/scripts/04_plsql_components.sql
