resource "yandex_kms_symmetric_key" "key-1" {
  name              = "netology-key"
  default_algorithm = "AES_256"
  rotation_period   = "8760h" // equal to 1 year
}