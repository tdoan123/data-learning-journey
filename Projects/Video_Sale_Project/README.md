# Video Game Sales Analysis

## Project Overview
This project explores the evolving landscape of the video game industry through data analysis of global sales patterns spanning 35 years (1980-2015). By examining a comprehensive dataset of 16,596 video games with sales exceeding 100,000 copies, I've uncovered significan trends in consumer preferences, market dynamics, and publisher strategies across different regions, genres and platforms.

## The Dataset
The analysis is based on a dataset from [Kaggle](https://www.kaggle.com/datasets/gregorut/videogamesales) containing video game sales data scraped from vgchartz.com. Each entry includes the game's rank, name, platform, release year, genre, publisher, and sales figures across North America, Europe, Japan, other regions, and global totals.

## Data Transformation Process
To extract meaningful insights from the raw data, I implemented the following transformations:

- Used the fuzzywuzzy Python library to match and group game titles into franchise series, enabling analysis of publisher performance at the franchise level [workbook review](Working_paper\string_extract.py)
- Performed comprehensive data cleaning, including unpivoting regional sales columns to create a more analysis-friendly structure
- Consolidated 31 platform categories into three logical groups (Console, PC, and Handheld) to reveal distinct sales patterns across device types
- Removed inconsistent years to ensure data quality throughout the analysis

## What I have learned from the data?

### Market Growth and Decline:
The video game industry experienced an average annual growth rate of 5.9% over the 35-year period, with sales peaking at $678 million in 2008 before entering a decline phase with an 11.1% year-over-year decrease.

### Publisher Concentration
The top 20 publishers generated $7.48 billion, representing 80% of the total $8.73 billion revenue during the period analyzed, demonstrating significant market concentration.

### Genre Evolution
Between 2011 and 2015, four genres dominated the market: Action (28.9%), Role-Playing (19.8%), Shooter (12.3%), and Sports (11.7%), collectively accounting for 72.7% of total revenue.

### Regional Shifts
Early market dominance by Japan and North America gave way to strong European growth after 1996, with sales increasing 31.7% from $278 million (1996-2000) to $635 million (2011-2015), while Japanese sales plateaued.

### Platform Preferences
In Japan specifically, portable consoles surpassed home consoles after 2005, accounting for 57.46% and 63.11% of total revenue in 2005-2010 and 2011-2015 respectively.

### Franchise Performance
Over the full period, Nintendo ($3.76M), Bethesda Softworks ($3.60M), Electronic Arts ($3.43M), and LucasArts ($3.40M) achieved the highest revenue per franchise, highlighting the importance of strong intellectual property.

### Late Market Strategy
In the mature market of 2011-2015, publishers who focused on leveraging established franchises rather than creating new ones achieved higher revenue per franchise, suggesting the increasing value of established IPs as the market saturated.

## Visualization
The analysis is presented through a 4-page Power BI dashboard with cross-filtering capabilities, providing interactive exploration of the data across different dimensions. [Link to access interactive dashboard](https://app.powerbi.com/view?r=eyJrIjoiY2FjOGVlYzktM2IxZC00ODdjLWIzZDEtYjIzZGZkZWI2OGNhIiwidCI6ImYwYWJhNWFlLTA1MzktNGZjMy05NDYxLTYwNzRmYjJmMzE2NCIsImMiOjEwfQ%3D%3D)

![!\[alt text\](image.png)](Images/image.png)

![!\[alt text\](image.png)](Images/image-1.png)

![!\[alt text\](image.png)](Images/image-2.png)

![!\[alt text\](image.png)](Images/image-3.png)
## Future Analysis Directions
- Calculate average performance metrics per franchise to identify the most efficient game production strategies
- Analyze performance trends among mid-tier publishers
- Apply linear regression to understand the relationship between franchise quantity and sales performance

## Technologies Used
- Python (with fuzzywuzzy for string matching)
- Power BI
- DAX
- Data cleaning and transformation techniques

---
