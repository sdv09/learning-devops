### Домашнее задание к занятию 2. «Применение принципов IaaC в работе с виртуальными машинами» [Степанников Денис]

---

### Задача 1
* Опишите основные преимущества применения на практике IaaC-паттернов.
* Какой из принципов IaaC является основополагающим?

### Решение:

*Опишите основные преимущества применения на практике IaaC-паттернов.*
* Значительное увеличение скорости развертывания инфраструктуры достигается благодаря повторяемости этапов конфигурации, что обеспечивает простое устранение отклонений в конфигурации в любых необходимых местах. Например, это может быть актуально при сравнении настроек между разными средами, такими как PREPROD и PROD. 
* Общее ускорение выполнения повседневных задач приводит к сокращению показателя Time To Market, являющегося ключевым аспектом в современном мире цифровых решений.

*Какой из принципов IaaC является основополагающим?*
* Идемпотентность - это характеристика операции, которая обеспечивает одинаковый результат при ее повторном выполнении, несмотря на многократное повторение операции.

### Задача 2
* Чем Ansible выгодно отличается от других систем управление конфигурациями?
* Какой, на ваш взгляд, метод работы систем конфигурации более надёжный — push или pull?

### Решение:

*Чем Ansible выгодно отличается от других систем управление конфигурациями?*
* Сравнительно низкий барьер входа по сравнению с альтернативными системами управления конфигурацией. Разработана на языке программирования Python, который является одним из самых популярных и простых, что облегчает добавление собственных модулей и использование уже существующих, расширяя функциональность решения. 
* Большая популярность системы по сравнению с конкурентами упрощает поиск ответов на вопросы, возникающие при эксплуатации, и обеспечивает признание на рынке. 
* Нет необходимости устанавливать агенты на целевые хосты.

*Какой, на ваш взгляд, метод работы систем конфигурации более надёжный — push или pull?*

Предпочитаю использовать подход pull, поскольку в этом случае единственной точкой отказа является сама система управления конфигурациями. Хосты обращаются к серверу конфигураций только в том случае, если с ними все в порядке. В отличие от подхода push, где возможны задержки из-за недоступности хоста, на который нужно применить конфигурацию.

### Задача 3

Установите на личный linux-компьютер(или учебную ВМ с linux):
* VirtualBox,
* Vagrant, рекомендуем версию 2.3.4(в более старших версиях могут возникать проблемы интеграции с ansible)
* Terraform версии 1.5.Х (1.6.х может вызывать проблемы с яндекс-облаком),
* Ansible.

Приложите вывод команд установленных версий каждой из программ, оформленный в Markdown.


### Решение:

```
root@sdvvm01:~# ansible --version
ansible 2.10.8
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.10.12 (main, Nov 20 2023, 15:14:05) [GCC 11.4.0]
```
```
root@sdvvm01:~# vagrant --version
Vagrant 2.3.4
```
```
root@sdvvm01:~# terraform --version
Terraform v1.5.7
on linux_amd64

Your version of Terraform is out of date! The latest version
is 1.7.0. You can update by downloading from https://www.terraform.io/downloads.html
```
```
root@sdvvm01:~# vboxmanage --version
6.1.48_Ubuntur159471
```
```
root@sdvvm01:~# apt list --installed | grep -E "virtualbox|vargant|terraform|ansible"

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

ansible/jammy,now 2.10.7+merged+base+2.10.8+dfsg-1 all [installed]
virtualbox-dkms/jammy-updates,now 6.1.48-dfsg-1~ubuntu1.22.04.1 amd64 [installed,automatic]
virtualbox-qt/jammy-updates,now 6.1.48-dfsg-1~ubuntu1.22.04.1 amd64 [installed,automatic]
virtualbox/jammy-updates,now 6.1.48-dfsg-1~ubuntu1.22.04.1 amd64 [installed]
root@sdvvm01:~#
```


### Задача 4

Воспроизведите практическую часть лекции самостоятельно.

### Решение:

```
root@sdvvm01:~# vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Checking if box 'bento/ubuntu-22.04' version '202309.08.0' is up to date...
==> server1.netology: Clearing any previously set forwarded ports...
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology: Warning: Connection reset. Retrying...
    server1.netology: Warning: Remote connection disconnect. Retrying...
    server1.netology: Warning: Connection reset. Retrying...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
    server1.netology: The guest additions on this VM do not match the installed version of
    server1.netology: VirtualBox! In most cases this is fine, but in rare cases it can
    server1.netology: prevent things such as shared folders from working properly. If you see
    server1.netology: shared folder errors, please make sure the guest additions within the
    server1.netology: virtual machine match the version of VirtualBox you have installed on
    server1.netology: your host and reload your VM.
    server1.netology:
    server1.netology: Guest Additions Version: 7.0.10
    server1.netology: VirtualBox Version: 6.1
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => /root
==> server1.netology: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> server1.netology: flag to force provisioning. Provisioners marked to run always will still run.
root@sdvvm01:~# vagrant provision
==> server1.netology: Running provisioner: ansible...
`playbook` does not exist on the host: /ansible/provision.yml

```

```
root@sdvvm01:~# vagrant provision
==> server1.netology: Running provisioner: ansible...
    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: If you are using a module and expect the file to exist on the remote, see the remote_src option
fatal: [server1.netology]: FAILED! => {"changed": false, "msg": "Could not find or access '~/.ssh/id_rsa.pub' on the Ansible Controller.\nIf you are using a module and expect the file to exist on the remote, see the remote_src option"}
...ignoring

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=['git', 'curl'])

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           :ok=7changed=3 unreachable=0    failed=0    skipped=0    rescued=0ignored=1
```
```
root@sdvvm01:~# vagrant status
Current machine states:

server1.netology          running (virtualbox)

The VM is running. To stop this VM, you can run `vagrant halt` to
shut it down forcefully, or you can run `vagrant suspend` to simply
suspend the virtual machine. In either case, to restart it again,
simply run `vagrant up`.
```
```
root@sdvvm01:~# vagrant ssh
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 5.15.0-83-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Thu Jan 18 06:23:03 PM UTC 2024

  System load:  0.4931640625       Users logged in:          0
  Usage of /:   14.4% of 30.34GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 31%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.56.11
  Processes:    140


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Thu Jan 18 18:21:18 2024 from 10.0.2.2
```
```
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
```
vagrant@server1:~$ hostname -f
server1.netology
vagrant@server1:~$
```