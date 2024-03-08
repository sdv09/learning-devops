### Домашнее задание к занятию «08.01 Введение в Ansible» [Степанников Денис]

---

### Подготовка к выполнению
1. Установите Ansible версии 2.10 или выше.
2. Создайте свой публичный репозиторий на GitHub с произвольным именем.
3. Скачайте Playbook из репозитория с домашним заданием и перенесите его в свой репозиторий.

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

### Основная часть

1. Попробуйте запустить playbook на окружении из test.yml, зафиксируйте значение, которое имеет факт some_fact для указанного хоста при выполнении playbook.
2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на all default fact.
3. Воспользуйтесь подготовленным (используется docker) или создайте собственное окружение для проведения дальнейших испытаний.
4. Проведите запуск playbook на окружении из prod.yml. Зафиксируйте полученные значения some_fact для каждого из managed host.
5. Добавьте факты в group_vars каждой из групп хостов так, чтобы для some_fact получились значения: для deb — deb default fact, для el — el default fact.
6. Повторите запуск playbook на окружении prod.yml. Убедитесь, что выдаются корректные значения для всех хостов.
7. При помощи ansible-vault зашифруйте факты в group_vars/deb и group_vars/el с паролем netology.
8. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь в работоспособности.
9. Посмотрите при помощи ansible-doc список плагинов для подключения. Выберите подходящий для работы на control node.
10. В prod.yml добавьте новую группу хостов с именем local, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь, что факты some_fact для каждого из хостов определены из верных group_vars.
12. Заполните README.md ответами на вопросы. Сделайте git push в ветку master. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым playbook и заполненным README.md.
13. Предоставьте скриншоты результатов запуска команд.

### Решение:

Установлен ansible
```
root@sdvvm01:~# ansible --version
ansible 2.10.8
```
Создан публичный репозитарий GitHub

```
root@sdvvm01:~# git clone https://github.com/sdv09/sdv-08-ansible-01-base.git
Cloning into 'sdv-08-ansible-01-base'...
warning: You appear to have cloned an empty repository.
root@sdvvm01:~# ls -lah
total 32K
drwx------  6 root root 4.0K Mar  6 18:32 .
drwxr-xr-x 19 root root 4.0K Jan 18 15:28 ..
drwxr-xr-x  3 root root 4.0K Mar  6 18:18 .ansible
-rw-r--r--  1 root root 3.1K Oct 15  2021 .bashrc
-rw-r--r--  1 root root  161 Jul  9  2019 .profile
drwxr-xr-x  3 root root 4.0K Mar  6 18:32 sdv-08-ansible-01-base
drwx------  3 root root 4.0K Jan 18 15:29 snap
drwx------  2 root root 4.0K Jan 18 15:29 .ssh
-rw-r--r--  1 root root    0 Mar  6 18:13 .sudo_as_admin_successful
root@sdvvm01:~# cd sdv-08-ansible-01-base/
root@sdvvm01:~/sdv-08-ansible-01-base# ls -lah
total 12K
drwxr-xr-x 3 root root 4.0K Mar  6 18:32 .
drwx------ 6 root root 4.0K Mar  6 18:32 ..
drwxr-xr-x 7 root root 4.0K Mar  6 18:32 .git
root@sdvvm01:~/sdv-08-ansible-01-base#
```
Playbook из задания добавлен в репозиторий:
```
root@sdvvm01:~/sdv-08-ansible-01-base# git push -u origin main
Enumerating objects: 16, done.
Counting objects: 100% (16/16), done.
Delta compression using up to 4 threads
Compressing objects: 100% (9/9), done.
Writing objects: 100% (16/16), 1.52 KiB | 778.00 KiB/s, done.
Total 16 (delta 0), reused 0 (delta 0), pack-reused 0
To github.com:sdv09/sdv-08-ansible-01-base.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```
1. Факт some_fact имеет значение 12.
```
root@sdvvm01:~/sdv-08-ansible-01-base# ansible-playbook -i ./inventory/test.yml site.yml

PLAY [Print os facts] ****************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] **********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
localhost                  :ok=3 changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
2. Установка нового значения some_fact.

```
root@sdvvm01:~/sdv-08-ansible-01-base# cat group_vars/all/examp.yml
---
  some_fact: all default fact
root@sdvvm01:~/sdv-08-ansible-01-base# ansible-playbook -i ./inventory/test.yml site.yml

PLAY [Print os facts] ****************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] **********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
localhost                  :ok=3 changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

