output "external_ip_jenkins-master" {
  value = yandex_compute_instance.jenkins-master.network_interface.0.nat_ip_address
}

output "external_ip_jenkins-agent" {
  value = yandex_compute_instance.jenkins-agent.network_interface.0.nat_ip_address
}

output "external_ip_el-instance" {
  value = yandex_compute_instance.el-instance.network_interface.0.nat_ip_address
}