# Домашнее задание к занятию "13.3 работа с kubectl"
## Задание 1: проверить работоспособность каждого компонента
Для проверки работы можно использовать 2 способа: port-forward и exec. Используя оба способа, проверьте каждый компонент:

- - -

* сделайте запросы к бекенду;

    ![pods](./screenshots/get_pods.png)

    ![backend_request](./screenshots/backend_request.png)

    ![backend_exec](./screenshots/backend_exec.png)

- - -

* сделайте запросы к фронту;

    ![frontend_port-forward](./screenshots/frontend_port-forward.png)

    ![frontend_request](./screenshots/frontend_request.png)

    ![frontend_exec](./screenshots/frontend_exec.png)

- - -

* подключитесь к базе данных.

    ![postgres_port-forward](./screenshots/postgres_port-forward.png)

    ![postgres_requeest](./screenshots/postgres_request.png)

    ![postgres_exec](./screenshots/postgres_exec.png)

- - -

## Задание 2: ручное масштабирование

При работе с приложением иногда может потребоваться вручную добавить пару копий. Используя команду kubectl scale, попробуйте увеличить количество бекенда и фронта до 3. Проверьте, на каких нодах оказались копии после каждого действия (kubectl describe, kubectl get pods -o wide). После уменьшите количество копий до 1.

![scale](./screenshots/scale.png)

---

