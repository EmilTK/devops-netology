# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  # service_account_key_file = "key.json"
  token = "AQAAAAAXvBz0AATuwSpq6nDRZ0ndr5h6BKP9dJQ"
  cloud_id  = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
}
