create database zero_Analyst;
use zero_Analyst;
create table retail_sales (transactions_id int primary key,
						   sale_date date,
                           sale_time time,
						   customer_id int,
						   gender varchar(10),
						   age int,
						   category varchar(20),
                           quantity int,
                           price_per_unit float,
                           cogs float,
                           total_sale float
);
desc retail_sales;
select * from retail_sales;

-- transaformation that i did 
set sql_safe_updates=0;
ALTER TABLE retail_sales CHANGE ï»¿transactions_id transactions_id int;
ALTER TABLE retail_sales modify  sale_date date;
ALTER TABLE retail_sales modify  sale_time time;
ALTER TABLE retail_sales modify  price_per_unit float;
ALTER TABLE retail_sales modify  cogs float;
ALTER TABLE retail_sales modify  total_sale float;
ALTER TABLE retail_sales rename column quantiy to quantity;
-- DATA CLEANING
-- null values delete kelya.

-- DATA EXPLORATION
-- how many sales we have?
select count(*) from retail_sales;

-- how many unique customers we have?
select count(distinct customer_id) from retail_sales;

-- how many unique customers we have?
select count(distinct category) as category from retail_sales;

-- DATA ANALYSIS
/*
Here are the 10 SQL questions from the image:

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
*/

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

