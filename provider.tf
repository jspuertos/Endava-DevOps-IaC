terraform {
  required_version = "~> 1.8.0"
  cloud {
    organization = "jspuertos"

    workspaces {
      name = "dev"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
