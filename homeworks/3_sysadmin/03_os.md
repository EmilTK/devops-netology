# Домашняя работа к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.
   * ```bash
      vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp' 2>&1 | grep chdir
      chdir("/tmp")                           = 0
      ```
1. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.
   * "/usr/share/misc/magic.mgc"
   
1. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
   * Получаем PID процесса: `lsof | grep deleted`
   * Получаем дескриптор: `ll /proc/PID/fd/ | gred deleted`
   * Отправляем пустую строку: `> /proc/PID/fd/<Дескриптор>`

1. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
   * Зомби-процессы не занимают ресурсы, т.к. освобождают все свои ранее используемые ресурсы
1. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).
   * ```bash
      vagrant@vagrant:~$ sudo opensnoop-bpfcc
      PID    COMM               FD ERR PATH
      1      systemd            12   0 /proc/401/cgroup
      766    vminfo              4   0 /var/run/utmp
      578    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
      578    dbus-daemon        18   0 /usr/share/dbus-1/system-services
      578    dbus-daemon        -1   2 /lib/dbus-1/system-services
      578    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
      583    irqbalance          6   0 /proc/interrupts
      583    irqbalance          6   0 /proc/stat
      583    irqbalance          6   0 /proc/irq/20/smp_affinity
      583    irqbalance          6   0 /proc/irq/0/smp_affinity
      583    irqbalance          6   0 /proc/irq/1/smp_affinity
      583    irqbalance          6   0 /proc/irq/8/smp_affinity
      583    irqbalance          6   0 /proc/irq/12/smp_affinity
      583    irqbalance          6   0 /proc/irq/14/smp_affinity
      583    irqbalance          6   0 /proc/irq/15/smp_affinity
      766    vminfo              4   0 /var/run/utmp
      578    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
      578    dbus-daemon        18   0 /usr/share/dbus-1/system-services
      578    dbus-daemon        -1   2 /lib/dbus-1/system-services
      578    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
      766    vminfo              4   0 /var/run/utmp
     ```
6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.
   * `uname -a` - использует системный вызов `uname`.</br>
   * `man 2 uname`
     ```bash
      char version[];    /* Operating system version */
     ```
   * `man proc`
      ```
     /proc/version
     This string identifies the kernel version that is currently running.  It includes the
     contents of /proc/sys/kernel/ostype,  /proc/sys/kernel/osrelease  and  /proc/sys/ker‐
     nel/version.`
     ```

1. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?
   * Оператор `;` - Применяется для последовательного исполнения команд, записанных в одну строку и разделенных данным оператором
   * Оператор `&&` - Команда находящаяся после данного оператора, будет выполнена только в случае успешного завершения первой команды (статус 0)
   * `set -e` - Прерывает выполнение, если получен не нулевой статус выполнения команды, использовать `&&` нет смысла.
1. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
   * `-e` - Немедленное завершение выполнения, если получен не нулевой статус;
   * `-u` - Если установлена, ссылка на любую переменную, которую ранее не определили, за исключением $ * и $ @, 
     является ошибкой и вызывает немедленный выход из программы;
   * `-x` - Все выполненные команды выводятся на терминал;
   * `-o` - Если какая-либо команда в конвейере терпит неудачу, этот код возврата будет использоваться как код возврата
     всего конвейера.
   * Данная конструкция удобна для отслеживания выполнения сценария и своевременного получения ошибок без продолжения
     дальнейшего выполнения, что в свою очередь помогает ускорить процесс устранения ошибок.   
1. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
   * Наиболее часто встречающийся статус это `I` - процесс бездействующий более 20 сек.
   * ```bash
      ps -e -o stat | sort | uniq -d -c
         8 I
        40 I<
        24 S
         2 S+
         2 SN
        15 Ss
         5 Ssl
      ```
