# Домашняя работа к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume,
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

```bash
version: '3.1'

services:

  db:
    image: postgres:12
    restart: always
    environment:
      POSTGRES_PASSWORD: netology21
    volumes:
      - psql-data:/var/lib/postgresql/data
      - psql-backup:/var/lib/postgresql/backup
    ports: #To connect
      - "5432:5432"

volumes:
  psql-data:
  psql-backup:

```
## Задача 2

В БД из задачи 1:
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db


```bash
postgres=\# CREATE DATABASE test_db;
postgres=\# CREATE USER test_admin_user;
postgres=\# CREATE USER test_simple_user;
postgres=\# \c test_db

test_db=\# CREATE TABLE orders (
id SERIAL PRIMARY KEY,
name TEXT,
price INTEGER
);

test_db=\# CREATE TABLE clients (
id SERIAL PRIMARY KEY,
lastname VARCHAR(20),
country VARCHAR(30),
order_id INTEGER REFERENCES orders
);



test_db=\# \l
                                    List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |      Access privileges
-----------+----------+----------+------------+------------+------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                 +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                 +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                +
           |          |          |            |            | postgres=CTc/postgres       +
           |          |          |            |            | test_admin_user=CTc/postgres


 test_db=\# \d
                List of relations
  Schema |      Name      |   Type   |  Owner
 --------+----------------+----------+----------
  public | clients        | table    | postgres
  public | clients_id_seq | sequence | postgres
  public | orders         | table    | postgres
  public | orders_id_seq  | sequence | postgres
 (4 rows)

 test_db=\# GRANT ALL ON ALL TABLES IN SCHEMA public TO test_simple_user;
 test_db=\# ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO test_simple_user;
 test_db=\# SELECT table_catalog, table_schema, table_name, privilege_type
 FROM information_schema.table_privileges
 WHERE grantee = 'test_admin_user';
  table_catalog | table_schema | table_name | privilege_type
 ---------------+--------------+------------+----------------
  test_db       | public       | orders     | INSERT
  test_db       | public       | orders     | SELECT
  test_db       | public       | orders     | UPDATE
  test_db       | public       | orders     | DELETE
  test_db       | public       | orders     | TRUNCATE
  test_db       | public       | orders     | REFERENCES
  test_db       | public       | orders     | TRIGGER
  test_db       | public       | clients    | INSERT
  test_db       | public       | clients    | SELECT
  test_db       | public       | clients    | UPDATE
  test_db       | public       | clients    | DELETE
  test_db       | public       | clients    | TRUNCATE
  test_db       | public       | clients    | REFERENCES
  test_db       | public       | clients    | TRIGGER
 (14 rows)

 test_db=\# GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO test_simple_user;
 test_db=\# ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO test_simple_user;
 test_db=\# SELECT table_catalog, table_schema, table_name, privilege_type
FROM information_schema.table_privileges
WHERE grantee = 'test_simple_user';
 table_catalog | table_schema | table_name | privilege_type
---------------+--------------+------------+----------------
 test_db       | public       | orders     | INSERT
 test_db       | public       | orders     | SELECT
 test_db       | public       | orders     | UPDATE
 test_db       | public       | orders     | DELETE
 test_db       | public       | clients    | INSERT
 test_db       | public       | clients    | SELECT
 test_db       | public       | clients    | UPDATE
 test_db       | public       | clients    | DELETE
(8 rows)
```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы
- приведите в ответе:
    - запросы
    - результаты их выполнения.

```bash
test_db=\# INSERT INTO orders (id, name, price) VALUES
(1, 'Шоколад', 10),
(2, 'Принтер', 3000),
(3, 'Книга', 500),
(4, 'Монитор', 7000),
(5, 'Гитара', 4000);
INSERT 0 5
test_db=\# SELECT * FROM orders;
 id |  name   | price
----+---------+-------
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
(5 rows)

test_db=\# INSERT INTO clients (id, lastname, country, order_id) VALUES
(1, 'Иванов Иван Иванович', 'USA', null),
(2, 'Петров Петр Петрович', 'Canada', null),
(3, 'Иоганн Себастьян Бах', 'Japan', null),
(4, 'Ронни Джеймс Дио', 'Russia', null),
(5, 'Ritchie Blackmore', 'Russia', null);
INSERT 0 5
test_db=\# SELECT * FROM clients;
 id |       lastname       | country | order_id
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |
  2 | Петров Петр Петрович | Canada  |
  3 | Иоганн Себастьян Бах | Japan   |
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
(5 rows)

test_db=\# SELECT count(*) FROM orders;
 count
-------
     5
(1 row)

test_db=\# SELECT count(*) FROM clients;
 count
-------
     5
(1 row)
```
## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.
```bash
test_db=\# UPDATE clients
SET order_id = ord.id
FROM (
SELECT id
FROM orders
WHERE name = 'Книга' ) as ord
WHERE lastname = 'Иванов Иван Иванович';

test_db=\# UPDATE clients
SET order_id = ord.id
FROM (
SELECT id
FROM orders
WHERE name = 'Монитор' ) as ord
WHERE lastname = 'Петров Петр Петрович';

test_db=\# UPDATE clients
SET order_id = ord.id
FROM (
SELECT id
FROM orders
WHERE name = 'Гитара' ) as ord
WHERE lastname = 'Иоганн Себастьян Бах';

```
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```bash
test_db=\# SELECT clients.id, clients.lastname, orders.name
FROM clients
JOIN orders
ON orders.id = clients.order_id;
 id |       lastname       |  name
----+----------------------+---------
  1 | Иванов Иван Иванович | Книга
  2 | Петров Петр Петрович | Монитор
  3 | Иоганн Себастьян Бах | Гитара
(3 rows)
```


## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

```bash

test_db=# EXPLAIN SELECT clients.id, clients.lastname, orders.name
FROM clients
JOIN orders
ON orders.id = clients.order_id;
                              QUERY PLAN
-----------------------------------------------------------------------
 Hash Join  (cost=37.00..52.93 rows=470 width=94)
   Hash Cond: (clients.order_id = orders.id)
   ->  Seq Scan on clients  (cost=0.00..14.70 rows=470 width=66)
   ->  Hash  (cost=22.00..22.00 rows=1200 width=36)
         ->  Seq Scan on orders  (cost=0.00..22.00 rows=1200 width=36)
(5 rows)
```
  * Фильтр "WHERE" выполняется последовательное сканирование указаных таблиц на совпадению заданному условию.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

```bash
docker exec -it 02-sql_db_1 bash
  pg_dump -U postgres test_db > /var/lib/postgresql/backup/test_db.sql_db_1
docker-compose stop
--name new_psql \
-e POSTGRES_PASSWORD=netology21 \
-v psql-backup:/var/lib/postgresql/backup \
postgres:14
docker exec -it new_psql bash
  psql -U postgres
    CREATE DATABASE test_db
  psql -U postgres test_db < /var/lib/postgresql/backup/test_db.sql
  psql -U postgres
    \c test_db
    test_db=\# SELECT * FROM clients;
    id |       lastname       | country | order_id
    ----+----------------------+---------+----------
    4 | Ронни Джеймс Дио     | Russia  |
    5 | Ritchie Blackmore    | Russia  |
    1 | Иванов Иван Иванович | USA     |        3
    2 | Петров Петр Петрович | Canada  |        4
    3 | Иоганн Себастьян Бах | Japan   |        5
    (5 rows)

```


---
