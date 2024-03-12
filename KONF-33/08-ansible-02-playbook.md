### Домашнее задание к занятию «08.02 Работа с Playbook» [Степанников Денис]

---

### Подготовка к выполнению
1. Необязательно. Изучите, что такое ClickHouse и Vector.
2. Создайте свой публичный репозиторий на GitHub с произвольным именем или используйте старый.
3. Скачайте Playbook из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.


### Основная часть

1. Подготовьте свой inventory-файл prod.yml.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает vector. Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по ссылке. не забудьте сделать handler на перезапуск vector в случае изменения конфигурации!
3. При создании tasks рекомендую использовать модули: get_url, template, unarchive, file.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите ansible-lint site.yml и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом --check.
7. Запустите playbook на prod.yml окружении с флагом --diff. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом --diff и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. Пример качественной документации ansible playbook по ссылке. Так же приложите скриншоты выполнения заданий №5-8
10. Готовый playbook выложите в свой репозиторий, поставьте тег 08-ansible-02-playbook на фиксирующий коммит, в ответ предоставьте ссылку на него.

### Решение:

1. *Подготовьте свой inventory-файл prod.yml.*
```
root@sdvvm01:~/08-ansible-02-playbook/playbook/inventory# cat prod.yml
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 51.250.95.191
vector:
  hosts:
    vector-01:
      ansible_host: 51.250.95.252
root@sdvvm01:~/08-ansible-02-playbook/playbook/inventory#
```

2. *Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает vector. Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по ссылке. не забудьте сделать handler на перезапуск vector в случае изменения конфигурации!*
3. *При создании tasks рекомендую использовать модули: get_url, template, unarchive, file.*
4. *Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.*

```
---
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service
    - name: Flush handlers
      meta: flush_handlers
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc != 82
      changed_when: create_db.rc == 0

- name: Install Vector
  hosts: vector
  handlers:
    - name: Restart Vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: restarted
  tasks:
    - name: install vector
      tags: install
      block:
        - name: Get vector distrib
          become: true
          ansible.builtin.get_url:
            url: "{{ vector_deb_package }}"
            dest: "/tmp/vector_distr.deb"
        - name: Install vector
          become: true
          ansible.builtin.apt:
            deb: /tmp/vector_distr.deb
    - name: configure vector
      tags: configure
      block:
        - name: Configure Vector
          become: true
          ansible.builtin.template:
            src: "vector.toml.j2"
            dest: "/etc/vector/vector.toml"
            owner: root
            group: root
            mode: 0644
          notify: Restart Vector service
```
5. *Запустите ansible-lint site.yml и исправьте ошибки, если они есть.*
```
root@sdvvm01:~/08-ansible-02-playbook/playbook# ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
root@sdvvm01:~/08-ansible-02-playbook/playbook#
```
6. *Попробуйте запустить playbook на этом окружении с флагом --check.*

```
root@sdvvm01:~/08-ansible-02-playbook/playbook# ansible-playbook site.yml -i inventory/prod.yml -l vector -k --check
SSH password:

PLAY [Install Clickhouse] ****************************************************************************************************************************************************
skipping: no hosts matched

PLAY [Install Vector] ********************************************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] ****************************************************************************************************************************************************
ok: [vector-01]

TASK [Install vector] ********************************************************************************************************************************************************
ok: [vector-01]

TASK [Configure Vector] ******************************************************************************************************************************************************
ok: [vector-01]

PLAY RECAP *******************************************************************************************************************************************************************
vector-01                  :ok=4 changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

root@sdvvm01:~/08-ansible-02-playbook/playbook#
```
7. *Запустите playbook на prod.yml окружении с флагом --diff. Убедитесь, что изменения на системе произведены.*
```
root@sdvvm01:~/08-ansible-02-playbook/playbook# ansible-playbook site.yml -i inventory/prod.yml -l vector -k --check --diff
SSH password:

PLAY [Install Clickhouse] ****************************************************************************************************************************************************
skipping: no hosts matched

PLAY [Install Vector] ********************************************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] ****************************************************************************************************************************************************
ok: [vector-01]

TASK [Install vector] ********************************************************************************************************************************************************
Selecting previously unselected package vector.
(Reading database ... 110044 files and directories currently installed.)
Preparing to unpack /tmp/vector_distr.deb ...
changed: [vector-01]

TASK [Configure Vector] ******************************************************************************************************************************************************
ok: [vector-01]

PLAY RECAP *******************************************************************************************************************************************************************
vector-01                  :ok=4changed=1 unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

root@sdvvm01:~/08-ansible-02-playbook/playbook#
```

8. *Повторно запустите playbook с флагом --diff и убедитесь, что playbook идемпотентен.*
```
root@sdvvm01:~/08-ansible-02-playbook/playbook# ansible-playbook site.yml -i inventory/prod.yml -l vector -k --check --diff
SSH password:

PLAY [Install Clickhouse] ****************************************************************************************************************************************************
skipping: no hosts matched

PLAY [Install Vector] ********************************************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] ****************************************************************************************************************************************************
ok: [vector-01]

TASK [Install vector] ********************************************************************************************************************************************************
Selecting previously unselected package vector.
(Reading database ... 110044 files and directories currently installed.)
Preparing to unpack /tmp/vector_distr.deb ...
changed: [vector-01]

TASK [Configure Vector] ******************************************************************************************************************************************************
ok: [vector-01]

PLAY RECAP *******************************************************************************************************************************************************************
vector-01                  :ok=4changed=1 unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

root@sdvvm01:~/08-ansible-02-playbook/playbook#
```

Готовый [playbook](https://github.com/sdv09/08-ansible-02-playbook) а моем репозитарии c тегом 08-ansible-02-playbook.
