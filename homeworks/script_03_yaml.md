# Домашняя работа к занятию "4.3. Языки разметки JSON и YAML"

## Обязательные задания

1. Мы выгрузили JSON, который получили через API запрос к нашему сервису:
	```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
	```
  Нужно найти и исправить все ошибки, которые допускает наш сервис
	
   ```json
	{
	  "info": "Sample JSON output from our service\\t",
	  "elements": [
		{
		  "name": "first",
		  "type": "server",
		  "ip": 7175
		},
		{
		  "name": "second",
		  "type": "proxy",
		  "ip": "71.78.22.43"
		}
	  ]
	}	
   ```
2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.


* Если я правильно понял, записывать в файл необходимо только один сервис. Просто для примера сделал на основе 
	  индекса в списке.

	```python
	#! /usr/bin/env python3

    import time
    import socket
    import json
    import yaml

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
            if service == services[0]:
                with open('service.json', 'w') as js:
                    json.dump({service: ip}, js)
            elif service == services[1]:
                with open('service.yml', 'w') as yml:
                    yaml.dump({service: ip}, yml)
        time.sleep(10)
	```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Решение ###
   * Файл [original_json.json](solution/json_yml/original_json.json) - json 
   * Файл [original_yaml.yaml](solution/json_yml/original_yaml.yaml) - yaml
   * Файл [json.yaml](solution/json_yml/json.yaml) - json с расширением .yaml
   * Файл [yaml.json](solution/json_yml/yaml.json) - yaml с расширением .json 

Пробовал реализовать проверку на соответствие файла его расширению с помошью функций:

```python
def is_json(file):
    try:
        json_object = json.load(file)
    except ValueError as e:
        return False
    return True


def is_yaml(file):
    try:
        yaml_object = yaml.safe_load(myyaml)
    except yaml.YAMLError as e:
        return False
    return True
```
При такой реализации файл [json.yaml](solution/json_yml/json.yaml) который содержит в себе `JSON`
проходит проверку функции `is_yaml`, что не является верным.

Поэтому данный функционал реализовал по другому [script_03.py](solution/script_03.py):
```python
#!/usr/bin/env python3

import os
import sys
import json
import yaml


def main(file):
    filename, file_extension = os.path.splitext(file)
    if file_extension == '.json':
        try:
            with open(file, 'r') as json_in:
                json_object = json.load(json_in)
                with open(f'{filename}.yml', 'w') as yml_out:
                    yaml.dump(json_object, yml_out)
        except json.decoder.JSONDecodeError:
            print(f'{file} - the file in not JSON')

    elif file_extension in ('.yml', '.yaml'):
        with open(file, 'r') as yml_in:
            lines = yml_in.readlines()
            if lines[0] != '{\n' and lines[-1] != '}':
                yml_in.seek(0)
                yml_object = yaml.safe_load(yml_in)
                with open(f'{filename}.json', 'w') as json_out:
                    json.dump(yml_object, json_out)
            else:
                print(f'{file} - the file is not YAML')
    else:
        print('The file is not JSON or YAML')


if __name__ == "__main__":
    try:
        main(os.path.join(sys.argv[1]))
    except IndexError:
        print('Specify the path to the file')


```

```bash
vagrant@vagrant:~/test/json$ ls
json.yaml  original_json.json  original_yaml.yaml  script_03.py  yaml.json
vagrant@vagrant:~/test/json$ ./script_03.py json.yaml
json.yaml - the file is not YAML
vagrant@vagrant:~/test/json$ ./script_03.py yaml.json
yaml.json - the file in not JSON
vagrant@vagrant:~/test/json$ ./script_03.py original_json.json
Convert JSON file: original_json.json to YAML - original_json.yaml
vagrant@vagrant:~/test/json$ ./script_03.py original_yaml.yaml
Convert YAML file: original_yaml.yaml to JSON - original_yaml.json
vagrant@vagrant:~/test/json$ ll
total 36
drwxrwxr-x 2 vagrant vagrant 4096 Oct  8 20:44 ./
drwxrwxr-x 5 vagrant vagrant 4096 Oct  8 17:59 ../
-rw-rw-r-- 1 vagrant vagrant   66 Oct  8 18:00 json.yaml
-rw-rw-r-- 1 vagrant vagrant  452 Oct  8 18:01 original_json.json
-rw-rw-r-- 1 vagrant vagrant  264 Oct  8 20:44 original_json.yaml
-rw-rw-r-- 1 vagrant vagrant  522 Oct  8 20:44 original_yaml.json
-rw-rw-r-- 1 vagrant vagrant  527 Oct  8 18:02 original_yaml.yaml
-rwxrwxr-x 1 vagrant vagrant 1307 Oct  8 18:06 script_03.py*
-rw-rw-r-- 1 vagrant vagrant  650 Oct  8 18:01 yaml.json
vagrant@vagrant:~/test/json$

```
	
		
