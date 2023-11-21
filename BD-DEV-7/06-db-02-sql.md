### Домашнее задание к занятию 2. «SQL» [Степанников Денис]

---

### Задача 1
Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose-манифест.

### Решение:

**Манифест для docker-compose:**
```
version: '3'

services:
  postgres:
    image: postgres:12
    container_name: pgsql-12
    environment:
      POSTGRES_USER: dbadmin
      POSTGRES_PASSWORD: dbadmin
    volumes:
      - /var/lib/docker/volumes/infra/postgresql/data:/var/lib/postgresql/data
      - /var/lib/docker/volumes/infra/postgresql/backups:/backups
    ports:
      - "5432:5432"

```

### Задача 1

В БД из задачи 1:

* создайте пользователя test-admin-user и БД test_db;
* в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже);
* предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db;
* создайте пользователя test-simple-user;
* предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE этих таблиц БД test_db.

Таблица orders:

* id (serial primary key);
* наименование (string);
* цена (integer).

Таблица clients:

* id (serial primary key);
* фамилия (string);
* страна проживания (string, index);
* заказ (foreign key orders).

Приведите:

* итоговый список БД после выполнения пунктов выше;
* описание таблиц (describe);
* SQL-запрос для выдачи списка пользователей с правами над таблицами test_db;
* список пользователей с правами над таблицами test_db.

### Решение:

*создайте пользователя test-admin-user и БД test_db;*

```
sdv@sdvpg:~/pg$ sudo docker exec -it pgsql-12 bash
root@d7140b94885c:/# psql -U dbadmin
psql (12.17 (Debian 12.17-1.pgdg120+1))
Type "help" for help.

dbadmin=# CREATE USER "test-admin-user" WITH PASSWORD 'password';
CREATE ROLE
dbadmin=# CREATE DATABASE test_db;
CREATE DATABASE
```

*в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже);*
```
dbadmin=# \c test_db;
You are now connected to database "test_db" as user "dbadmin".
test_db=# CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    наименование VARCHAR(255),
    цена INTEGER
);
CREATE TABLE
test_db=# CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    фамилия VARCHAR(255),
    страна_проживания VARCHAR(255),
    заказ_id INTEGER REFERENCES orders(id)
);
CREATE TABLE
```

*предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db;*
```
test_db=# GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "test-admin-user";
GRANT
```

*создайте пользователя test-simple-user;*
```
test_db=# CREATE USER "test-simple-user" WITH PASSWORD 'password';
CREATE ROLE
```

*предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE этих таблиц БД test_db.*

```
test_db=# GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE orders, clients TO "test-simple-user";
GRANT
```
*Приведите итоговый список БД после выполнения пунктов выше;*
```
test_db=# \l
                               List of databases
   Name    |  Owner  | Encoding |  Collate   |   Ctype    |  Access privileges
-----------+---------+----------+------------+------------+---------------------
 dbadmin   | dbadmin | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | dbadmin | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | dbadmin | UTF8     | en_US.utf8 | en_US.utf8 | =c/dbadmin         +
           |         |          |            |            | dbadmin=CTc/dbadmin
 template1 | dbadmin | UTF8     | en_US.utf8 | en_US.utf8 | =c/dbadmin         +
           |         |          |            |            | dbadmin=CTc/dbadmin
 test_db   | dbadmin | UTF8     | en_US.utf8 | en_US.utf8 |
(5 rows)
```

*Приведите описание таблиц (describe);*
```
test_db=# \d orders
                                       Table "public.orders"
    Column    |          Type          | Collation | Nullable |              Default
--------------+------------------------+-----------+----------+------------------------------------
 id           | integer                |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying(255) |           |          |
 цена         | integer                |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_id_fkey" FOREIGN KEY ("заказ_id") REFERENCES orders(id)

```
*Приведите SQL-запрос для выдачи списка пользователей с правами над таблицами test_db;*
```
SELECT grantee
FROM information_schema.table_privileges
WHERE table_catalog = 'test_db'
GROUP BY grantee;
```
*Приведите список пользователей с правами над таблицами test_db.*
```
test_db=# SELECT grantee
FROM information_schema.table_privileges
WHERE table_catalog = 'test_db'
GROUP BY grantee;
     grantee
------------------
 PUBLIC
 dbadmin
 test-admin-user
 test-simple-user
(4 rows)
```



