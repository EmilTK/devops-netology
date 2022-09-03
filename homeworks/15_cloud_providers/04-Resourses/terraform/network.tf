resource "yandex_vpc_network" "default" {
  name = "netology"
}

resource "yandex_vpc_subnet" "public-a" {
  name           = "public-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
}

resource "yandex_vpc_subnet" "public-b" {
  name           = "public-b"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.default.id}"
}

resource "yandex_vpc_subnet" "public-c" {
  name           = "public-c"
  v4_cidr_blocks = ["192.168.30.0/24"]
  zone           = "ru-central1-c"
  network_id     = "${yandex_vpc_network.default.id}"
}


resource "yandex_vpc_subnet" "private-a" {
  name           = "private-a"
  v4_cidr_blocks = ["192.168.40.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  route_table_id = "${yandex_vpc_route_table.private-rt.id}"
}

resource "yandex_vpc_subnet" "private-b" {
  name           = "private-b"
  v4_cidr_blocks = ["192.168.50.0/24"]
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.default.id}"
  route_table_id = "${yandex_vpc_route_table.private-rt.id}"
}

resource "yandex_vpc_subnet" "private-c" {
  name           = "private-c"
  v4_cidr_blocks = ["192.168.60.0/24"]
  zone           = "ru-central1-c"
  network_id     = "${yandex_vpc_network.default.id}"
  route_table_id = "${yandex_vpc_route_table.private-rt.id}"
}

resource "yandex_vpc_route_table" "private-rt" {
  name       = "private_rt"
  network_id = "${yandex_vpc_network.default.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "${yandex_compute_instance.nat-instance.network_interface.0.ip_address}"
  }
}
