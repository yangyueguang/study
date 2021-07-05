import pytz
from datetime import datetime, timedelta
from airflow.models import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
"""
airflow db init
airflow users create --lastname user --firstname admin --username admin --email admin_user@mail.com --role Admin --password admin
airflow webserver -D
airflow scheduler -D
airflow worker -D
"""

default_args = {
    'owner': 'airflow',
    'depends_on_past': True,
    'wait_for_downstream': True,
    'execution_timeout': timedelta(minutes=3),
    'email': ['2829969299@qq.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}


def hello():
    print('hello world')


dag_id = 'aaadd'
dag = DAG(
    dag_id=dag_id,
    default_args=default_args,
    description='my DAG',
    schedule_interval=None, #'*/2 * * * *',  # 执行周期
    start_date=datetime(2018, 7, 26, 12, 20, tzinfo=pytz.timezone('Asia/Shanghai')).astimezone(pytz.utc).replace(tzinfo=None)
)
BashOperator(task_id='te1st1', bash_command='pwd', dag=dag)
PythonOperator(task_id='task_id', python_callable=hello, dag=dag)


from airflow.models.dagbag import DagBag
dagbag = DagBag(include_examples=False, include_smart_sensor=False, read_dags_from_db=True)
dagbag.dags = {
    dag.dag_id: dag
}
dagbag.sync_to_db()

import subprocess
subprocess.run(f'airflow dags unpause {dag_id} && airflow dags trigger {dag_id}', shell=True, check=True)
