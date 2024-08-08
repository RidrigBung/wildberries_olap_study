create table if not exists default.Shk_LostPost
(
    operation_id       String,
    operation_dt       DateTime,
    shk_id             UInt64,
    chrt_id            UInt64,
    nm_id              UInt64,
    create_employee_id Int64,
    lostreason_id      Int64,
    reason_descr       String,
    contragent_code    String,
    contragent_id      UInt64,
    retention_amount   Float64,
    new_shk_id         UInt64,
    lost_post          UInt8,
    currency_code      UInt32,
    entry              String,
    shk_price          Int32
)
engine = MergeTree()
PARTITION BY toYYYYMM(operation_dt)
ORDER BY shk_id
SETTINGS index_granularity = 8192;

create database if not exists report;

create table if not exists report.shk_lost_emp
(
    shk_id        UInt64,
    new_shk_id    UInt64,
    lostreason_id Int64,
    operation_dt  DateTime
)
engine = MergeTree()
PARTITION BY toYYYYMM(operation_dt)
ORDER BY shk_id
SETTINGS index_granularity = 8192;
