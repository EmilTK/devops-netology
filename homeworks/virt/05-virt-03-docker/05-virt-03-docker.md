
# Домашняя работа к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.
  * https://hub.docker.com/r/emiltk/nginx_netology

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
    * Виртуализация
- Nodejs веб-приложение;
    * Docker
- Мобильное приложение c версиями для Android и iOS;
    * Docker 
- Шина данных на базе Apache Kafka;
    * Виртуализация
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
    * Виртуализация
- Мониторинг-стек на базе Prometheus и Grafana;
    * Docker
- MongoDB, как основное хранилище данных для java-приложения;
    * Docker
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
    * Docker

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

```bash
$ mkdir ~/netology/05-virt-03-docker/data
$ docker run -it --rm -d --name container1 -v ~/netology/05-virt-03-docker/data:/data centos:8
$ docker run -it --rm -d --name container2 -v ~/netology/05-virt-03-docker/data:/data debian:11-slim
$ docker exec -it container1 bash
$ [root@ac80e14fcfb7 /]# echo "Hello world!" >> /data/file1.txt
$ [root@ac80e14fcfb7 /]# exit
$ echo "hello netology" >> ~/netology/05-virt-03-docker/data/file2.txt
$ docker exec -it container2 bash
$ root@dc97c88aab8e:/# ls /data
  file1.txt  file2.txt
$ root@dc97c88aab8e:/# exit 
$ ls ~/netology/05-virt-03-docker/data                                                               ──(Wed,Nov03)─┘
  file1.txt  file2.txt
```
## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.
* https://hub.docker.com/r/emiltk/ansible
```bash
$ docker run --rm --name ansible emiltk/ansible:latest
ansible-playbook 2.9.24
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.9/site-packages/ansible
  executable location = /usr/bin/ansible-playbook
  python version = 3.9.5 (default, May 12 2021, 20:44:22) [GCC 10.3.1 20210424]
```


---
