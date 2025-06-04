# https://www.terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket      = "aaronmcd-state-files"
    prefix      = "terraform/060325-global-alb"
    credentials = "key.json"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }

    # tls = {
    #   source  = "hashicorp/tls"
    #   version = "~> 4.0"
    # }
  }
}