3. Запуск окружения:
```
root@sdvvm01:~/sdv-08-ansible-01-base# sudo docker run --rm --name "ubuntu" -d pycontribs/ubuntu:latest sleep 3600
Unable to find image 'pycontribs/ubuntu:latest' locally
latest: Pulling from pycontribs/ubuntu
423ae2b273f4: Pull complete
de83a2304fa1: Pull complete
f9a83bce3af0: Pull complete
b6b53be908de: Pull complete
7378af08dad3: Pull complete
Digest: sha256:dcb590e80d10d1b55bd3d00aadf32de8c413531d5cc4d72d0849d43f45cb7ec4
Status: Downloaded newer image for pycontribs/ubuntu:latest
c5de3e0cc356d7f5d9bc9566fe64bcfeede2900ca4460c3ecc26025265cff4c1
root@sdvvm01:~/sdv-08-ansible-01-base# sudo docker run --rm --name "centos7" -d pycontribs/centos:7 sleep 3600
Unable to find image 'pycontribs/centos:7' locally
7: Pulling from pycontribs/centos
2d473b07cdd5: Pull complete
43e1b1841fcc: Pull complete
85bf99ab446d: Pull complete
Digest: sha256:b3ce994016fd728998f8ebca21eb89bf4e88dbc01ec2603c04cc9c56ca964c69
Status: Downloaded newer image for pycontribs/centos:7
2eb1180d23928729119efd155ad410cbea9bc1d591546bfac8f8c2c2c0aee99b
root@sdvvm01:~/sdv-08-ansible-01-base# sudo docker ps
CONTAINER ID   IMAGE                      COMMAND        CREATED              STATUS              PORTS     NAMES
2eb1180d2392   pycontribs/centos:7        "sleep 3600"   28 seconds ago       Up 9 seconds                  centos7
c5de3e0cc356   pycontribs/ubuntu:latest   "sleep 3600"   About a minute ago   Up About a minute             ubuntu
```
4. Запуск playbook на окружении prod.yml

```
root@sdvvm01:~/sdv-08-ansible-01-base# ansible-playbook -i ./inventory/prod.yml site.yml

PLAY [Print os facts] ****************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more
information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
centos7                    :ok=3 changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     :ok=3 changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

* Значение some_fact для managed host "ubuntu" deb.
* Значение some_fact для managed host "centos7" el.

5. Обновленные факты в group_vars для групп хостов.

```
root@sdvvm01:~/sdv-08-ansible-01-base# cat group_vars/deb/examp.yml
---
#  some_fact: "deb default fact"
  some_fact: "deb default fact"
root@sdvvm01:~/sdv-08-ansible-01-base# cat group_vars/el/examp.yml
---
  some_fact: "el default fact"
root@sdvvm01:~/sdv-08-ansible-01-base#
```
6. Повторный запуск playbook на окружении prod.yml.
```
root@sdvvm01:~/sdv-08-ansible-01-base# ansible-playbook -i ./inventory/prod.yml site.yml

PLAY [Print os facts] ****************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more
information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}

TASK [Print fact] ********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
centos7                    :ok=3 changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     :ok=3 changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

root@sdvvm01:~/sdv-08-ansible-01-base#
```
* Значение some_fact для managed host "ubuntu" deb default fact.
* Значение some_fact для managed host "centos7" el default fact.

7. Шифрование фактов с помощью ansible-vault.
```
root@sdvvm01:~/sdv-08-ansible-01-base# ansible-vault encrypt group_vars/deb/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
root@sdvvm01:~/sdv-08-ansible-01-base# ansible-vault encrypt group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
root@sdvvm01:~/sdv-08-ansible-01-base# cat group_vars/deb/examp.yml
$ANSIBLE_VAULT;1.1;AES256
35363465623136336564356639353263373136333830666333373963383636396233663135623662
3135373665663539373233393431356539303437313939300a396235333838356162343661303733
62306635623964653665636431393534663161643530643333333131303630626662396331663437
6532306366373564330a333962643632386165373462313265333063323366363136633861326331
37326237313431393762626639383636343030313530636632353561353962353630663163393665
61386662623462356136633139623131663762303538653036353065626435386331336166643034
30366639343365326635356262633464316138383639373432366531663864353866613138306530
64393562616163333939
root@sdvvm01:~/sdv-08-ansible-01-base# cat group_vars/el/examp.yml
$ANSIBLE_VAULT;1.1;AES256
34643536343864393433386532323033616333383136303861356339616638313966333161633161
3435393634313330666563396234616231313961386333650a633062323231663733616431333932
37343664366563346639656133623962646331363431356231656438363439346331633130623934
3565333633343730610a633039623763386336303637376161656162306535366137633131393733
35346462663165396634343662313737353632663135633232343164343265653932343066313035
3037633638326335633664663835663366656531353864623165
root@sdvvm01:~/sdv-08-ansible-01-base#
```

8. Запуск playbook с окружением prod.yml и ключом --ask-vault-pass для запроса пароля шифрования.
```
root@sdvvm01:~/sdv-08-ansible-01-base# ansible-playbook -i ./inventory/prod.yml site.yml --ask-vault-password
Vault password:

PLAY [Print os facts] ****************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more
information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
centos7                    :ok=3 changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     :ok=3 changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

root@sdvvm01:~/sdv-08-ansible-01-base#
```
9. Для подключения к control node выбран плагин local.
```
root@sdvvm01:~/sdv-08-ansible-01-base# ansible-doc -t connection --list | grep "on control"
local                          execute on controller
root@sdvvm01:~/sdv-08-ansible-01-base#
```

10. Скорректировал prod.yml

```
root@sdvvm01:~/sdv-08-ansible-01-base# cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```

11. Повторный запуск playbook на окружении prod.yml

```
root@sdvvm01:~/sdv-08-ansible-01-base# sudo ansible-playbook -i ./inventory/prod.yml site.yml --ask-vault-password
Vault password:

PLAY [Print os facts] ****************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [localhost]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more
information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
centos7                    :ok=3 changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  :ok=3 changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     :ok=3 changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

root@sdvvm01:~/sdv-08-ansible-01-base#
```
* Значение some_fact для managed host "ubuntu" deb default fact.
* Значение some_fact для managed host "centos7" el default fact.
* Значение some_fact для managed host "localhost" all default fact.