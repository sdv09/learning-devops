### Домашнее задание к занятию 05.3. «Введение. Экосистема. Архитектура. Жизненный цикл Docker-контейнера» [Степанников Денис]

---

### Задача 1
Сценарий выполнения задачи:

создайте свой репозиторий на https://hub.docker.com;
выберите любой образ, который содержит веб-сервер Nginx;
создайте свой fork образа;
реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный fork в своём репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.
### Решение:

Создаем каталог Docker:
```
mkdir ~/docker
```

В этой же папке создаем файл с именем Docker содержащий:

```
FROM nginx:latest
EXPOSE 80
COPY index.html  /usr/share/nginx/html/
```

Создаем в той же папке файл index.html следующего содержания:

```
<html>
 <head>
  <meta charset="UTF-8">
  Hey, Netology
 </head>
 <body>
  <h1>I'm DevOps Engineer!</h1>
 </body>
</html>
```
Строим образ Docker:
```
sudo docker build -t dstepannikov-nginx-image .
```
Создаем и запускаем контейнер:
```
sudo docker run -d -p 80:80 dstepannikov-nginx-image

```
В браузере пробуем открыть index.html, набрав в адресной строке http://ip_сервера

Проверяем версию nginx:
```
dys5324@sdvvm01:~/docker$ sudo docker ps -a
CONTAINER ID   IMAGE                      COMMAND                  CREATED        STATUS          PORTS                               NAMES
f2affae7ca09   dstepannikov-nginx-image   "/docker-entrypoint.…"   32 hours ago   Up 10 seconds   0.0.0.0:80->80/tcp, :::80->80/tcp   silly_haibt
dys5324@sdvvm01:~/docker$ sudo docker exec -it f2affae7ca09 /bin/bash
root@f2affae7ca09:/# nginx -v
nginx version: nginx/1.25.3
root@f2affae7ca09:/#
```
Останавливаем контейнер, тэгируем и указываем удаленный репозиторий:
```
dys5324@sdvvm01:~/docker$ sudo docker stop f2affae7ca09
f2affae7ca09
dys5324@sdvvm01:~/docker$ sudo docker tag dstepannikov-nginx-image:1.25.3 dstepannikov/dstepannikov-nginx:1.25.3
Error response from daemon: No such image: dstepannikov-nginx-image:1.25.3
dys5324@sdvvm01:~/docker$ sudo docker images
REPOSITORY                 TAG       IMAGE ID       CREATED        SIZE
dstepannikov-nginx-image   latest    ff4fbda4025f   32 hours ago   187MB
dys5324@sdvvm01:~/docker$ sudo docker tag dstepannikov-nginx-image:latest dstepannikov/dstepannikov-nginx:1.25.3

```
Логинимся в docker hub, загружаю образ в репозиторий, публикую созданный fork в своём репозитории:
```
# В качестве пароля используется токен, который нужно создать в разделе Account settings/Security в Docker Hub
dys5324@sdvvm01:~/docker$ sudo chmod 666 /var/run/docker.sock
dys5324@sdvvm01:~/docker$ docker login -u dstepannikov
Password:
WARNING! Your password will be stored unencrypted in /home/dys5324/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
dys5324@sdvvm01:~/docker$ docker push dstepannikov/dstepannikov-nginx:1.25.3
The push refers to repository [docker.io/dstepannikov/dstepannikov-nginx]
5120f6caf195: Pushed
009507b85609: Mounted from library/nginx
fbcc9bc44d3e: Mounted from library/nginx
b4ad47845036: Mounted from library/nginx
eddcd06e5ef9: Mounted from library/nginx
b61d4b2cd2da: Mounted from library/nginx
b6c2a8d6f0ac: Mounted from library/nginx
571ade696b26: Mounted from library/nginx
1.25.3: digest: sha256:120db461d81a54c9a9a7dbbc36c4e55c478e484bf446934a2acc66f656ce6dda size: 1985
dys5324@sdvvm01:~/docker$ docker pull dstepannikov/dstepannikov-nginx:1.25.3
1.25.3: Pulling from dstepannikov/dstepannikov-nginx
Digest: sha256:120db461d81a54c9a9a7dbbc36c4e55c478e484bf446934a2acc66f656ce6dda
Status: Image is up to date for dstepannikov/dstepannikov-nginx:1.25.3
docker.io/dstepannikov/dstepannikov-nginx:1.25.3
dys5324@sdvvm01:~/docker$
```
https://hub.docker.com/repository/docker/dstepannikov/dstepannikov-nginx/general

### Задача 2
Посмотрите на сценарий ниже и ответьте на вопрос: «Подходит ли в этом сценарии использование Docker-контейнеров или лучше подойдёт виртуальная машина, физическая машина? Может быть, возможны разные варианты?»

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- высоконагруженное монолитное Java веб-приложение;
- Nodejs веб-приложение;
- мобильное приложение c версиями для Android и iOS;
- шина данных на базе Apache Kafka;
- Elasticsearch-кластер для реализации логирования продуктивного веб-приложения — три ноды elasticsearch, два logstash и две ноды kibana;
- мониторинг-стек на базе Prometheus и Grafana;
- MongoDB как основное хранилище данных для Java-приложения;
- Gitlab-сервер для реализации CI/CD-процессов и приватный (закрытый) Docker Registry.
### Решение:

*Посмотрите на сценарий ниже и ответьте на вопрос: «Подходит ли в этом сценарии использование Docker-контейнеров или лучше подойдёт виртуальная машина, физическая машина? Может быть, возможны разные варианты?»
Детально опишите и обоснуйте свой выбор.*

