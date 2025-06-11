CREATE TABLE  retail_sales(

       transactions_id int primary key,
       sale_date DATE,
       sale_time TIME,
       customer_id INT	,       
       gender VARCHAR(15),
       age	INT,
       category VARCHAR(15),
       quantiy INT,
       price_per_unit FLOAT,
       cogs FLOAT,
       total_sale FLOAT
);

SELECT*FROM RETAIL_SALES
LIMIT 10;

SELECT COUNT(*) FROM retail_sales

DELETE FROM retail_sales 
WHERE 
    transactions_id is null
 or
   sale_date is null
 or 
   sale_time is null
 or 
   gender is null
 or 
  category is NULL
  or
  quantiy is NULL
  or 
  cogs is null;

  -- DATA EXPLORATION
SELECT COUNT(*) as total_sale FROM retail_sales

-- how many unique customers we have
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

SELECT DISTINCT category  FROM retail_sales

-- Data analysis and business key problems
-- Q1 write the sql query to retieve all columns for sales made on '2022-11-05'

select * from retail_sales
where sale_date = '2022-11-05';
-- Q-2  write the sql query to retieve all transactions where the category is clothing and the quantity 
-- sold is more than 4 in the month of nov 2022

select * from retail_sales
where 
TO_CHAR(sale_date,'yyyy-mm')= '2022-11'
AND
category = 'Clothing' AND quantiy >=4 

-- q3 write the sql query to calculate the total sales (total_sales) or each category

select category ,count(total_sale)as total_orders, sum(total_sale)as net_sale from retail_sales
group by category

-- Q4  write the sql query to find average age of customers who purchased items from the 'beauty' category
select round(avg(age),2) as average_age from retail_sales
where category = 'Beauty'

-- Q5 write the sql query to find all transactions where the total sale is greater than 1000
select * from retail_sales
where total_sale > 1000

-- Q6 write the sql query to find total number of transactions made by each gender in each category

select gender,category,count(transactions_id)as total_transactions from retail_sales
group by category, gender

-- IMP Q7 write the sql query to calculate average sale for each month find out best selling month in each YEAR

SELECT year,month,avg_sale from(
select EXTRACT(year FROM sale_date)as year,
        EXTRACT(month FROM sale_date)as month,
		AVG(total_sale)as avg_sale ,
		RANK() OVER(PARTITION BY EXTRACT(year FROM sale_date)ORDER BY AVG(total_sale)DESC)as rank
		 FROM retail_sales
		group by 1,2) as t1
		WHERE rank = 1;
-- Q8 write the sql query to find the top 3 customers based on the highest total sales

select customer_id ,sum(total_sale)as total_sale from retail_sales
group by 1
order by 2 desc
limit 3

-- Q9write the sql query to find the number of unique customers who purchased items from unique category
select category,count(distinct customer_id)as count_unique_customers
from retail_sales
group by category

-- IMP Q10 write the sql query to calculate each shift and number of orders (morning,afternoon,evening)

WITH hourly_sale 
as 
(
SELECT * ,
CASE 
WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
WHEN EXTRACT(HOUR FROM sale_time)BETWEEN 12 and 17 THEN 'Afternoon'
else 'Evening'
END as shift
FROM retail_sales
)
SELECT
shift,
count(*)as total_orders
FROM hourly_sale
group by shift
