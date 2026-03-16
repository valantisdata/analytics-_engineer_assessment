# Analytics Engineer Assessment

## Overview

This project implements an end-to-end ETL pipeline that transforms raw casino data into a business-ready Gold table for analytics.

The pipeline includes:

* ingestion of raw CSV datasets
* Slowly Changing Dimension (SCD Type 2) modeling
* incremental data processing
* currency conversion to EUR
* enrichment with VIP status
* aggregation into a Gold analytical table
* data quality validation

The implementation was developed using **PostgreSQL and SQL**.

---

## Source Datasets

Three source datasets were provided:

* **casinodaily.csv**
  Contains casino activity metrics and financial data.

* **currencyrates.csv**
  Provides exchange rates for converting currencies to EUR.

* **users.csv**
  Contains user snapshot/event data representing changes in VIP status.

---

## Data Architecture

### Bronze Layer

Raw CSV files loaded directly into PostgreSQL tables:

* `casinodaily`
* `currencyrates`
* `users`

### Silver Layer

Intermediate transformation tables:

* `dim_users` – SCD Type 2 user dimension
* `pipeline_state` – stores watermark for incremental processing
* `casino_with_currency` – casino metrics converted to EUR
* `casino_vip_status` – casino facts enriched with VIP status

### Gold Layer

Final analytical output:

* `gold_table`

---

## Slowly Changing Dimension (SCD Type 2)

The `users` dataset was transformed into an SCD Type 2 dimension (`dim_users`) with the following fields:

* UserProfileId
* ApplicationId
* CountryName
* VIPSysname
* ValidFromDate
* ValidToDate
* IsCurrent

Window functions (`LEAD`) were used to calculate validity periods and determine the current VIP status record.

---

## Incremental Processing

Incremental processing is implemented using the `UpdatedTimestamp` column as a watermark.

The `pipeline_state` table stores the latest processed timestamp.
During each run, only records with a newer timestamp are processed.

This design ensures:

* idempotent execution
* efficient incremental loads
* scalability for large datasets

---

## Currency Conversion

Casino financial metrics are converted to EUR by joining:

* `casinodaily`
* `currencyrates`

Join conditions:

* `CurrencyId = ToCurrencyId`
* `p_Date = Date`

Metrics converted:

* Turnover_EUR
* Returns_EUR
* GGR_EUR

Formula:

metric_eur = metric * EuroRate

---

## VIP Enrichment

Casino facts are enriched with the correct VIP status by joining:

* `casino_with_currency`
* `dim_users`

Join conditions ensure that the VIP tier is valid at the time of play (`p_Date`).

Missing VIP statuses are labeled as **UNKNOWN**.

---

## Gold Table Aggregation

The final Gold table aggregates casino metrics at the following level:

* UpdatedTimestamp
* ApplicationId
* CountryName
* VIPSysname
* CurrencySysname
* p_Date
* GameName
* ProviderName
* ManufacturerName

Aggregated metrics:

* SUM(Turnover_EUR)
* SUM(Returns_EUR)
* SUM(GGR_EUR)

The final output is exported as:

**gold_table.csv**

---

## Data Quality Checks

The pipeline includes several validation checks:

1. Timestamp completeness validation
2. Missing currency rate detection
3. VIP status coverage analysis
4. Duplicate detection in the Gold table
5. Financial metric validation

During validation it was observed that the source field `GGR` does not always match the row-level formula:

GGR = Turnover - Returns

This was documented as a **source data inconsistency**, while aggregated totals remain consistent.

---

## Pipeline Orchestration

The pipeline is executed as a SQL-driven workflow within PostgreSQL.

Pipeline steps:

1. Load raw CSV files
2. Build the SCD Type 2 dimension
3. Process incremental casino records
4. Convert metrics to EUR
5. Enrich facts with VIP status
6. Aggregate the Gold table
7. Run data quality checks
8. Update the watermark

In a production environment this pipeline could be scheduled using:

* Windows Task Scheduler
* Cron
* Apache Airflow
* dbt

---

## Repository Structure

```
sql/
  01_create_tables.sql
  02_dim_users_scd2.sql
  03_incremental_processing.sql
  04_currency_conversion.sql
  05_vip_status.sql
  06_gold_table.sql
  07_data_quality_checks.sql

gold_table.csv
README.md
```

---

## (Bonus: Visualization & Big Data)

For a dataset exceeding 100M records, the Gold table could be optimized using:

* columnar storage formats such as **Parquet**
* partitioning by date
* materialized views or pre-aggregations
* distributed query engines (Spark, Trino)
* cloud data warehouses (BigQuery, Snowflake, Redshift)

These approaches would improve query performance and support scalable BI dashboards.
