# Домашняя работа к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

---

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
  * replication - динамическое масштабирование сервесов в количестве указаном в параметре `--replicas`
  * global - распростронение сервиса на все ноды кластера
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
  * Используется алгоритм распределенного консенсуса - Raft </br>
    Каждая Manager нода кластера может находится в одном из трех состояний - Последователь, Кондидат, Лидер. Изначально у всех manager нод состояние - последователь, но если нода не получает значение от лидера, в течении 150-300 мс.(тайм-аут выбора) она может стать лидером, для это она переходит в состояние кондидата и запрашивает у других нод подтверждение стать лидером, кондидат становится лидером, если получил подтверждение от большинства нод.
- Что такое Overlay Network?
  * Логическая сеть создаваемая поверх другой сети. В случае docker - это сеть создаваемая поверх сети хоста, объединяющая контейнеры в локальную сеть.

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```
```bash
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
tt797ojt874e9zdr46hma419s *   node01.netology.yc   Ready     Active         Leader           20.10.10
wevjg7aqzs4lg4zoj55c4h965     node02.netology.yc   Ready     Active         Reachable        20.10.10
r2jf2onbrnqxenk1giy6dkstt     node03.netology.yc   Ready     Active         Reachable        20.10.10
3kbygt8qxkqgg14k9vbkx6ks6     node04.netology.yc   Ready     Active                          20.10.10
zgnwa5cd7fuljtrbw6b25zbak     node05.netology.yc   Ready     Active                          20.10.10
kehprvdajqruubnqs9jw8pmsf     node06.netology.yc   Ready     Active                          20.10.10
```


## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```

```bash
centos@node01 ~]$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
xezqk0yjgwai   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
ipw9arh7aduw   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
k61b6g2j1hwp   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
nrbvcnhhzvxs   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
vr6hvw887sgy   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
5q9lizl5gu0p   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
i3ugnuddv786   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
ivfnr7dg1094   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```

## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```
* Автоматическая блокировка docker swarm, для защиты сертификатов TLS используемых для связей нод и ключа шифрования и дешифрования RAFT которые хранятся локально в памяти каждого узла кластера после перезапуска docker swarm.
```bash
[centos@node03 ~]$ sudo docker swarm update --autolock=true
Swarm updated.
[centos@node03 ~]$ sudo systemctl restart docker
[centos@node03 ~]$ sudo docker service ls
Error response from daemon: Swarm is encrypted and needs to be unlocked before it can be used. Please use "docker swarm unlock" to unlock it.
[centos@node03 ~]$ sudo docker swarm unlock
Please enter unlock key:
[centos@node03 ~]$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
xezqk0yjgwai   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
ipw9arh7aduw   swarm_monitoring_caddy              replicated   0/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
k61b6g2j1hwp   swarm_monitoring_cadvisor           global       5/5        google/cadvisor:latest
nrbvcnhhzvxs   swarm_monitoring_dockerd-exporter   global       5/5        stefanprodan/caddy:latest
vr6hvw887sgy   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
5q9lizl5gu0p   swarm_monitoring_node-exporter      global       5/5        stefanprodan/swarmprom-node-exporter:v0.16.0
i3ugnuddv786   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
ivfnr7dg1094   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```
