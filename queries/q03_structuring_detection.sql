-- ============================================================
--  Q3: STRUCTURING DETECTION
--  Finds customers making 3+ purchases in one day, all just under $500
--  Fraud Pattern: Breaking up transactions to avoid detection thresholds
--  Technique: GROUP BY date + HAVING with amount band filter
-- ============================================================

USE FraudAnalytics;
GO

SELECT
    customer_id,
    CAST(txn_timestamp AS DATE) AS txn_date,
    COUNT(*)                    AS num_txns,
    MIN(amount)                 AS min_amount,
    MAX(amount)                 AS max_amount,
    SUM(amount)                 AS total_spend
FROM transactions
WHERE txn_type = 'PURCHASE'
  AND status   = 'APPROVED'
  AND amount   BETWEEN 450 AND 499.99
GROUP BY customer_id, CAST(txn_timestamp AS DATE)
HAVING COUNT(*) >= 3
ORDER BY total_spend DESC;
GO
