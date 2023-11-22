### Домашнее задание к занятию 2. «MySQL» [Степанников Денис]

---

### Задача 1
Используя Docker, поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h`, получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из её вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.


### Решение:

**Манифест для docker-compose:**
```
version: '3.8'

services:
  mysql:
    image: mysql:8
    container_name: mysql-8
    environment:
      MYSQL_ROOT_PASSWORD: sdvpass
      MYSQL_DATABASE: test_db
    ports:
      - "3306:3306"
    volumes:
      - /var/lib/docker/volumes/infra/mysql:/var/lib/mysql

volumes:
  mysql_data:
```

**Запускаем контейнер:**
```
sudo docker-compose up -d
```
**Проверяем что контейнер запущен:**
```
sdv@sdvpg:~/mysql$ sudo docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                                                  NAMES
ea15d421edfe   mysql:8       "docker-entrypoint.s…"   3 minutes ago   Up 3 minutes   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   mysql-8
```
*Изучите бэкап БД и восстановитесь из него.*

**Скачиваем бэкап и помещаем его в persistent volume:**
```
sdv@sdvpg:~/mysql$ wget https://raw.githubusercontent.com/netology-code/virt-homeworks/virt-11/06-db-03-mysql/test_data/test_dump.sql
--2023-11-22 18:42:37--  https://raw.githubusercontent.com/netology-code/virt-homeworks/virt-11/06-db-03-mysql/test_data/test_dump.sql
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.110.133, 185.199.111.133, 185.199.108.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.110.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2073 (2.0K) [text/plain]
Saving to: ‘test_dump.sql’

test_dump.sql                                                100%[===========================================================================================================================================>]   2.02K  --.-KB/s    in 0s

2023-11-22 18:42:37 (32.4 MB/s) - ‘test_dump.sql’ saved [2073/2073]

sdv@sdvpg:~/mysql$ sudo cp ./test_dump.sql /var/lib/docker/volumes/infra/mysql
sdv@sdvpg:~/mysql$
```
*Перейдите в управляющую консоль mysql внутри контейнера.*
```
sdv@sdvpg:~/mysql$ sudo docker exec -it mysql-8 bash
bash-4.4# mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.2.0 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```
```
mysql> status
--------------
mysql  Ver 8.2.0 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          8
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.2.0 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 15 min 31 sec

Threads: 2  Questions: 6  Slow queries: 0  Opens: 119  Flush tables: 3  Open tables: 38  Queries per second avg: 0.006
--------------

mysql>
```
**Восстанавливаем базу из бэкапа**
```
bash-4.4# mysql -u root -p test_db < /var/lib/mysql/test_dump.sql
Enter password:
bash-4.4# mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 8.2.0 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```

*Приведите в ответе количество записей с price > 300:*
```
mysql> USE test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW TABLES;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)

mysql>
```
---
### Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:

- плагин авторизации mysql_native_password
- срок истечения пароля — 180 дней 
- количество попыток авторизации — 3 
- максимальное количество запросов в час — 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James".

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES, получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

### Решение:
*Создайте пользователя test в БД c паролем test-pass, используя:*

*плагин авторизации mysql_native_password*

*срок истечения пароля — 180 дней*

*количество попыток авторизации — 3*

*аттрибуты пользователя:*

*Фамилия "Pretty"*

*Имя "James".*

```
mysql> CREATE USER 'test'@'%' IDENTIFIED WITH mysql_native_password BY 'test-pass' PASSWORD EXPIRE INTERVAL 180 DAY FAILED_LOGIN_ATTEMPTS 3 ATTRIBUTE '{"Last Name": "Pretty", "First Name": "James"}';
Query OK, 0 rows affected (0.01 sec)

mysql>
```
*максимальное количество запросов в час — 100*
```
mysql> ALTER USER 'test'@'%' WITH MAX_QUERIES_PER_HOUR 100;
Query OK, 0 rows affected (0.02 sec)

mysql>
```
*Предоставьте привелегии пользователю test на операции SELECT базы test_db.*
```
mysql> GRANT SELECT ON test_db.* TO 'test'@'%';
Query OK, 0 rows affected (0.01 sec)

mysql>
```
*Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES, получите данные по пользователю test и приведите в ответе к задаче.*
```
mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user = 'test';
+------+------+------------------------------------------------+
| USER | HOST | ATTRIBUTE                                      |
+------+------+------------------------------------------------+
| test | %    | {"Last Name": "Pretty", "First Name": "James"} |
+------+------+------------------------------------------------+
1 row in set (0.00 sec)

mysql>
```

---
### Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`,
- на `InnoDB`.

### Решение:
*Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES; Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.*

**Используется InnDB**
```
mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show table status like 'orders';
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
| orders | InnoDB |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2023-11-22 18:54:18 | NULL        | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.02 sec)

mysql>
```
*Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:*

*- на `MyISAM`,*

*- на `InnoDB`.*

