DROP TABLE analysis.tmp_rfm_monetary_value;

CREATE TABLE analysis.tmp_rfm_monetary_value (
 user_id INT NOT NULL PRIMARY KEY,
 monetary_value INT NOT NULL CHECK(monetary_value >= 1 AND monetary_value <= 5)
);

INSERT INTO analysis.tmp_rfm_monetary_value
WITH monetary_value_absolute as
(
	SELECT
  	users.id AS user_id,
  	COALESCE(SUM(payment),0) as successful_orders_sum
  from analysis.users AS users
  LEFT JOIN 
  	(SELECT * FROM analysis.orders AS orders
	 LEFT JOIN analysis.orderstatuses AS statuses
	 ON statuses.id = orders.status
	 WHERE statuses.key ='Closed'
	 )AS orders
  ON orders.user_id = users.id
  GROUP BY users.id
)
SELECT
user_id,
CASE
	WHEN successful_orders_sum<(SELECT percentile_disc(0.2) WITHIN GROUP (ORDER BY successful_orders_sum) FROM monetary_value_absolute)
		THEN 1
	WHEN successful_orders_sum<(SELECT percentile_disc(0.4) WITHIN GROUP (ORDER BY successful_orders_sum) FROM monetary_value_absolute)
		THEN 2
	WHEN successful_orders_sum<(SELECT percentile_disc(0.6) WITHIN GROUP (ORDER BY successful_orders_sum) FROM monetary_value_absolute)
		THEN 3
	WHEN successful_orders_sum<(SELECT percentile_disc(0.8) WITHIN GROUP (ORDER BY successful_orders_sum) FROM monetary_value_absolute)
		THEN 4
	ELSE 5
	END AS monetary_value
FROM monetary_value_absolute
;