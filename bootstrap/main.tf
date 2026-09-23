terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.130"
    }
  }
}

provider "yandex" {
  folder_id = "b1gv5911ld8dt77bu0l4"
  zone      = "ru-central1-a"
  token     = var.yc_token
}

variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}

resource "yandex_iam_service_account" "terraform" {
  name        = "diploma-terraform-sa"
  description = "SA for managing diploma infrastructure via S3 backend"
}

resource "yandex_resourcemanager_folder_iam_binding" "terraform_editor" {
  folder_id = "b1gv5911ld8dt77bu0l4"
  role      = "editor"
  members   = ["serviceAccount:${yandex_iam_service_account.terraform.id}"]
}

resource "yandex_iam_service_account_static_access_key" "terraform_key" {
  service_account_id = yandex_iam_service_account.terraform.id
  description        = "Static access key for Terraform S3 backend"
}

resource "yandex_storage_bucket" "tf_state" {
  bucket     = "sergey281296-diploma-tf-state"
  access_key = yandex_iam_service_account_static_access_key.terraform_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.terraform_key.secret_key

  versioning {
    enabled = true
  }

  force_destroy = true
}

output "sa_id" {
  value = yandex_iam_service_account.terraform.id
}

output "access_key" {
  value     = yandex_iam_service_account_static_access_key.terraform_key.access_key
  sensitive = true
}

output "secret_key" {
  value     = yandex_iam_service_account_static_access_key.terraform_key.secret_key
  sensitive = true
}

output "bucket_name" {
  value = yandex_storage_bucket.tf_state.bucket
}
