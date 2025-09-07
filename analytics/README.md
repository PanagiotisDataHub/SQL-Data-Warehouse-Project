# Analytics Layer

This folder contains the **Analytics extension** of the SQL Data Warehouse project.  
It builds on top of the **Gold layer** (star schema) and demonstrates how to use SQL for:

- **Exploratory Data Analysis (EDA):** database profiling, dimension exploration, date ranges, measures, magnitude checks, and ranking.
- **Business Analysis:** trends over time, cumulative metrics, performance tracking, segmentation.
- **Reporting Queries:** customer- and product-level reports that can directly feed dashboards.

Each script is written to highlight clear SQL practices and logical structuring for data exploration and analytics.

---

## Structure

- `scripts/eda/` → exploratory analysis scripts (profiling & discovery)  
- `scripts/analysis/` → deeper business analysis queries  
- `scripts/reporting/` → final reporting queries  

---

## How to Use

1. Make sure the **Data Warehouse** is built (bronze → silver → gold) using the `/scripts` folder at the root.
2. Run any SQL scripts from `analytics/scripts/` against the same database.
3. Optionally connect Power BI to the Gold schema or to the views in `analytics/semantic/views_sql/`.

---

## Notes
- The `00_init_database.sql` file is optional here, since the DW is already created in `/scripts/init_database.sql`.  
- Scripts are organized to mirror the typical flow: **EDA → Analysis → Reporting**.