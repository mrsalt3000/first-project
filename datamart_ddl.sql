-- analysis.dm_rfm_segments definition

-- Drop table

-- DROP TABLE analysis.dm_rfm_segments;


CREATE TABLE analysis.dm_rfm_segments(
user_id  int4 NOT NULL,
recency int4 NOT NULL,
frequency int4 NOT NULL,
monetary_value int4 NOT NULL,

CONSTRAINT dm_rfm_segments_pkey PRIMARY KEY (user_id)
);