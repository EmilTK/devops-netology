provider "yandex" {
}

locals {
  cores = 2
  memory = 4
  image_id = "fd8hedriopd1p208elrg" #Centos7
  ssh-keys = "cloud-user:${file("~/.ssh/id_rsa.pub")}"
}


resource "yandex_compute_instance" "nexus" {
  name = "nexus"
  platform_id = "standard-v1"

  resources {
    cores  = local.cores
    memory = local.memory
  }

  boot_disk {
    initialize_params {
      image_id = local.image_id 
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = local.ssh-keys
  }
}

resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet"
  v4_cidr_blocks = ["10.2.0.0/24"]
  network_id     = yandex_vpc_network.network.id
}
