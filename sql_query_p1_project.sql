-- sql retail sales analysis - p1 
CREATE DATABASE sql_projectp1;
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
     transactions_id INT PRIMARY KEY,	
     sale_date	DATE,
     sale_time	TIME,
     customer_id INT,
     gender	VARCHAR(15),
     age INT,
	 category VARCHAR(15),
     quantiy INT,
     price_per_unit FLOAT,	
	 cogs FLOAT,
    total_sale FLOAT
);
USE sql_projectp1;

SELECT * FROM retail_sales;

SELECT 
COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL;
SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE 
     transactions_id IS NULL
	 OR
     sale_date	IS NULL
     OR
     sale_time	IS NULL
     OR
     customer_id IS NULL
     OR
     gender	IS NULL
     OR
     age IS NULL
     OR
	 category IS NULL
     OR
     quantiy IS NULL
     OR
     price_per_unit IS NULL
     OR
	 cogs IS NULL
     OR
    total_sale IS NULL;
    
-- HOW MANY SALES WE HAVE ?
SELECT COUNT(*) as total_sale FROM retail_sales;
-- how many UNIQUE customers we have
select COUNT(distinct customer_id) as total_sales from retail_sales;
-- business key problems
-- only a particar date
select * from retail_sales
where sale_date = '2022-12-16';

-- write a query to calculate the total_sales  for each category;

select 
      category,
      sum(total_sale) as net_sale,
      count(*) as total_orders
from retail_sales
group by 1;

-- query to find avg of customers who purchased items from the beauty category
select 
     ROUND(AVG(age), 2) as avg_age
From retail_sales
where category = 'Beauty';

-- write a query to find all transaction where the total_sales greater than 1000.
select * from retail_sales
where total_sale > 1000;

-- write a sql query to find the total number of transcations (transaction_id) made by  each gender in each category
select category,gender,count(*) as total_trans
from retail_sales
group by category,gender
order by 1;

-- write a query to calcuulate the avg sale for each month.find out best selling month in each year
select  year,month, avg_sale from 
(
select 
    Extract(year FROM sale_date) as year,
    Extract(month FROM sale_date) as month,
    AVG(total_sale) as AVG_sale,
    RANK() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rnk
 from retail_sales
 group by 1, 2
 ) as t1
where rnk  = 1
order by year;

-- order by 1, 2, 3 DESC;
-- write a query to fin the top 5 customers based on the highest total sales
select 
   customer_id,
   sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

-- write a query to find the number of unique  customers who purchased items from each category.
select 
category,
count(distinct customer_id) as cnt_uniques_as
from retail_sales
group by 1;

-- write a query to create ech shifts and number of orders(ex morning <=12, afternoon between 12 & 17 ,eveng < 17)
with hourly_sale
as
(
select *,
    case 
        when extract(hour from sale_time) < 12 then 'morning'
        when extract(hour from sale_time) between 12 and 17 then 'afternoon'
        else 'evening'
      end as shift
   from retail_Sales
)
   select 
        shift,
        count(*) as total_orders
  from hourly_sale
  group by shift;
   