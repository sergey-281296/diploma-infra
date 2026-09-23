terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.130"
    }
  }
}

variable "yc_token" {
  sensitive = true
}

provider "yandex" {
  token     = var.yc_token
  folder_id = "b1gv5911ld8dt77bu0l4"
  zone      = "ru-central1-a"
}

data "yandex_vpc_network" "existing" {
  network_id = "enpjoq023phcnnf561gg"
}

resource "yandex_vpc_subnet" "subnet-a" {
  name           = "diploma-k8s-subnet-a"
  zone           = "ru-central1-a"
  network_id     = data.yandex_vpc_network.existing.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_subnet" "subnet-b" {
  name           = "diploma-k8s-subnet-b"
  zone           = "ru-central1-a"
  network_id     = data.yandex_vpc_network.existing.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

resource "yandex_compute_instance" "k8s-master" {
  name        = "k8s-master"
  zone        = "ru-central1-a"
  platform_id = "standard-v1"
  
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd806c8slu9j1pa87msc"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "k8s-worker-1" {
  name        = "k8s-worker-1"
  zone        = "ru-central1-a"
  platform_id = "standard-v1"
  
  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd806c8slu9j1pa87msc"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-b.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "k8s-worker-2" {
  name        = "k8s-worker-2"
  zone        = "ru-central1-a"
  platform_id = "standard-v1"
  
  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd806c8slu9j1pa87msc"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-b.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "master_public_ip" {
  value = yandex_compute_instance.k8s-master.network_interface[0].nat_ip_address
}

output "worker1_private_ip" {
  value = yandex_compute_instance.k8s-worker-1.network_interface[0].ip_address
}

output "worker2_private_ip" {
  value = yandex_compute_instance.k8s-worker-2.network_interface[0].ip_address
}

output "worker1_public_ip" {
  value = yandex_compute_instance.k8s-worker-1.network_interface[0].nat_ip_address
}

output "worker2_public_ip" {
  value = yandex_compute_instance.k8s-worker-2.network_interface[0].nat_ip_address
}
