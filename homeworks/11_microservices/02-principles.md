
# Домашнее задание к занятию "11.02 Микросервисы: принципы"

Вы работаете в крупной компанию, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps специалисту необходимо выдвинуть предложение по организации инфраструктуры, для разработки и эксплуатации.

## Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- Маршрутизация запросов к нужному сервису на основе конфигурации
- Возможность проверки аутентификационной информации в запросах
- Обеспечение терминации HTTPS

Обоснуйте свой выбор.

- - -
|Решение     | Маршрутизация запросов | Аутентификация информации в запросах| Терминация HTTPS |
|:-----------|:----------------------:|:-----------------------------------:|:----------------:|
|Nginx       |           +            |                +                    |         +        |
|Kong        |           +            |                +                    |         +        |
|Tyk         |           +            |                +                    |         +        |
|Apigee      |           +            |                +                    |         +        |
|Yandex API Gateway|     +            |                +                    |         +        |


Все перечисленные решения ссответсвуют заявленным требованиям. На мой взгляд наибольшим функционалом обладают системы Kong и Apigee. Бесплатного функционала Kong должно хватить для решения поставленных задач.
- - -


## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- Поддержка кластеризации для обеспечения надежности
- Хранение сообщений на диске в процессе доставки
- Высокая скорость работы
- Поддержка различных форматов сообщений
- Разделение прав доступа к различным потокам сообщений
- Протота эксплуатации

Обоснуйте свой выбор.

- - -
|Решение     | Поддержка кластеризации | Хранение сообщений на диске| Высокая скорость | Поддержка различных форматов | Разделение прав доступа | Проcтота эксплуатации |
|:-----------|:-----------------------:|:--------------------------:|:----------------:|:----------------------------:|:-----------------------:|:---------------------:|
|Kafka       |          +              |               +            |         +        |               +              |             +           |           +           |
|NATS        |          +              |               +            |         +        |               +              |             +           |           +           |
|RabbitMQ    |          +              |               +            |         +        |               +              |             +           |           +           |
|Redis       |          +              |               -            |         +        |               +              |             +           |           +           |
|Qpid        |          +              |               +            |         -        |               +              |             +           |           -           | 

Заявленным требованиям соответсвуют следующие системы: Kafka, NATS, RabbitMQ. На мой взгляд для решения поставленных задач лучше выбрать Kafka как наиболее надежную и масштабируемую систему.
- - -