# Домашняя работа к занятию "14.1 Создание и использование секретов"

## Задача 1: Работа с секретами через утилиту kubectl в установленном minikube

Выполните приведённые ниже команды в консоли, получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать секрет?

```
openssl genrsa -out cert.key 4096
openssl req -x509 -new -key cert.key -days 3650 -out cert.crt \
-subj '/C=RU/ST=Moscow/L=Moscow/CN=server.local'
kubectl create secret tls domain-cert --cert=certs/cert.crt --key=certs/cert.key
```
![create_tls_secret](./screenshots/create_tls_cert.png)

### Как просмотреть список секретов?

```
kubectl get secrets
kubectl get secret
```
![kubectl_get_secrets](./screenshots/kubectl_get_secrets.png)

### Как просмотреть секрет?

```
kubectl get secret domain-cert
kubectl describe secret domain-cert
```
![kubectl_get_secret](./screenshots/kubectl_get_secret.png)

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get secret domain-cert -o yaml
kubectl get secret domain-cert -o json
```
* Вывод большой, выгрузил в файл для ответа на следующий вопрос.

### Как выгрузить секрет и сохранить его в файл?

```
kubectl get secrets -o json > secrets.json
kubectl get secret domain-cert -o yaml > domain-cert.yml
```
[domain-cert.yaml](./cert/domain-cert.yaml)

[domain-cert.json](./cert/domain-cert.json)

### Как удалить секрет?

```
kubectl delete secret domain-cert
```
![delete_secret](./screenshots/delete_secrets.png)

### Как загрузить секрет из файла?

```
kubectl apply -f domain-cert.yml
```
![insert_secret](./screenshots/insert_secret.png)

## Задача 2 (*): Работа с секретами внутри модуля

Выберите любимый образ контейнера, подключите секреты и проверьте их доступность
как в виде переменных окружения, так и в виде примонтированного тома.

[busybox.yaml](./busybox.yaml)

![env_secrets](./screenshots/env_secrets.png)

---

