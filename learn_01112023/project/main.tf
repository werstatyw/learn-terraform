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
    }
      #     backend "S3" {
        
      # }
}

provider "aws" {
  region = "us-east-2"
  profile = "default"
}

resource "aws_instance" "test_server" {
  ami = "ami-0f19d220602031aed"
  instance_type = "t2.nano"

  tags = {
    Name: "Test server"
  }
}

provider "google" {
  credentials = file(pathexpand("~/.config/gcloud/legacy_credentials/isaid.zx@gmail.com/adc.json"))
  region = "us-east1"
  project = "just-landing-292712"
}

resource "google_compute_instance" "test_gcp_instance" {
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