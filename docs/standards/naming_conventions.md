# Naming Conventions

This document describes how we name **schemas, tables, views, columns, and code artifacts** across the warehouse.

## Table of Contents
1. [General Principles](#general-principles)
2. [Table Naming](#table-naming)
   - [Bronze Rules](#bronze-rules)
   - [Silver Rules](#silver-rules)
   - [Gold Rules](#gold-rules)
3. [Column Naming](#column-naming)
   - [Surrogate Keys](#surrogate-keys)
   - [Technical / System Columns](#technical--system-columns)
4. [Views & Other Objects](#views--other-objects)
5. [Stored Procedures](#stored-procedures)

---

## General Principles
- **Case & style:** `snake_case` (lowercase with underscores).
- **Language:** English for all identifiers.
- **No reserved words:** Avoid SQL keywords and ambiguous abbreviations.
- **Schemas:** Use layer-aligned schemas: `bronze`, `silver`, `gold`.

---

## Table Naming

### Bronze Rules
Raw landings from source systems. Names mirror the source to preserve lineage.
- Pattern: **`<sourcesystem>_<entity>`**
  - `<sourcesystem>`: e.g., `crm`, `erp`.
  - `<entity>`: exact table/object name from the source.
- Example: `crm_customer_info` → raw CRM customer table.

### Silver Rules
Cleaned, conformed, lightly modeled data. Still traceable to source.
- Pattern: **`<sourcesystem>_<entity>`**
  - Keep the source prefix; normalize column names and datatypes.
- Example: `erp_sales_order_header`.

### Gold Rules
Business/semantic layer with meaningful names.
- Pattern: **`<category>_<entity>`**
  - `<category>`: `dim`, `fact`, `report`.
  - `<entity>`: business-friendly noun (e.g., `customers`, `products`, `sales`).
- Examples:
  - `dim_customers` → customer dimension.
  - `fact_sales` → sales fact table.

#### Glossary of Table Categories

| Pattern   | Meaning            | Example(s)                            |
|-----------|--------------------|---------------------------------------|
| `dim_`    | Dimension table    | `dim_customer`, `dim_product`         |
| `fact_`   | Fact table         | `fact_sales`                          |
| `report_` | Reporting snapshot | `report_sales_monthly`                |

---

## Column Naming

### Surrogate Keys
- Suffix: **`_key`** for surrogate keys in dimensions.
- Pattern: **`<entity>_key`**
  - Example: `customer_key` in `dim_customers`.

### Technical / System Columns
- Prefix: **`dwh_`** for system-managed metadata.
- Pattern: **`dwh_<purpose>`**
  - Examples: `dwh_load_date`, `dwh_batch_id`, `dwh_source`.
- Common business patterns (recommended):
  - Booleans: `is_active`, `is_current`
  - Dates: `*_date` (DATE), timestamps: `*_dt` (DATETIME)
  - Amounts/qty: `*_amount`, `*_qty`

> SCD Type 2 (if used): `effective_from`, `effective_to`, `is_current`.

---

## Views & Other Objects

- **Gold views (semantic):** prefix with `vw_`.
  - Pattern: **`vw_<business_topic>`**
  - Examples: `vw_sales_summary`, `vw_customer_lifetime`.
- **Constraints:**  
  - Primary key: `PK_<table>` → `PK_dim_customers`  
  - Foreign key: `FK_<fromtable>_<col>__<totable>` → `FK_fact_sales_customer_key__dim_customers`  
  - Unique: `UQ_<table>_<col>`; Check: `CK_<table>_<rule>`
- **Indexes:** `IX_<table>_<col>` (include column list if composite).
- **Temp/Staging (transient):** use leading underscore or hash where applicable (e.g., `_stg_sales_daily`, `#tmp_orders`).

---

## Stored Procedures

- Loader procedures follow: **`load_<layer>`**
  - `<layer>` ∈ `bronze`, `silver`, `gold`
  - Examples: `load_bronze`, `load_silver`, `load_gold`
- Optional, more specific loaders:
  - **`load_<layer>_<object>`** → `load_gold_fact_sales`, `load_silver_customers`

> Keep each procedure focused on a single responsibility and name it accordingly. 
