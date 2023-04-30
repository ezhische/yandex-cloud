terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
provider "yandex" {
  service_account_key_file = {Path to authorized_key.json}
  zone                     = "ru-central1-a"
  cloud_id                 = <CLOUD ID>
  folder_id                = <FOLDER ID>
}

variable "snapshot_id" {}

resource "yandex_compute_instance" "backup" {
  name               = "backup"
  platform_id        = "standard-v3"
  zone               = "ru-central1-b"
  service_account_id = <ID сервисного аккаунта с правами на удаление машины>
  resources {
    cores  = 4
    memory = 16
  }

  boot_disk {
    initialize_params {
      snapshot_id = var.snapshot_id
      type        = "network-ssd"
    }
  }

  network_interface {
    subnet_id = <ID подсети>
    nat       = true
  }

  metadata = {

    user-data = file("cloudconfig.yaml")
  }
  timeouts {
    create = "10m"
  }
}
data 