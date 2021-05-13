README
=====================

Этот README документирует описывает все шаги, необходимые для создания и запуска веб-приложения.


### Настройки Docker

##### Установка

* [Подробное руководство по установке](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

##### Команды для запуска docker без sudo (для локалки)

* `sudo groupadd docker`
* `sudo gpasswd -a ${USER} docker`
* `newgrp docker`
* `sudo service docker restart`

##### Проверка работоспособности docker без sudo

* `docker run hello-world`

### Настройки Docker-compose

##### Установка

* [Подробное руководство по установке](https://docs.docker.com/compose/install/)

##### Команда для запуска docker-compose без sudo (для локалки)

* `sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose`

### Fabric

Файл `fabfile.py` содержит ряд функций, которые помогают при локальной разработке.

##### Установка

* `sudo pip install 'fabric<2.0'`

**Примечание**: важно устанавливать именно первую версию fabric.

##### Основные команды

* `fab dev` - запустить локально веб приложение
* `fab makemigrations` - создать файл миграций
* `fab migrate` - применить миграции
* `fab load_backup` - загрузить резервную копию базы
* `fab createsuperuser` - создать супер пользователя

### Локальная разработка

##### Команды для первого запуска

* `docker-compose up -d db` - создание контейнера с базой
* `fab load_dump` - загрузить дамп базы в контейнер с базой
* `7z x media.7z -oserver/` - разархивировать медию
* `docker-compose build` - создать контейнеры docker
* `fab dev` - запустить веб приложение
* `fab migrate` - применить миграции

##### Команды для последующего запуска

* `docker-compose build` - создать контейнеры docker
* `fab dev` - зупустить веб приложение
* `fab migrate` - применить миграции

**Примечание**: для запуска всех контенеров (включая celery) необходимо выполнить команду `docker-compose up`.

##### Доступ

* http://localhost:8000

### Развертывание веб-приложения на production сервере

##### Команды

* `fab deploy` - пересборка и запуск контейнеров nginx и server

### Примечания

* При разработке можно убрать ненужные зависимости
    
    `docker-compose run server poetry remove req_name`