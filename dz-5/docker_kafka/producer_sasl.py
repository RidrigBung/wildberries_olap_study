from confluent_kafka import Producer
import json
from clickhouse_driver import Client
from typing import *

# clickhouse conn data
dbname = 'default'

with open('secrets/ch_db.json') as json_file:
    data = json.load(json_file)

client = Client(data['server'][0]['host'],
                user=data['server'][0]['user'],
                password=data['server'][0]['password'],
                port=data['server'][0]['port'],
                verify=False,
                database=dbname,
                settings={"wait_end_of_query": True,
                          "numpy_columns": False, 'use_numpy': False},
                compression=True)


# kafka conn
config = {
    'bootstrap.servers': '192.168.1.8:29092',  # адрес Kafka сервера
    'client.id': 'simple-producer',
    'sasl.mechanism': 'PLAIN',
    'security.protocol': 'SASL_PLAINTEXT',
    'sasl.username': 'admin',
    'sasl.password': 'admin-secret'
}

producer = Producer(**config)


# start of script
def delivery_report(err, msg):
    if err is not None:
        print(f"Message delivery failed: {err}")
    else:
        print(
            f"Message delivered to {msg.topic()} [{msg.partition()}] at offset {msg.offset()}")


def send_message(recieved_data):
    try:
        # Асинхронная отправка сообщения
        producer.produce('my_topic', recieved_data.encode(
            'utf-8'), callback=delivery_report)
        # Поллинг для обработки обратных вызовов
        producer.poll(0)
    except BufferError:
        print(
            f"Local producer queue is full ({len(producer)} messages awaiting delivery): try again")


if __name__ == '__main__':
    query = '''
        select shk_id
             , chrt_id
             , nm_id
             , reason_id
             , dt
             , employee_id
             , wh_id
             , price
             , new_shk_id
             , wbuser_id
             , is_mp
        from shk_substituted_sp 
        where dt >= yesterday() 
        limit 5000
    '''
    rows = client.execute(query)

    for row in rows:
        json_row = json.dumps(
            {
                'shk_id': row[0],
                'chrt_id': row[1],
                'nm_id': row[2],
                'reason_id': row[3],
                'dt': row[4].strftime('%Y-%m-%dT%H:%M:%S'),
                'employee_id': row[5],
                'wh_id': row[6],
                'price': float(row[7]),
                'new_shk_id': row[8],
                'wbuser_id': row[9],
                'is_mp': row[10]
            }
        )
        print(f'[LOG] send to kafka: {json_row}')
        send_message(json_row)
        producer.flush()
