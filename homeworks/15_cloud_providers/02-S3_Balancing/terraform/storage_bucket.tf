locals {
  # current_date = formatdate("DD.MM.YY",timestamp())
  bucket_name = "emil.temerbulatov"
  file        =  "../files/vombat.jpg"
}

resource "yandex_storage_bucket" "netology" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.bucket_name
}

resource "yandex_storage_object" "vombat" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.netology.id
  key        = basename(local.file)
  source     = local.file
  acl        = "public-read"
}

# data "template_file" "index" {
#   template = "${file("templates/index.tpl")}"
#     vars = {
#       bucket    = local.bucket_name
#       file_name = basename(local.file)
#     }
# }

# resource "local_file" "index" {
#   content  = "${data.template_file.index.rendered}"
#   filename = "./index.yaml"
# }
