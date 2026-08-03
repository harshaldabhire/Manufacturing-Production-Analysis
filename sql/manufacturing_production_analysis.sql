/*====================================================================================================
                              MANUFACTURING PRODUCTION ANALYSIS
======================================================================================================

SECTION 1 : PROJECT INTRODUCTION

Previous Stage:
The dataset used in this project (`manufacturing_cleaned.csv`) was prepared during the Python phase, where the following tasks were completed:

• Exploratory Data Analysis (EDA)
• Data Quality Assessment
• Data Cleaning
• Feature Engineering
• Data Validation
• Export of the cleaned dataset

This SQL project focuses exclusively on business analysis using the cleaned dataset.

Business Domain:
Manufacturing / Steel Production

Project Overview:
This project analyzes manufacturing production data using SQL to evaluate production
performance, operational efficiency, downtime, scrap generation, machine utilization,
production line performance, operator performance, shift performance, product performance,
and time-based production trends.

Business Objective:
Transform the cleaned manufacturing dataset into meaningful business insights using SQL.
The analysis focuses on answering business questions, calculating KPIs, identifying
performance trends, and supporting data-driven decision making.

Project Scope:
This project demonstrates SQL querying techniques, filtering, aggregations, KPI analysis,
GROUP BY analysis, HAVING, window functions, Common Table Expressions (CTEs), views,
and business insights. Data cleaning and preprocessing were completed during the Python stage.

Dataset:
manufacturing_cleaned.csv

Database:
manufacturing_analysis

Table:
manufacturing_production

SQL Dialect:
MySQL

Project Workflow:

Raw Dataset
    │
    ▼
Python
(Data Preparation)
    │
    ▼
manufacturing_cleaned.csv
    │
    ▼
MySQL
(Business Analysis)
    │
    ▼
Microsoft Excel
(Business Reporting)
    │
    ▼
Power BI
(Interactive Dashboard)

====================================================================================================*/


/*====================================================================================================
                                  SECTION 2 : DATABASE SETUP
======================================================================================================

Purpose:
Create the project database and table for storing the cleaned manufacturing production data.

Note:
The dataset has already been cleaned, validated, and feature-engineered during the Python
stage. Import the exported 'manufacturing_cleaned.csv' file into the
'manufacturing_production' table using MySQL Workbench before continuing with the SQL
analysis.

====================================================================================================*/
-- Create Database
CREATE DATABASE IF NOT EXISTS manufacturing_analysis;

-- Select Database
USE manufacturing_analysis;

-- Create Table
CREATE TABLE IF NOT EXISTS manufacturing_production (

    Production_ID         VARCHAR(20) PRIMARY KEY,
    Date                  DATE,
    Production_Line       VARCHAR(20),
    Shift                 VARCHAR(20),
    Machine_ID            VARCHAR(20),
    Operator_ID           VARCHAR(20),
    Product               VARCHAR(50),

    Planned_Qty           INT,
    Produced_Qty          INT,
    Scrap_Qty             INT,
    Downtime_Minutes      INT,

    Downtime_Reason       VARCHAR(50),

    Efficiency_Percent    DECIMAL(5,2),
    Scrap_Rate_Percent    DECIMAL(5,2),

    Good_Qty              INT,
    Production_Loss       INT,
    Downtime_Hours        DECIMAL(6,2),

    Month                 VARCHAR(20),
    Quarter               INT,
    Week                  INT,
    Day_Name              VARCHAR(20),

    Efficiency_Category   VARCHAR(20)

);


/*====================================================================================================
                                        SECTION 3 : DATA VERIFICATION
======================================================================================================

Purpose:
Verify that the manufacturing dataset has been successfully imported into MySQL before
starting the business analysis.

The verification includes:

• Total Records
• Total Columns
• Data Preview
• Data Types
• Import Validation

====================================================================================================*/

-- 1. Verify Active Database

SELECT DATABASE();


-- 2. Verify Available Tables

SHOW TABLES;


-- 3. Verify Total Records

SELECT COUNT(*) AS Total_Records
FROM manufacturing_production;


-- 4. Preview the Dataset

SELECT *
FROM manufacturing_production
LIMIT 10;


-- 5. Verify Table Structure and Data Types

DESCRIBE manufacturing_production;


/*====================================================================================================
                                        SECTION 4 : SQL FUNDAMENTALS
====================================================================================================*/

-- 1. Display all columns and records
SELECT *
FROM manufacturing_production;

-- 2. Display specific columns
SELECT Production_ID,
       Date,
       Product,
       Produced_Qty
FROM manufacturing_production;

-- 3. Display unique production lines
SELECT DISTINCT Production_Line
FROM manufacturing_production;

-- 4. Display unique shifts
SELECT DISTINCT Shift
FROM manufacturing_production;

-- 5. Display first 10 records
SELECT *
FROM manufacturing_production
LIMIT 10;

-- 6. Sort by Produced Quantity (Highest First)
SELECT Production_ID,
       Product,
       Produced_Qty
FROM manufacturing_production
ORDER BY Produced_Qty DESC;

-- 7. Sort by Date (Oldest First)
SELECT Production_ID,
       Date,
       Product
FROM manufacturing_production
ORDER BY Date ASC;

-- 8. Use Column Aliases
SELECT Production_ID AS ProductionID,
       Produced_Qty AS ProducedQuantity,
       Good_Qty AS GoodQuantity
FROM manufacturing_production;

