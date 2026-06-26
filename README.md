# 📉 Layoffs Analysis & Dashboard (SQL + EDA + Tableau Dashboard Visualization)

An end-to-end **data cleaning, exploratory data analysis (EDA), and dashboard project** built using SQL and visualization tools to analyze global tech layoffs trends.

This project transforms raw layoffs data into a clean dataset and extracts meaningful insights about companies, industries, countries, and time-based trends.

---

## 📌 Project Overview

This project uses the **Layoffs dataset (Kaggle)** to:

- Clean and standardize raw SQL data
- Remove duplicates and fix inconsistencies
- Handle missing values
- Perform exploratory data analysis (EDA)
- Build insights on global layoffs trends
- Visualize key metrics in a dashboard

---

## 🧹 Data Cleaning (SQL)

Key steps performed:

### 1. Remove Duplicates
- Used `ROW_NUMBER()` with partitioning
- Created staging tables for safe transformations
- Deleted duplicate rows while preserving first occurrence

### 2. Standardize Data
- Trimmed whitespace in company names
- Unified inconsistent industry labels (e.g., Crypto variations → “Crypto”)
- Cleaned country values (removed trailing periods)
- Converted date column from text → DATE format

### 3. Handle Missing Values
- Converted blank strings to NULL
- Imputed missing industries using self-joins on company names
- Retained meaningful NULLs for analysis (e.g., funding, layoffs)

### 4. Remove Unnecessary Data
- Deleted rows where both `total_laid_off` and `percentage_laid_off` were NULL
- Dropped helper columns (e.g., `row_num`)

---

## 📊 Exploratory Data Analysis (SQL)

Key insights extracted:

- 🔻 Maximum single-day layoffs
- 💯 Companies with 100% workforce reduction
- 🏢 Companies with highest total layoffs
- 🌍 Countries with highest layoffs (USA leading)
- 🏭 Industry-wise layoffs distribution
- 📈 Layoffs trend over time (yearly/monthly)
- 🧑‍💼 Company stage analysis (Post-IPO highest layoffs)
- 🏆 Top companies per year using window functions
- 📉 Rolling monthly layoffs trend

---

## 📈 Dashboard Summary

The final dashboard includes:

### 🔑 KPIs
- Companies affected: **1,627**
- Countries affected: **51**
- Total layoffs: **383,659**

---

### 📊 Visualizations

- 🏢 Top companies by layoffs  
  *(Amazon, Google, Meta, Salesforce)*

- 🌍 Global layoffs map (country-wise distribution)

- 📉 Layoffs over time  
  (Monthly & yearly trend line chart)

- 🧩 Industry breakdown  
  (Tree map showing industry concentration — Consumer & Retail leading)

---

## 🛠️ Tech Stack

- **SQL (MySQL)** → Data cleaning + EDA
- **Window Functions** → Ranking & rolling trends
- **CTEs** → Multi-step analysis
- **Tableau / Visualization Tool** → Dashboard creation
- **Kaggle Dataset** → Layoffs dataset

---

## 📌 Key SQL Concepts Used

- Window Functions (`ROW_NUMBER`, `DENSE_RANK`)
- CTEs (Common Table Expressions)
- Data Cleaning with `TRIM`, `UPDATE`, `DELETE`
- Date parsing (`STR_TO_DATE`)
- Aggregations (`SUM`, `MAX`, `GROUP BY`)
- Self-joins for data imputation

---

## 💡 Key Insights

- The **United States** experienced the highest total layoffs (~256K+).
- **Post-IPO companies** had the highest total layoffs across stages.
- Layoffs peaked heavily during specific economic downturn periods.
- A small number of large tech companies contributed to a major portion of total layoffs.

---

## 📁 Dataset

- Source: Kaggle — Layoffs Dataset  
- Link: https://www.kaggle.com/datasets/swaptr/layoffs-2022
