# Домашняя работа к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
  * [Dockerfile](https://github.com/EmilTK/devops-netology/blob/main/homeworks/db/src/05-elasticsearch/Dockerfile)
- ссылку на образ в репозитории dockerhub
  * https://hub.docker.com/repository/docker/emiltk/netology
  * `docker pull emiltk/netology:elastic`
- ответ `elasticsearch` на запрос пути `/` в json виде
```bash
{
    "name": "netology_test",
    "cluster_name": "netology",
    "cluster_uuid": "_na_",
    "version": {
        "number": "7.15.2",
        "build_flavor": "default",
        "build_type": "tar",
        "build_hash": "93d5a7f6192e8a1a12e154a2b81bf6fa7309da0c",
        "build_date": "2021-11-04T14:04:42.515624022Z",
        "build_snapshot": false,
        "lucene_version": "8.9.0",
        "minimum_wire_compatibility_version": "6.8.0",
        "minimum_index_compatibility_version": "6.0.0-beta1"
    },
    "tagline": "You Know, for Search"
}
```
Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html)
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```bash
curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'
curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
{
 "settings": {
   "number_of_shards": 2,
   "number_of_replicas": 1
 }
}
'
curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 4,
    "number_of_replicas": 2
  }
}
'
```
Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

```bash
curl -X GET "localhost:9200/_cat/indices"

green  open ind-1            854UmeBVSj-6XvOy46yudw 1 0  0 0   208b   208b
yellow open ind-3            RxVmdhiZSSOubmj0zwQPUQ 4 2  0 0   832b   832b
yellow open ind-2            zVgeq7IMQ8K8B_GvfeDGTQ 2 1  0 0   416b   416b
```
Получите состояние кластера `elasticsearch`, используя API.

```bash
curl -X GET "localhost:9200/_cluster/health?pretty"                                                                                                                              ──(Sat,Dec04)─┘

{
  "cluster_name" : "netology",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
* Реплики не активны по причине отсутствия второй ноды.

Удалите все индексы.
```bash
curl -X DELETE "localhost:9200/_all"
{"acknowledged":true}%
```

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository)
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

```bash
curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/var/lib/elasticsearch/snapshots"
  }
}
'
{
  "acknowledged" : true
}
```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```bash
curl -X GET "localhost:9200/_cat/indices"
green open test             ZKLklC2AQY2VDNdi7iZwMQ 1 0  0 0   208b   208b
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html)
состояния кластера `elasticsearch`.

```bash
curl -X PUT "localhost:9200/_snapshot/netology_backup/netology_snapshot_1?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "netology_snapshot_1",
    "uuid" : "B6ZrF67iRxaYV7FDRhBK_A",
    "repository" : "netology_backup",
    "version_id" : 7150299,
    "version" : "7.15.2",
    "indices" : [
      ".geoip_databases",
      "test"
    ],
    "data_streams" : [ ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2021-12-05T12:16:05.013Z",
    "start_time_in_millis" : 1638706565013,
    "end_time" : "2021-12-05T12:16:11.585Z",
    "end_time_in_millis" : 1638706571585,
    "duration_in_millis" : 6572,
    "failures" : [ ],
    "shards" : {
      "total" : 2,
      "failed" : 0,
      "successful" : 2
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}
```
**Приведите в ответе** список файлов в директории со `snapshot`ами.

```bash
sudo ls -la /var/lib/docker/volumes/elasticsearch/_data/snapshots
total 40
drwxr-xr-x. 3 emil emil   134 Dec  5 15:16 .
drwxr-xr-x. 4 root root    35 Dec  5 14:24 ..
-rw-r--r--. 1 emil emil   837 Dec  5 15:16 index-0
-rw-r--r--. 1 emil emil     8 Dec  5 15:16 index.latest
drwxr-xr-x. 4 emil emil    66 Dec  5 15:16 indices
-rw-r--r--. 1 emil emil 27608 Dec  5 15:16 meta-B6ZrF67iRxaYV7FDRhBK_A.dat
-rw-r--r--. 1 emil emil   446 Dec  5 15:16 snap-B6ZrF67iRxaYV7FDRhBK_A.dat
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```bash
curl -X DELETE "localhost:9200/test"
{"acknowledged":true}%

curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'    {
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'

{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}

curl -X GET "localhost:9200/_cat/indices"
green open test-2           CKv_L212TVeixyOA7sdf2g 1 0  0 0   208b   208b
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее.

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```bash
curl -X POST "localhost:9200/_snapshot/netology_backup/netology_snapshot_1/_restore?pretty"
{
  "accepted" : true
}

curl -X GET "localhost:9200/_cat/indices"
green  open test-2           9Z2IIWZuT22v7pw8UOix3A 1 0 0 0 208b 208b
yellow open test             -mb4W3wTQ2iJUAPDYnIEcQ 1 0
```

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`