-- 9. Calculated Columns (Expressions)
SELECT Production_ID,
       Produced_Qty - Scrap_Qty AS Net_Production
FROM manufacturing_production;


/*====================================================================================================
                                        SECTION 5 : FILTERING DATA
====================================================================================================*/

-- 1. WHERE
SELECT *
FROM manufacturing_production
WHERE Shift = 'Morning';

-- 2. AND
SELECT *
FROM manufacturing_production
WHERE Shift = 'Morning'
AND Efficiency_Percent > 95;

-- 3. OR
SELECT *
FROM manufacturing_production
WHERE Shift = 'Morning'
OR Shift = 'Night';

-- 4. NOT
SELECT *
FROM manufacturing_production
WHERE NOT Shift = 'Evening';

-- 5. IN
SELECT *
FROM manufacturing_production
WHERE Production_Line IN ('Line A', 'Line B');

-- 6. BETWEEN
SELECT *
FROM manufacturing_production
WHERE Efficiency_Percent BETWEEN 95 AND 99;

-- 7. LIKE (Products starting with Steel)
SELECT *
FROM manufacturing_production
WHERE Product LIKE 'Steel%';

-- 8. IS NULL
SELECT *
FROM manufacturing_production
WHERE Operator_ID IS NULL;

-- 9. IS NOT NULL
SELECT *
FROM manufacturing_production
WHERE Operator_ID IS NOT NULL;

-- 10. Combined Filter
SELECT Production_ID,
       Product,
       Shift,
       Produced_Qty,
       Efficiency_Percent
FROM manufacturing_production
WHERE Shift = 'Morning'
AND Produced_Qty > 1500
ORDER BY Efficiency_Percent DESC;


/*====================================================================================================
                                    SECTION 6 : AGGREGATE FUNCTIONS
====================================================================================================

Purpose:
Use aggregate functions to summarize manufacturing production data and calculate
overall business metrics.

====================================================================================================*/

-- 1. Total Production Records

SELECT COUNT(*) AS Total_Records
FROM manufacturing_production;


-- Expected Output:
-- Displays the total number of production records.


-- 2. Total Planned Production

SELECT SUM(Planned_Qty) AS Total_Planned_Qty
FROM manufacturing_production;


-- Expected Output:
-- Displays the total planned production quantity.


-- 3. Total Produced Quantity

SELECT SUM(Produced_Qty) AS Total_Produced_Qty
FROM manufacturing_production;


-- Expected Output:
-- Displays the total produced quantity.


-- 4. Average Production Efficiency

SELECT ROUND(AVG(Efficiency_Percent),2) AS Average_Efficiency
FROM manufacturing_production;


-- Expected Output:
-- Displays the average production efficiency.


-- 5. Minimum Produced Quantity

SELECT MIN(Produced_Qty) AS Minimum_Produced_Qty
FROM manufacturing_production;


-- Expected Output:
-- Displays the minimum production quantity.


-- 6. Maximum Produced Quantity

SELECT MAX(Produced_Qty) AS Maximum_Produced_Qty
FROM manufacturing_production;


-- Expected Output:
-- Displays the maximum production quantity.


-- 7. Average Scrap Rate

SELECT ROUND(AVG(Scrap_Rate_Percent),2) AS Average_Scrap_Rate
FROM manufacturing_production;


-- Expected Output:
-- Displays the average scrap rate.


/*====================================================================================================
                                    SECTION 7 : GROUP BY ANALYSIS
======================================================================================================

Purpose:
Analyze manufacturing performance by grouping data into meaningful business categories.

====================================================================================================*/

-- 1. Production Line Analysis

SELECT Production_Line,
       COUNT(*) AS Total_Records
FROM manufacturing_production
GROUP BY Production_Line;

-- Expected Output:
-- Displays the number of production records for each production line.


-- 2. Shift Analysis

SELECT Shift,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Shift;

-- Expected Output:
-- Displays total production for each shift.


-- 3. Machine Analysis

