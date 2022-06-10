# Домашнее задание к занятию "12.4 Развертывание кластера на собственных серверах, лекция 2"
Новые проекты пошли стабильным потоком. Каждый проект требует себе несколько кластеров: под тесты и продуктив. Делать все руками — не вариант, поэтому стоит автоматизировать подготовку новых кластеров.

## Задание 1: Подготовить инвентарь kubespray
Новые тестовые кластеры требуют типичных простых настроек. Нужно подготовить инвентарь и проверить его работу. Требования к инвентарю:
* подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды;
* в качестве CRI — containerd;
* запуск etcd производить на мастере.

- - -

* Control Plane
```bash
emil@master1:~$ kubectl version
Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.7", GitCommit:"42c05a547468804b2053ecf60a3bd15560362fc2", GitTreeState:"clean", BuildDate:"2022-05-24T12:30:55Z", GoVersion:"go1.17.10", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.7", GitCommit:"42c05a547468804b2053ecf60a3bd15560362fc2", GitTreeState:"clean", BuildDate:"2022-05-24T12:24:41Z", GoVersion:"go1.17.10", Compiler:"gc", Platform:"linux/amd64"}
emil@master1:~$ kubectl get nodes
NAME      STATUS   ROLES                  AGE   VERSION
master1   Ready    control-plane,master   38m   v1.23.7
worker1   Ready    <none>                 37m   v1.23.7
worker2   Ready    <none>                 37m   v1.23.7
worker3   Ready    <none>                 37m   v1.23.7
worker4   Ready    <none>                 37m   v1.23.7
```
* Local PC
```bash
(20:37:25 on master)──> kubectl get nodes
NAME      STATUS   ROLES                  AGE   VERSION
master1   Ready    control-plane,master   40m   v1.23.7
worker1   Ready    <none>                 38m   v1.23.7
worker2   Ready    <none>                 38m   v1.23.7
worker3   Ready    <none>                 38m   v1.23.7
worker4   Ready    <none>                 38m   v1.23.7
```
Для добавление адреса Control Plane node в сертификат для удаленного подключения, необходимо отредактировать файл [k8s-cluster.yml](k8s-cluster.yml)
```
supplementary_addresses_in_ssl_keys: [51.250.10.100]
```
- - -

## Задание 2 (*): подготовить и проверить инвентарь для кластера в AWS
Часть новых проектов хотят запускать на мощностях AWS. Требования похожи:
* разворачивать 5 нод: 1 мастер и 4 рабочие ноды;
* работать должны на минимально допустимых EC2 — t3.small.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
