CREATE TABLE pipeline_state (
    pipeline_name TEXT PRIMARY KEY,
    last_watermark TIMESTAMP
);

INSERT INTO pipeline_state (pipeline_name, last_watermark)
VALUES ('casino_pipeline', '1969-06-09 00:00:00');

CREATE TABLE incremental_casinodaily AS
SELECT *
FROM casinodaily
WHERE UpdatedTimestamp >
(
    SELECT last_watermark
    FROM pipeline_state
    WHERE pipeline_name = 'casino_pipeline'
);

UPDATE pipeline_state
SET last_watermark = (
    SELECT MAX(UpdatedTimestamp)
    FROM casinodaily
)
WHERE pipeline_name = 'casino_pipeline';
