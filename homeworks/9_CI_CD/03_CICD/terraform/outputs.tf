output "external_ip_sonarqube" {
  value = yandex_compute_instance.sonarqube.network_interface.0.nat_ip_address
}
output "external_ip_nexus" {
  value = yandex_compute_instance.nexus.network_interface.0.nat_ip_address
}