### Задача 3

Используя SQL-синтаксис, наполните таблицы следующими тестовыми данными:

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

Используя SQL-синтаксис:
- вычислите количество записей для каждой таблицы.

Приведите в ответе:

    - запросы,
    - результаты их выполнения.



### Решение:

*Используя SQL-синтаксис, наполните таблицы следующими тестовыми данными:*
```
dbadmin=# \c test_db
You are now connected to database "test_db" as user "dbadmin".
test_db=# INSERT INTO orders ("наименование", "цена")
VALUES
  ('Шоколад', 10),
  ('Принтер', 3000),
  ('Книга', 500),
  ('Монитор', 7000),
  ('Гитара', 400);
INSERT 0 5

test_db=# SELECT "наименование", "цена" FROM orders;
 наименование | цена
--------------+------
 Шоколад      |   10
 Принтер      | 3000
 Книга        |  500
 Монитор      | 7000
 Гитара       |  400
(5 rows)

test_db=# INSERT INTO clients ("фамилия", "страна_проживания")
VALUES
  ('Иванов Иван Иванович', 'USA'),
  ('Петров Петр Петрович', 'Canada'),
  ('Иоганн Себастьян Бах', 'Japan'),
  ('Ронни Джеймс Дио', 'Russia'),
  ('Ritchie Blackmore', 'Russia');
INSERT 0 5

test_db=# SELECT "фамилия", "страна_проживания" FROM clients;
       фамилия        | страна_проживания
----------------------+-------------------
 Иванов Иван Иванович | USA
 Петров Петр Петрович | Canada
 Иоганн Себастьян Бах | Japan
 Ронни Джеймс Дио     | Russia
 Ritchie Blackmore    | Russia
(5 rows)
```

*Используя SQL-синтаксис вычислите количество записей для каждой таблицы.*

```
test_db=# SELECT COUNT(*) FROM orders;
 count
-------
     5
(1 row)

test_db=# SELECT COUNT(*) FROM clients;
 count
-------
     5
(1 row)
```
### Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys, свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения этих операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод этого запроса.
 
Подсказка: используйте директиву `UPDATE`.

### Решение:

*Приведите SQL-запросы для выполнения этих операций.*

**Опция 1**
```
UPDATE clients
SET заказ_id = 4  
WHERE "фамилия" = 'Петров Петр Петрович';

UPDATE clients
SET заказ_id = 5  
WHERE "фамилия" = 'Иоганн Себастьян Бах';

UPDATE clients
SET заказ_id = 3  
WHERE "фамилия" = 'Иванов Иван Иванович';
```
**Опция 2**
```
UPDATE clients
SET заказ_id = CASE
    WHEN "фамилия" = 'Петров Петр Петрович' THEN 4
    WHEN "фамилия" = 'Иоганн Себастьян Бах' THEN 5
    WHEN "фамилия" = 'Иванов Иван Иванович' THEN 3
    ELSE заказ_id
END;
```

*Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод этого запроса.*

```
test_db=# SELECT *
FROM clients
WHERE заказ_id IS NOT NULL;
 id |       фамилия        | страна_проживания | заказ_id
----+----------------------+-------------------+----------
  2 | Петров Петр Петрович | Canada            |        4
  3 | Иоганн Себастьян Бах | Japan             |        5
  1 | Иванов Иван Иванович | USA               |        3
(3 rows)
```

### Задача 5
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните, что значат полученные значения.

### Решение:

```
test_db=# explain analyze SELECT *
FROM clients
WHERE заказ_id IS NOT NULL;
                                              QUERY PLAN
------------------------------------------------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..10.70 rows=70 width=1040) (actual time=0.014..0.015 rows=3 loops=1)
   Filter: ("заказ_id" IS NOT NULL)
   Rows Removed by Filter: 2
 Planning Time: 0.037 ms
 Execution Time: 0.026 ms
(5 rows)
```
1. `Seq Scan on clients:` - последовательный скан (Seq Scan), т.е. полный проход по таблице для выполнения запроса.
2. `cost=0.00..10.70 rows=70 width=1040:`
- `cost` - оценочная стоимость выполнения запроса;
- `rows` - оценочное количество строк, которые обработает запрос;
- `width` - "Estimated average width (in bytes) of rows output by this plan node". Оценка среднего размера строки в байтах. В контексте операции Seq Scan (последовательного сканирования) таблицы, ширина строки представляет собой оценку того, сколько места в байтах занимает одна строка данных.
3. `actual time=0.014..0.015 rows=3 loops=1:` Фактическое время выполнения запроса, количество обработанных строк и количество выполненных циклов. Здесь запрос выполнился за короткое время (от 0.0014 до 0.0015 секунд), обработано 3 строки, и запрос выполнился в одном цикле.
Filter: ("заказ_id" IS NOT NULL):

