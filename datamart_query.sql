-- analysis.dm_rfm_segments definition

-- Drop table

DROP TABLE analysis.dm_rfm_segments;

CREATE TABLE analysis.dm_rfm_segments (
	user_id int4 NOT NULL,
	recency int4 NOT NULL,
	frequency int4 NOT NULL,
	monetary_value int4 NOT NULL,
	CONSTRAINT dm_rfm_segments_pkey PRIMARY KEY (user_id)
);

INSERT INTO analysis.dm_rfm_segments
SELECT
  users.id as user_id,
  recency,
  frequency,
  monetary_value
FROM analysis.users AS users
LEFT JOIN analysis.tmp_rfm_recency 
ON tmp_rfm_recency.user_id = users.id
LEFT JOIN analysis.tmp_rfm_frequency 
ON tmp_rfm_frequency.user_id = users.id
LEFT JOIN analysis.tmp_rfm_monetary_value 
ON tmp_rfm_monetary_value.user_id = users.id

/*
|user_id|recency|frequency|monetary_value|
|-------|-------|---------|--------------|
|0      |2      |4        |4             |
|1      |3      |4        |3             |
|2      |2      |4        |5             |
|3      |2      |4        |3             |
|4      |2      |4        |3             |
|5      |3      |5        |5             |
|6      |1      |4        |5             |
|7      |4      |3        |2             |
|8      |3      |2        |3             |
|9      |3      |3        |2             |
|10     |3      |5        |2             |

*/