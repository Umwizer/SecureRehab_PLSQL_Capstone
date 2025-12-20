-- ============================================================
-- PHASE IV: Database Creation - SECUREREHAB System
-- Student: Umwizerwa Ruth (ID: 28235)
-- Database: D_28235_Ruth_SecureRehab_DB
-- Date: December 20, 2025
-- ============================================================

-- Run as: system/Oracle123@XE AS SYSDBA

SET SERVEROUTPUT ON;
SET FEEDBACK ON;

PROMPT === PHASE IV: DATABASE CREATION ===

-- 1. CREATE PDB WITH PROJECT NAME
PROMPT 1. Creating PDB: D_28235_Ruth_SecureRehab_DB...
CREATE PLUGGABLE DATABASE D_28235_Ruth_SecureRehab_DB
ADMIN USER SecureRehab_Admin IDENTIFIED BY Ruth
ROLES = (DBA)
FILE_NAME_CONVERT = ('pdbseed', 'D_28235_Ruth_SecureRehab_DB');

-- 2. OPEN AND USE PDB
ALTER PLUGGABLE DATABASE D_28235_Ruth_SecureRehab_DB OPEN;
ALTER SESSION SET CONTAINER = D_28235_Ruth_SecureRehab_DB;

-- 3. CREATE TABLESPACES
CREATE TABLESPACE SecureRehab_Data
DATAFILE 'securehab_data01.dbf' SIZE 100M
AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

CREATE TABLESPACE SecureRehab_Index
DATAFILE 'securehab_index01.dbf' SIZE 50M
AUTOEXTEND ON NEXT 5M MAXSIZE 200M;

CREATE TEMPORARY TABLESPACE SecureRehab_Temp
TEMPFILE 'securehab_temp01.dbf' SIZE 50M
AUTOEXTEND ON NEXT 5M MAXSIZE 100M;

-- 4. CONFIGURE ADMIN USER
ALTER USER SecureRehab_Admin 
DEFAULT TABLESPACE SecureRehab_Data
TEMPORARY TABLESPACE SecureRehab_Temp
QUOTA UNLIMITED ON SecureRehab_Data
QUOTA UNLIMITED ON SecureRehab_Index;

GRANT UNLIMITED TABLESPACE TO SecureRehab_Admin;

-- 5. SET MEMORY PARAMETERS
ALTER SYSTEM SET SGA_TARGET=300M SCOPE=BOTH;
ALTER SYSTEM SET PGA_AGGREGATE_TARGET=100M SCOPE=BOTH;

-- 6. VERIFICATION
PROMPT === VERIFICATION ===

PROMPT 1. PDB Status:
SELECT name, open_mode FROM v$pdbs WHERE name LIKE '%SECUREREHAB%';

PROMPT 2. Tablespaces:
SELECT tablespace_name, ROUND(bytes/1024/1024) || 'MB' AS size
FROM dba_data_files WHERE tablespace_name LIKE '%SECUREREHAB%';

PROMPT 3. Admin User:
SELECT username, default_tablespace, account_status
FROM dba_users WHERE username = 'SECUREREHAB_ADMIN';

PROMPT 4. Memory Settings:
SELECT name, value/1024/1024 || 'MB' AS size
FROM v$parameter WHERE name IN ('sga_target', 'pga_aggregate_target');

PROMPT === PHASE IV COMPLETE ===
PROMPT Database: D_28235_Ruth_SecureRehab_DB
PROMPT Admin: SecureRehab_Admin / Ruth
PROMPT Ready for Phase V.