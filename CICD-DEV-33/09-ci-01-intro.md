### Домашнее задание к занятию «Жизненный цикл ПО» [Степанников Денис]

---

### Основная часть

Необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. Задачи типа bug должны проходить жизненный цикл:

1. Open -> On reproduce.
2. On reproduce -> Open, Done reproduce.
3. Done reproduce -> On fix.
4. On fix -> On reproduce, Done fix.
5. Done fix -> On test.
6. On test -> On fix, Done.
7. Done -> Closed, Open.
Остальные задачи должны проходить по упрощённому workflow:

1. Open -> On develop.
2. On develop -> Open, Done develop.
3. Done develop -> On test.
4. On test -> On develop, Done.
5. Done -> Closed, Open.

### Что нужно сделать

1. Создайте задачу с типом bug, попытайтесь провести его по всему workflow до Done.
2. Создайте задачу с типом epic, к ней привяжите несколько задач с типом task, проведите их по всему workflow до Done.
3. При проведении обеих задач по статусам используйте kanban.
4. Верните задачи в статус Open.
5. Перейдите в Scrum, запланируйте новый спринт, состоящий из задач эпика и одного бага, стартуйте спринт, проведите задачи до состояния Closed. Закройте спринт.
6. Если всё отработалось в рамках ожидания — выгрузите схемы workflow для импорта в XML. Файлы с workflow и скриншоты workflow приложите к решению задания.

### Решение:
Доски, правила созданы, workflow прошел.
![Task #9.01 results](screenshots/09-ci-01-intro-3.png)

workflow для задач BUG:
![Task #9.01 results](screenshots/09-ci-01-intro-2.png)

workflow для прочих задач:
![Task #9.01 results](screenshots/09-ci-01-intro-1.png)

Готовый [sdv-bug.xml](https://github.com/sdv09/CICD-DEV-33/09-ci-01-intro-repos/sdv-bug.xml)

Готовый [sdv-all.xml](https://github.com/sdv09/CICD-DEV-33/09-ci-01-intro-repos/sdv-all.xml)
