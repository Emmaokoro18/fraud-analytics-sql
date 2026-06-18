-- ============================================================
--  Q4: SHARED DEVICE / IP FINGERPRINTING
--  Identifies devices or IPs used by more than one customer
--  Fraud Pattern: Account linking, synthetic identity, mule networks
--  Technique: DISTINCT dedup CTE + STRING_AGG grouping
-- ============================================================

USE FraudAnalytics;
GO

WITH device_deduped AS (
    SELECT DISTINCT device_id, customer_id FROM transactions
),
device_sharing AS (
    SELECT
        device_id                        AS identifier,
        'DEVICE'                         AS link_type,
        COUNT(customer_id)               AS unique_customers,
        STRING_AGG(customer_id, ', ')
            WITHIN GROUP (ORDER BY customer_id) AS customer_list
    FROM device_deduped
    GROUP BY device_id
    HAVING COUNT(customer_id) > 1
),
ip_deduped AS (
    SELECT DISTINCT ip_address, customer_id FROM transactions
),
ip_sharing AS (
    SELECT
        ip_address                       AS identifier,
        'IP'                             AS link_type,
        COUNT(customer_id)               AS unique_customers,
        STRING_AGG(customer_id, ', ')
            WITHIN GROUP (ORDER BY customer_id) AS customer_list
    FROM ip_deduped
    GROUP BY ip_address
    HAVING COUNT(customer_id) > 1
)
SELECT link_type, identifier, unique_customers, customer_list FROM device_sharing
UNION ALL
SELECT link_type, identifier, unique_customers, customer_list FROM ip_sharing
ORDER BY unique_customers DESC;
GO
