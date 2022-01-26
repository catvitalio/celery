from rest_framework.views import APIView
from rest_framework.exceptions import APIException
from rest_framework.response import Response

from config.celery import CeleryQueues

from .tasks import default_task, priority_task


class TaskView(APIView):
    def post(self, request, *args):
        """
        Run multiple celery tasks
        """
        task_type = request.data.get('task_type')

        if task_type == CeleryQueues.DEFAULT:
            for _ in range(100):
                default_task.delay()
        elif task_type == CeleryQueues.PRIORITY:
            for _ in range(100):
                priority_task.delay()
        else:
            raise APIException('task_type_not_set', code=400)

        return Response()
