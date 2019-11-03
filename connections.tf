provider "google" {
  credentials = "${file("../myVPS/terraform-gcp-account.json")}"
  project = "terraform-257213"
  region = "us-east1"
}

provider "aws" {
  region = "eu-central-1"
}

provider "kubernetes" {}
