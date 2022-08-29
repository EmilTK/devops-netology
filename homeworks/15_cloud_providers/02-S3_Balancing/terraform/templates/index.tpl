#cloud-config
runcmd:
  - [ sh, -c, "echo '<img src='https://storage.yandexcloud.net/${bucket}/${file_name}'>' > /var/www/html/index.html" ]