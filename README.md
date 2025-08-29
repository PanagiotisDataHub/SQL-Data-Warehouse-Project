# Data Warehouse & Analytics Project

This is my **Data Warehouse & Analytics Project** – built from scratch, step by step.  
It’s not just a technical exercise, but also a project where I explored how raw data can be shaped, structured, and brought to life through careful design and clear analytics.  

---

## 🏗️ Data Architecture

The architecture follows the **Medallion Approach**: 
![Data Architecture](docs/Data_Architecture.png)

1. **Bronze Layer** – The raw landing zone: data ingested directly from CSV files into SQL Server.  
2. **Silver Layer** – Data is cleaned, standardized, and transformed into something consistent and reliable.  
3. **Gold Layer** – Business-ready data, modeled as a **star schema**, built for insights and decision-making.  

---

## 📖 Project Overview

This project includes:  

1. **Data Architecture** – A complete flow from raw ingestion to business-ready data  
2. **ETL Pipelines** – Processes to move and transform data efficiently  
3. **Data Modeling** – Fact and dimension tables supporting analytical queries  
4. **Analytics & Reporting** – SQL queries that reveal customer behavior, product performance, and sales trends  

At its core, the project shows how unstructured data can evolve into something meaningful when approached with the right architecture and discipline.  

---

## 🛠️ Tools & Technologies

- SQL Server Express  
- SQL Server Management Studio (SSMS)  
- Visual Studio Code (development & version control)  
- Draw.io for diagrams  
- GitHub for versioning  
- Notion for documenting steps and decisions  

---

## 📂 Repository Structure
```
data-warehouse-project/
│
├── datasets/ # Source ERP and CRM datasets
│
├── docs/ # Documentation, diagrams, data catalog
│ ├── data_architecture.drawio
│ ├── data_flow.drawio
│ ├── data_models.drawio
│ ├── data_catalog.md
│ ├── naming-conventions.md
│
├── scripts/ # SQL scripts for ETL & transformations
│ ├── bronze/ # Raw ingestion
│ ├── silver/ # Cleaning & standardization
│ ├── gold/ # Star schema & reporting models
│
├── analytics/ # SQL queries, KPIs, and reporting logic
│
├── tests/ # Validation & quality checks
├── README.md # Project overview
└── requirements.txt # Dependencies
```
---

## 🛡️ License  

This project is licensed under the [MIT License](LICENSE).

---

## 🌟 About Me  

My name is **Panagiotis Christias**. I see data projects as a mix of logic and creativity – building pipelines and schemas is a bit like composing music: structure, flow, and harmony matter.  

This repository is one example of that approach: starting simple, layering complexity, and ending with something that feels complete.  
