# fraud-analytics-sql
SQL fraud detection project using CTEs, window functions, and behavioral analytics on synthetic transaction data.
# Fraud Analytics SQL Project

A end-to-end SQL fraud detection project built on SQL Server (SSMS), covering database design, synthetic data generation, and 12 investigation queries across real-world fraud patterns.

Built as part of a Fraud Analyst / Risk Analyst analytics portfolio.

---

## Tools & Skills

- **Database:** Microsoft SQL Server
- **Interface:** SQL Server Management Studio (SSMS)
- **Techniques:** CTEs, Window Functions, Correlated Subqueries, Conditional Aggregation, Rolling Averages, Composite Scoring

---

## Project Structure

```
fraud-analytics-sql/
│
├── README.md
│
├── schema/
│   ├── 01_create_database.sql       -- Creates the FraudAnalytics database
│   └── 02_create_tables.sql         -- Creates all 4 tables with constraints
│
├── data/
│   └── 03_seed_data.sql             -- 8 customers, 8 merchants, 27 transactions
│                                       seeded with 7 fraud patterns
│
└── queries/
    ├── q01_velocity_check.sql
    ├── q02_amount_spike_detection.sql
    ├── q03_structuring_detection.sql
    ├── q04_shared_device_ip.sql
    ├── q05_high_risk_merchant_exposure.sql
    ├── q06_geo_anomaly_impossible_travel.sql
    ├── q07_refund_abuse.sql
    ├── q08_decline_storm.sql
    ├── q09_odd_hour_transactions.sql
    ├── q10_fraud_flag_dashboard.sql
    ├── q11_rolling_7day_fraud_rate.sql
    └── q12_customer_risk_scorecard.sql

# How to Run

1. Open **SQL Server Management Studio (SSMS)**
2. Run files **in order**:
   ```
   schema/01_create_database.sql
   schema/02_create_tables.sql
   data/03_seed_data.sql
   ```
3. Run any query file from the `queries/` folder individually

Each query file is self-contained with a `USE FraudAnalytics;` statement at the top.

## Author

**Emmanuel**
Analytics Portfolio | Fraud Analyst · Risk Analyst · Data Analyst
