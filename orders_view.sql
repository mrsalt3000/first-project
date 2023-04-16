CREATE  OR REPLACE VIEW analysis.Orders
AS
WITH 
statuses AS
(
SELECT
  order_id,
  status_id as status_id,
  row_number() over(partition by order_id order by dttm DESC) = 1 as is_last
  from orderstatuslog
)
SELECT
orders.*,
status_id
FROM production.orders AS orders
LEFT JOIN (SELECT * FROM statuses WHERE is_last) AS statuses  
ON statuses.order_id = orders.order_id;