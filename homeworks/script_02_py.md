# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательные задания

1. Есть скрипт:
	```python
    #!/usr/bin/env python3
	a = 1
	b = '2'
	c = a + b
	```
	* Какое значение будет присвоено переменной c?
	  * Данный пример вызовет ошибку из-за различия типов данных
	* Как получить для переменной c значение 12?
	  * Если мы хотим получить строку: `c = (str(a) + b)`
	  * Если мы хотим получить число: `c = int(str(a) +b)`
	* Как получить для переменной c значение 3?
	  * `c = a + int(b)`
1. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

	```python
    #!/usr/bin/env python3

    import os

	bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
	result_os = os.popen(' && '.join(bash_command)).read()
    is_change = False
	for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(prepare_result)
            break

	```
 	* Исходя из задания, необходимо выводить только модифицированные файлы, про новые и удаленные файлы ничего не сказано.
	Тогда решение такое:
    ```python
	   #!/usr/bin/env python3

	   import os

	   path = os.path.join('~/netology/sysadm-homeworks')
	   bash_command = [f"cd {path}", "git status"]
	   result_os = os.popen(' && '.join(bash_command)).read()

	   for result in result_os.split('\n'):
       if result.find('modified') != -1:
        	prepare_result = result.replace('\tmodified:   ', '')
        	print(os.path.join(path, prepare_result))
	```
   * Результат:
	
	```bash
	vagrant@vagrant:~/netology/sysadm-homeworks$ ./main.py
	~/netology/sysadm-homeworks/test.txt
	~/netology/sysadm-homeworks/testing_python.py
	~/netology/sysadm-homeworks/vol1/volumes.ini
    ```
 
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.
	```python
	#!/usr/bin/env python3

   import os
   import sys


   path = os.path.join(sys.argv[1])
   bash_command = [f"cd {path}", "git status"]

   try:
        if ".git" in os.listdir(path):
            result_os = os.popen(' && '.join(bash_command)).read()
            print('modified:')
            for result in result_os.split('\n'):
                if result.find('modified') != -1:
                    prepare_result = result.replace('\tmodified:   ', '')
                    print(' -', os.path.join(path, prepare_result))
        else:
            print('The specified directory is not a git repository.')
   except FileNotFoundError:
       print(f'Directory "{path}" not found')
   except NotADirectoryError:
        print('The passed value is not a director.')
    ```
	
   * Результат:
   ```bash
   vagrant@vagrant:~/test/py_script$ ./main.py ~/netology/sysadm-homeworks/
   modified:
    - /home/vagrant/netology/sysadm-homeworks/test.txt
    - /home/vagrant/netology/sysadm-homeworks/testing_python.py
    - /home/vagrant/netology/sysadm-homeworks/vol1/volumes.ini
   ```

1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.
	```python
	#! /usr/bin/env python3

    import time
    import socket

    services = ('drive.google.com', 'mail.google.com', 'google.com')
    ip_hosts = {}

    while True:
    for service in services:
        ip = socket.gethostbyname(service)

        if service not in ip_hosts.keys():
            ip_hosts[service] = ip

        else:
            if ip != ip_hosts[service]:
                print(f'[ERROR] {service} IP mismatch: {ip_hosts[service]} -> {ip}')
                ip_hosts[service] = ip
        print(f'{service:20} - {ip}')
    time.sleep(10)
    ```
 	* Результат:
	
	```bash
	vagrant@vagrant:~/test/py_script$ ./checkdns.py
	drive.google.com     - 173.194.73.194
	mail.google.com      - 74.125.205.17
	google.com           - 64.233.164.139
	drive.google.com     - 173.194.73.194
	mail.google.com      - 74.125.205.17
	google.com           - 64.233.164.139
	drive.google.com     - 173.194.73.194
	mail.google.com      - 74.125.205.17
	[ERROR] google.com IP mismatch: 64.233.164.139 -> 10.0.0.1
	google.com           - 10.0.0.1
	drive.google.com     - 173.194.73.194
	[ERROR] mail.google.com IP mismatch: 74.125.205.17 -> 74.125.205.83
	mail.google.com      - 74.125.205.83
	google.com           - 10.0.0.1
	drive.google.com     - 173.194.73.194
	mail.google.com      - 74.125.205.83
	google.com           - 10.0.0.1
	drive.google.com     - 173.194.73.194
	mail.google.com      - 74.125.205.83
	[ERROR] google.com IP mismatch: 10.0.0.1 -> 64.233.164.101
	google.com           - 64.233.164.101	
 
 	```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 
