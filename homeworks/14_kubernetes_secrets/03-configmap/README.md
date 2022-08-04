# Домашняя работа к занятию "14.3 Карты конфигураций"

## Задача 1: Работа с картами конфигураций через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать карту конфигураций?

```
kubectl create configmap nginx-config --from-file=nginx.conf
kubectl create configmap domain --from-literal=name=netology.ru
```
![create_cm](./screenshots/create_cm.png)

### Как просмотреть список карт конфигураций?

```
kubectl get configmaps
kubectl get configmap
```
![get_cm](./screenshots/get_configmap.png)

### Как просмотреть карту конфигурации?

```
kubectl get configmap nginx-config
kubectl describe configmap domain
```
![describe_cm](./screenshots/describe_cm.png)

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get configmap nginx-config -o yaml
kubectl get configmap domain -o json
```
![get_info_cm](./screenshots/get_info_cm.png)

### Как выгрузить карту конфигурации и сохранить его в файл?

```
kubectl get configmaps -o json > configmaps.json
kubectl get configmap nginx-config -o yaml > nginx-config.yml
```
* [configmaps.json](./configmaps.json)
* [nginx-config.yml](./nginx-config.yml)

### Как удалить карту конфигурации?

```
kubectl delete configmap nginx-config
```
![delete_cm](./screenshots/delete_cm.png)

### Как загрузить карту конфигурации из файла?

```
kubectl apply -f nginx-config.yml
```
![apply_cm](./screenshots/apply_cm.png)

---