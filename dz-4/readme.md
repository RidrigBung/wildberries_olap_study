<h1>4-е Домашнее задание - Clickhouse.</h1>
<p>1) pull and run clickhouse-server:
<p>docker run -d --name my-clickhouse-server -p 8123:8123 --ulimit nofile=262144:262144 clickhouse/clickhouse-server
<p>Подключимся через DBeaver по адресу: 'localhost:8123' и пользователю 'default', который создан автоматически
<p>Текст, реализующий последующие задачи расположен в файлах 'task_{№задания}.sql' согласно тз.
