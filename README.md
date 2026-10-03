# 🛒 SQL E-Commerce Data Cleaning & Analysis

A comprehensive, end-to-end data cleaning and auditing project using **T-SQL (SQL Server)** to transform a massive, uncleaned e-commerce dataset into a reliable, analytics-ready format.

---

## 📌 Project Overview
E-commerce data at scale (exceeding 500,000 rows)[cite: 10] frequently contains structural anomalies, missing values, formatting inconsistencies, and invalid records. This project focuses on auditing, cleaning, and validating the dataset using advanced T-SQL queries to ensure high data integrity before business reporting and analysis. 

*(Note: Due to GitHub file size limits, the repository includes a representative sample file containing 500 rows (`sales_sample.csv` / `E-Commerce Data.xlsx`)*[cite: 10].

---

## 🔍 Key Data Cleaning & Auditing Steps (T-SQL Implementation)

1. **Database Setup & Record Count Auditing:**
   - Initialized the environment, imported raw data tables, and executed baseline record-count checks to establish baseline data volumes.

2. **Handling Missing & Null Values:**
   - Identified and managed missing values across critical transactional attributes (such as customer IDs, product details, quantities, and pricing fields) to prevent analytical bias.

3. **Standardizing Data Types & Formats:**
   - Converted string-based dates, numeric fields, and categorical columns into proper SQL data types (`DATE`, `INT`, `FLOAT`) after cleaning underlying anomalies and textual errors.

4. **Cleaning Anomalies & Outliers:**
   - Checked for logical inconsistencies (e.g., negative quantities, invalid unit prices, or duplicate transaction logs) and standardized data patterns.

5. **Data Quality Validation:**
   - Executed final post-cleaning validation queries to verify that all constraints are met and the data is fully ready for business intelligence tools.

---

## 🛠️ Technologies Used
- **SQL Server (T-SQL):** Advanced querying, constraints alteration, schema cleaning, and data integrity checks.
- **Git & GitHub:** Version control, large dataset management via samples, and professional documentation.

---

## 🚀 How to Use
1. Clone or download this repository.
2. Import the sample dataset (`E-Commerce Data.xlsx` or your full dataset) into your SQL Server database.
3. Run the `Ecommerce_Data_Cleaning_And_Auditing.sql` script step-by-step to execute the entire data cleaning pipeline.
