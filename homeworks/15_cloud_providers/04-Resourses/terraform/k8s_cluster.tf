

resource "yandex_kubernetes_cluster" "netology-k8s" {
  name        = "netology-k8s"

  network_id = "${yandex_vpc_network.default.id}"

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = "${yandex_vpc_subnet.public-a.zone}"
        subnet_id = "${yandex_vpc_subnet.public-a.id}"
      }

      location {
        zone      = "${yandex_vpc_subnet.public-b.zone}"
        subnet_id = "${yandex_vpc_subnet.public-b.id}"
      }

      location {
        zone      = "${yandex_vpc_subnet.public-c.zone}"
        subnet_id = "${yandex_vpc_subnet.public-c.id}"
      }
    }

    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day        = "sunday"
        start_time = "01:00"
        duration   = "3h"
      }
    }
  }

  kms_provider {
    key_id = yandex_kms_symmetric_key.key-1.id
  }

  service_account_id      = "${yandex_iam_service_account.sa-k8s.id}"
  node_service_account_id = "${yandex_iam_service_account.sa-k8s.id}"

  release_channel = "STABLE"
  network_policy_provider = "CALICO"

  depends_on = [
    yandex_iam_service_account.sa-k8s,
  ]
}

resource "yandex_kubernetes_node_group" "netology_node_group" {
  cluster_id  = "${yandex_kubernetes_cluster.netology-k8s.id}"
  name        = "netology-node-group"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat                = true
      subnet_ids         = ["${yandex_vpc_subnet.public-a.id}"]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 32
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      min = 3
      max = 6  
      initial = 3
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      start_time = "03:00"
      duration   = "3h"
    }
  }
}

resource "yandex_iam_service_account" "sa-k8s" {
  name        = "k8s"
  description = "service account to manage K8S cluster"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
 # Сервисному аккаунту назначается роль "editor".
 folder_id = var.folder_id
 role      = "editor"
 members   = [
   "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
 # Сервисному аккаунту назначается роль "container-registry.images.puller".
 folder_id = var.folder_id
 role      = "container-registry.images.puller"
 members   = [
   "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
 ]
}


