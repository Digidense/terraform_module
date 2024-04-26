terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.53.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}