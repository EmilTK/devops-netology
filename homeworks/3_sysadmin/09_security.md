# Домашняя работа к занятию "3.9. Элементы безопасности информационных систем"

1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.

![bitwarden](./screenshots/bitwarden.PNG)<br>

2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.

![bitwarden](./screenshots/bitwarden_two.PNG)<br>

3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.

![apache](./screenshots/apache_openssl.PNG)<br>

4. Проверьте на TLS уязвимости произвольный сайт в интернете. 
   ```bash
   vagrant@vagrant:~/testssl.sh$ ./testssl.sh -U --sneaky https://netology.ru
   ...
    Testing vulnerabilities

     Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
     CCS (CVE-2014-0224)                       not vulnerable (OK)
     Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
     ROBOT                                     not vulnerable (OK)
     Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed
     Secure Client-Initiated Renegotiation     not vulnerable (OK)
     CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
     BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/" tested
                                               Can be ignored for static pages or if no secrets in the page
     POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
     TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
     SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers
     FREAK (CVE-2015-0204)                     not vulnerable (OK)
     DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                               make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                               https://censys.io/ipv4?q=E0B331456C82BFE5B3C17868FD60F2BDD41D3981693D1F9ED6EC47D469BB3708 could help you to find out
     LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
     BEAST (CVE-2011-3389)                     TLS1: ECDHE-RSA-AES128-SHA AES128-SHA ECDHE-RSA-AES256-SHA
                                                     AES256-SHA DES-CBC3-SHA
                                               VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
     LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
     Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
     RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)
   ...
   ```
5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.
   * Генерация ключа `ssh-keygen`
   * Перенос открытого ключа на удаленный сервер: `ssh-copy-id username@remote_server` либо вручную скопировать содержимое файла
   `~/.ssh/id_rsa.pub` на удаленный сервер в файл `~/.ssh/autorized_keys`
   * Подключение к удаленному серверу: `ssh user@remote_server`
   
 
6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.
   * Переименовать файл ключа: `mv ~/.ssh/id_rsa ~/.ssh/vagrant_rsa`
   * Необходимо создать файл конфигурации ssh: `vim ~/.ssh/config`
   * Добавить:
   ```bash
   Host netology
   HostName remote_server_ip
   User remote_user
   Port 22
   IdentityFile ~/.ssh/vagrant_rsa
   ```
   * Подключение: `ssh netology`
   
7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.
   ```bash
   root@vagrant:~# tcpdump -v -c 100 -i eth1 -w tcpdump.pcap
   tcpdump: listening on eth1, link-type EN10MB (Ethernet), capture size 262144 bytes
   100 packets captured
   102 packets received by filter
   0 packets dropped by kernel
   ```
![wireshark](./screenshots/wireshark.PNG)<br>
 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

8*. Просканируйте хост scanme.nmap.org. Какие сервисы запущены?
   ```bash
   vagrant@vagrant:~$ nmap -sV scanme.nmap.org
   Starting Nmap 7.80 ( https://nmap.org ) at 2021-09-27 18:41 UTC
   Nmap scan report for scanme.nmap.org (45.33.32.156)
   Host is up (0.19s latency).
   Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f
   Not shown: 991 filtered ports
   PORT      STATE  SERVICE    VERSION
   21/tcp    closed ftp
   22/tcp    open   ssh        OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.13 (Ubuntu Linux; protocol 2.0)
   25/tcp    closed smtp
   80/tcp    open   http       Apache httpd 2.4.7 ((Ubuntu))
   199/tcp   closed smux
   587/tcp   closed submission
   995/tcp   closed pop3s
   9929/tcp  open   nping-echo Nping echo
   31337/tcp open   tcpwrapped
   Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

   Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
   Nmap done: 1 IP address (1 host up) scanned in 18.99 seconds
   ```

9*. Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443
   ```bash
   vagrant@vagrant:~$ sudo ufw status
   Status: active

   To                         Action      From
   --                         ------      ----
   Apache                     ALLOW       Anywhere
   Apache Secure              ALLOW       Anywhere
   OpenSSH                    ALLOW       Anywhere

   vagrant@vagrant:~$ sudo ufw app info 'Apache'
   Profile: Apache
   Title: Web Server
   Description: Apache v2 is the next generation of the omnipresent Apache web
   server.

   Port:
     80/tcp
   vagrant@vagrant:~$ sudo ufw app info 'Apache Secure'
   Profile: Apache Secure
   Title: Web Server (HTTPS)
   Description: Apache v2 is the next generation of the omnipresent Apache web
   server.

   Port:
     443/tcp
   vagrant@vagrant:~$ sudo ufw app info 'OpenSSH'
   Profile: OpenSSH
   Title: Secure shell server, an rshd replacement
   Description: OpenSSH is a free implementation of the Secure Shell protocol.

   Port:
     22/tcp
   ```