-- ============================================================
--  Q8: DECLINE STORM — CARD TESTING SIGNAL
--  Finds customers with a high ratio of declined transactions
--  Fraud Pattern: Automated card testing before fraudulent use
--  Technique: Conditional aggregation + decline rate calculation
-- ============================================================

USE FraudAnalytics;
GO

WITH status_counts AS (
    SELECT
        customer_id,
        SUM(CASE WHEN status = 'APPROVED' THEN 1 ELSE 0 END) AS approved,
        SUM(CASE WHEN status = 'DECLINED' THEN 1 ELSE 0 END) AS declined,
        COUNT(*)                                               AS total_txns
    FROM transactions
    GROUP BY customer_id
)
SELECT
    sc.customer_id,
    c.full_name,
    sc.approved,
    sc.declined,
    sc.total_txns,
    ROUND(
        CAST(sc.declined AS DECIMAL(10,2)) / NULLIF(sc.total_txns, 0) * 100,
    1) AS decline_rate_pct
FROM status_counts sc
JOIN customers c ON sc.customer_id = c.customer_id
WHERE sc.declined > 0
ORDER BY decline_rate_pct DESC;
GO
