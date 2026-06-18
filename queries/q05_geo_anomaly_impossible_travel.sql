-- ============================================================
--  Q6: GEO ANOMALY — IMPOSSIBLE TRAVEL
--  Detects customers who transact in 2+ countries on the same day
--  Fraud Pattern: Stolen card used internationally, account takeover
--  Technique: Multi-CTE with DISTINCT dedup + STRING_AGG
-- ============================================================

USE FraudAnalytics;


WITH country_deduped AS (
    SELECT DISTINCT
        t.customer_id,
        CAST(t.txn_timestamp AS DATE) AS txn_date,
        m.country
    FROM transactions t
    JOIN merchants m ON t.merchant_id = m.merchant_id
),
daily_countries AS (
    SELECT
        customer_id,
        txn_date,
        COUNT(country)                          AS country_count,
        STRING_AGG(country, ' -> ')
            WITHIN GROUP (ORDER BY country)     AS countries_visited
    FROM country_deduped
    GROUP BY customer_id, txn_date
),
daily_txns AS (
    SELECT
        t.customer_id,
        CAST(t.txn_timestamp AS DATE)           AS txn_date,
        STRING_AGG(t.txn_id, ', ')
            WITHIN GROUP (ORDER BY t.txn_id)    AS related_txns
    FROM transactions t
    GROUP BY t.customer_id, CAST(t.txn_timestamp AS DATE)
)
SELECT
    dc.customer_id,
    c.full_name,
    dc.txn_date,
    dc.country_count,
    dc.countries_visited,
    dt.related_txns
FROM daily_countries dc
JOIN customers  c  ON dc.customer_id = c.customer_id
JOIN daily_txns dt ON dc.customer_id = dt.customer_id AND dc.txn_date = dt.txn_date
WHERE dc.country_count > 1
ORDER BY dc.txn_date;
GO
