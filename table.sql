CREATE DATABASE qwe;

CREATE TABLE qwe.qwe_queue
(
  key String,
  num Int64
) ENGINE = Kafka
    SETTINGS
      kafka_broker_list = '127.0.0.1:9092',
      kafka_topic_list = 'test',
      kafka_group_name = 'click',
      kafka_format = 'Protobuf',
      kafka_schema = 'proto/ex_001.proto:Transaction';

CREATE TABLE IF NOT EXISTS qwe.qwe
(
  qwe_key String,
  qwe_num Int64
) ENGINE = ReplacingMergeTree()
    ORDER BY qwe_key;

CREATE MATERIALIZED VIEW IF NOT EXISTS qwe.qwe_consumer TO qwe.qwe AS
SELECT
  anyLast(key) as qwe_key,
  anyLast(num) as qwe_num
FROM qwe.qwe_queue
GROUP BY key
  SETTINGS stream_flush_interval_ms = 60000;

