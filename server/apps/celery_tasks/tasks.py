import time

from config.celery import app, CeleryQueues


@app.task(name='default_task')
def default_task():
    time.sleep(1)


@app.task(name='priority_task', queue=CeleryQueues.PRIORITY, priority_task=10)
def priority_task():
    time.sleep(1)
