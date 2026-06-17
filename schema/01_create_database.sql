-- ============================================================
--  FRAUD ANALYTICS PROJECT
--  Step 1: Create Database
--  Tool: SQL Server / SSMS
-- ============================================================
 
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'FraudAnalytics')
BEGIN
    CREATE DATABASE FraudAnalytics;
END
GO
 
USE FraudAnalytics;
GO
