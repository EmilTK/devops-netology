output "external_ip_nexus" {
  value = yandex_compute_instance.nexus.network_interface.0.nat_ip_address
}