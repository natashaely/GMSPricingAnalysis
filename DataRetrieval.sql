-- All products: Sales volume vs item price

SELECT
  item.item_id,
  item.item_name,
  item.price_in_usd,
  SUM(item.quantity) AS total_sold_quantity,
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(items) AS item
WHERE
  event_name = 'purchase'
GROUP BY
  1,
  2,
  3
ORDER BY
  total_sold_quantity DESC


-- Sales and revenue data for all products

SELECT
  item.item_id,
  item.item_name,
  event_date,
  event_timestamp,
  item.price_in_usd,
  item.item_revenue_in_usd,
  item.item_category,
  SUM(item.quantity) AS sold_quantity_on_that_date
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(items) AS item
WHERE
  event_name = 'purchase'
  AND item.item_id IN ('9188203', '9180819', '9180865', '9188201', '9195032')
GROUP BY
  1, 2, 3, 4, 5, 6, 7
ORDER BY
  item.item_category, event_date DESC, event_timestamp DESC;


-- Top 5 best-selling items 

SELECT
  item.item_id,
  item.item_name,
  SUM(item.quantity) AS total_sold_quantity
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(items) AS item
WHERE
  event_name = 'purchase'
GROUP BY
  1,
  2
ORDER BY
  total_sold_quantity DESC
LIMIT
  5;


-- Price and sales correlation: Analysing how price impacts sales

SELECT
  price_range,
  COUNT(*) AS total_sales,
  AVG(item_revenue_in_usd) AS avg_sales
FROM (
  SELECT
    item.item_id,
    item.item_name,
    CASE
      WHEN item.price_in_usd BETWEEN 1 AND 20 THEN '1-20'
      WHEN item.price_in_usd BETWEEN 21 AND 40 THEN '21-40'
      WHEN item.price_in_usd BETWEEN 41 AND 60 THEN '41-60'
      WHEN item.price_in_usd BETWEEN 61 AND 80 THEN '61-80'
      WHEN item.price_in_usd BETWEEN 81 AND 100 THEN '81-100'
      WHEN item.price_in_usd BETWEEN 90 AND 100 THEN '90-100'
      ELSE '100+'
    END AS price_range,
    item.item_revenue_in_usd
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(items) AS item
)
GROUP BY
  price_range
ORDER BY
  total_sales DESC;


