CREATE TABLE stg.shk_substitution
(
    `shk_id` Int64,
    `chrt_id` UInt32,
    `reason_id` UInt8,
    `dt` DateTime,
    `employee_id` UInt32,
    `price` Decimal(11, 2),
    `new_shk_id` Int64
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(dt)
ORDER BY shk_id
TTL dt + interval 7 day
SETTINGS index_granularity = 8192
;

CREATE TABLE direct_log.shk_substitution_buf
(
    `shk_id` Int64,
    `chrt_id` UInt32,
    `reason_id` UInt8,
    `dt` DateTime,
    `employee_id` UInt32,
    `price` Decimal(11, 2),
    `new_shk_id` Int64
)
ENGINE = Buffer(stg, shk_substitution, 16, 10, 100, 10000, 1000000, 10000000, 100000000)
;

-- Заодно создадим соответствующие таблицы в database current & history
CREATE TABLE current.shk_substitution
(
    `shk_id` Int64,
    `chrt_id` UInt32,
    `reason_id` UInt8,
    `dt` DateTime,
    `employee_id` UInt32,
    `price` Decimal(11, 2),
    `new_shk_id` Int64
)
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(dt)
ORDER BY shk_id
SETTINGS index_granularity = 8192
;

CREATE TABLE history.shk_substitution
(
    `shk_id` Int64,
    `chrt_id` UInt32,
    `reason_id` UInt8,
    `dt` DateTime,
    `employee_id` UInt32,
    `price` Decimal(11, 2),
    `new_shk_id` Int64
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(dt)
ORDER BY shk_id
SETTINGS index_granularity = 8192
;
