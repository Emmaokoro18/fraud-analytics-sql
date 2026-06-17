-- ============================================================
--  Q2: AMOUNT SPIKE DETECTION
--  Flags transactions that are 5x above the customer's own average
--  Fraud Pattern: Stolen card used for large purchase
--  Technique: CTE baseline + ratio comparison
-- ============================================================

USE FraudAnalytics;
GO

WITH customer_baseline AS (
    SELECT
        customer_id,
        AVG(amount)   AS avg_spend,
        STDEV(amount) AS stddev_spend
    FROM transactions
    WHERE status   = 'APPROVED'
      AND txn_type = 'PURCHASE'
    GROUP BY customer_id
),
flagged_spikes AS (
    SELECT
        t.txn_id,
        t.customer_id,
        t.txn_timestamp,
        t.amount,
        ROUND(b.avg_spend, 2)                        AS customer_avg,
        ROUND(t.amount / NULLIF(b.avg_spend, 0), 2)  AS spike_ratio
    FROM transactions t
    JOIN customer_baseline b ON t.customer_id = b.customer_id
    WHERE t.status   = 'APPROVED'
      AND t.txn_type = 'PURCHASE'
      AND t.amount   > 5 * b.avg_spend
)
SELECT * FROM flagged_spikes
ORDER BY spike_ratio DESC;
GO
