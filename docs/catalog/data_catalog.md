# Data Catalog – Gold Layer

## Overview
The **Gold Layer** serves as the semantic/business layer of the warehouse.  
It is optimized for analytics and reporting, and exposes **dimension tables** and **fact tables** that drive key business metrics.

---

### 1. gold.dim_customers
- **Purpose:** Holds customer master data, enriched with demographic and geographic attributes.  
- **Grain:** One record per unique customer.

| Column Name     | Data Type     | Description                                                                    |
|-----------------|---------------|--------------------------------------------------------------------------------|
| customer_key    | INT           | Surrogate key (primary key) for the customer dimension.                         |
| customer_id     | INT           | Natural/business identifier for the customer.                                  |
| customer_number | NVARCHAR(50)  | External alphanumeric code used for tracking and references.                   |
| first_name      | NVARCHAR(50)  | Customer’s given name.                                                          |
| last_name       | NVARCHAR(50)  | Customer’s surname.                                                             |
| country         | NVARCHAR(50)  | Country of residence (e.g., 'Australia').                                      |
| marital_status  | NVARCHAR(50)  | Marital status (e.g., 'Married', 'Single').                                    |
| gender          | NVARCHAR(50)  | Gender value (e.g., 'Male', 'Female', 'n/a').                                  |
| birthdate       | DATE          | Customer’s date of birth in `YYYY-MM-DD` format.                               |
| create_date     | DATE          | Date when the customer record was first created in the source system.          |

---

### 2. gold.dim_products
- **Purpose:** Provides details for products and their classification attributes.  
- **Grain:** One record per product.

| Column Name         | Data Type     | Description                                                                  |
|---------------------|---------------|------------------------------------------------------------------------------|
| product_key         | INT           | Surrogate key (primary key) for the product dimension.                        |
| product_id          | INT           | Natural identifier for the product.                                          |
| product_number      | NVARCHAR(50)  | Structured alphanumeric product code.                                        |
| product_name        | NVARCHAR(50)  | Descriptive name of the product.                                             |
| category_id         | NVARCHAR(50)  | Identifier linking the product to a category.                                |
| category            | NVARCHAR(50)  | Broad classification (e.g., Bikes, Components).                              |
| subcategory         | NVARCHAR(50)  | More detailed classification within a category.                              |
| maintenance_required| NVARCHAR(50)  | Indicates whether maintenance is required (‘Yes’/‘No’).                      |
| cost                | INT           | Base cost of the product in currency units.                                  |
| product_line        | NVARCHAR(50)  | Product line/series (e.g., Road, Mountain).                                  |
| start_date          | DATE          | Date when the product became available for sale.                             |

---

### 3. gold.fact_sales
- **Purpose:** Stores transactional sales data at the line-item level for reporting and analysis.  
- **Grain:** One record per order line.

| Column Name    | Data Type     | Description                                                                    |
|----------------|---------------|--------------------------------------------------------------------------------|
| order_number   | NVARCHAR(50)  | Unique identifier for the sales order (e.g., 'SO54496').                       |
| product_key    | INT           | Foreign key referencing `dim_products`.                                        |
| customer_key   | INT           | Foreign key referencing `dim_customers`.                                       |
| order_date     | DATE          | Date when the order was placed.                                                |
| shipping_date  | DATE          | Date when the order was shipped.                                               |
| due_date       | DATE          | Date when the order payment was due.                                           |
| sales_amount   | INT           | Monetary amount of the sale for the line item.                                 |
| quantity       | INT           | Quantity of product units ordered.                                             |
| price          | INT           | Price per unit of the product.                                                 |
