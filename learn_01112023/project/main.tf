terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~>3.27"
      }
      
      google = {
        source = "hashicorp/google"
        version = "~>4.0"
      }
      yandex = {
      source = "yandex-cloud/yandex"
      version = "0.102.0"
    }
    }
  backend "s3" {
    encrypt = true
    bucket = "terraform-lrn-01112023-bucket"
    key = "terraform-state/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-class-202311-lock"
  }
}

provider "aws" {
  region = "us-east-2"
  profile = "default"
}


module "backend" {
  count = terraform.workspace == "backend" ? 1 : 0
  source = "./modules/backend"
}

module "ec2" {
  count = terraform.workspace == "backend" ? 0 : 1
  source = "./modules/ec2"
  env = terraform.workspace
}

provider "google" {
  credentials = file(pathexpand("~/.config/gcloud/legacy_credentials/isaid.zx@gmail.com/adc.json"))
  region = "us-east1"
  project = "just-landing-292712"
}

resource "google_compute_instance" "test_gcp_instance" {
  count = terraform.workspace == "backend" ? 1 : 0
  name         = "test-gcp-instance-us-east1"
  machine_type = "e2-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

// Configure the Yandex.Cloud provider
provider "yandex" {
  token                    = YA_TOKEN
#  service_account_key_file = "path_to_service_account_key_file"
  cloud_id                 = "b1gao5h6m0ih7dpq8c65"
  folder_id                = "b1glorm4oekc0i95v44s"
  zone                     = "ru-central1-a"
}

// Create a new instance
resource "yandex_compute_instance" "default" {
  count = terraform.workspace == "backend" ? 1 : 0
  name        = "redos_test"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8q0kjl4l1iovds9f29"
    }
  }

  network_interface {
    subnet_id = "e9b7ep7k26kq3i4nrgr4"
  }
}


