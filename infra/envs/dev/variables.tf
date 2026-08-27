variable "username" {
  type = string
}

variable "environment" {
  type        = string
  description = "dev|staging|prod"

  validation {
    condition     = can(regex("^[a-z]+$", var.environment))
    error_message = "Must be a lowercase"
  }
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR complet du VPC (utilise pour la route locale de la table de routage)"
}

variable "cidr" {
  type = string

  validation {
    condition     = can(cidrhost(var.cidr, 0))
    error_message = "Le CIDR ne doit contenir que des chiffres, des points et un slash."
  }
}

# VARIABLE POUR LA PLAGE D'ADRESSE DESTINEE A SE CONNECTER EN SSH
variable "allowed_ssh_cidr" {
  type        = string
  description = "Adresse IP autorisee a faire le ssh"
}

variable "instance_type" {
  type        = string
  description = "Type d'instance EC2"
}

variable "has_public_ip" {
  type        = bool
  description = "Associer une IP publique a la VM"
  default     = false
}

variable "assign_public_ip_on_launch" {
  type        = bool
  description = "Attribuer automatiquement une IP publique aux instances du subnet"
  default     = false
}
