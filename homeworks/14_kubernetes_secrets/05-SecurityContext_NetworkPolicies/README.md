# Домашняя работа к занятию "14.5 SecurityContext, NetworkPolicies"

## Задача 1: Рассмотрите пример 14.5/example-security-context.yml

Создайте модуль

```
kubectl apply -f 14.5/example-security-context.yml
```

Проверьте установленные настройки внутри контейнера

![SC_logs](./screenshots/SC_logs.png)

```
kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
```

## Задача 2 (*): Рассмотрите пример 14.5/example-network-policy.yml

Создайте два модуля. Для первого модуля разрешите доступ к внешнему миру
и ко второму контейнеру. Для второго модуля разрешите связь только с
первым контейнером. Проверьте корректность настроек.

1. Запускаем поды:
    * [app1.yml](./NetworkPolicies/app1.yml)
    * [app2.yml](./NetworkPolicies/app2.yml)

    ![nc_create_pods](./screenshots/nc_create_pods.png)

2. Проверяем доступ к сети Интернет и между подами:

    ![nc_check_access](./screenshots/nc_check_access.png)

3. Применяем политики на блокировку всего входящего и исходящего трафика и проверяем доступ к сети Интернет и между подами:

    * [00-deny-egress-all.yml](./NetworkPolicies/Policies/Egress/00-deny-egress-all.yml)
    * [00-deny-ingress-all.yml](./NetworkPolicies/Policies/Ingress/00-deny-ingress-all.yml)

    ![apply_default_policies](./screenshots/apply_default_policies.png)

    ![nc_deny_all](./screenshots/nc_deny_all.png)

4. Открываем доступ для пода `app1` в сеть Интернет и проверяем:

    * [01-allow-inet-app1.yml](./NetworkPolicies/Policies/Egress/01-allow-inet-app1.yml)

    ![nc_allow_inet_app1](./screenshots/nc_allow_inet_app1.png)

5. Открываем доступ поду `app1` до пода `app2`, на поде `app2` разрешаем входящий трафик от `app1`:

    * [02-allow-icmp-app1.yml](./NetworkPolicies/Policies/Egress/02-allow-icmp-app1.yml)
    * [01-allow-icmp-app2.yml](./NetworkPolicies/Policies/Ingress/01-allow-icmp-app2.yml)

    ![nc_allow_app1_to_app2](./screenshots/nc_allow_app1_to_app2.png)

6. Открываем доступ поду `app2` до пода `app1`, на поде `app1` разрешаем входящий трафик от `app2`:

    * [03-allow-icmp-app2.yml](./NetworkPolicies/Policies/Egress/03-allow-icmp-app2.yml)
    * [02-allow-icmp-app1.yml](./NetworkPolicies/Policies/Ingress/02-allow-icmp-app1.yml)

    ![nc_allow_app2_to_app1](./screenshots/nc_allow_app2_to_app1.png)
