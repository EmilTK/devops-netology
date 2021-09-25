# Домашняя работа к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```
* ```bash
  route-views>show ip route my_domain
  Routing entry for 88.201.211.0/24
  Known via "bgp 6447", distance 20, metric 0
  Tag 3267, type external
  Last update from 194.85.40.15 2d06h ago
  Routing Descriptor Blocks:
  * 194.85.40.15, from 194.85.40.15, 2d06h ago
      Route metric is 0, traffic share count is 1
      AS Hops 2
      Route tag 3267
      MPLS label: none
  
  route-views>show bgp my_ip
  BGP routing table entry for 88.201.211.0/24, version 1038509300
  Paths: (1 available, best #1, table default)
  Not advertised to any peer
  Refresh Epoch 1
  3267 35807
    194.85.40.15 from 194.85.40.15 (185.141.126.1)
      Origin incomplete, metric 0, localpref 100, valid, external, best
      path 7FE0A0D7D128 RPKI State not found
      rx pathid: 0, tx pathid: 0x0
  ```
2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
   ```bash
   root@vagrant:~# ip -br link
   lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
   eth0             UP             08:00:27:73:60:cf <BROADCAST,MULTICAST,UP,LOWER_UP>
   dummy0           UNKNOWN        72:ff:e4:a8:99:92 <BROADCAST,NOARP,UP,LOWER_UP>
   root@vagrant:~# ip r
   default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
   10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
   10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
   172.16.200.0/24 dev dummy0 scope link
   192.168.15.0/24 via 10.0.2.2 dev eth0
   ```
3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
   ```bash
   root@vagrant:~# netstat -lptn
   Active Internet connections (only servers)
   Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
   tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      1/init
   tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      577/systemd-resolve
   tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      844/sshd: /usr/sbin
   tcp6       0      0 :::111                  :::*                    LISTEN      1/init
   tcp6       0      0 :::22                   :::*                    LISTEN      844/sshd: /usr/sbin
   ```

4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
   ```bash 
   root@vagrant:~# netstat -lpun
   Active Internet connections (only servers)
   Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
   udp        0      0 127.0.0.53:53           0.0.0.0:*                           577/systemd-resolve
   udp        0      0 10.0.2.15:68            0.0.0.0:*                           403/systemd-network
   udp        0      0 0.0.0.0:111             0.0.0.0:*                           1/init
   udp6       0      0 :::111                  :::*                                1/init
   ```

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 
![home_network](./scheme/home_network.png)
 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

6*. Установите Nginx, настройте в режиме балансировщика TCP или UDP.
   * Установка nginx `apt update && apt install nginx`
   * Для тестирование балансировки запустил три контейнера nginx:
   ```bash
    docker run -it --rm -d -p 8082:80 --name web1 -v ~/projects/netology/site1:/usr/share/nginx/html nginx
    docker run -it --rm -d -p 8083:80 --name web2 -v ~/projects/netology/site2:/usr/share/nginx/html nginx
    docker run -it --rm -d -p 8084:80 --name web3 -v ~/projects/netology/site3:/usr/share/nginx/html nginx
   ```
   * В каталогах site{1..3} находится файл `index.html` с содержимым:
   ```html
   <!doctype html>
   <html lang="en">
   <head>
     <meta charset="utf-8">
     <title>Nginx - load balancing 1</title>
   </head>
   <body>
     <h2>Hello from Nginx container #1</h2>  <!-- Номера отличаются -->
   </body>
   </html> 
   ```
   * Добавляем в `/etc/nginx/nginx.conf` в блок `http`:
   ```bash
   upstream backend1 {
     server 192.168.50.10:8082;
     server 192.168.50.10:8083;
     server 192.168.50.10:8084;
   }
   ```
   * Проверяем:
   ```BASH
  root@vagrant:~# curl 192.168.15.122/
   <!doctype html>
   <html lang="en">
   <head>
     <meta charset="utf-8">
     <title>Nginx - load balancing 2</title>
   </head>
   <body>
     <h2>Hello from Nginx container #2</h2>
   </body>
   </html>
   root@vagrant:~# curl 192.168.15.122/
   <!doctype html>
   <html lang="en">
   <head>
     <meta charset="utf-8">
     <title>Nginx - load balancing 3</title>
   </head>
   <body>
     <h2>Hello from Nginx container #3</h2>
   </body>
   </html>
   root@vagrant:~# curl 192.168.15.122/
   <!doctype html>
   <html lang="en">
   <head>
     <meta charset="utf-8">
     <title>Nginx - load balancing 1</title>
   </head>
   <body>
     <h2>Hello from Nginx container #1</h2>
   </body>
   </html> 
   ```
