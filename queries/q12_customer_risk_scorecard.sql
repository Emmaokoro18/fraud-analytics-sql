-- ============================================================
--  Q12: CUSTOMER RISK SCORECARD
--  Assigns a composite risk score per customer across 5 signals
--  Output: Score + risk tier (HIGH / MEDIUM / LOW)
--  Technique: Multi-CTE scoring model with LEFT JOINs + ISNULL
--
--  Scoring Breakdown:
--    Velocity (3+ flagged txns)       → 30 pts
--    Amount Spike (5x avg)            → 25 pts
--    High-Risk Merchant               → 20 pts
--    Odd-Hour Activity (12am–4am)     → 15 pts
--    Pre-flagged High Risk Customer   → 10 pts
-- ============================================================

USE FraudAnalytics;
GO

WITH velocity_score AS (
    SELECT customer_id,
           CASE WHEN SUM(CASE WHEN is_flagged = 1 THEN 1 ELSE 0 END) >= 3
                THEN 30 ELSE 0 END AS score
    FROM transactions
    GROUP BY customer_id
),
spike_score AS (
    SELECT t.customer_id,
           CASE WHEN MAX(t.amount) > 5 * AVG(t.amount)
                THEN 25 ELSE 0 END AS score
    FROM transactions t
    WHERE txn_type = 'PURCHASE' AND status = 'APPROVED'
    GROUP BY t.customer_id
),
high_risk_merch_score AS (
    SELECT t.customer_id,
           CASE WHEN COUNT(*) > 0 THEN 20 ELSE 0 END AS score
    FROM transactions t
    JOIN merchants m ON t.merchant_id = m.merchant_id
    WHERE m.risk_tier = 'HIGH'
    GROUP BY t.customer_id
),
odd_hour_score AS (
    SELECT customer_id,
           CASE WHEN COUNT(*) > 0 THEN 15 ELSE 0 END AS score
    FROM transactions
    WHERE DATEPART(HOUR, txn_timestamp) BETWEEN 0 AND 4
    GROUP BY customer_id
),
base_risk AS (
    SELECT customer_id,
           CASE WHEN is_high_risk = 1 THEN 10 ELSE 0 END AS score
    FROM customers
)
SELECT
    c.customer_id,
    c.full_name,
    c.country,
    ISNULL(v.score,  0) AS velocity_pts,
    ISNULL(sp.score, 0) AS spike_pts,
    ISNULL(hr.score, 0) AS high_risk_merch_pts,
    ISNULL(oh.score, 0) AS odd_hour_pts,
    ISNULL(br.score, 0) AS base_risk_pts,
    (ISNULL(v.score,0) + ISNULL(sp.score,0) + ISNULL(hr.score,0)
     + ISNULL(oh.score,0) + ISNULL(br.score,0))            AS total_risk_score,
    CASE
        WHEN (ISNULL(v.score,0) + ISNULL(sp.score,0) + ISNULL(hr.score,0)
              + ISNULL(oh.score,0) + ISNULL(br.score,0)) >= 50 THEN 'HIGH'
        WHEN (ISNULL(v.score,0) + ISNULL(sp.score,0) + ISNULL(hr.score,0)
              + ISNULL(oh.score,0) + ISNULL(br.score,0)) >= 25 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS risk_tier
FROM customers c
LEFT JOIN velocity_score         v  ON c.customer_id = v.customer_id
LEFT JOIN spike_score            sp ON c.customer_id = sp.customer_id
LEFT JOIN high_risk_merch_score  hr ON c.customer_id = hr.customer_id
LEFT JOIN odd_hour_score         oh ON c.customer_id = oh.customer_id
LEFT JOIN base_risk              br ON c.customer_id = br.customer_id
ORDER BY total_risk_score DESC;
GO
