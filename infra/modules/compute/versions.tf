terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0" # ← contrainte du PROVIDER aws
    }
  }
  required_version = ">=1.5.0" # ← contrainte du binaire terraform
}
