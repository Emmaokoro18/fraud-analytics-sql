-- ============================================================
--  Q9: OVERNIGHT / ODD-HOUR TRANSACTION ANALYSIS
--  Surfaces transactions between midnight and 5am
--  Fraud Pattern: Bot-driven fraud, account takeover activity
--  Technique: DATEPART(HOUR) filter with multi-table JOIN
-- ============================================================

USE FraudAnalytics;
GO

SELECT
    t.txn_id,
    t.customer_id,
    c.full_name,
    t.txn_timestamp,
    DATEPART(HOUR, t.txn_timestamp) AS txn_hour,
    t.amount,
    t.channel,
    m.merchant_name,
    m.category
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
JOIN merchants m ON t.merchant_id = m.merchant_id
WHERE DATEPART(HOUR, t.txn_timestamp) BETWEEN 0 AND 4
ORDER BY t.txn_timestamp;
GO
