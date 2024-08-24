create database datalens;
drop table if exists datalens.dq_shk_substituted_sp;
create table datalens.dq_shk_substituted_sp engine = ReplacingMergeTree() order by dt_hour as
select toStartOfHour(dt) dt_hour
     , count() rows_qty
     , uniq(shk_id) uniq_shk_id
     , uniq(new_shk_id) uniq_new_shk_id
     , uniq(chrt_id) uniq_chrt_id
     , uniq(wh_id) uniq_wh_id
     , uniq(employee_id) uniq_employee_id
     , sum(length(subs_photo_urls)) urls_qty
     , countIf(is_mp < 1) is_mp_0_qty
     , countIf(is_mp = 1) is_mp_1_qty
     , countIf(reason_id < 1) reason_0_qty
     , countIf(reason_id = 1) reason_1_qty
     , countIf(reason_id = 2) reason_2_qty
     , countIf(reason_id = 3) reason_3_qty
     , countIf(reason_id = 4) reason_4_qty
     , countIf(reason_id = 5) reason_5_qty
     , countIf(reason_id = 6) reason_6_qty
     , countIf(reason_id = 7) reason_7_qty
     , countIf(shk_id < 1) shk_id_0_qty
     , countIf(new_shk_id < 1) new_shk_id_0_qty
     , countIf(chrt_id < 1) chrt_id_0_qty
     , countIf(wh_id < 1) wh_id_0_qty
     , countIf(employee_id < 1) employee_id_0_qty
     , countIf(price < 1) price_0_qty
     , countIf(length(subs_photo_urls) < 1) len_subs_photo_urls_0_qty
from default.shk_substituted_sp
group by dt_hour
order by dt_hour desc
;