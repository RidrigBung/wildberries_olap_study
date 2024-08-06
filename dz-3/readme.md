3-е Домашнее задание. Kafka.</h1>

<p>1) Клонируем репо https://github.com/AinKub/WB-Practice-BI-Olap/tree/main/kafka, 
<p>с него берем папку "docker_with_sasl", копируем её к себе в репозиторий, переходим в скопированную папку, 
<p>запускаем docker-compose командой:
<p><b>docker-compose -f docker-compose-kafka-sasl.yml up -d</b>
<p>Подключаемся с помощью интерфейса offset explorer
<p><img src='./images/kafka_sasl_connected.png' alt='image1' />
<p>2) Создадим новый топик с помощью интерфейса offset explorer
<p><img src='./images/topic_created.png' alt='image2' />
<p>3) Напишем скрипт для заливки данных на основе скрипта с git kafka (./src/producer.py)
<p>4) Запускаем скрипт, смотрим результат
<p><img src='./images/recieved_messages_from_producer.png' alt='image3' />
<p>5) Напишем скрипт для чтения данных на основе скрипта с git kafka (./src/consumer.py)
<p><img src='./images/recieved_messages_from_consumer.png' alt='image4' />
