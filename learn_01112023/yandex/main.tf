terraform {
    required_providers {
      yandex = {
      source = "yandex-cloud/yandex"
      version = "0.102.0"
    }
    }
      #     backend "S3" {
        
      # }
}


// Configure the Yandex.Cloud provider
provider "yandex" {
  token                    = "y0_AgAAAAAHOI-eAATuwQAAAADxorsJB6r026yqQiSlDmu35LMEf9h2Q9c"
#  service_account_key_file = "path_to_service_account_key_file"
  cloud_id                 = "b1gao5h6m0ih7dpq8c65"
  folder_id                = "b1glorm4oekc0i95v44s"
  zone                     = "ru-central1-a"
}

// Create a new instance
# resource "yandex_compute_instance" "default" {
#   name        = "redos_test"
#   platform_id = "standard-v1"
#   zone        = "ru-central1-a"

#   resources {
#     cores  = 2
#     memory = 4
#   }

#   boot_disk {
#     initialize_params {
#       image_id = "fd8q0kjl4l1iovds9f29"
#     }
#   }

#   network_interface {
#     subnet_id = "e9b7ep7k26kq3i4nrgr4"
#   }
# }

resource "yandex_compute_instance" "default" {
  name        = "test"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8q0kjl4l1iovds9f29"
    }
  }

 network_interface {
    subnet_id = "${yandex_vpc_subnet.foo.id}"
    nat = true
    nat_ip_address = yandex_vpc_address.addr.external_ipv4_address[0].address
  }
  metadata = {
    foo      = "bar"
    ssh-keys = "alexg:${file("~/.ssh/id_rsa.pub")}"
    preemtible = "true"
  }
}

resource "yandex_vpc_network" "foo" {}

resource "yandex_vpc_subnet" "foo" {
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.foo.id}"
  v4_cidr_blocks = ["10.5.0.0/24"]
}


resource "yandex_vpc_address" "addr" {

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}