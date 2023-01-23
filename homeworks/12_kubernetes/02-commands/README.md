# Домашнее задание к занятию "12.2 Команды для работы с Kubernetes"
Кластер — это сложная система, с которой крайне редко работает один человек. Квалифицированный devops умеет наладить работу всей команды, занимающейся каким-либо сервисом.
После знакомства с кластером вас попросили выдать доступ нескольким разработчикам. Помимо этого требуется служебный аккаунт для просмотра логов.

## Задание 1: Запуск пода из образа в деплойменте
Для начала следует разобраться с прямым запуском приложений из консоли. Такой подход поможет быстро развернуть инструменты отладки в кластере. Требуется запустить деплоймент на основе образа из hello world уже через deployment. Сразу стоит запустить 2 копии приложения (replicas=2). 

Требования:
 * пример из hello world запущен в качестве deployment
 * количество реплик в deployment установлено в 2
 * наличие deployment можно проверить командой kubectl get deployment
 * наличие подов можно проверить командой kubectl get pods

- - -

* Манифест `deployment` [hello-world.yaml](./hello-world.yaml)
```bash
root@netology-12:~# kubectl create namespace app-namespace
namespace/app-namespace created
root@netology-12:~# kubectl apply -f hello-world.yaml
deployment.apps/hello-world created
root@netology-12:~# kubectl get deployment
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
hello-world   2/2     2            2           11s
root@netology-12:~# kubectl get pods
NAME                           READY   STATUS    RESTARTS   AGE
hello-world-5c6748dcbc-hhh4d   1/1     Running   0          22s
hello-world-5c6748dcbc-l45mg   1/1     Running   0          22s
```
- - -

## Задание 2: Просмотр логов для разработки
Разработчикам крайне важно получать обратную связь от штатно работающего приложения и, еще важнее, об ошибках в его работе. 
Требуется создать пользователя и выдать ему доступ на чтение конфигурации и логов подов в app-namespace.

Требования: 
 * создан новый токен доступа для пользователя
 * пользователь прописан в локальный конфиг (~/.kube/config, блок users)
 * пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod <pod_id>)

- - - 
* Манифест [ServiceAccount](./serviceaccount.yaml)
* Манифест [Role](./role.yml)
* Манифест [RoleBinding](role-binding.yaml)

* Создание ServiceAccount, создание роли доступа, присвоение роли доступа созданному **ServiceAccount**: `netology`
```bash
root@netology-12:~# kubectl apply -f serviceaccount.yaml -f role.yaml -f role-binding.yaml -n app-namespace
serviceaccount/netology created
role.rbac.authorization.k8s.io/pod-reader created
rolebinding.rbac.authorization.k8s.io/read-pods created
```
* Проверяем наличие токена у созданного **ServiceAccount**: `netology`
```bash
root@netology-12:~# kubectl get secret -n app-namespace
NAME                   TYPE                                  DATA   AGE
default-token-nt7m2    kubernetes.io/service-account-token   3      55m
netology-token-nq8sz   kubernetes.io/service-account-token   3      13m
```

* Просмотр подов, логов, дополнительных сведений из под созданного **ServiceAccount**: `netology`
```bash
root@netology-12:~# kubectl get pods -n app-namespace --as=system:serviceaccount:app-namespace:netology
NAME                           READY   STATUS    RESTARTS   AGE
hello-world-5c6748dcbc-48jlg   1/1     Running   0          14s
hello-world-5c6748dcbc-6z9mp   1/1     Running   0          116s
hello-world-5c6748dcbc-99ngm   1/1     Running   0          116s
hello-world-5c6748dcbc-9q9jz   1/1     Running   0          14s
hello-world-5c6748dcbc-vthtk   1/1     Running   0          14s
root@netology-12:~# kubectl logs hello-world-5c6748dcbc-99ngm -n app-namespace --as=system:serviceaccount:app-namespace:netology
root@netology-12:~# kubectl describe pods hello-world-5c6748dcbc-99ngm -n app-namespace --as=system:serviceaccount:app-namespace:netology
Name:         hello-world-5c6748dcbc-99ngm
Namespace:    app-namespace
Priority:     0
Node:         netology-12/10.128.0.20
Start Time:   Fri, 03 Jun 2022 19:59:46 +0000
Labels:       app=hello-world
              pod-template-hash=5c6748dcbc
Annotations:  <none>
Status:       Running
IP:           172.17.0.9
IPs:
  IP:           172.17.0.9
Controlled By:  ReplicaSet/hello-world-5c6748dcbc
Containers:
  hello-world:
    Container ID:   docker://27f099df3b27a06bfd316dfed1487939ffc0fcba32b86d9ad79de063ecbf065f
    Image:          k8s.gcr.io/echoserver:1.4
    Image ID:       docker-pullable://k8s.gcr.io/echoserver@sha256:5d99aa1120524c801bc8c1a7077e8f5ec122ba16b6dda1a5d3826057f67b9bcb
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Fri, 03 Jun 2022 19:59:48 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-klhqx (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-klhqx:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:                      <none>
```
* Проверка прав доступа **ServiceAccount**: `netology` на редактирование и удаление подов.
```bash
root@netology-12:~# kubectl scale --replicas=3 deploy hello-world -n app-namespace --as=system:serviceaccount:app-namespace:netology
Error from server (Forbidden): deployments.apps "hello-world" is forbidden: User "system:serviceaccount:app-namespace:netology" cannot get resource "deployments" in API group "apps" in the namespace "app-namespace"
root@netology-12:~# kubectl delete pods hello-world-5c6748dcbc-99ngm -n app-namespace --as=system:serviceaccount:app-namespace:netology
Error from server (Forbidden): pods "hello-world-5c6748dcbc-99ngm" is forbidden: User "system:serviceaccount:app-namespace:netology" cannot delete resource "pods" in API group "" in the namespace "app-namespace"
```
- - -

## Задание 3: Изменение количества реплик 
Поработав с приложением, вы получили запрос на увеличение количества реплик приложения для нагрузки. Необходимо изменить запущенный deployment, увеличив количество реплик до 5. Посмотрите статус запущенных подов после увеличения реплик. 

Требования:
 * в deployment из задания 1 изменено количество реплик на 5
 * проверить что все поды перешли в статус running (kubectl get pods)

```bash
root@netology-12:~# kubectl scale --replicas=5 deployment/hello-world -n app-namespace
deployment.apps/hello-world scaled
root@netology-12:~# kubectl get pods -n app-namespace
NAME                           READY   STATUS    RESTARTS   AGE
hello-world-5c6748dcbc-5kvrf   1/1     Running   0          10s
hello-world-5c6748dcbc-9nqhd   1/1     Running   0          10s
hello-world-5c6748dcbc-dhkd2   1/1     Running   0          10s
hello-world-5c6748dcbc-hhh4d   1/1     Running   0          94s
hello-world-5c6748dcbc-l45mg   1/1     Running   0          94s
```

## Полезный мариал:
https://kubernetes.io/docs/reference/access-authn-authz/rbac/  
https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/#apply
https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
https://www.ibm.com/docs/en/cloud-paks/cp-management/2.0.0?topic=kubectl-using-service-account-tokens-connect-api-server

---
