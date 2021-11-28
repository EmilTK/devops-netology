# Домашняя работа к занятию "6.3. MySQL"

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.
```bash
mysql> \s
--------------
mysql  Ver 8.0.27 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          12
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.27 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 4 min 48 sec
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.
```bash
mysql> SELECT * FROM orders WHERE price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)
```
В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней
- количество попыток авторизации - 3
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

```bash
CREATE USER 'test'@'localhost'
 IDENTIFIED WITH mysql_native_password BY 'test-pass'
 WITH MAX_QUERIES_PER_HOUR 100
 PASSWORD EXPIRE INTERVAL 180 DAY
 FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 30
 ATTRIBUTE '{"firstname": "James", "lastname": "Pretty"}';
```

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
```bash
mysql> GRANT SELECT ON test.orders TO 'test'@'localhost';
```
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и
**приведите в ответе к задаче**.

```bash
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES
    -> WHERE USER='test' AND HOST='localhost';
+------+-----------+----------------------------------------------+
| USER | HOST      | ATTRIBUTE                                    |
+------+-----------+----------------------------------------------+
| test | localhost | {"lastname": "Pretty", "firstname": "James"} |
+------+-----------+----------------------------------------------+
1 row in set (0.00 sec)
```


## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

* `SHOW PROFILES` отображает список самых последних запросов, отправленных на сервер, по умолчанию 15 последних, данное значение устанавливается в переменной `profiling_history_size`;

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

```bash
mysql> show table status;
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time         | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| orders | InnoDB |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2021-11-28 14:19:39 | 2021-11-28 14:19:40 | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.00 sec)
```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

```bash
mysql> SHOW PROFILES;
+----------+------------+----------------------------------------------------------------+
| Query_ID | Duration   | Query                                                          |
+----------+------------+----------------------------------------------------------------+
|        1 | 0.09708850 | ALTER TABLE orders ENGINE=MyISAM                               |
|        2 | 0.01918025 | INSERT INTO orders (id, title, price) VALUES (6, 'test1', 250) |
|        3 | 0.13651125 | ALTER TABLE orders ENGINE=InnoDB                               |
|        4 | 0.05341750 | INSERT INTO orders (id, title, price) VALUES (7, 'test2', 250) |
+----------+------------+----------------------------------------------------------------+
```

## Задача 4

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

```bash
#Скорость IO важнее сохранности данных
innodb_flush_log_at_trx_commit = 2
##Нужна компрессия таблиц для экономии места на диске
innodb_file_per_table = 1
##Размер буфера с незаконченными транзакциями 1 Мб
innodb_log_buffer_size = 1M
##Буффер кеширования 30% от ОЗУ
innodb_buffer_pool_size = 1024М
##Размер файла логов операций 100 Мб
innodb_log_file_size = 100M
```
