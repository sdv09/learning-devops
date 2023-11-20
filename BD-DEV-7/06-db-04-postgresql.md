### Домашнее задание к занятию 4. «PostgreSQL» [Степанников Денис]

---

### Задача 1
Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL, используя psql.

Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.

Найдите и приведите управляющие команды для:

1. вывода списка БД,
2. подключения к БД,
3. вывода списка таблиц,
4. вывода описания содержимого таблиц,
5. выхода из psql.

### Решение:

**Манифест для docker-compose:**
```
version: '3'

services:
  postgres:
    image: postgres:13
    container_name: pgsql-13
    environment:
      POSTGRES_USER: dbadmin
      POSTGRES_PASSWORD: dbadmin
    volumes:
      - /var/lib/docker/volumes/infra/postgresql/data:/var/lib/postgresql/data
      - /var/lib/docker/volumes/infra/postgresql/backups:/backups
    ports:
      - "5432:5432"

```
Запускаем контейнер: 

```
sudo docker-compose up -d
```
```
sdv@sdvpg:~/pg$ sudo docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
ca8a3631e768   postgres:13   "docker-entrypoint.s…"   22 minutes ago   Up 22 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   pgsql-13

```

*Подключаемся к БД PostgreSQL, используя psql:*

```
sudo docker exec -it pgsql-13 bash
psql -U dbadmin
```

*Найдите и приведите управляющие команды для вывода списка БД:*
```
\l
```
*Найдите и приведите управляющие команды для подключения к БД:*

```
\c <database_name>
```

*Найдите и приведите управляющие команды для вывода списка таблиц:*
```
\dt
```

*Найдите и приведите управляющие команды для вывода описания содержимого таблиц:*
```
\d <table_name>
```

*Найдите и приведите управляющие команды для выхода из psql*

```
\q
```


### Задача 2
1. Используя psql, создайте БД test_database.

2. Восстановите бэкап БД в test_database.

3. Перейдите в управляющую консоль psql внутри контейнера.

4. Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

5. Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.

Приведите в ответе команду, которую вы использовали для вычисления, и полученный результат.


### Решение:

1.
 ```
root@ca8a3631e768:/backups# psql -U dbadmin
psql (13.13 (Debian 13.13-1.pgdg120+1))
Type "help" for help.

dbadmin=# CREATE DATABASE test_database;
```

2.
```
wget https://raw.githubusercontent.com/netology-code/virt-homeworks/virt-11/06-db-04-postgresql/test_data/test_dump.sql
sudo mv ./test_dump.sql /var/lib/docker/volumes/infra/postgresql/backups/test_dump.sql
psql -U dbadmin -d test_database < /backups/test_dump.sql
```

3.

```
root@ca8a3631e768:/backups# psql -U dbadmin
psql (13.13 (Debian 13.13-1.pgdg120+1))
Type "help" for help.

dbadmin=#
```

4.

```
root@ca8a3631e768:/backups# psql -U dbadmin
psql (13.13 (Debian 13.13-1.pgdg120+1))
Type "help" for help.

dbadmin=# \c test_database
You are now connected to database "test_database" as user "dbadmin".

test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+---------
 public | orders | table | dbadmin
(1 row)

test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE

test_database=#

```
5.
```
test_database=# SELECT attname, avg_width FROM pg_stats WHERE tablename = 'orders' order by avg_width desc limit 1;
 attname | avg_width
---------+-----------
 title   |        16
(1 row)

test_database=#
```

### Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.

Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?


### Решение:

*Предложите SQL-транзакцию для проведения этой операции:*

```
-- Создаем две таблицы, данные в которых должны удовлетворять заданным условиям
-- Первая - со значением price <= 499 
CREATE TABLE orders_1 (
    LIKE orders INCLUDING ALL,
    CHECK (price <= 499)
);


-- Вторая - со значением price > 499 
CREATE TABLE orders_2 (
    LIKE orders INCLUDING ALL,
    CHECK (price > 499)
);

-- Переносим данные из исходной таблицы orders во вновь созданные
INSERT INTO orders_1 SELECT * FROM orders WHERE price <= 499;
INSERT INTO orders_2 SELECT * FROM orders WHERE price > 499;

-- Так как все данные из старой таблицы мы перенесли, а новые будут создаваться в таблицах orders_1 и orders_2 - удалим исходную таблицу orders:
DROP TABLE orders;
```

*Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?*

Да, можно сделать при создании таблицы, НО в данном случае данные из бекапап не попадут в партиции, т.к. загружаются с помощью COPY, в таком случае RULES не вызываются. Так указано документации Postgres:

**COPY FROM will invoke any triggers and check constraints on the destination table. However, it will not invoke rules.**


### Задача 4
Используя утилиту pg_dump, создайте бекап БД test_database.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?

### Решение:

*Используя утилиту pg_dump, создайте бекап БД test_database:*
```
root@ca8a3631e768:/backups# psql -U dbadmin
psql (13.13 (Debian 13.13-1.pgdg120+1))
Type "help" for help.

dbadmin=# pg_dump -U dbadmin -d test_database > /backups/test_database.sql
dbadmin-#
```
*Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?*

В конец файла добавлю директиву, которая сделает столбец title уникальным:

```
ALTER TABLE orders ADD UNIQUE (title);
```
