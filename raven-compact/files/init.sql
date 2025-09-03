CREATE TABLE IF NOT EXISTS ai_logs_averages_local ON CLUSTER default (
    model_id String,
    event_amount Int32,
    confidence_score Float64,
    response_time_ms Int32,
    numeric_summaries_json String,
    categorical_summaries_json String,
    timestamp DateTime64(3)
) ENGINE = MergeTree()
  ORDER BY timestamp;

CREATE TABLE IF NOT EXISTS ai_logs_averages ON CLUSTER default
AS ai_logs_averages_local ENGINE = Distributed(default, default, ai_logs_averages_local, rand());
