from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
from clickhouse_driver import Client
import psycopg2
import json

default_args = {
    "owner": "Babanin",
    "start_date": datetime(2024, 8, 8),
    "retries": 1,
    "retry_delay": timedelta(seconds=60)
}

dag = DAG(
    dag_id='report_shk_lost_emp',
    default_args=default_args,
    schedule_interval='@daily',
    description='Отчет для списаний только на сотрудников',
    catchup=False,
    max_active_runs=1
)

with open('/opt/airflow/dags/credentials.json') as json_file:
    data = json.load(json_file)

client_ch = Client(data['clickhouse'][0]['host'],
                user=data['clickhouse'][0]['user'],
                password=data['clickhouse'][0]['password'],
                port=data['clickhouse'][0]['port'],
                verify=False,
                settings={"numpy_columns": True, 'use_numpy': True},
                compression=False)

client_pg = psycopg2.connect(host=data['postgres'][0]['host'],
                              user=data['postgres'][0]['user'],
                              password=data['postgres'][0]['password'],
                              port=data['postgres'][0]['port'],
                              dbname=data['postgres'][0]['dbname'])


def main():
    #click
    source_db = "default"
    source_table = "Shk_LostPost"
    db = "report"
    table = "shk_lost_emp"

    sql = f'''
        insert into {db}.{table}
        select shk_id
             , new_shk_id
             , lostreason_id
             , operation_dt
        from {source_db}.{source_table}
        where operation_dt > (select max(operation_dt) from {db}.{table})
          and contragent_code = 'EMP'
        order by operation_dt desc
        limit 1 by shk_id
    '''

    client_ch.execute(sql)

    query = f'''
        select shk_id
             , new_shk_id
             , lostreason_id
             , operation_dt
        from {db}.{table} 
    '''

    df = client_ch.query_dataframe(query)

    #pg
    sync = "shk_lost_emp"

    cursor = client_pg.cursor()

    df = df.to_json(orient="records", date_format="iso", date_unit="s")
    cursor.execute(f"CALL sync.{sync}(_src := '{df}')")
    client_pg.commit()

    cursor.close()
    client_pg.close()


PythonOperator(
    task_id='report_thefts', python_callable=main, dag=dag)
