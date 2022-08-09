# Домашняя работа к занятию "14.4 Сервис-аккаунты"

## Задача 1: Работа с сервис-аккаунтами через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать сервис-аккаунт?

```
kubectl create serviceaccount netology
```
![create_svc](./screenshots/create_svc.png)

### Как просмотреть список сервис-акаунтов?

```
kubectl get serviceaccounts
kubectl get serviceaccount
```
![get_svc](./screenshots/get_svc.png)

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get serviceaccount netology -o yaml
kubectl get serviceaccount default -o json
```
![save_svc_yml_json](./screenshots/get_svc_yml_json.png)

### Как выгрузить сервис-акаунты и сохранить его в файл?

```
kubectl get serviceaccounts -o json > serviceaccounts.json
kubectl get serviceaccount netology -o yaml > netology.yml
```
![save_to_file](./screenshots/save_to_file.png)

* [serviceaccounts.json](./serviceaccounts.json)
* [netology.yml](netology.yml)

### Как удалить сервис-акаунт?

```
kubectl delete serviceaccount netology
```
![delete_svc](./screenshots/delete_svc.png)

### Как загрузить сервис-акаунт из файла?

```
kubectl apply -f netology.yml
```
![apply_svc](./screenshots/apply_svc.png)

## Задача 2 (*): Работа с сервис-акаунтами внутри модуля

Выбрать любимый образ контейнера, подключить сервис-акаунты и проверить
доступность API Kubernetes

```
kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
```
![run_fedora](./screenshots/2_run_fedora.png)

Просмотреть переменные среды

```
env | grep KUBE
```
![view_fedora](./screenshots/2_view_env.png)

Получить значения переменных

```
K8S=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
SADIR=/var/run/secrets/kubernetes.io/serviceaccount
TOKEN=$(cat $SADIR/token)
CACERT=$SADIR/ca.crt
NAMESPACE=$(cat $SADIR/namespace)
```
![get_env](./screenshots/2_get_env.png)

Подключаемся к API

```
curl -H "Authorization: Bearer $TOKEN" --cacert $CACERT $K8S/api/v1/
```
![connect_API](./screenshots/2_connect_API.png)


В случае с minikube может быть другой адрес и порт, который можно взять здесь

```
cat ~/.kube/config
```

или здесь

```
kubectl cluster-info
```

---