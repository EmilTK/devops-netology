locals {
  cores         = 2
  memory        = 2
  ssh-keys      = "centos:${file("~/.ssh/id_rsa.pub")}"
  nods = toset([
    "centos7-vm1",
    "centos7-vm2",
  ])
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
      image_id = var.nat-instance
    }
  }

    network_interface {
    subnet_id  = yandex_vpc_subnet.public-a.id
    ip_address = var.nat-static_ip
    nat        = true
  }

  metadata = {
    ssh-keys = local.ssh-keys
  }

}

resource "yandex_compute_instance" "centos7" {
  for_each = local.nods
  name        = each.key
  hostname    = each.key
  platform_id = "standard-v1"

  resources {
    cores  = local.cores
    memory = local.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.centos7
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public-a.id
    nat       = true
  }

  metadata = {
    ssh-keys = local.ssh-keys
  }
}
