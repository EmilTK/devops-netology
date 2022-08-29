provider "yandex" {
#Environment variables are used
}


resource "yandex_iam_service_account" "ig-sa" {
  name        = "ig-sa"
  description = "service account to manage IG"
}

resource "yandex_iam_service_account" "backet-sa" {
  name        = "netology"
  description = "service account to manage Backet"
}

resource "yandex_resourcemanager_folder_iam_binding" "ig-sa-editor" {
  folder_id = "${data.yandex_resourcemanager_folder.netology.id}"
  role      = "editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.ig-sa.id}"
  ]
  depends_on = [
    yandex_iam_service_account.ig-sa,
  ]
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