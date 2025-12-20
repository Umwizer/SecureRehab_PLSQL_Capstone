# Phase IV: Database Creation - SecureRehab System

### Database Name (As Required)
**D_28235_Ruth_SecureRehab_DB** - Created as per naming convention: `Group_StudentID_FirstName_ProjectName_DB`

### Admin User Configuration
- **Username:** `SecureRehab_Admin` (Identifiable as per requirements)
- **Password:** `Ruth` (Your first name as required)
- **Privileges:** Super Admin (DBA role + UNLIMITED TABLESPACE + all object creation rights)

### Technical Architecture

#### 1. Pluggable Database (PDB) Configuration
- **PDB Name:** `D_28235_Ruth_SecureRehab_DB`
- **Container:** Oracle XE 21c Multitenant Architecture
- **Creation Method:** `CREATE PLUGGABLE DATABASE` command with ADMIN USER clause
- **File Conversion:** Automatic file name conversion from PDB seed
- **Status:** OPEN READ WRITE mode

#### 2. Tablespaces Configuration

| Tablespace | Purpose | Size | Autoextend | Max Size | Extent Management | Segment Management |
|------------|---------|------|------------|----------|-------------------|-------------------|
| SecureRehab_Data | Main data storage | 100MB | ON (+10MB) | 500MB | LOCAL | AUTO |
| SecureRehab_Index | Index storage | 50MB | ON (+5MB) | 200MB | LOCAL | AUTO |
| SecureRehab_Temp | Temporary operations | 50MB | ON (+5MB) | 100MB | - | - |

#### 3. Memory & Performance Configuration
- **SGA_TARGET:** 300MB (System Global Area for shared memory)
- **PGA_AGGREGATE_TARGET:** 100MB (Program Global Area for session memory)
- **Oracle XE Limitation:** Maximum 2GB RAM usage enforced by Express Edition
- **Parameter Scope:** BOTH (immediate and persistent changes)

#### 4. Archive Logging Configuration
- **Status:** `NOARCHIVELOG` (Oracle XE default - documented limitation)
- **Production Configuration:** Would be `ARCHIVELOG` in Enterprise Edition
- **Purpose:** Point-in-time recovery and database backup
- **Architecture Note:** Configured at CDB level, inherited by all PDBs

#### 5. Autoextend Configuration
- All datafiles configured with `AUTOEXTEND ON`
- **Data Tablespace:** Extends by 10MB chunks up to 500MB
- **Index Tablespace:** Extends by 5MB chunks up to 200MB
- **Prevents:** `ORA-01653: unable to extend table` errors

### Connection Information

#### Primary Connections:
- **Container Database (CDB):** `XE` (localhost:1521)
- **Project PDB:** `D_28235_Ruth_SecureRehab_DB`
- **System User:** `system` / `Oracle123`
- **Project Admin:** `SecureRehab_Admin` / `Ruth`

#### Alternative Connection Strings:
```bash
# As system to CDB
sqlplus system/Oracle123@XE

# As system to specific PDB
sqlplus system/Oracle123@localhost/XEPDB1

# As project admin to project PDB
sqlplus SecureRehab_Admin/Ruth@localhost/D_28235_Ruth_SecureRehab_DB

# As SYSDBA (administrative)
sqlplus / as sysdba