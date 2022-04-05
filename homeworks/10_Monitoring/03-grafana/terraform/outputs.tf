output "external_ip_prometheus" {
  value = yandex_compute_instance.prometheus.network_interface.0.nat_ip_address
}