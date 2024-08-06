-- Роль только для чтения
create role if not exists read_only;

grant select on *.* to read_only;

-- Роль с возможность создавать и заполнять данные в БД стейджинга(stg)
create role if not exists stage_creator;

grant create, insert on stg.* to stage_creator;

-- Создать двух пользователей с такими правами по умолчанию
create user if not exists sokolov default role read_only identified with sha256_password by '1415';

create user if not exists bobrov default role stage_creator identified with sha256_password by '3435';
