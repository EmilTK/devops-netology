provider "yandex" {
#Environment variables are used
}

locals {
  cores = 2
  memory = 2
  nat-static_ip = "192.168.10.254"
  nat-instance = "fd80mrhj8fl2oe87o4e1"
  centos7 = "fd8hedriopd1p208elrg"
  ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
}

# Network 
resource "yandex_vpc_network" "default" {
  name = "netology"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
}

resource "yandex_vpc_subnet" "private" {
  name           = "private"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-a"
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

# Compute instance
resource "yandex_compute_instance" "nat-instance" {
  name        = "nat-instance"
  hostname    = "nat-instance"
  platform_id = "standard-v1"

  resources {
    cores  = local.cores
    memory = local.memory
  }

  boot_disk {
    initialize_params {
      image_id = local.nat-instance
    }
  }

    network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    ip_address = local.nat-static_ip
    nat        = true
  }

  metadata = {
    ssh-keys = local.ssh-keys
  }

}

resource "yandex_compute_instance" "centos7-vm1" {
  name        = "centos7-vm1"
  hostname    = "centos7-vm1"
  platform_id = "standard-v1"

  resources {
    cores  = local.cores
    memory = local.memory
  }

  boot_disk {
    initialize_params {
      image_id = local.centos7
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    ssh-keys = local.ssh-keys
  }
}

resource "yandex_compute_instance" "centos7-vm2" {
  name        = "centos7-vm2"
  hostname    = "centos7-vm2"
  platform_id = "standard-v1"

  resources {
    cores  = local.cores
    memory = local.memory
  }

  boot_disk {
    initialize_params {
      image_id = local.centos7
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
  }

  metadata = {
    ssh-keys = local.ssh-keys
  }
}