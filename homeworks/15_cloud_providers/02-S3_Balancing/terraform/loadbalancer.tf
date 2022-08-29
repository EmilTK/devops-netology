data "yandex_compute_instance_group" "ig_data" {
  instance_group_id = yandex_compute_instance_group.lamp-group.id
}

resource "yandex_lb_target_group" "lb_group" {
  name      = "target-group-1"
  region_id = "ru-central1"

  target {
    subnet_id = yandex_vpc_subnet.public.id
    address   = data.yandex_compute_instance_group.ig_data.instances[0].network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.public.id
    address   = data.yandex_compute_instance_group.ig_data.instances[1].network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.public.id
    address   = data.yandex_compute_instance_group.ig_data.instances[2].network_interface[0].ip_address
  }
}

  resource "yandex_lb_network_load_balancer" "load_balancer" {
    name = "network-load-balancer"

    listener {
      name = "my-listener"
      port = 80
      external_address_spec {
        ip_version = "ipv4"
      }
    }

    attached_target_group {
      target_group_id = yandex_lb_target_group.lb_group.id

      healthcheck {
        name = "http"
        http_options {
          port = 80
          path = "/"
        }
      }
    }
  }