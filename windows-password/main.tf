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

resource "yandex_compute_instance" "winhost" {
  name               = "winhost"
  platform_id        = "standard-v3"
  zone               = "ru-central1-a"
  hostname           = "winhost"
  service_account_id = {ID Service account with KMS Decrypt right}
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.kosmos2022.id
      size     = 50
    }

  }

  network_interface {
    subnet_id  = {Subnet ID}
  }

  metadata = {
    user-data = file("bootstrap.ps1")
    pass      = {Encrypted Password}
    keyid     = {KMS Key ID}
    timezone = "Russian Standard Time"
  }
  labels = {}
}

data "yandex_compute_image" "kosmos2022" {
  family = "fotonsrv-kosmosvm2022"
}
