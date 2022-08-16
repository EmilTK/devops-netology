# Домашнее задание к занятию "10.06. Инцидент-менеджмент"

## Задание 1

Составьте постмотрем, на основе реального сбоя системы Github в 2018 году.

Информация о сбое доступна [в виде краткой выжимки на русском языке](https://habr.com/ru/post/427301/) , а
также [развёрнуто на английском языке](https://github.blog/2018-10-30-oct21-post-incident-analysis/).

### Краткое описание инцидента
22 октября 2018 года в 22:52 по UTC в результате регламентных работ по замене вышедшего из строя оптического оборудования была потеряна связь между оборудованием на Западном побережье США и основным центром обработки данных на Восточном поборежье США, что привело к ухудшению качества обслуживания на 24 часа 11 минут.

### Предшествующие события
Техническое обслуживания оптического сетевого оборудования 100G.

### Сбой
Отсутствия связи между датацентрами на 43 секунды.

### Последствия
На протяжении 24 часов и 11 минут у пользователей сервиса отсутствовала возможность создать issue, оставить комментарий, не работали хуки.

### Обнаружение
21.10.18 в 22:54 UTC дежурные инженеры получили оповещение от систем мониторинга и в 23:07 передали информацию координатору инцидента.

### Реакция
Команда по реагированию на инцидент восстановила согласованность кластерам БД и восстановила работоспособность всех сервисов за 24 часа и 11 минут.

### Восстановление
Был разработан план восстановления данных из резервных копий, синхронизации реплик на обоих площадках, возобнавление обработки запросов. БД была восстановлена из резерных копий. Пользовательские данные не пострадали.

### График

* 21.10.2008 22:52 UTC: Потеря связи между US East Coast network hub и US East Coast data center;
* 21.10.2008 22:54 UTC: Сработка системы мониторинга и оповещение дежурных инженеров;
* 21.10.2008 23:02 UTC: Выявлена проблема с топологией кластера БД;
* 21.10.2008 23:07 UTC: Внутренние обработчики переведены в режим read-only для предотвращения ухудшения ситуации;
* 21.10.2008 23:09 UTC: Сервис переведен в жёлтый статус, информация передана ответственному координатору инцидента;
* 21.10.2008 23:11 UTC: Кординатором инцеденнта был изменен статус на красный;
* 21.10.2008 23:13 UTC: Все сервисы переведены в режим read-only для восстановления работоспособности;
* 21.10.2008 23:19 UTC: Приостановлена работа webhook's и Github Pages;
* 22.10.2008 00:05 UTC: Принято решение восстановить базу из резервных копий и провести синхронизацию кластера;
* 22.10.2008 00:41 UTC: Запущено восстановление из резервных копий;
* 22.10.2008 06:51 UTC: Часть БД на Восточном побережье восстановлены, идёт репликация с Западным;
* 22.10.2008 07:46 UTC: Все БД на Восточном побережье восстановлены;
* 22.10.2008 16:24 UTC: Восстановление завершено, репликация завершена, топология восстановлена;
* 22.10.2008 16:45 UTC: Начинает обрабатываться очередь из скопившихся webhook'ов;
* 22.10.2008 23:03 UTC: Сервис работает в штатном режиме.


## Задача повышенной сложности

Прослушайте [симуляцию аудиозаписи о инциденте](https://youtu.be/vw6I5DYWkNA?t=1), предоставленную 
разработчиками инструмента для автоматизации инцидент-менеджмента PagerDuty.

На основании этой аудиозаписи попробуйте составить сообщения для пользователей о данном инциденте.

Должно быть 3 сообщения о:
- начале инцидента
- продолжающихся работах
- окончании инцидента и возвращении к штатной работе

---