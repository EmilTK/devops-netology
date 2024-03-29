# Домашняя работа к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
    * Windows - `ipconfig /all`
    * Linux - `ip link show`


2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
   * Для определения соседа по сетевому интерфейсу используется протокол LLDP
   * Используется пакет `lldpd`
   * Команда `lldpctl`


3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
   * Технология VLAN
   * Пакет `vlan` 
   #### Создать VLAN на интерфейсе с помощью команды `ip` ####
   * `ip link add link eth0 name eth0.10 type vlan id 10`
   * Присвоить адрес: `ip addr add 192.168.1.10/24 brd 192.168.1.255 dev eth0.10`  
   * Активировать: `ip link set dev eth0.10 up`
   * Удалить VLAN: `ip link set dev eth0.10 down && ip link delete eth0.10`
    
   #### Создать статический VLAN интерфейс: ####
   * Отредактировать файл `/etc/network/interfaces`
   * Добавить в файл:
   ```bash
   auth eth0.10
   iface eth0.10 inet static
   address 192.168.1.10
   netmask 255.255.255.0
   vlan-raw-device eth0 
   ```
   * Включить интерфейс: `ifup eth0.10`
   * Проверить:  `cat /proc/net/vlan/config`
   * Выключить интерфейс: `ifdown eth0.10`
    

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
   * Mode-0(balance-rr) – Данный режим используется по умолчанию. Balance-rr обеспечивается балансировку нагрузки и отказоустойчивость. В данном режиме сетевые пакеты отправляются “по кругу”, от первого интерфейса к последнему.
   * Mode-1(active-backup) – Один из интерфейсов работает в активном режиме, остальные в ожидающем. При обнаружении проблемы на активном интерфейсе производится переключение на ожидающий интерфейс.
   * Mode-2(balance-xor) – Передача пакетов распределяется по типу входящего и исходящего трафика по формуле ((MAC src) XOR (MAC dest)) % число интерфейсов. Режим дает балансировку нагрузки и отказоустойчивость.
   * Mode-3(broadcast) – Происходит передача во все объединенные интерфейсы, тем самым обеспечивая отказоустойчивость. Рекомендуется только для использования MULTICAST трафика.
   * Mode-4(802.3ad) – динамическое объединение одинаковых портов. В данном режиме можно значительно увеличить пропускную способность входящего так и исходящего трафика.
   * Mode-5(balance-tlb) – Адаптивная балансировки нагрузки трафика. Входящий трафик получается только активным интерфейсом, исходящий распределяется в зависимости от текущей загрузки канала каждого интерфейса.
   * Mode-6(balance-alb) – Адаптивная балансировка нагрузки. Отличается более совершенным алгоритмом балансировки нагрузки чем Mode-5). Обеспечивается балансировку нагрузки как исходящего так и входящего трафика.
    
   #### Создать агрегированный интерфейс с помощью команды `ip` ####
      ``` bash
      ip link add bond0 type bond mode 802.3ad
      ip link set eth0 master bond0
      ip link set eth1 master bond0
      ```
   #### Создать статический агрегированный интерфейс Mode-1 ####
   * Отредактировать файл `/etc/network/interfaces`
   * Добавить в файл:
   ```bash
   auto bond0
   iface bond0 inet static
       iaddress 192.168.1.10
       netmask 255.255.255.0
       network 192.168.1.0
       gateway 192.168.1.1
       bond-slaves eth0 eth1
       bond-mode active-backup
       bond-miimon 100  # Это значение определяет как часто будет проверяться состояние соединения на каждом интерфейсе в миллисекундах.
       bond-downdelay 200  # Время в миллисекунд ожидания, прежде чем отключить slave в случае отказа соединения.
       bond-updelay 200 # Время в миллисекунд ожидания, прежде чем включить slave после восстановления соединения.
   ```
   * Выключить интерфейсы и включить bond-интерфейс: `ifdown eth0 && ifdown eth1 && ifup bond0`
   * Подробная информация: `$ cat /proc/net/bonding/bond0`
 

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
   * Всего в сети 8 IP-адресов, 6 из них выделены под пользовательские хосты
   * Сеть с маской /24, можно разделить на 32 подсети с маской /29. 
   ```bash
   ipcalc 10.10.10.0/24 /29
   ...
   Subnets:   32
   Hosts:     192
   ```  
   * Пример подсетей с маской /29
   ```bash
   10.10.10.72/29
   10.10.10.80/29
   10.10.10.88/29
   10.10.10.96/29
   ```
   

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
   * Сеть 100.64.0.0/26
   ```bash
   ipcalc 100.64.0.0 -s 50
   1. Requested size: 50 hosts
   Netmask:   255.255.255.192 = 26 11111111.11111111.11111111.11 000000
   Network:   100.64.0.0/26        01100100.01000000.00000000.00 000000
   HostMin:   100.64.0.1           01100100.01000000.00000000.00 000001
   HostMax:   100.64.0.62          01100100.01000000.00000000.00 111110
   Broadcast: 100.64.0.63          01100100.01000000.00000000.00 111111
   Hosts/Net: 62                    Class A

   Needed size:  64 addresses.
   Used network: 100.64.0.0/26
   ```


7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
   * Windows:
      * Вывод ARP таблицы: `arp -a`
      * Удаление одной записи: `arp -d ip_addr`
      * Очистить кеш полностью: `netsh interface ip delete arpcache`
   * Linux: 
      * Вывод ARP таблицы: `ip neigh show`
      * Удаление одной записи: `ip neigh del ip_addr dev ethX`
      * Очистить кеш полностью: `ip neigh flush dev all`
   