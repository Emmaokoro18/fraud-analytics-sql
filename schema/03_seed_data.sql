-- ============================================================
--  FRAUD ANALYTICS PROJECT
--  Step 3: Seed Data
--  Tool: SQL Server / SSMS
--  Run after: 02_create_tables.sql
--
--  Dataset includes 8 customers, 8 merchants, 27 transactions
--  seeded with 6 real-world fraud patterns:
--    1. Velocity fraud      (Brian)
--    2. Geo anomaly         (Carla)
--    3. High-risk customer  (Derek)
--    4. Structuring         (Frank)
--    5. Shared device       (Grace & Hector)
--    6. Amount spike        (Elena)
--    7. Refund abuse        (Alice)
-- ============================================================
 
USE FraudAnalytics;
GO
 
-- Customers
INSERT INTO customers VALUES
('C001','Alice Morgan',  'alice@email.com',  '555-1001','US','2022-01-15 09:00:00',0),
('C002','Brian Tate',    'brian@email.com',  '555-1002','US','2021-06-20 11:30:00',0),
('C003','Carla Vega',    'carla@email.com',  '555-1003','MX','2023-03-10 08:15:00',0),
('C004','Derek Zhou',    'derek@email.com',  '555-1004','US','2020-11-05 14:00:00',1),
('C005','Elena Frost',   'elena@email.com',  '555-1005','CA','2022-07-22 10:45:00',0),
('C006','Frank Nile',    'frank@email.com',  '555-1006','US','2023-08-01 09:30:00',0),
('C007','Grace Kim',     'grace@email.com',  '555-1007','KR','2021-04-18 16:20:00',0),
('C008','Hector Ruiz',   'hector@email.com', '555-1008','MX','2022-09-30 13:10:00',1);
GO
 
-- Merchants
INSERT INTO merchants VALUES
('M001','TechWorld',     'Electronics','US','MEDIUM'),
('M002','JetSetTravel',  'Travel',     'UK','HIGH'),
('M003','QuickCash ATM', 'ATM',        'US','HIGH'),
('M004','SuperMart',     'Grocery',    'US','LOW'),
('M005','LuxeGoods',     'Luxury',     'FR','HIGH'),
('M006','BetZone',       'Gambling',   'MT','HIGH'),
('M007','EverydayPharm', 'Pharmacy',   'US','LOW'),
('M008','StreamItAll',   'Digital',    'US','LOW');
GO
 
-- Transactions: Normal activity (Alice)
INSERT INTO transactions VALUES
('T0001','C001','M004','2024-01-05 08:30:00',  52.40,'USD','PURCHASE',  'IN_STORE','98.1.1.10', 'DEV-A1','APPROVED',0),
('T0002','C001','M007','2024-01-06 09:00:00',  18.99,'USD','PURCHASE',  'IN_STORE','98.1.1.10', 'DEV-A1','APPROVED',0),
('T0003','C001','M008','2024-01-07 20:15:00',  12.99,'USD','PURCHASE',  'ONLINE',  '98.1.1.10', 'DEV-A1','APPROVED',0);
GO
 
-- Transactions: Velocity fraud (Brian - 6 txns in 10 minutes)
INSERT INTO transactions VALUES
('T0004','C002','M001','2024-02-10 02:01:00', 499.00,'USD','PURCHASE',  'ONLINE',  '45.9.9.1',  'DEV-B2','APPROVED',1),
('T0005','C002','M001','2024-02-10 02:03:00', 499.00,'USD','PURCHASE',  'ONLINE',  '45.9.9.1',  'DEV-B2','APPROVED',1),
('T0006','C002','M001','2024-02-10 02:05:00', 499.00,'USD','PURCHASE',  'ONLINE',  '45.9.9.1',  'DEV-B2','APPROVED',1),
('T0007','C002','M001','2024-02-10 02:06:00', 499.00,'USD','PURCHASE',  'ONLINE',  '45.9.9.1',  'DEV-B2','DECLINED',1),
('T0008','C002','M001','2024-02-10 02:08:00', 499.00,'USD','PURCHASE',  'ONLINE',  '45.9.9.1',  'DEV-B2','DECLINED',1),
('T0009','C002','M001','2024-02-10 02:10:00', 499.00,'USD','PURCHASE',  'ONLINE',  '45.9.9.1',  'DEV-B2','DECLINED',1);
GO
 
-- Transactions: Geo anomaly (Carla - Mexico to France same day)
INSERT INTO transactions VALUES
('T0010','C003','M004','2024-03-01 10:00:00',  35.00,'MXN','PURCHASE',  'IN_STORE','187.2.3.10','DEV-C3','APPROVED',0),
('T0011','C003','M005','2024-03-01 14:30:00',3200.00,'EUR','PURCHASE',  'IN_STORE','82.45.10.5','DEV-C3','APPROVED',1);
GO
 
