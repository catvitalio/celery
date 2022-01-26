from django.urls import include, path

from apps.celery_tasks import urls

urlpatterns = [
    path('tasks/', include(urls)),
]
