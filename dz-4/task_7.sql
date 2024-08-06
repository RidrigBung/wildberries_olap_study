-- Возьмем 200 строк из реальной таблицы, намеренно испортим данные в них и экспортируем в csv, 
-- после чего импортируем в direct_log.shk_substitution_buf имитируя поступление 200 строк из kafka.
-- Через заданное время буфферная таблица перекинет данные в соответствующую таблицу в database stg,
-- откуда черех созданные view данные попадут в соотвутствующие таблицы для database current и history.

select * from stg.shk_substitution;     -- imgaes/screen_1
select * from current.shk_substitution; -- imgaes/screen_2
select * from history.shk_substitution; -- imgaes/screen_3
