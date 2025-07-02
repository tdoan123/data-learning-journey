# Maven Fuzzy Factory

## Project Description

The **Maven Fuzzy Factory** project is a comprehensive e-commerce analytics case study designed to simulate and evaluate the performance of an online retailer across multiple product lines and marketing channels. Leveraging realistic sample data, the project demonstrates how to build a relational database, extract and transform data using SQL, process results in Excel, and produce insightful reports for stakeholders.

## Analysis Process

1. **Creating the Database**

   - Defined the database schema using DDL scripts.
   - Loaded sample data into tables such as `website_sessions`, `orders`,`order_items` `products`, and `website_pageviews`.
  ![!\[alt text\](image.png)](images/image7.png)

1. **Writing SQL to Extract Data**

   - Wrote SQL queries to calculate key metrics: traffic volume, conversion rates, average order value, and cross-sell performance.
   - Joined and aggregated data from multiple tables to support cohort analyses and period-over-period comparisons.
   ![!\[alt text\](image.png)](images/image8.png)

2. **Processing Data in Excel**

   - Imported raw SQL query outputs into Excel worksheets.
   - Cleaned, normalized, and pivoted the data to prepare for visual analysis.
   - Applied formulas and conditional formatting to highlight trends and outliers.

3. **Creating Reports**

   - Designed a slide deck in PowerPoint and exported as a PDF.
   - Included charts for sales trends, channel performance, product cohort analyses, and cross-sell matrices.
   - Generated individual slide PNGs for easy embedding and sharing.
  ![!\[alt text\](image.png)](images/image1.png)
  ![!\[alt text\](image.png)](images/image2.png)
  ![!\[alt text\](image.png)](images/image3.png)
  ![!\[alt text\](image.png)](images/image4.png)
  ![!\[alt text\](image.png)](images/image5.png)
  ![!\[alt text\](image.png)](images/image6.png)

## Deliverables

- [**SQL File**](./files/maven_fuzzy_factory.sql): All database DDL and extraction queries.
- [**Excel Process Files**](./files/Charts.xlsx): Cleaned datasets, pivot tables, and supporting calculations.
- [**PDF Report**](./files/Maven%20Fuzzy%20Factory%20.pdf): A slide deck summarizing findings.

---

Feel free to explore each component to understand the full analytics workflow from raw data to actionable business insights. If you have any questions or feedback, don’t hesitate to open an issue or reach out!

**Credit** Source: https://mavenanalytics.io/course/advanced-mysql-data-analysis
