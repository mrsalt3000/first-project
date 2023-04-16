DROP TABLE analysis.tmp_rfm_frequency;

CREATE TABLE analysis.tmp_rfm_frequency (
 user_id INT NOT NULL PRIMARY KEY,
 frequency INT NOT NULL CHECK(frequency >= 1 AND frequency <= 5)
);

INSERT INTO analysis.tmp_rfm_frequency
WITH frequency_absolute as
(
	SELECT
  	users.id AS user_id,
  	COALESCE(count(order_id),0) as successful_orders
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
	WHEN successful_orders<(SELECT percentile_disc(0.2) WITHIN GROUP (ORDER BY successful_orders) FROM frequency_absolute)
		THEN 1
	WHEN successful_orders<(SELECT percentile_disc(0.4) WITHIN GROUP (ORDER BY successful_orders) FROM frequency_absolute)
		THEN 2
	WHEN successful_orders<(SELECT percentile_disc(0.6) WITHIN GROUP (ORDER BY successful_orders) FROM frequency_absolute)
		THEN 3
	WHEN successful_orders<(SELECT percentile_disc(0.8) WITHIN GROUP (ORDER BY successful_orders) FROM frequency_absolute)
		THEN 4
	ELSE 5
	END AS frequency
FROM frequency_absolute
;