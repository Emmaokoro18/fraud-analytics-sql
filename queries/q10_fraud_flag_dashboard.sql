-- ============================================================
--  Q10: FRAUD FLAG SUMMARY DASHBOARD
--  Summarizes confirmed fraud by flag type with financial impact
--  Use Case: Analyst review queue prioritization
--  Technique: Conditional aggregation + confirmation rate calculation
-- ============================================================

USE FraudAnalytics;
GO

SELECT
    ff.flag_type,
    COUNT(*)                                                  AS total_flags,
    SUM(CASE WHEN ff.confirmed_fraud = 1 THEN 1 ELSE 0 END)  AS confirmed,
    SUM(CASE WHEN ff.confirmed_fraud = 0 THEN 1 ELSE 0 END)  AS unconfirmed,
    ROUND(
        CAST(SUM(CASE WHEN ff.confirmed_fraud = 1 THEN 1 ELSE 0 END) AS DECIMAL(10,2))
        / NULLIF(COUNT(*), 0) * 100,
    1)                                                        AS confirmation_rate_pct,
    ROUND(
        SUM(CASE WHEN ff.confirmed_fraud = 1 THEN t.amount ELSE 0 END),
    2)                                                        AS confirmed_fraud_amount
FROM fraud_flags ff
JOIN transactions t ON ff.txn_id = t.txn_id
GROUP BY ff.flag_type
ORDER BY confirmed_fraud_amount DESC;
GO
