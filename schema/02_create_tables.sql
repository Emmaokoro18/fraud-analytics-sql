-- ============================================================
--  FRAUD ANALYTICS PROJECT
--  Step 2: Create Tables
--  Tool: SQL Server / SSMS
--  Run after: 01_create_database.sql
-- ============================================================
 
USE FraudAnalytics;
GO
 
IF OBJECT_ID('fraud_flags',  'U') IS NOT NULL DROP TABLE fraud_flags;
IF OBJECT_ID('transactions', 'U') IS NOT NULL DROP TABLE transactions;
IF OBJECT_ID('merchants',    'U') IS NOT NULL DROP TABLE merchants;
IF OBJECT_ID('customers',    'U') IS NOT NULL DROP TABLE customers;
GO
 
CREATE TABLE customers (
    customer_id     VARCHAR(10)  NOT NULL PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(100),
    phone           VARCHAR(20),
    country         VARCHAR(50),
    created_at      DATETIME,
    is_high_risk    BIT          DEFAULT 0
);
GO
 
CREATE TABLE merchants (
    merchant_id     VARCHAR(10)  NOT NULL PRIMARY KEY,
    merchant_name   VARCHAR(100) NOT NULL,
    category        VARCHAR(50),
    country         VARCHAR(50),
    risk_tier       VARCHAR(10)  -- LOW, MEDIUM, HIGH
);
GO
 
CREATE TABLE transactions (
    txn_id          VARCHAR(15)  NOT NULL PRIMARY KEY,
    customer_id     VARCHAR(10)  NOT NULL REFERENCES customers(customer_id),
    merchant_id     VARCHAR(10)  NOT NULL REFERENCES merchants(merchant_id),
    txn_timestamp   DATETIME,
    amount          DECIMAL(10,2),
    currency        VARCHAR(5),
    txn_type        VARCHAR(20),  -- PURCHASE, REFUND, WITHDRAWAL
    channel         VARCHAR(20),  -- ONLINE, IN_STORE, ATM
    ip_address      VARCHAR(20),
    device_id       VARCHAR(20),
    status          VARCHAR(15),  -- APPROVED, DECLINED, REVERSED
    is_flagged      BIT          DEFAULT 0
);
GO
 
CREATE TABLE fraud_flags (
    flag_id         INT IDENTITY(1,1) PRIMARY KEY,
    txn_id          VARCHAR(15)  NOT NULL REFERENCES transactions(txn_id),
    flag_type       VARCHAR(50),  -- VELOCITY, GEO_ANOMALY, AMOUNT_SPIKE, etc.
    flagged_at      DATETIME,
    reviewed        BIT          DEFAULT 0,
    confirmed_fraud BIT          DEFAULT 0
);
GO
 
