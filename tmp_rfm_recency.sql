DROP TABLE analysis.tmp_rfm_recency;

CREATE TABLE analysis.tmp_rfm_recency (
 user_id INT NOT NULL PRIMARY KEY,
 recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);

INSERT INTO analysis.tmp_rfm_recency
WITH recency_absolute as
(
	SELECT
  	users.id AS user_id,
  	CURRENT_DATE::date - COALESCE(max(order_ts),TO_DATE('19000101','YYYYMMDD'))::date as days_since_last_order
  from analysis.users AS users
  LEFT JOIN analysis.orders AS orders
  ON orders.user_id = users.id
  GROUP BY users.id
)
SELECT
user_id,
CASE
	WHEN days_since_last_order<(SELECT percentile_disc(0.2) WITHIN GROUP (ORDER BY days_since_last_order) FROM recency_absolute)
		THEN 5
	WHEN days_since_last_order<(SELECT percentile_disc(0.4) WITHIN GROUP (ORDER BY days_since_last_order) FROM recency_absolute)
		THEN 4
	WHEN days_since_last_order<(SELECT percentile_disc(0.6) WITHIN GROUP (ORDER BY days_since_last_order) FROM recency_absolute)
		THEN 3
	WHEN days_since_last_order<(SELECT percentile_disc(0.8) WITHIN GROUP (ORDER BY days_since_last_order) FROM recency_absolute)
		THEN 2
	ELSE 1
	END AS recency
FROM recency_absolute
;