SELECT Machine_ID,
       ROUND(AVG(Efficiency_Percent),2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Machine_ID;

-- Expected Output:
-- Displays average efficiency for each machine.


-- 4. Operator Analysis

SELECT Operator_ID,
       SUM(Good_Qty) AS Total_Good_Qty
FROM manufacturing_production
GROUP BY Operator_ID;

-- Expected Output:
-- Displays total good quantity produced by each operator.


-- 5. Product Analysis

SELECT Product,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Product;

-- Expected Output:
-- Displays total production for each product.


-- 6. Monthly Analysis

SELECT Month,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Month;

-- Expected Output:
-- Displays total production for each month.


-- 7. Downtime Reason Analysis

SELECT Downtime_Reason,
       SUM(Downtime_Minutes) AS Total_Downtime
FROM manufacturing_production
GROUP BY Downtime_Reason;

-- Expected Output:
-- Displays total downtime for each downtime reason.


/*====================================================================================================
                                    SECTION 8 : HAVING ANALYSIS
======================================================================================================

Purpose:
Filter grouped data using the HAVING clause to identify meaningful business insights.

====================================================================================================*/

-- 1. Production Lines with Total Production Greater Than 5,000,000

SELECT Production_Line,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Production_Line
HAVING SUM(Produced_Qty) > 5000000;

-- Expected Output:
-- Displays production lines with total production above 5,000,000.


-- 2. Machines with Average Efficiency Greater Than 95%

SELECT Machine_ID,
       ROUND(AVG(Efficiency_Percent), 2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Machine_ID
HAVING AVG(Efficiency_Percent) > 95;

-- Expected Output:
-- Displays machines whose average efficiency exceeds 95%.


-- 3. Products with Total Scrap Greater Than 20,000

SELECT Product,
       SUM(Scrap_Qty) AS Total_Scrap
FROM manufacturing_production
GROUP BY Product
HAVING SUM(Scrap_Qty) > 20000;

-- Expected Output:
-- Displays products generating more than 20,000 scrap quantity.


-- 4. Operators with Total Good Quantity Greater Than 300,000

SELECT Operator_ID,
       SUM(Good_Qty) AS Total_Good_Qty
FROM manufacturing_production
GROUP BY Operator_ID
HAVING SUM(Good_Qty) > 300000;

-- Expected Output:
-- Displays operators producing more than 300,000 good units.


-- 5. Downtime Reasons with Total Downtime Greater Than 20,000 Minutes

SELECT Downtime_Reason,
       SUM(Downtime_Minutes) AS Total_Downtime
FROM manufacturing_production
GROUP BY Downtime_Reason
HAVING SUM(Downtime_Minutes) > 20000;

-- Expected Output:
-- Displays downtime reasons with more than 20,000 total downtime minutes.

-- 6. Combined Business Filtering

SELECT Production_Line,
       SUM(Produced_Qty) AS Total_Production,
       ROUND(AVG(Efficiency_Percent), 2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Production_Line
HAVING SUM(Produced_Qty) > 4000000
   AND AVG(Efficiency_Percent) > 92;

-- Expected Output:
-- Displays production lines that satisfy multiple business performance conditions.


/*====================================================================================================
                                SECTION 9 : PRODUCTION KPI ANALYSIS
======================================================================================================

Purpose:
Calculate key manufacturing KPIs to evaluate overall production performance.

====================================================================================================*/

-- 1. Total Planned Production

SELECT SUM(Planned_Qty) AS Total_Planned_Production
FROM manufacturing_production;

-- Expected Output:
-- Returns the total planned production quantity.


-- 2. Total Produced Quantity

SELECT SUM(Produced_Qty) AS Total_Produced_Quantity
FROM manufacturing_production;

-- Expected Output:
-- Returns the total produced quantity.


-- 3. Total Good Quantity

SELECT SUM(Good_Qty) AS Total_Good_Quantity
FROM manufacturing_production;

-- Expected Output:
-- Returns the total good quantity produced.


-- 4. Total Scrap Quantity

SELECT SUM(Scrap_Qty) AS Total_Scrap_Quantity
FROM manufacturing_production;

-- Expected Output:
-- Returns the total scrap quantity.


-- 5. Total Production Loss

SELECT SUM(Production_Loss) AS Total_Production_Loss
FROM manufacturing_production;

-- Expected Output:
-- Returns the total production loss.


-- 6. Average Production Efficiency

SELECT ROUND(AVG(Efficiency_Percent),2) AS Average_Efficiency
FROM manufacturing_production;

-- Expected Output:
-- Returns the average production efficiency.


-- 7. Average Scrap Rate

SELECT ROUND(AVG(Scrap_Rate_Percent),2) AS Average_Scrap_Rate
FROM manufacturing_production;

-- Expected Output:
-- Returns the average scrap rate.


-- 8. Average Downtime

SELECT ROUND(AVG(Downtime_Minutes),2) AS Average_Downtime_Minutes
FROM manufacturing_production;

-- Expected Output:
-- Returns the average downtime in minutes.


-- 9. Overall KPI Summary

SELECT
    SUM(Planned_Qty) AS Total_Planned_Production,
    SUM(Produced_Qty) AS Total_Produced_Quantity,
    SUM(Good_Qty) AS Total_Good_Quantity,
    SUM(Scrap_Qty) AS Total_Scrap_Quantity,
    SUM(Production_Loss) AS Total_Production_Loss,
    ROUND(AVG(Efficiency_Percent),2) AS Average_Efficiency,
    ROUND(AVG(Scrap_Rate_Percent),2) AS Average_Scrap_Rate,
    ROUND(AVG(Downtime_Minutes),2) AS Average_Downtime_Minutes
FROM manufacturing_production;

-- Expected Output:
-- Returns a single-row KPI dashboard summarizing overall manufacturing performance.


/*====================================================================================================
                              SECTION 10 : PRODUCTION LINE ANALYSIS
======================================================================================================

Purpose:
Analyze the performance of each production line using key manufacturing metrics.

====================================================================================================*/

-- 1. Total Production by Production Line

SELECT Production_Line,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Production_Line
ORDER BY Total_Production DESC;

-- Expected Output:
-- Displays total production for each production line.


-- 2. Total Good Quantity by Production Line

SELECT Production_Line,
       SUM(Good_Qty) AS Total_Good_Quantity
FROM manufacturing_production
GROUP BY Production_Line
ORDER BY Total_Good_Quantity DESC;

-- Expected Output:
-- Displays total good quantity for each production line.


-- 3. Total Scrap Quantity by Production Line

SELECT Production_Line,
       SUM(Scrap_Qty) AS Total_Scrap_Quantity
FROM manufacturing_production
GROUP BY Production_Line
ORDER BY Total_Scrap_Quantity DESC;

-- Expected Output:
-- Displays total scrap quantity for each production line.


-- 4. Total Production Loss by Production Line

SELECT Production_Line,
       SUM(Production_Loss) AS Total_Production_Loss
FROM manufacturing_production
GROUP BY Production_Line
ORDER BY Total_Production_Loss DESC;

-- Expected Output:
-- Displays production loss for each production line.


-- 5. Total Downtime by Production Line

SELECT Production_Line,
       SUM(Downtime_Minutes) AS Total_Downtime_Minutes
FROM manufacturing_production
GROUP BY Production_Line
ORDER BY Total_Downtime_Minutes DESC;

-- Expected Output:
-- Displays total downtime for each production line.


-- 6. Average Efficiency by Production Line

SELECT Production_Line,
       ROUND(AVG(Efficiency_Percent),2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Production_Line
ORDER BY Average_Efficiency DESC;

-- Expected Output:
-- Displays average efficiency for each production line.


-- 7. Production Line Ranking

SELECT Production_Line,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Production_Line
ORDER BY Total_Production DESC;

-- Expected Output:
-- Ranks production lines based on total production.


-- 8. Best Performing Production Line

SELECT Production_Line,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Production_Line
ORDER BY Total_Production DESC
LIMIT 1;

-- Expected Output:
-- Displays the best performing production line.


-- 9. Lowest Performing Production Line

SELECT Production_Line,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Production_Line
ORDER BY Total_Production ASC
LIMIT 1;

-- Expected Output:
-- Displays the lowest performing production line.


/*====================================================================================================
                                        SECTION 11 : SHIFT ANALYSIS
======================================================================================================

Purpose:
Analyze production performance across different manufacturing shifts.

====================================================================================================*/

-- 1. Total Production by Shift

SELECT Shift,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Shift
ORDER BY Total_Production DESC;

-- Expected Output:
-- Displays total production for each shift.


-- 2. Average Efficiency by Shift

SELECT Shift,
       ROUND(AVG(Efficiency_Percent), 2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Shift
ORDER BY Average_Efficiency DESC;

-- Expected Output:
-- Displays average efficiency for each shift.


-- 3. Total Scrap Quantity by Shift

SELECT Shift,
       SUM(Scrap_Qty) AS Total_Scrap_Quantity
FROM manufacturing_production
GROUP BY Shift
ORDER BY Total_Scrap_Quantity DESC;

-- Expected Output:
-- Displays total scrap quantity for each shift.


-- 4. Total Downtime by Shift

SELECT Shift,
       SUM(Downtime_Minutes) AS Total_Downtime_Minutes
FROM manufacturing_production
GROUP BY Shift
ORDER BY Total_Downtime_Minutes DESC;

-- Expected Output:
-- Displays total downtime for each shift.


-- 5. Best Performing Shift

SELECT Shift,
       ROUND(AVG(Efficiency_Percent), 2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Shift
ORDER BY Average_Efficiency DESC
LIMIT 1;

-- Expected Output:
-- Displays the shift with the highest average efficiency.


-- 6. Lowest Performing Shift

SELECT Shift,
       ROUND(AVG(Efficiency_Percent), 2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Shift
ORDER BY Average_Efficiency ASC
LIMIT 1;

-- Expected Output:
-- Displays the shift with the lowest average efficiency.


/*====================================================================================================
                                        SECTION 12 : PRODUCT ANALYSIS
======================================================================================================

Purpose:
Analyze the production performance of each product using key manufacturing metrics.

====================================================================================================*/

-- 1. Total Production by Product

SELECT Product,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Product
ORDER BY Total_Production DESC;

-- Expected Output:
-- Displays total production for each product.


-- 2. Average Efficiency by Product

SELECT Product,
       ROUND(AVG(Efficiency_Percent), 2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Product
ORDER BY Average_Efficiency DESC;

-- Expected Output:
-- Displays average production efficiency for each product.


-- 3. Total Scrap Quantity by Product

SELECT Product,
       SUM(Scrap_Qty) AS Total_Scrap_Quantity
FROM manufacturing_production
GROUP BY Product
ORDER BY Total_Scrap_Quantity DESC;

-- Expected Output:
-- Displays total scrap quantity for each product.


-- 4. Total Production Loss by Product

SELECT Product,
       SUM(Production_Loss) AS Total_Production_Loss
FROM manufacturing_production
GROUP BY Product
ORDER BY Total_Production_Loss DESC;

-- Expected Output:
-- Displays total production loss for each product.


-- 5. Top Performing Product

SELECT Product,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Product
ORDER BY Total_Production DESC
LIMIT 1;

-- Expected Output:
-- Displays the highest performing product.


-- 6. Lowest Performing Product

SELECT Product,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Product
ORDER BY Total_Production ASC
LIMIT 1;

-- Expected Output:
-- Displays the lowest performing product.


/*====================================================================================================
                                      SECTION 13 : MACHINE ANALYSIS
======================================================================================================

Purpose:
Analyze machine performance using key manufacturing metrics.

====================================================================================================*/

-- 1. Total Production by Machine

SELECT Machine_ID,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Machine_ID
ORDER BY Total_Production DESC;

-- Expected Output:
-- Displays total production for each machine.


-- 2. Average Efficiency by Machine

SELECT Machine_ID,
       ROUND(AVG(Efficiency_Percent), 2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Machine_ID
ORDER BY Average_Efficiency DESC;

-- Expected Output:
-- Displays average efficiency for each machine.


-- 3. Total Downtime by Machine

SELECT Machine_ID,
       SUM(Downtime_Minutes) AS Total_Downtime_Minutes
FROM manufacturing_production
GROUP BY Machine_ID
ORDER BY Total_Downtime_Minutes DESC;

-- Expected Output:
-- Displays total downtime for each machine.


-- 4. Total Scrap Quantity by Machine

SELECT Machine_ID,
       SUM(Scrap_Qty) AS Total_Scrap_Quantity
FROM manufacturing_production
GROUP BY Machine_ID
ORDER BY Total_Scrap_Quantity DESC;

-- Expected Output:
-- Displays total scrap quantity for each machine.


-- 5. Machine Ranking by Total Production

SELECT Machine_ID,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Machine_ID
ORDER BY Total_Production DESC;

-- Expected Output:
-- Ranks all machines based on total production in descending order.


-- 6. Best Performing Machine

SELECT Machine_ID,
       ROUND(AVG(Efficiency_Percent), 2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Machine_ID
ORDER BY Average_Efficiency DESC
LIMIT 1;

-- Expected Output:
-- Displays the machine with the highest average efficiency.


-- 7. Lowest Performing Machine

SELECT Machine_ID,
       ROUND(AVG(Efficiency_Percent), 2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Machine_ID
ORDER BY Average_Efficiency ASC
LIMIT 1;

-- Expected Output:
-- Displays the machine with the lowest average efficiency.


/*====================================================================================================
                                      SECTION 14 : OPERATOR ANALYSIS
======================================================================================================

Purpose:
Analyze operator performance using key manufacturing metrics.

====================================================================================================*/

-- 1. Operator Production

SELECT Operator_ID,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Operator_ID
ORDER BY Total_Production DESC;

-- Expected Output:
-- Displays total production for each operator.


-- 2. Operator Efficiency

SELECT Operator_ID,
       ROUND(AVG(Efficiency_Percent), 2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Operator_ID
ORDER BY Average_Efficiency DESC;

-- Expected Output:
-- Displays average efficiency for each operator.


-- 3. Operator Scrap

SELECT Operator_ID,
       SUM(Scrap_Qty) AS Total_Scrap_Quantity
FROM manufacturing_production
GROUP BY Operator_ID
ORDER BY Total_Scrap_Quantity DESC;

-- Expected Output:
-- Displays total scrap quantity for each operator.


-- 4. Operator Production Loss

SELECT Operator_ID,
       SUM(Production_Loss) AS Total_Production_Loss
FROM manufacturing_production
GROUP BY Operator_ID
ORDER BY Total_Production_Loss DESC;

-- Expected Output:
-- Displays total production loss for each operator.


-- 5. Operator Ranking by Total Production

SELECT Operator_ID,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Operator_ID
ORDER BY Total_Production DESC;

-- Expected Output:
-- Ranks all operators based on total production in descending order.


-- 6. Top Performing Operator

SELECT Operator_ID,
       ROUND(AVG(Efficiency_Percent), 2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Operator_ID
ORDER BY Average_Efficiency DESC
LIMIT 1;

-- Expected Output:
-- Displays the top performing operator based on average efficiency.


-- 7. Lowest Performing Operator

SELECT Operator_ID,
       ROUND(AVG(Efficiency_Percent), 2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Operator_ID
ORDER BY Average_Efficiency ASC
LIMIT 1;

-- Expected Output:
-- Displays the lowest performing operator based on average efficiency.


/*====================================================================================================
                                     SECTION 15 : DOWNTIME ANALYSIS
======================================================================================================

Purpose:
Analyze downtime across reasons, production lines, machines, and time to identify
major operational losses.

====================================================================================================*/

-- 1. Downtime by Reason

SELECT Downtime_Reason,
       SUM(Downtime_Minutes) AS Total_Downtime_Minutes
FROM manufacturing_production
GROUP BY Downtime_Reason
ORDER BY Total_Downtime_Minutes DESC;

-- Expected Output:
-- Displays total downtime for each downtime reason.


-- 2. Downtime by Production Line

SELECT Production_Line,
       SUM(Downtime_Minutes) AS Total_Downtime_Minutes
FROM manufacturing_production
GROUP BY Production_Line
ORDER BY Total_Downtime_Minutes DESC;

-- Expected Output:
-- Displays total downtime for each production line.


-- 3. Downtime by Machine

SELECT Machine_ID,
       SUM(Downtime_Minutes) AS Total_Downtime_Minutes
FROM manufacturing_production
GROUP BY Machine_ID
ORDER BY Total_Downtime_Minutes DESC;

-- Expected Output:
-- Displays total downtime for each machine.


-- 4. Monthly Downtime

SELECT Month,
       SUM(Downtime_Minutes) AS Total_Downtime_Minutes
FROM manufacturing_production
GROUP BY Month
ORDER BY MIN(Date);

-- Expected Output:
-- Displays monthly downtime in chronological order.


-- 5. Downtime Trend

SELECT Date,
       SUM(Downtime_Minutes) AS Total_Downtime_Minutes
FROM manufacturing_production
GROUP BY Date
ORDER BY Date;

-- Expected Output:
-- Displays the daily downtime trend over time.


/*====================================================================================================
                                        SECTION 16 : TIME ANALYSIS
======================================================================================================

Purpose:
Analyze production performance across different time periods to identify trends and
seasonal patterns.

====================================================================================================*/

-- 1. Monthly Production

SELECT Month,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Month
ORDER BY MIN(Date);

-- Expected Output:
-- Displays total production for each month in chronological order.


-- 2. Quarterly Production

SELECT Quarter,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Quarter
ORDER BY Quarter;

-- Expected Output:
-- Displays total production for each quarter.


-- 3. Weekly Production

SELECT Week,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Week
ORDER BY Week;

-- Expected Output:
-- Displays total production for each week.


-- 4. Day-wise Production

SELECT Day_Name,
       SUM(Produced_Qty) AS Total_Production
FROM manufacturing_production
GROUP BY Day_Name
ORDER BY FIELD(Day_Name,
               'Monday',
               'Tuesday',
               'Wednesday',
               'Thursday',
               'Friday',
               'Saturday',
               'Sunday');

-- Expected Output:
-- Displays total production for each day of the week.


-- 5. Monthly Efficiency

SELECT Month,
       ROUND(AVG(Efficiency_Percent), 2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Month
ORDER BY MIN(Date);

-- Expected Output:
-- Displays average production efficiency by month.


-- 6. Monthly Scrap

SELECT Month,
       SUM(Scrap_Qty) AS Total_Scrap_Quantity
FROM manufacturing_production
GROUP BY Month
ORDER BY MIN(Date);

-- Expected Output:
-- Displays total scrap quantity by month.


-- 7. Monthly Downtime

SELECT Month,
       SUM(Downtime_Minutes) AS Total_Downtime_Minutes
FROM manufacturing_production
GROUP BY Month
ORDER BY MIN(Date);

-- Expected Output:
-- Displays total downtime by month.


/*====================================================================================================
                                    SECTION 17 : WINDOW FUNCTIONS
======================================================================================================

Purpose:
Use SQL Window Functions to perform advanced analytical calculations without
grouping the dataset.

====================================================================================================*/

-- 1. ROW_NUMBER()

SELECT Production_ID,
       Production_Line,
       Produced_Qty,
       ROW_NUMBER() OVER (ORDER BY Produced_Qty DESC) AS `Row_Number`
FROM manufacturing_production;

-- Expected Output:
-- Assigns a unique sequential number to each record based on produced quantity.


-- 2. RANK()

SELECT Production_ID,
       Production_Line,
       Produced_Qty,
       RANK() OVER (ORDER BY Produced_Qty DESC) AS Production_Rank
FROM manufacturing_production;

-- Expected Output:
-- Assigns ranks based on produced quantity with gaps for ties.


-- 3. DENSE_RANK()

SELECT Production_ID,
       Production_Line,
       Produced_Qty,
       DENSE_RANK() OVER (ORDER BY Produced_Qty DESC) AS `Dense_Rank`
FROM manufacturing_production;

-- Expected Output:
-- Assigns consecutive ranks without gaps.


-- 4. NTILE()

SELECT Production_ID,
       Produced_Qty,
       NTILE(4) OVER (ORDER BY Produced_Qty DESC) AS Production_Quartile
FROM manufacturing_production;

-- Expected Output:
-- Divides production records into four equal groups.


-- 5. LAG()

SELECT Date,
       Produced_Qty,
       LAG(Produced_Qty) OVER (ORDER BY Date) AS Previous_Production
FROM manufacturing_production;

-- Expected Output:
-- Displays the previous record's production quantity.


-- 6. LEAD()

SELECT Date,
       Produced_Qty,
       LEAD(Produced_Qty) OVER (ORDER BY Date) AS Next_Production
FROM manufacturing_production;

-- Expected Output:
-- Displays the next record's production quantity.


-- 7. Running Total

SELECT Date,
       Produced_Qty,
       SUM(Produced_Qty) OVER (
           ORDER BY Date
       ) AS Running_Total
FROM manufacturing_production;

-- Expected Output:
-- Displays the cumulative production quantity over time.


-- 8. Running Average

SELECT Date,
       Produced_Qty,
       ROUND(
           AVG(Produced_Qty) OVER (
               ORDER BY Date
           ), 2
       ) AS Running_Average
FROM manufacturing_production;

-- Expected Output:
-- Displays the cumulative average production quantity.


-- 9. Moving Average

SELECT Date,
       Produced_Qty,
       ROUND(
           AVG(Produced_Qty) OVER (
               ORDER BY Date
               ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
           ), 2
       ) AS Moving_Average
FROM manufacturing_production;

-- Expected Output:
-- Displays the 3-record moving average of production quantity.


/*====================================================================================================
                             SECTION 18 : COMMON TABLE EXPRESSIONS (CTEs)
======================================================================================================

Purpose:
Use Common Table Expressions (CTEs) to simplify complex queries and improve readability.

====================================================================================================*/

-- 1. Single CTE

WITH Production_Summary AS
(
    SELECT Production_Line,
           SUM(Produced_Qty) AS Total_Production
    FROM manufacturing_production
    GROUP BY Production_Line
)

SELECT *
FROM Production_Summary
ORDER BY Total_Production DESC;

-- Expected Output:
-- Displays total production for each production line using a CTE.


-- 2. Multiple CTEs

WITH Production AS
(
    SELECT Production_Line,
           SUM(Produced_Qty) AS Total_Production
    FROM manufacturing_production
    GROUP BY Production_Line
),

Efficiency AS
(
    SELECT Production_Line,
           ROUND(AVG(Efficiency_Percent),2) AS Average_Efficiency
    FROM manufacturing_production
    GROUP BY Production_Line
)

SELECT P.Production_Line,
       P.Total_Production,
       E.Average_Efficiency
FROM Production P
JOIN Efficiency E
ON P.Production_Line = E.Production_Line
ORDER BY P.Total_Production DESC;

-- Expected Output:
-- Combines production and efficiency using multiple CTEs.


-- 3. Nested Business Analysis

WITH Product_Performance AS
(
    SELECT Product,
           SUM(Produced_Qty) AS Total_Production,
           ROUND(AVG(Efficiency_Percent),2) AS Average_Efficiency
    FROM manufacturing_production
    GROUP BY Product
)

SELECT *
FROM Product_Performance
WHERE Average_Efficiency > 92
ORDER BY Total_Production DESC;

-- Expected Output:
-- Displays high-efficiency products using a CTE.


-- 4. CTE with Aggregate Functions

WITH Monthly_Production AS
(
    SELECT Month,
           SUM(Produced_Qty) AS Total_Production
    FROM manufacturing_production
    GROUP BY Month
)

SELECT *
FROM Monthly_Production
ORDER BY Total_Production DESC;

-- Expected Output:
-- Displays monthly production totals using a CTE.


-- 5. CTE with Window Functions

WITH Machine_Ranking AS
(
    SELECT Machine_ID,
           SUM(Produced_Qty) AS Total_Production,
           RANK() OVER
           (
               ORDER BY SUM(Produced_Qty) DESC
           ) AS Machine_Rank
    FROM manufacturing_production
    GROUP BY Machine_ID
)

SELECT *
FROM Machine_Ranking
ORDER BY Machine_Rank;

-- Expected Output:
-- Displays machine rankings using a CTE and a window function.


/*====================================================================================================
                                          SECTION 19 : VIEWS
======================================================================================================

Purpose:
Create reusable SQL views for common business analysis.

====================================================================================================*/

-- 1. Production Summary View

CREATE OR REPLACE VIEW vw_production_summary AS

SELECT Production_Line,
       SUM(Produced_Qty) AS Total_Production,
       SUM(Good_Qty) AS Total_Good_Quantity,
       SUM(Scrap_Qty) AS Total_Scrap_Quantity,
       ROUND(AVG(Efficiency_Percent),2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Production_Line;

-- Expected Output:
-- Creates a view summarizing production line performance.


-- 2. Shift Performance View

CREATE OR REPLACE VIEW vw_shift_performance AS

SELECT Shift,
       SUM(Produced_Qty) AS Total_Production,
       ROUND(AVG(Efficiency_Percent),2) AS Average_Efficiency,
       SUM(Downtime_Minutes) AS Total_Downtime
FROM manufacturing_production
GROUP BY Shift;

-- Expected Output:
-- Creates a view summarizing shift performance.


-- 3. Machine Performance View

CREATE OR REPLACE VIEW vw_machine_performance AS

SELECT Machine_ID,
       SUM(Produced_Qty) AS Total_Production,
       ROUND(AVG(Efficiency_Percent),2) AS Average_Efficiency,
       SUM(Downtime_Minutes) AS Total_Downtime
FROM manufacturing_production
GROUP BY Machine_ID;

-- Expected Output:
-- Creates a view summarizing machine performance.


-- 4. Operator Performance View

CREATE OR REPLACE VIEW vw_operator_performance AS

SELECT Operator_ID,
       SUM(Produced_Qty) AS Total_Production,
       ROUND(AVG(Efficiency_Percent),2) AS Average_Efficiency,
       SUM(Production_Loss) AS Total_Production_Loss
FROM manufacturing_production
GROUP BY Operator_ID;

-- Expected Output:
-- Creates a view summarizing operator performance.


-- 5. Monthly KPI View

CREATE OR REPLACE VIEW vw_monthly_kpi AS

SELECT Month,
       SUM(Produced_Qty) AS Total_Production,
       SUM(Good_Qty) AS Total_Good_Quantity,
       SUM(Scrap_Qty) AS Total_Scrap_Quantity,
       ROUND(AVG(Efficiency_Percent),2) AS Average_Efficiency
FROM manufacturing_production
GROUP BY Month;

-- Expected Output:
-- Creates a monthly KPI summary view.


SELECT Production_ID,
       Production_Line,
       Produced_Qty,
       DENSE_RANK() OVER (ORDER BY Produced_Qty DESC) AS `Dense_Rank`
FROM manufacturing_production;


/*====================================================================================================
                               SECTION 20 : QUERY BEST PRACTICES
======================================================================================================

Purpose:
Document the SQL coding standards, formatting guidelines, and best practices
followed throughout this project.

====================================================================================================*/


/*----------------------------------------------------------------------------------
1. SQL Formatting Standards
------------------------------------------------------------------------------------

• SQL keywords are written in UPPERCASE.
• Each SQL clause begins on a new line.
• Queries use consistent indentation.
• Long queries are formatted for readability.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
2. Naming Conventions
------------------------------------------------------------------------------------

• Meaningful table names are used.
• Meaningful column aliases are applied.
• Views follow the 'vw_' naming convention.
• Calculated columns use descriptive names.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
3. Aliases
------------------------------------------------------------------------------------

• Aliases improve readability.
• Aggregate columns use meaningful business names.

Example:
SUM(Produced_Qty) AS Total_Production

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
4. Readable Queries
------------------------------------------------------------------------------------

• Only required columns are selected.
• Queries are consistently formatted.
• Proper indentation is maintained.
• Business logic remains easy to understand.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
5. Comments
------------------------------------------------------------------------------------

• Every section begins with a header comment.
• Every query includes an Expected Output comment.
• Complex business logic is documented.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
6. Query Organization
------------------------------------------------------------------------------------

• Queries are grouped by business topic.
• Each section focuses on one analytical objective.
• Similar analyses are organized together.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
7. CTE vs Subquery
------------------------------------------------------------------------------------

• CTEs are preferred for complex analytical queries.
• Subqueries are suitable for simple one-time calculations.
• CTEs improve readability and maintainability.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
8. Views vs Tables
------------------------------------------------------------------------------------

Tables:
• Store actual production data.

Views:
• Store reusable SQL logic.
• Simplify reporting and analysis.
• Do not duplicate data.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
9. Reusable SQL
------------------------------------------------------------------------------------

• Reusable Views are created for reporting.
• CTEs reduce duplicate SQL logic.
• Consistent naming improves maintainability.
• SQL follows production-quality coding standards.

----------------------------------------------------------------------------------*/


/*====================================================================================================
                                   SECTION 21 : BUSINESS INSIGHTS
======================================================================================================

Purpose:
Summarize the key business findings obtained from the SQL analysis.

====================================================================================================*/


/*----------------------------------------------------------------------------------
1. Production Performance Summary
------------------------------------------------------------------------------------

Summarize overall production performance using key KPIs such as planned production,
actual production, good quantity, scrap quantity, production loss, production
efficiency, and downtime.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
2. Production Line Performance Summary
------------------------------------------------------------------------------------

Summarize the best and lowest performing production lines based on production,
efficiency, downtime, scrap quantity, and production loss.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
3. Shift Performance Summary
------------------------------------------------------------------------------------

Summarize the performance of Morning, Evening, and Night shifts by comparing
production output, efficiency, scrap generation, and downtime.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
4. Product Performance Summary
------------------------------------------------------------------------------------

Summarize the highest and lowest performing products using production,
efficiency, scrap quantity, and production loss.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
5. Machine Performance Summary
------------------------------------------------------------------------------------

Summarize machine performance to identify the best and lowest performing
machines based on production, efficiency, scrap quantity, and downtime.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
6. Operator Performance Summary
------------------------------------------------------------------------------------

Summarize operator performance by comparing production output, efficiency,
scrap quantity, and production loss.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
7. Downtime Analysis Summary
------------------------------------------------------------------------------------

Summarize the major downtime reasons, affected production lines,
machines, and downtime trends observed during the analysis.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
8. Time Analysis Summary
------------------------------------------------------------------------------------

Summarize monthly, quarterly, weekly, and day-wise production trends
identified during the SQL analysis.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
9. Overall Business Recommendations
------------------------------------------------------------------------------------

Provide practical business recommendations based on the SQL analysis to
improve production efficiency, reduce downtime, minimize scrap generation,
and support better operational decision-making.

----------------------------------------------------------------------------------*/


/*====================================================================================================
                                   SECTION 22 : SQL PROJECT SUMMARY
======================================================================================================

Purpose:
Provide a concise summary of the SQL project, highlighting the skills demonstrated,
business problems solved, key analyses performed, and the continuation of the
overall Data Analyst project.

====================================================================================================*/


/*----------------------------------------------------------------------------------
1. Project Summary
------------------------------------------------------------------------------------

This SQL project analyzed cleaned manufacturing production data to evaluate
production performance, operational efficiency, product quality, machine
utilization, operator performance, downtime, and time-based production trends.
The analysis transformed raw business data into meaningful insights that support
better operational decision-making.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
2. SQL Skills Demonstrated
------------------------------------------------------------------------------------

• Database Creation and Setup
• Data Verification
• SQL Fundamentals
• Data Filtering
• Aggregate Functions
• GROUP BY Analysis
• HAVING Analysis
• Production KPI Analysis
• Window Functions
• Common Table Expressions (CTEs)
• Views
• SQL Best Practices

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
3. Business Problems Solved
------------------------------------------------------------------------------------

• Measured overall production performance.
• Compared production line performance.
• Evaluated shift efficiency.
• Identified high and low performing products.
• Assessed machine utilization.
• Evaluated operator performance.
• Identified major downtime contributors.
• Analyzed production trends over time.

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
4. Key KPIs Analyzed
------------------------------------------------------------------------------------

• Total Planned Production
• Total Produced Quantity
• Total Good Quantity
• Total Scrap Quantity
• Total Production Loss
• Average Production Efficiency
• Average Scrap Rate
• Average Downtime

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
5. Advanced SQL Concepts Used
------------------------------------------------------------------------------------

• Aggregate Functions
• GROUP BY
• HAVING
• Window Functions
• ROW_NUMBER()
• RANK()
• DENSE_RANK()
• LAG()
• LEAD()
• Running Total
• Moving Average
• Common Table Expressions (CTEs)
• Views

----------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------
6. Project Continuation
------------------------------------------------------------------------------------

This SQL analysis serves as the foundation for the remaining stages of the project.

Next Stage: Microsoft Excel

• Create Pivot Tables
• Develop Pivot Charts
• Build Interactive Business Reports
• Summarize Manufacturing KPIs

Final Stage: Power BI

• Build Data Model
• Create DAX Measures
• Develop Interactive KPI Dashboard
• Design Executive-Level Business Reports

These stages will use the same cleaned manufacturing dataset and SQL business
logic to create professional business reports and dashboards.

----------------------------------------------------------------------------------*/


## Next Steps

The analytical insights generated in this SQL project will be used in the remaining stages:

1. Microsoft Excel
   - Pivot Tables
   - Pivot Charts
   - Interactive business reporting

2. Power BI
   - Data modeling
   - DAX measures
   - Executive dashboard