locals {
  current_date = formatdate("DD.MM.YY",timestamp())
  bucket_name = "emil.temerbulatov-${local.current_date}"
  file        =  "../files/vombat.jpg"
}

resource "yandex_iam_service_account" "backet-sa" {
  name        = "netology"
  description = "service account to manage Backet"
}

resource "yandex_resourcemanager_folder_iam_member" "backet-sa-editor" {
  role       = "storage.editor"
  folder_id  = "${data.yandex_resourcemanager_folder.netology.id}"
  member     = "serviceAccount:${yandex_iam_service_account.backet-sa.id}"
  depends_on = [
    yandex_iam_service_account.backet-sa,
  ]
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.backet-sa.id
  description        = "static access key for object storage"
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

data "template_file" "index" {
  template = "${file("templates/index.tpl")}"
    vars = {
      bucket    = local.bucket_name
      file_name = basename(local.file)
    }
}

resource "local_file" "index" {
  content  = "${data.template_file.index.rendered}"
  filename = "./index.yaml"
}
