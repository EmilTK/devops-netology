# Домашняя работа к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws.

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано
[здесь](https://www.terraform.io/docs/backends/types/s3.html).

![Terraform_workspace](../screenshots/aws_s3_ls.PNG)

1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше.

```bash
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.70.0"
    }
  }

  backend "s3" {
    bucket = "netology-s3"
    key    = "main/netology"
    region = "eu-central-1"
  }
}

```

## Задача 2. Инициализируем проект и создаем воркспейсы.

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
1. Создайте два воркспейса `stage` и `prod`.
1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах
использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два.
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.<br>

![Terraform_workspace](../screenshots/terraform_workspace.PNG)
* Вывод команды `terraform plan` для воркспейса `prod`.
  * [Terraform plan](../../terraform/07-terraform-03-basic/terraform_plan_prod.md)
  * [Terraform project](../../terraform/07-terraform-03-basic)

![Terraform_workspace](../screenshots/aws_instance_each.PNG)
---
