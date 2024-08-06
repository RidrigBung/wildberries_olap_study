create materialized view stg.shk_substitution_stg_to_current to current.shk_substitution as
select shk_id
    , chrt_id
    , reason_id
    , dt
    , employee_id
    , price
    , new_shk_id
from stg.shk_substitution
;

create materialized view stg.shk_substitution_stg_to_history to history.shk_substitution as
select shk_id
    , chrt_id
    , reason_id
    , dt
    , employee_id
    , price
    , new_shk_id
from stg.shk_substitution
;
