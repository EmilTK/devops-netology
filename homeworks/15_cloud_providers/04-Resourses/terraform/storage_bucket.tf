locals {
  # current_date = formatdate("DD.MM.YY",timestamp())
  # bucket_name = "emil.temerbulatov-${current_date}"
  bucket_name = "emil.temerbulatov"
  file        =  "../files/vombat.jpg"
}

resource "yandex_iam_service_account" "backet-sa" {
  name        = "netology"
  description = "service account to manage Backet"
}

resource "yandex_resourcemanager_folder_iam_member" "backet-sa-editor" {
  folder_id  = var.folder_id
  role       = "storage.editor"
  member     = "serviceAccount:${yandex_iam_service_account.backet-sa.id}"
  depends_on = [
    yandex_iam_service_account.backet-sa,
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "kms-backet-iam" {
  folder_id   = var.folder_id
  role        = "kms.keys.encrypterDecrypter"
  members     = [
    "serviceAccount:${yandex_iam_service_account.backet-sa.id}",
  ]
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.backet-sa.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "netology" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket        = local.bucket_name
  force_destroy = "true"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-1.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "yandex_storage_object" "vombat" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.netology.id
  key        = basename(local.file)
  source     = local.file
  acl        = "public-read"

  depends_on = [
    yandex_storage_bucket.netology,
  ]
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
