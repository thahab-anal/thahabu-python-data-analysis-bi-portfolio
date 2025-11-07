/*Monthly Revenue and Profit Trends*/

/*Querying to solve below questions:
What is the total monthly revenue and total profit?
Which months show the highest and lowest sales?
Has profitability improved or declined over time?*/

WITH
  total_revenue_profit AS (
  SELECT
    EXTRACT(YEAR
    FROM
      order_item.created_at) AS order_year,
    EXTRACT(month
    FROM
      order_item.created_at) AS order_month,
    SUM(order_item.sale_price) AS total_revenue,
    SUM(inventory_item.cost) AS total_cost_price,
    SUM(order_item.sale_price-inventory_item.cost) AS total_profit
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` order_item
  LEFT JOIN
    `bigquery-public-data.thelook_ecommerce.inventory_items` inventory_item
  ON
    order_item.inventory_item_id=inventory_item.id
  GROUP BY
    order_year,
    order_month)
SELECT
  order_year,
  order_month,
  FORMAT('%04d-%02d',order_year,order_month) as year_month,
  total_revenue,
  total_cost_price,
  total_profit,
  FIRST_VALUE(order_month) OVER(PARTITION BY order_year ORDER BY total_revenue ASC) least_revenue_month_of_the_year,
  FIRST_VALUE(total_revenue) OVER(PARTITION BY order_year ORDER BY total_revenue ASC) least_revenue_of_the_year,
  FIRST_VALUE(order_month) OVER(PARTITION BY order_year ORDER BY total_revenue DESC) highest_revenue_month_of_the_year,
  FIRST_VALUE(total_revenue) OVER(PARTITION BY order_year ORDER BY total_revenue DESC) highest_revenue_of_the_year,
  LAG(total_profit) OVER(PARTITION BY order_year ORDER BY order_month) AS previous_month_profit,
  ROUND(SAFE_DIVIDE((total_profit-(LAG(total_profit) OVER(PARTITION BY order_year ORDER BY order_month))),(LAG(total_profit) OVER(PARTITION BY order_year ORDER BY order_month)))*100,2) AS month_over_month_growth_percentage,
FROM
  total_revenue_profit;

  /* Attached the results in this folder which  are also visualized in a looker studio adhoc dashboard to show monthly revenue and profit trends over time, 
  highlighting months with highest and lowest sales, and tracking profitability changes.
  */


