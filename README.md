Project Overview
Project Title: Retail Sales Analysis

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

Objectives
Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
Data Cleaning: Identify and remove any records with missing or null values.
Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.
Project Structure
1. Database Setup
Database Creation: The project starts by creating a database named p1_retail_db.
Table Creation: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.


CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);


-- transformation 
set sql_safe_updates=0;
ALTER TABLE retail_sales CHANGE ï»¿transactions_id transactions_id int;
ALTER TABLE retail_sales modify  sale_date date;
ALTER TABLE retail_sales modify  sale_time time;
ALTER TABLE retail_sales modify  price_per_unit float;
ALTER TABLE retail_sales modify  cogs float;
ALTER TABLE retail_sales modify  total_sale float;
ALTER TABLE retail_sales rename column quantiy to quantity;

-- DATA EXPLORATION
-- how many sales we have?
select count(*) from retail_sales;

-- how many unique customers we have?
select count(distinct customer_id) from retail_sales;

-- how many unique customers we have?
select count(distinct category) as category from retail_sales;


- DATA ANALYSIS
1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
2. Write a SQL query to retrieve all transactions where the category is 'Clothing'
-- and the quantity sold is more than 4 in the month of Nov 2022.
3. Write a SQL query to calculate the total sales (total_sale) for each category.
4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
7. Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year.
8. Write a SQL query to find the top 5 customers based on the highest total sales.
9. Write a SQL query to find the number of unique customers who purchased items from each category.
10. Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17).


-- 1) 
select * from retail_sales where sale_date ='2022-11-05';

-- 2)
select * from retail_sales where category="Clothing"
and year(sale_date)=2022 and month(sale_date)=11 and quantity >=4;

-- 3)
select category,sum(total_sale) as total_sales from retail_sales 
group by category;
 
 -- 4)
 select avg(age) as age from retail_sales where category="Beauty";
 
 -- 5)
 select * from retail_sales where total_sale>1000;
 
 -- 6) 
 select category,gender,count(transactions_id) as count_of_transacations from retail_sales group by category,gender;
 
 -- 7) 
SELECT year,month,avg_sale FROM (    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rnk
FROM retail_sales GROUP BY 1, 2) as t1
WHERE rnk = 1;


 -- 8) 
 select * from retail_sales order by total_sale desc limit 5;
 
 -- 9)
 select count(distinct customer_id) as unique_customers,category
 from retail_sales group by category;
 
 -- 10) 
with hourly_sales as
(
select *,
case
when extract(hour from sale_time)<12 then 'Morning'
when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
else 'Evening'
end as shift
from retail_sales
)
select 
shift, count(*) as Total_orders from hourly_sales
group by shift;

Findings
Customer Demographics: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
High-Value Transactions: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
Sales Trends: Monthly analysis shows variations in sales, helping identify peak seasons.
Customer Insights: The analysis identifies the top-spending customers and the most popular product categories.


Reports
Sales Summary: A detailed report summarizing total sales, customer demographics, and category performance.
Trend Analysis: Insights into sales trends across different months and shifts.
Customer Insights: Reports on top customers and unique customer counts per category.


Conclusion
This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
