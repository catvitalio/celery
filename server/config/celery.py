from __future__ import absolute_import

import os
from typing import Final

from celery import Celery
from kombu import Exchange, Queue


class CeleryQueues:
    DEFAULT: Final[str] = 'default'
    PRIORITY: Final[str] = 'priority'


os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

app = Celery('config')
app.config_from_object('django.conf:settings', namespace='CELERY')
app.conf.task_default_queue = CeleryQueues.DEFAULT
app.conf.task_default_priority = 5
app.conf.task_queue_max_priority = 10
app.conf.task_queues = (
    Queue(
        CeleryQueues.DEFAULT,
        Exchange(CeleryQueues.DEFAULT),
        routing_key=CeleryQueues.DEFAULT,
        queue_arguments={'x-max-priority': 5},
    ),
    Queue(
        CeleryQueues.PRIORITY,
        Exchange(CeleryQueues.PRIORITY),
        routing_key=CeleryQueues.PRIORITY,
        queue_arguments={'x-max-priority': 10},
    ),
)
app.autodiscover_tasks()
