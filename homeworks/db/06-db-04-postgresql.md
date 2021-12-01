# Домашняя работа к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
  * `\l[+]   [PATTERN]      list databases`
- подключения к БД
  * `\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo} connect to new database (currently "postgres")`
- вывода списка таблиц
  * `  \dt[S+] [PATTERN] list tables`
- вывода описания содержимого таблиц
  * `\d[S+]  NAME   describe table, view, sequence, or index`
- выхода из psql
  * ` \q  quit psql`

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders`
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
```
test_database=# SELECT attname, avg_width
test_database-# FROM pg_stats
test_database-# WHERE avg_width = (
test_database(# SELECT MAX(avg_width)
test_database(# FROM pg_stats
test_database(# WHERE tablename='orders');
 attname | avg_width
---------+-----------
 title   |        16
(1 row)
```
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

```
test_database=# BEGIN;
BEGIN
test_database=*# CREATE TABLE orders_part (
id int not null,
title varchar (80) not null,
price int
) PARTITION BY RANGE (price);
CREATE TABLE
test_database=*# CREATE TABLE orders_1 PARTITION OF orders_part
FOR VALUES FROM (499) TO (9999999);
CREATE TABLE
test_database=*# CREATE TABLE orders_2 PARTITION OF orders_part
FOR VALUES FROM (0) TO (499);
CREATE TABLE
test_database=*# INSERT INTO orders_part SELECT * FROM orders;
INSERT 0 8
test_database=*# COMMIT;
```

* Результат

```
test_database=# SELECT * FROM orders_1;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  7 | Me and my bash-pet |   499
  8 | Dbiezdmin          |   501
(4 rows)

test_database=# SELECT * FROM orders_2;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
(4 rows)
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
  * Как я вижу, можно было при определении таблицы   можно было создать унаследованные таблицы и добавить правила на основную таблицу распределения:

* Создание таблиц

```
CREATE TABLE orders_1 (
CHECK ( price > 499 )
) INHERITS (orders);

CREATE TABLE orders_2 (
CHECK ( price <= 499 )
) INHERITS (orders);
```

* Правила распределения

```
CREATE RULE orders_more_499 AS ON INSERT TO orders WHERE (price > 499) DO INSTEAD INSER
T INTO orders_1 VALUES (NEW.*);

CREATE RULE orders_smaller_499 AS ON INSERT TO orders WHERE (price <= 499) DO INSTEAD
INSERT INTO orders_2 VALUES (NEW.*);
```


## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

```
pg_dump postgresql://postgres:netology21@localhost:5432/test_database > /var/lib/postgresql/data/dump_test_database.sql
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?
```bash
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) UNIQUE NOT NULL,
    price integer DEFAULT 0
);
```

---