4. `Filter: ("заказ_id" IS NOT NULL): Rows Removed by Filter: 2:` - условие фильтрации вывода и количество отфильтрованных строк.

5. `Planning Time: 0.037 ms:` - время, затраченное на планирование выполнения запроса.
6. `Execution Time: 0.026 ms:` фактическое время выполнения запроса.

### Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).

Остановите контейнер с PostgreSQL, но не удаляйте volumes.

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

### Решение:
*Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).*
```
pg_dump -U dbadmin -d test_db > /backups/test_db.sql
```
Остановите контейнер с PostgreSQL, но не удаляйте volumes.
```
sudo docker stop pgsql-12
```

Создаем новый файл docker-compose и запускаем контейнер:
```
version: '3'

services:
  postgres:
    image: postgres:12
    container_name: pgsql-12-2
    environment:
      POSTGRES_USER: dbadmin
      POSTGRES_PASSWORD: dbadmin
    volumes:
      - /var/lib/docker/volumes/infra/postgresql-2/data:/var/lib/postgresql/data
      - /var/lib/docker/volumes/infra/postgresql/backups:/backups
    ports:
      - "5432:5432"
```

```
sdv@sdvpg:~/pg$ sudo docker-compose up -d
Recreating pgsql-12 ... done
sdv@sdvpg:~/pg$ sudo docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                                       NAMES
7949c11185fa   postgres:12   "docker-entrypoint.s…"   7 seconds ago   Up 6 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   pgsql-12-2
sdv@sdvpg:~/pg$
```
Запускаем bash в контейнере, подключаемся к серверу PostgreSQL и проверяем, что базы test_db на нем нет:

```
sdv@sdvpg:~/pg$ sudo docker exec -it pgsql-12-2 bash

root@7949c11185fa:/# psql -U dbadmin
psql (12.17 (Debian 12.17-1.pgdg120+1))
Type "help" for help.

dbadmin=# \l
                               List of databases
   Name    |  Owner  | Encoding |  Collate   |   Ctype    |  Access privileges
-----------+---------+----------+------------+------------+---------------------
 dbadmin   | dbadmin | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | dbadmin | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | dbadmin | UTF8     | en_US.utf8 | en_US.utf8 | =c/dbadmin         +
           |         |          |            |            | dbadmin=CTc/dbadmin
 template1 | dbadmin | UTF8     | en_US.utf8 | en_US.utf8 | =c/dbadmin         +
           |         |          |            |            | dbadmin=CTc/dbadmin
(4 rows)
```
*Восстановите БД test_db в новом контейнере.*

Предсоздаем, восстанавливаем БД, проверяем, что бд восстановилась:

```
dbadmin=# CREATE DATABASE test_db;
CREATE DATABASE
dbadmin=# psql -U pgadmin -d test_db < /backups/test_db.sql
dbadmin-# \l
                               List of databases
   Name    |  Owner  | Encoding |  Collate   |   Ctype    |  Access privileges
-----------+---------+----------+------------+------------+---------------------
 dbadmin   | dbadmin | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | dbadmin | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | dbadmin | UTF8     | en_US.utf8 | en_US.utf8 | =c/dbadmin         +
           |         |          |            |            | dbadmin=CTc/dbadmin
 template1 | dbadmin | UTF8     | en_US.utf8 | en_US.utf8 | =c/dbadmin         +
           |         |          |            |            | dbadmin=CTc/dbadmin
 test_db   | dbadmin | UTF8     | en_US.utf8 | en_US.utf8 |
(5 rows)

dbadmin-# \c test_db
You are now connected to database "test_db" as user "dbadmin".
```