-- Transactions: High-risk customer (Derek - late-night ATM + gambling)
INSERT INTO transactions VALUES
('T0012','C004','M003','2024-03-15 23:45:00', 900.00,'USD','WITHDRAWAL','ATM',     '10.0.0.5',  'DEV-D4','APPROVED',1),
('T0013','C004','M003','2024-03-15 23:58:00', 900.00,'USD','WITHDRAWAL','ATM',     '10.0.0.5',  'DEV-D4','APPROVED',1),
('T0014','C004','M006','2024-03-16 00:30:00',1500.00,'USD','PURCHASE',  'ONLINE',  '10.0.0.5',  'DEV-D4','APPROVED',1);
GO
 
-- Transactions: Structuring (Frank - just under $500 threshold)
INSERT INTO transactions VALUES
('T0015','C006','M001','2024-04-02 11:00:00', 498.00,'USD','PURCHASE',  'ONLINE',  '72.3.11.20','DEV-F6','APPROVED',0),
('T0016','C006','M001','2024-04-02 13:00:00', 497.50,'USD','PURCHASE',  'ONLINE',  '72.3.11.20','DEV-F6','APPROVED',0),
('T0017','C006','M001','2024-04-02 15:00:00', 499.00,'USD','PURCHASE',  'ONLINE',  '72.3.11.20','DEV-F6','APPROVED',0),
('T0018','C006','M001','2024-04-02 17:00:00', 496.00,'USD','PURCHASE',  'ONLINE',  '72.3.11.20','DEV-F6','APPROVED',0);
GO
 
-- Transactions: Shared device (Grace and Hector - account linking signal)
INSERT INTO transactions VALUES
('T0019','C007','M002','2024-05-10 09:00:00', 850.00,'USD','PURCHASE',  'ONLINE',  '55.6.7.8',  'DEV-GH9','APPROVED',0),
('T0020','C008','M002','2024-05-10 09:45:00', 920.00,'USD','PURCHASE',  'ONLINE',  '55.6.7.8',  'DEV-GH9','APPROVED',1);
GO
 
-- Transactions: Amount spike (Elena - low avg then huge charge)
INSERT INTO transactions VALUES
('T0021','C005','M004','2024-06-01 08:00:00',  22.00,'CAD','PURCHASE',  'IN_STORE','199.1.2.3', 'DEV-E5','APPROVED',0),
('T0022','C005','M004','2024-06-02 08:30:00',  30.00,'CAD','PURCHASE',  'IN_STORE','199.1.2.3', 'DEV-E5','APPROVED',0),
('T0023','C005','M004','2024-06-03 09:00:00',  18.50,'CAD','PURCHASE',  'IN_STORE','199.1.2.3', 'DEV-E5','APPROVED',0),
('T0024','C005','M005','2024-06-04 14:00:00',4750.00,'EUR','PURCHASE',  'ONLINE',  '82.45.10.5','DEV-E5','APPROVED',1);
GO
 
-- Transactions: Refund abuse (Alice - refund then immediate repurchase)
INSERT INTO transactions VALUES
('T0025','C001','M001','2024-07-01 10:00:00', 349.00,'USD','PURCHASE',  'ONLINE',  '98.1.1.10', 'DEV-A1','APPROVED',0),
('T0026','C001','M001','2024-07-03 11:00:00', 349.00,'USD','REFUND',    'ONLINE',  '98.1.1.10', 'DEV-A1','REVERSED',0),
('T0027','C001','M001','2024-07-03 11:30:00', 349.00,'USD','PURCHASE',  'ONLINE',  '98.1.1.10', 'DEV-A1','APPROVED',0);
GO
 
-- Fraud Flags
INSERT INTO fraud_flags (txn_id, flag_type, flagged_at, reviewed, confirmed_fraud) VALUES
('T0004','VELOCITY',     '2024-02-10 02:11:00',1,1),
('T0005','VELOCITY',     '2024-02-10 02:11:00',1,1),
('T0006','VELOCITY',     '2024-02-10 02:11:00',1,1),
('T0007','VELOCITY',     '2024-02-10 02:11:00',1,1),
('T0008','VELOCITY',     '2024-02-10 02:11:00',1,1),
('T0009','VELOCITY',     '2024-02-10 02:11:00',1,1),
('T0011','GEO_ANOMALY',  '2024-03-01 15:00:00',1,1),
('T0012','AMOUNT_SPIKE', '2024-03-15 23:50:00',0,0),
('T0013','VELOCITY',     '2024-03-15 23:59:00',1,1),
('T0014','HIGH_RISK_MCC','2024-03-16 01:00:00',0,0),
('T0020','SHARED_DEVICE','2024-05-10 10:00:00',1,1),
('T0024','AMOUNT_SPIKE', '2024-06-04 14:05:00',0,0);
GO
 
