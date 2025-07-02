# 📊 Telecom Customer Churn Analysis Portfolio

## 🎯 Project Overview

This project demonstrates a complete **end-to-end data analytics pipeline** for telecom customer churn analysis, showcasing skills in database management, ETL processes, data transformation, and business intelligence visualization.

### 🔍 Business Problem
Telecom companies face significant revenue loss due to customer churn. This analysis aims to:
- Identify key factors driving customer churn
- Analyze churn patterns across demographics, geography, and service usage  
- Provide actionable insights to reduce churn rates and improve customer retention

### 📊  Data Observation
6.4k row of customer data with 32 columns presenting customer attributes such as gender, age, married state, contract information, etc. 

### 💡 Key Objectives
- **Demographic Analysis**: Understanding churn patterns by age, gender, and marital status
- **Geographic Analysis**: Identifying high-churn states and regions
- **Service Analysis**: Evaluating impact of different services on customer retention

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **SQL Server** | Data storage and ETL processing |
| **SQL** | Data cleaning, transformation, and analysis |
| **Power BI** | Data visualization and dashboard creation |
| **DAX** | Advanced calculations and measures |

## 📁 Project Structure

```
telecom-churn-analysis/
│
├── data/
│   ├── Customer_Data           # Original CSV datasets
│
├── sql/
│   ├── 01_database_setup.sql   # Database creation scripts
│   ├── 02_data_exploration.sql # EDA queries
│   └── 03_data_cleaning.sql    # ETL process
│
├── powerbi/
│   ├── churn_dashboard.pbix    # Main Power BI file
│   └── data_model.png          # Data model screenshot
│
├── images/
│   ├── dashboard_summary.png   # Dashboard screenshots
│   └── dashboard_details.png
│
└── README.md                   # Project documentation
```

## 🔄 Project Workflow

### **Phase 1: Database Setup & ETL Process**
1. **Database Creation**: Set up SQL Server database for the project
2. **Data Import**: Import raw CSV data into staging tables
3. **Data Exploration**: Comprehensive analysis of data quality and patterns
4. **Data Cleaning**: Handle null values, standardize formats, create production tables

### **Phase 2: Data Transformation (Power BI)**
1. **Calculated Columns**: Created business-relevant groupings (age groups, tenure groups, charge ranges)
2. **Reference Tables**: Built mapping tables for proper sorting and filtering
3. **Data Modeling**: Established relationships between fact and dimension tables
4. **Service Analysis**: Unpivoted service columns for detailed analysis

### **Phase 3: Business Intelligence & Visualization**
1. **KPI Measures**: Developed key metrics using DAX
2. **Interactive Dashboards**: Created comprehensive visualization suite
3. **Drill-down Analysis**: Implemented detailed tooltips and navigation

## 📈 Key Insights & Findings

### **Customer Demographics**
- **Total Customers Analyzed**: 6,418 customers
- **Overall Churn Rate**: 27%
- **New Joiners**: 411 customers

### **High-Risk Segments**
- Month-to-month contract customers show highest churn rates that accounts for 47% while One Year and Two Year contracts are 11% and 3% respectively 
- Customers with fiber optic internet service have elevated churn with 41%
- Long-tenure customers (>= 24 months) are most likely to churn with 28%

### **Geographic Patterns**
- Top 5 states with highest churn rates identified
- Regional variations in service preferences observed

### **Service Impact**
- Premium services correlation with retention rates
- Payment method influence on customer loyalty

## 🎨 Dashboard Features

### **Summary Page**
- **KPI Cards**: Total customers, new joiners, churn count, churn rate, Total revenue from Churn
- **Demographic Insights**: Gender and age group analysis
- **Account Information**: Payment methods, contracts, and tenure analysis
- **Geographic View**: State-wise churn distribution
- **Service Analysis**: Internet type and service usage patterns

### **Interactive Elements**
- **Drill-through Pages**: Detailed churn reason analysis
- **Dynamic Filtering**: Cross-filter functionality across all visuals
- **Tooltips**: Additional context on hover for enhanced insights

## 💻 Technical Implementation

### **SQL Highlights**
```sql
-- Example: Churn rate by demographic segment
SELECT
    Gender,
    COUNT(Customer_ID) as TotalCount,
    ROUND(COUNT(Customer_ID) * 100.0 / (SELECT COUNT(*) FROM Customer_Data), 2) as Percentage
FROM Customer_Data
GROUP BY Gender
```

### **DAX Measures**
```dax
Total Customers = COUNT(prod_Churn[Customer_ID])
Churn Rate = DIVIDE([Total Churn], [Total Customers], 0)
New Joiners = CALCULATE(COUNT(prod_Churn[Customer_ID]), prod_Churn[Customer_Status] = "Joined")
```

## 🚀 Business Recommendations

Based on the analysis, key recommendations include:

1. **Contract Strategy**: Focus on converting month-to-month customers to longer-term contracts
2. **Service Optimization**: Investigate fiber optic service quality issues
3. **Early Intervention**: Implement retention programs for new customers (< 6 months)
4. **Geographic Focus**: Deploy targeted retention campaigns in high-churn states
5. **Payment Experience**: Improve payment processes for high-churn payment methods

## 📊 Data Quality & Methodology

- **Null Value Handling**: Systematic approach to missing data using business logic
- **Data Validation**: Comprehensive checks for data integrity and consistency
- **Standardization**: Consistent formatting and categorization across all fields

## 🔍 Skills Demonstrated

### **Technical Skills**
- **SQL**: Advanced querying, window functions, CTEs, stored procedures
- **ETL Development**: Complete extract-transform-load pipeline design
- **Data Modeling**: Star schema implementation, relationship management
- **DAX**: Complex measures, time intelligence, calculated columns
- **Power BI**: Advanced visualization techniques, user experience design

### **Analytical Skills**
- **Exploratory Data Analysis**: Statistical profiling and pattern recognition
- **Business Intelligence**: KPI development and metric definition
- **Data Storytelling**: Clear communication of insights through visualization
- **Problem Solving**: End-to-end solution architecture

## 🔗 Project Links

- **Live Dashboard**: [View Telecom Churn Dashboard](https://app.powerbi.com/view?r=eyJrIjoiZDllMjFlZWYtNGJmNS00MTY4LThjYzQtYTY1NzFkMjAzNTI1IiwidCI6ImYwYWJhNWFlLTA1MzktNGZjMy05NDYxLTYwNzRmYjJmMzE2NCIsImMiOjEwfQ%3D%3D)
![alt text](.images/image.png)

## 🙏 Credit
Dataset and tutorial guide courtesy of [Pivotal Stats](https://www.youtube.com/watch?v=QFDslca5AX8&t=3944s)


