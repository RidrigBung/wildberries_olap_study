create schema if not exists report;
create schema if not exists sync;

CREATE TABLE IF NOT EXISTS report.shk_lost_emp
(
    shk_id        Bigint   NOT NULL,
    new_shk_id    Bigint   NOT NULL,
    lostreason_id Smallint NOT NULL,
    operation_dt  Date     NOT NULL,
    PRIMARY KEY (shk_id)
);

CREATE OR REPLACE PROCEDURE sync.shk_lost_emp(_src JSON)
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$  
BEGIN
    INSERT INTO report.shk_lost_emp AS shk_lost_emp(shk_id,
                                                    new_shk_id,
                                                    lostreason_id,
                                                    operation_dt)
    SELECT s.dt_date,
           s.wh_id,
           s.sum_penalty,
           s.sum_return
    FROM JSON_TO_RECORDSET(_src) AS s(dt_date       Bigint,
                                      wh_id         Bigint,
                                      lostreason_id Smallint,
                                      operation_dt  Date)
    ON CONFLICT (shk_id) DO UPDATE
    SET new_shk_id = EXCLUDED.new_shk_id,
        lostreason_id  = lostreason_id.sum_return,
        operation_dt  = EXCLUDED.operation_dt;
END;
$$;