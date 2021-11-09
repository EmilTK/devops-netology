# Домашняя работа к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.
    *   Разреженные – это специальные файлы, которые не позволяют ФС занимать свободное дисковое пространство носителя,
        когда разделы не заполнены.<br>
        Как я это понял - При создании разряженного файла определенного объема, ФС не резервирует под этот файл 
        указанный объем на диске и не заполняет его нулями. Занимаемый размер файла на диске будет увеличиваться по мере
        наполнения файла.<br>
        Аналогия разреженных файлов - это динамические диски в системах виртуализации.
        
1. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
   * Не могут, т.к. жесткие ссылки указывают на один и тот же участок жесткого диски, что и исходный файл. Значение 
     inode и набор разрешений у них схожий.
1. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

1. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
    ```bash
    Command (m for help): p
    Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0xcbc76a02

    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdb1          2048 4196351 4194304    2G 83 Linux
    /dev/sdb2       4196352 5242879 1046528  511M 83 Linux
    ```

1. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.
    ```bash 
    root@vagrant:~# sfdisk -d /dev/sdb | sfdisk /dev/sdc
    ```

1. Соберите `mdadm` RAID1 на паре разделов 2 Гб.
    ```bash 
    root@vagrant:~# mdadm --create --verbose /dev/md1 -l 1 -n 2 /dev/sdb1 /dev/sdc1
    root@vagrant:~# lsblk
      NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT 
      sdb                    8:16   0  2.5G  0 disk
      ├─sdb1                 8:17   0    2G  0 part
      │ └─md1                9:1    0    2G  0 raid1
      └─sdb2                 8:18   0  511M  0 part
      sdc                    8:32   0  2.5G  0 disk
      ├─sdc1                 8:33   0    2G  0 part
      │ └─md1                9:1    0    2G  0 raid1
      └─sdc2                 8:34   0  511M  0 part
    ```

1. Соберите `mdadm` RAID0 на второй паре маленьких разделов.
    ```bash 
    root@vagrant:~# mdadm --create --verbose /dev/md0 -l 0 -n 2 /dev/sdb2 /dev/sdc2
    root@vagrant:~# lsblk
    NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    sdb                    8:16   0  2.5G  0 disk
    ├─sdb1                 8:17   0    2G  0 part
    │ └─md1                9:1    0    2G  0 raid1
    └─sdb2                 8:18   0  511M  0 part
      └─md0                9:0    0 1018M  0 raid0
    sdc                    8:32   0  2.5G  0 disk
    ├─sdc1                 8:33   0    2G  0 part
    │ └─md1                9:1    0    2G  0 raid1
    └─sdc2                 8:34   0  511M  0 part
      └─md0                9:0    0 1018M  0 raid0
    ```

1. Создайте 2 независимых PV на получившихся md-устройствах.
    ```bash
    root@vagrant:~# pvcreate /dev/md0
    Physical volume "/dev/md0" successfully created.
    root@vagrant:~# pvcreate /dev/md1
    Physical volume "/dev/md1" successfully created.
    root@vagrant:~# pvs
    PV         VG        Fmt  Attr PSize    PFree
    /dev/md0             lvm2 ---  1018.00m 1018.00m
    /dev/md1             lvm2 ---    <2.00g   <2.00g
    /dev/sda5  vgvagrant lvm2 a--   <63.50g       0
    ```

1. Создайте общую volume-group на этих двух PV.
    ```bash
    root@vagrant:~# vgcreate vg01 /dev/md0 /dev/md1
    Volume group "vg01" successfully created
    root@vagrant:~# vgdisplay
      ...
      --- Volume group ---
      VG Name               vg01
      System ID
      Format                lvm2
      Metadata Areas        2
      Metadata Sequence No  1
      VG Access             read/write
      VG Status             resizable
      MAX LV                0
      Cur LV                0
      Open LV               0
      Max PV                0
      Cur PV                2
      Act PV                2
      VG Size               <2.99 GiB
      PE Size               4.00 MiB
      Total PE              765
      Alloc PE / Size       0 / 0
      Free  PE / Size       765 / <2.99 GiB
      VG UUID               On7EdJ-ZZf2-YOI4-Jzi6-TEt4-iocr-da3VYw
    ```

1. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
    ```bash
   root@vagrant:~# lvcreate -L100 -n lv1 vg01 /dev/md0
     Logical volume "lv1" created. 
   root@vagrant:~# lvdisplay
      --- Logical volume ---
      LV Path                /dev/vg01/lv1
      LV Name                lv1
      VG Name                vg01
      LV UUID                AQp7Du-kOh2-dHnE-7vax-MhOO-3owX-fHxJcB
      LV Write Access        read/write
      LV Creation host, time vagrant, 2021-09-13 18:38:13 +0000
      LV Status              available
      # open                 0
      LV Size                100.00 MiB
      Current LE             25
      Segments               1
      Allocation             inherit
      Read ahead sectors     auto
      - currently set to     4096
      Block device           253:2
       ```
1. Создайте `mkfs.ext4` ФС на получившемся LV.
   ```bash
   root@vagrant:~# mkfs.ext4 /dev/vg01/lv1
    mke2fs 1.45.5 (07-Jan-2020)
    Creating filesystem with 25600 4k blocks and 25600 inodes

    Allocating group tables: done
    Writing inode tables: done
    Creating journal (1024 blocks): done
    Writing superblocks and filesystem accounting information: done 
   ```
1. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.
    ```bash
    root@vagrant:~# mount /dev/vg01/lv1 /tmp/new/
    ```

1. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

1. Прикрепите вывод `lsblk`.
    ```bash
    root@vagrant:~# lsblk
    NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    sda                    8:0    0   64G  0 disk
    ├─sda1                 8:1    0  512M  0 part  /boot/efi
    ├─sda2                 8:2    0    1K  0 part
    └─sda5                 8:5    0 63.5G  0 part
      ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
      └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
    sdb                    8:16   0  2.5G  0 disk
    ├─sdb1                 8:17   0    2G  0 part
    │ └─md1                9:1    0    2G  0 raid1
    └─sdb2                 8:18   0  511M  0 part
      └─md0                9:0    0 1018M  0 raid0
        └─vg01-lv1       253:2    0  100M  0 lvm   /tmp/new
    sdc                    8:32   0  2.5G  0 disk
    ├─sdc1                 8:33   0    2G  0 part
    │ └─md1                9:1    0    2G  0 raid1
    └─sdc2                 8:34   0  511M  0 part
      └─md0                9:0    0 1018M  0 raid0
        └─vg01-lv1       253:2    0  100M  0 lvm   /tmp/new
    ```

1. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
   * Работает
   ```bash
   root@vagrant:~# gzip -t /tmp/new/test.gz
   root@vagrant:~# echo $?
   0
   ```
1. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
    ```bash
    root@vagrant:~# pvmove /dev/md0 /dev/md1
    /dev/md0: Moved: 12.00%
    /dev/md0: Moved: 100.00%
    ```

1. Сделайте `--fail` на устройство в вашем RAID1 md.
    ```bash 
    root@vagrant:~# mdadm /dev/md1 --fail /dev/sdb1
    mdadm: set /dev/sdb1 faulty in /dev/md1
    ```

1. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
    ```bash
    root@vagrant:~# dmesg
    ...
    [ 3402.602680] md/raid1:md1: Disk failure on sdb1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
    ```

1. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
    * Работает 
    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ``` 
1. Погасите тестовый хост, `vagrant destroy`.

 