![load_balancing](./screenshots/sysadm_net_8_1.png)
![load_balancing](./screenshots/sysadm_net_8_2.png)
![load_balancing](./screenshots/sysadm_net_8_3.png)<br>

7*. Установите bird2, настройте динамический протокол маршрутизации RIP.
   * К сожалению, пока не разобрался.

8*. Установите Netbox, создайте несколько IP префиксов, используя curl проверьте работу API.

![netbox](./screenshots/netbox_prefix.png)<br>

```bash
root@vagrant:~# curl -X GET "http://192.168.50.10:8000/api/ipam/prefixes/" -H  "accept: application/json" -H  "Authorization: Token 0123456789abcdef0123456789abcdef01234567" | json_pp
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1213  100  1213    0     0  17328      0 --:--:-- --:--:-- --:--:-- 17084
{
   "count" : 2,
   "next" : null,
   "previous" : null,
   "results" : [
      {
         "_depth" : 0,
         "children" : 0,
         "created" : "2021-09-25",
         "custom_fields" : {},
         "description" : "",
         "display" : "10.9.128.0/23",
         "family" : {
            "label" : "IPv4",
            "value" : 4
         },
         "id" : 1,
         "is_pool" : true,
         "last_updated" : "2021-09-25T17:24:13.427694Z",
         "mark_utilized" : false,
         "prefix" : "10.9.128.0/23",
         "role" : null,
         "site" : {
            "display" : "Ð¡Ð¾Ð»Ð½ÐµÑÐ½ÑÐ¹ Ð³Ð¾ÑÐ¾Ð´",
            "id" : 1,
            "name" : "Ð¡Ð¾Ð»Ð½ÐµÑÐ½ÑÐ¹ Ð³Ð¾ÑÐ¾Ð´",
            "slug" : "sg",
            "url" : "http://192.168.50.10:8000/api/dcim/sites/1/"
         },
         "status" : {
            "label" : "Active",
            "value" : "active"
         },
         "tags" : [],
         "tenant" : null,
         "url" : "http://192.168.50.10:8000/api/ipam/prefixes/1/",
         "vlan" : null,
         "vrf" : null
      },
      {
         "_depth" : 0,
         "children" : 0,
         "created" : "2021-09-25",
         "custom_fields" : {},
         "description" : "",
         "display" : "10.9.130.0/23",
         "family" : {
            "label" : "IPv4",
            "value" : 4
         },
         "id" : 2,
         "is_pool" : true,
         "last_updated" : "2021-09-25T17:23:56.999316Z",
         "mark_utilized" : false,
         "prefix" : "10.9.130.0/23",
         "role" : null,
         "site" : {
            "display" : "Ð¡Ð¾Ð»Ð½ÐµÑÐ½ÑÐ¹ Ð³Ð¾ÑÐ¾Ð´",
            "id" : 1,
            "name" : "Ð¡Ð¾Ð»Ð½ÐµÑÐ½ÑÐ¹ Ð³Ð¾ÑÐ¾Ð´",
            "slug" : "sg",
            "url" : "http://192.168.50.10:8000/api/dcim/sites/1/"
         },
         "status" : {
            "label" : "Active",
            "value" : "active"
         },
         "tags" : [],
         "tenant" : null,
         "url" : "http://192.168.50.10:8000/api/ipam/prefixes/2/",
         "vlan" : null,
         "vrf" : null
      }
   ]
}

```