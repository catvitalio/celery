# $1 - USERNAME
# $2 - HOST_IP

echo "create .env file"
set -e

> .env
echo "VERSION=$CI_PIPELINE_ID" >> .env
echo "CI_PROJECT_NAMESPACE=$CI_PROJECT_NAMESPACE" >> .env
echo "CI_PROJECT_NAME=$CI_PROJECT_NAME" >> .env
echo "CI_REGISTRY=$CI_REGISTRY" >> .env

echo "create project dir"
ssh $1@$2 mkdir -p /data/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME

echo "login docker registry"
ssh $1@$2 "docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" $CI_REGISTRY"

echo "copy wait-for-postgres file"
scp $SSH_OPT ./deploy/wait-for-postgres.sh $1@$2:/data/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME/wait-for-postgres.sh;
ssh $1@$2 "chmod +x /data/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME/wait-for-postgres.sh"

echo "copy docker-compose file"
if [[ "$ENV" == "develop" ]]; then
  echo "SENTRY_DSN=$SENTRY_DSN_DEVELOP" >> .env
  echo "CORS_ALLOWED_ORIGINS=$DEVELOP_CORS_ALLOWED_ORIGINS"
  scp $SSH_OPT ./docker-compose.stage.yml $1@$2:/data/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME/docker-compose.yml;
elif [[ "$ENV" == "master" ]]; then
  echo "SENTRY_DSN=$SENTRY_DSN_MASTER" >> .env
  echo "CORS_ALLOWED_ORIGINS=$PRODUCTION_CORS_ALLOWED_ORIGINS"
  scp $SSH_OPT ./docker-compose.prod.yml $1@$2:/data/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME/docker-compose.yml;
fi

echo "copy .env file"
scp ./.env $1@$2:/data/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME/.env


echo "pull images"
ssh $1@$2 "cd /data/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME/ && docker-compose pull"


echo "migrate..."
ssh $1@$2 "cd /data/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME/ && docker-compose run --rm server bash -c \"./wait-for-postgres.sh db python manage.py migrate --noinput\""


echo "start services"
ssh $1@$2 "cd /data/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME/ && docker-compose up -d"


echo "remove none docker images"
ssh $1@$2 'docker image prune -a -f'
