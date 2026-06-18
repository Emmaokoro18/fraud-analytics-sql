-- ============================================================
--  Q11: ROLLING 7-DAY FRAUD RATE
--  Tracks daily flagged transactions vs total, with 7-day moving average
--  Use Case: Trend monitoring, fraud spike detection
--  Technique: CTE + AVG() window with ROWS BETWEEN
-- ============================================================

USE FraudAnalytics;
GO

WITH daily_stats AS (
    SELECT
        CAST(txn_timestamp AS DATE)                             AS txn_date,
        COUNT(*)                                                AS total_txns,
        SUM(CASE WHEN is_flagged = 1 THEN 1 ELSE 0 END)        AS flagged_txns,
        SUM(amount)                                             AS total_amount,
        SUM(CASE WHEN is_flagged = 1 THEN amount ELSE 0 END)   AS flagged_amount
    FROM transactions
    GROUP BY CAST(txn_timestamp AS DATE)
)
SELECT
    txn_date,
    total_txns,
    flagged_txns,
    ROUND(
        CAST(flagged_txns AS DECIMAL(10,2)) / NULLIF(total_txns, 0) * 100,
    1)                                                          AS flag_rate_pct,
    ROUND(total_amount,   2)                                    AS total_amount,
    ROUND(flagged_amount, 2)                                    AS flagged_amount,
    ROUND(
        AVG(CAST(flagged_amount AS DECIMAL(10,2))) OVER (
            ORDER BY txn_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ),
    2)                                                          AS rolling_7d_fraud_avg
FROM daily_stats
ORDER BY txn_date;
GO
