# SecureRehab PL/SQL Capstone Project

## Phase V: Database Table Implementation & Data Insertion

### Project Information

- **Student:** Umwizerwa Ruth
- **Student ID:** 28235
- **Database:** D_28235_Ruth_SecureRehab_DB
- **Phase:** V - Table Implementation
- **Completion Date:** 20-December-2025

### Phase V Objectives

Successfully create all database tables, insert realistic sample data, and validate data integrity for the SecureRehab Offender Rehabilitation Management System.

### Database Schema

#### 6 Core Tables Created:

1. **OFFENDERS** - Core offender information (120 rows)
2. **OFFENSES** - Criminal offenses committed (240 rows)
3. **SENTENCES** - Court sentences assigned (300 rows)
4. **REHAB_PROGRAMS** - Rehabilitation programs offered (44 rows)
5. **PROGRAM_PARTICIPATION** - Offender program enrollment (400 rows)
6. **ALERTS** - System alerts and notifications (150 rows)

**Total Records:** 1254+ realistic data rows

### Project Files

#### SQL Scripts:

- `D_28235_Ruth_SecureRehab_Tables.sql` - Table creation with constraints
- `D_28235_Ruth_SecureRehab_InsertData.sql` - Sample data insertion
- `D_28235_Ruth_SecureRehab_ValidationQueries.sql` - Data validation queries

#### Screenshots:

- `PhaseV_Table_Creation.png` - Successful table creation
- `PhaseV_Data_Counts.png` - Record counts per table
- `PhaseV_Data_Quality.png` - Data validation results
- `PhaseV_Business_Rules.png` - Risk distribution & business metrics
- `PhaseV_Sample_Data.png` - Sample offender and program data
- `PhaseV_Completion.png` - Phase completion confirmation

### Technical Implementation

#### Database Configuration:

```sql
-- Connection string used:
sqlplus SecureRehab_Admin/Ruth@localhost/D_28235_Ruth_SecureRehab_DB

-- Permissions granted:
ALTER USER SecureRehab_Admin QUOTA UNLIMITED ON SYSTEM;
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE TO SecureRehab_Admin;
```