```
mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show table status like 'orders';
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
| orders | InnoDB |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2023-11-22 18:54:18 | NULL        | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.02 sec)

mysql> set profiling =1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> select * from orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)

mysql> show profiles;
+----------+------------+----------------------+
| Query_ID | Duration   | Query                |
+----------+------------+----------------------+
|        1 | 0.00028675 | select * from orders |
+----------+------------+----------------------+
1 row in set, 1 warning (0.00 sec)

mysql> alter table orders engine = MyISAM;
Query OK, 5 rows affected (0.17 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> select * from orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)

mysql> show profiles;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|        1 | 0.00028675 | select * from orders               |
|        2 | 0.17190200 | alter table orders engine = MyISAM |
|        3 | 0.00026250 | select * from orders               |
+----------+------------+------------------------------------+
3 rows in set, 1 warning (0.00 sec)

mysql> show table status like 'orders';
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
| orders | MyISAM |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2023-11-22 19:43:22 | NULL        | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.00 sec)

mysql>
```

### Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):

- скорость IO важнее сохранности данных;
- нужна компрессия таблиц для экономии места на диске;
- размер буффера с незакомиченными транзакциями 1 Мб;
- буффер кеширования 30% от ОЗУ;
- размер файла логов операций 100 Мб.

Приведите в ответе изменённый файл `my.cnf`.

---
### Решение

Создадим файл /etc/mysql/conf.d/my.cnf следующего содержания:

```
[mysqld]
# Увеличиваем способность работы движка InnoDB с операциями ввода/вывода с 200 (по умолчанию) до 1000
innodb_io_capacity = 1000

# Исходя из документации документации компрессия работает только с включенной опцией innodb_file_per_table
innodb_file_per_table = 1

# задаем уровень компрессии.
innodb_compression_level = 7

# Устанавливаем размер буфера для незакомиченных транзакций в 1 Мб
innodb_log_buffer_size = 1M

# Задаем буффер кеширования в 30% от ОЗУ (от 1,8GB лимита на контейнер с MySQL)
innodb_buffer_pool_size = 540M

# Задаем размер файла логов операций 100 Мб
innodb_redo_log_capacity = 100M
```

```
bash-4.4# touch my.cnf
bash-4.4# echo "[mysqld]" > /etc/mysql/conf.d/my.cnf
bash-4.4# echo "# Увеличиваем способность работы движка InnoDB с операциями ввода/вывода с 200 (по умолчанию) до 1000" >> /etc/mysql/conf.d/my.cnf
bash-4.4# echo "innodb_io_capacity = 1000"  >> /etc/mysql/conf.d/my.cnf
bash-4.4# echo "# Исходя из документации документации компрессия работает только с включенной опцией innodb_file_per_table" >> /etc/mysql/conf.d/my.cnf
bash-4.4# echo "innodb_file_per_table = 1" >> /etc/mysql/conf.d/my.cnf
bash-4.4# echo "# задаем уровень компрессии." >> /etc/mysql/conf.d/my.cnf
bash-4.4# echo "innodb_compression_level = 7" >> /etc/mysql/conf.d/my.cnf
bash-4.4# echo "# Устанавливаем размер буфера для незакомиченных транзакций в 1 Мб" >> /etc/mysql/conf.d/my.cnf
bash-4.4# echo "innodb_log_buffer_size = 1M" >> /etc/mysql/conf.d/my.cnf
bash-4.4# echo "# Задаем буффер кеширования в 30% от ОЗУ (от 1,8GB лимита на контейнер с MySQL)" >> /etc/mysql/conf.d/my.cnf
bash-4.4# echo "innodb_buffer_pool_size = 540M" >> /etc/mysql/conf.d/my.cnf
bash-4.4# echo "# Задаем размер файла логов операций 100 Мб" >> /etc/mysql/conf.d/my.cnf
bash-4.4# echo "innodb_redo_log_capacity = 100M" >> /etc/mysql/conf.d/my.cnf
```
**Перезапускаем контейнер и проверяем конфигурацию**
```
sdv@sdvpg:~/mysql$ sudo docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS                         PORTS                                                  NAMES
19dea0863670   mysql:8       "docker-entrypoint.s…"   9 minutes ago   Up 9 minutes                   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   mysql-8

sdv@sdvpg:~/mysql$ sudo docker restart 19dea0863670
19dea0863670

sdv@sdvpg:~/mysql$ sudo docker exec -it mysql-8 bash

bash-4.4# mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.2.0 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show variables like '%compres%';
+---------------------------------------------+----------------------------------------+
| Variable_name                               | Value                                  |
+---------------------------------------------+----------------------------------------+
| binlog_transaction_compression              | OFF                                    |
| binlog_transaction_compression_level_zstd   | 3                                      |
| gtid_executed_compression_period            | 0                                      |
| have_compress                               | YES                                    |
| innodb_compression_failure_threshold_pct    | 5                                      |
| innodb_compression_level                    | 7                                      |
| innodb_compression_pad_pct_max              | 50                                     |
| innodb_log_compressed_pages                 | ON                                     |
| mysqlx_compression_algorithms               | DEFLATE_STREAM,LZ4_MESSAGE,ZSTD_STREAM |
| mysqlx_deflate_default_compression_level    | 3                                      |
| mysqlx_deflate_max_client_compression_level | 5                                      |
| mysqlx_lz4_default_compression_level        | 2                                      |
| mysqlx_lz4_max_client_compression_level     | 8                                      |
| mysqlx_zstd_default_compression_level       | 3                                      |
| mysqlx_zstd_max_client_compression_level    | 11                                     |
| protocol_compression_algorithms             | zlib,zstd,uncompressed                 |
| replica_compressed_protocol                 | OFF                                    |
| slave_compressed_protocol                   | OFF                                    |
+---------------------------------------------+----------------------------------------+
18 rows in set (0.00 sec)

mysql>
```