Предполагаю, что разумно начать с обсуждения плюсов и минусов двух вариантов. По всей видимости, при разработке собственного приложения в большинстве случаев стоит отдавать предпочтение контейнеризации. Это облегчит процесс доставки приложения, обеспечит быстрое и гибкое масштабирование при необходимости, а также позволит настроить современные автоматизированные процессы разработки ПО, такие как CI/CD.

В случае "коробочных" приложений я также склонен отдавать предпочтение контейнеризации, особенно если сам разработчик предоставляет приложение в виде контейнера и поддерживает такую форму установки. Возможные исключения, вероятно, включают монолитные stateful-приложения, где особенности контейнеризации, такие как возможность прекращения работы контейнера в любое время, могут вызвать проблемы с сохранением данных или другими аспектами приложения.

Иными словами, в случаях, где отсутствуют существенные обоснования для развертывания приложения на выделенной виртуальной машине или физическом сервере, я бы предложил использовать контейнеризацию.

*высоконагруженное монолитное Java веб-приложение*

Это сильно зависит от конкретной ситуации, но, как правило, подобные приложения представляют собой корпоративные stateful-системы с устойчивым, хотя и высоким, уровнем загрузки (то есть, как правило, не требующие динамического масштабирования). Здесь ключевым фактором является максимальная производительность, и с этой точки зрения введение дополнительного уровня виртуализации влечет лишние накладные расходы. В таких случаях я предпочел бы развертывать такие приложения либо на физических серверах, либо на виртуальных машинах.

*Nodejs веб-приложение*

Возможно, для большинства веб-приложений, особенно тех, которые созданы в собственном производстве, я бы предпочел использовать контейнеры. Независимо от того, используется ли Node.js или Laravel, мой выбор склоняется в сторону контейнеризации.

*мобильное приложение c версиями для Android и iOS*

Предположу, что присутствует микросервисная архитектура, и в данном контексте контейнеризация почти единственно правильный вариант выбора.

*шина данных на базе Apache Kafka*

У компании RedHat даже есть статья, в которой обосновывается, почему развертывание Kafka на Kubernetes является предпочтительным вариантом. Так что мы остановимся на контейнеризации.

*Elasticsearch-кластер для реализации логирования продуктивного веб-приложения — три ноды elasticsearch, два logstash и две ноды kibana*

Ответ на вопрос фактически содержится в самом термине "ноды". Все эти инструменты являются частью современного стека разработки, и, как правило, их развертывание осуществляется в форме контейнеров.

*мониторинг-стек на базе Prometheus и Grafana*

Так же, как и в предыдущем пункте, ответ заключается в использовании контейнеризации.

*MongoDB как основное хранилище данных для Java-приложения*

По моему мнению, для управления СУБД лучше использовать отдельные виртуальные машины или, возможно, даже физические серверы, учитывая, что это stateful ПО. На практике, конечно, существует возможность успешного запуска СУБД в контейнере, но при личном выборе я бы отдал предпочтение развертыванию СУБД на виртуальной машине.

*Gitlab-сервер для реализации CI/CD-процессов и приватный (закрытый) Docker Registry*

Обычно инструменты современного стека разработки разворачиваются в формате контейнеров.

### Задача 3

- Запустите первый контейнер из образа centos c любым тегом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера.
- Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера.
- Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data.
- Добавьте ещё один файл в папку /data на хостовой машине.
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.


### Решение:

```
dys5324@sdvvm01:~/docker$ docker pull centos:latest
latest: Pulling from library/centos
a1d0c7532777: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
docker.io/library/centos:latest
dys5324@sdvvm01:~/docker$ sudo docker run -td -v ~/study/docker/data:/data --name centos centos
a30bc3a745acb8b6e2ffbb5bd9a9fec0098313740752773f4f1cf4d2387179d3
dys5324@sdvvm01:~/docker$ docker pull debian:latest
latest: Pulling from library/debian
1b13d4e1a46e: Pull complete
Digest: sha256:b16cef8cbcb20935c0f052e37fc3d38dc92bfec0bcfb894c328547f81e932d67
Status: Downloaded newer image for debian:latest
docker.io/library/debian:latest
dys5324@sdvvm01:~/docker$ sudo docker run -td -v ~/study/docker/data:/data --name debian debian
9a83ff6500feeb6ef099ff4a04dd4fa183dc72c27781787f1804ee8e0012bc8d
dys5324@sdvvm01:~/docker$ docker exec -it centos /bin/bash
[root@a30bc3a745ac /]# echo "Hi, I'm devops!" >> /data/message_to_devops.txt
[root@a30bc3a745ac /]# sudo touch ~/study/docker/data/sdv_another_file.txt
bash: sudo: command not found
[root@a30bc3a745ac /]# touch ~/study/docker/data/sdv_another_file.txt
touch: cannot touch '/root/study/docker/data/sdv_another_file.txt': No such file or directory
[root@a30bc3a745ac /]# exit
exit
dys5324@sdvvm01:~/docker$ sudo touch ~/study/docker/data/sdv_another_file.txt
dys5324@sdvvm01:~/docker$ docker exec -it debian /bin/bash
root@9a83ff6500fe:/# ls /data
message_to_devops.txt  sdv_another_file.txt
root@9a83ff6500fe:/# ls -lah /data
total 12K
drwxr-xr-x 2 root root 4.0K Jan 22 19:52 .
drwxr-xr-x 1 root root 4.0K Jan 22 19:45 ..
-rw-r--r-- 1 root root   16 Jan 22 19:50 message_to_devops.txt
-rw-r--r-- 1 root root    0 Jan 22 19:52 sdv_another_file.txt
root@9a83ff6500fe:/#
```


