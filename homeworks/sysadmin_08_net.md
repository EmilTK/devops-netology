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

 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

6*. Установите Nginx, настройте в режиме балансировщика TCP или UDP.

7*. Установите bird2, настройте динамический протокол маршрутизации RIP.

8*. Установите Netbox, создайте несколько IP префиксов, используя curl проверьте работу API.
