terraform {
  backend "s3" {
    bucket                      = "sergey281296-diploma-tf-state"
    key                         = "diploma-infra/terraform.tfstate"
    region                      = "ru-central1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
  }
}
