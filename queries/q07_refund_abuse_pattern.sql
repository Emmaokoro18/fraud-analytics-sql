-- ============================================================
--  Q7: REFUND ABUSE PATTERN
--  Finds customers who refund and immediately repurchase the same amount
--  Fraud Pattern: Refund fraud, return policy abuse
--  Technique: CTE self-join on refund -> repurchase within 2 hours
-- ============================================================

USE FraudAnalytics;
GO

WITH refunds AS (
    SELECT customer_id, merchant_id, amount,
           txn_timestamp AS refund_time,
           txn_id        AS refund_txn
    FROM transactions
    WHERE txn_type = 'REFUND'
),
repurchases AS (
    SELECT customer_id, merchant_id, amount,
           txn_timestamp AS repurchase_time,
           txn_id        AS repurchase_txn
    FROM transactions
    WHERE txn_type = 'PURCHASE'
)
SELECT
    r.customer_id,
    r.refund_txn,
    r.refund_time,
    p.repurchase_txn,
    p.repurchase_time,
    r.amount,
    DATEDIFF(MINUTE, r.refund_time, p.repurchase_time) AS minutes_between
FROM refunds r
JOIN repurchases p
  ON  r.customer_id = p.customer_id
  AND r.merchant_id = p.merchant_id
  AND r.amount      = p.amount
  AND p.repurchase_time BETWEEN r.refund_time
                            AND DATEADD(HOUR, 2, r.refund_time)
ORDER BY minutes_between;
GO
