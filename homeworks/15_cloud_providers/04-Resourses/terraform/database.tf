resource "yandex_mdb_mysql_cluster" "netology-mysql" {
  name        = "netology-mysql_cluster"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.default.id
  version     = "8.0"
  deletion_protection = "true"

  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-hdd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.private-a.id
  }

  host {
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.private-b.id
  }

  host {
    zone      = "ru-central1-c"
    subnet_id = yandex_vpc_subnet.private-c.id
  }

  backup_window_start {
    hours     = "23"
    minutes   = "59"
  }

  depends_on = [
    yandex_vpc_network.default,
    yandex_vpc_subnet.private-a,
    yandex_vpc_subnet.private-b,
    yandex_vpc_subnet.private-c,
  ]

}

resource "yandex_mdb_mysql_database" "netology-db" {
  cluster_id = yandex_mdb_mysql_cluster.netology-mysql.id
  name       = "netology_db"

  depends_on = [
    yandex_mdb_mysql_cluster.netology-mysql,
  ]
}

resource "yandex_mdb_mysql_user" "admin" {
    cluster_id = yandex_mdb_mysql_cluster.netology-mysql.id
    name       = "netology"
    password   = "netology"

    permission {
      database_name = yandex_mdb_mysql_database.netology-db.name
      roles         = ["ALL"]
    }

    authentication_plugin = "SHA256_PASSWORD"

    depends_on = [
      yandex_mdb_mysql_cluster.netology-mysql,
      yandex_mdb_mysql_database.netology-db,
    ]
}