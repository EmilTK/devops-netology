# Домашняя работа к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
  * IaaC - Предоставляет больший контроль над инфраструктурой, исключает ручную настройку ресурсов, что в свою очередь снижает возможность возникновения "Дрейфа конфигурации" и значительно ускоряет процесс развертывания.
  
- Какой из принципов IaaC является основополагающим?
  * Идемпотентность - Получение одинакового результата при повторном выполнении операции.
  

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями? 
  * Отсутствие агентов, которые необходимо устанавливать на конфигурируемые сервера, вся конфигурация происходит по SSH. 
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
  * Как по мне более надежный является метод Push, поскольку за распределение отвечает централизованный сервер, а не агент на конфигурируемом сервере.

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*
  * Virtualbox
  ``` bash
  $ VboxManage --version
  6.1.26.r145957
  ```
  * Vagrant
  ```bash
  $ vagrant --version                                                                       ✔ 
  Vagrant 2.2.18  
  ```

  * Ansible
  ```bash
  $ ansible --version
  ansible [core 2.11.5]
  ```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```

[vagrant & ansible](https://github.com/EmilTK/devops-netology/tree/main/homeworks/solution/vm)
```bash
$ vagrant ssh                     
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Tue 02 Nov 2021 05:44:38 PM UTC

  System load:  0.1               Users logged in:          0
  Usage of /:   3.2% of 61.31GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 21%               IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                IPv4 address for eth1:    192.168.192.11
  Processes:    105


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Tue Nov  2 17:43:54 2021 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ 
```


