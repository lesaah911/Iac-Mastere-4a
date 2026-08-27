variable "username" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "local_network_cidr" {
  type        = string
  description = "CIDR complet du VPC (route locale, deja creee automatiquement par AWS - elle sera adoptee)"
}

variable "extra_network_cidr" {
  type        = string
  description = "Plage de destination pour la route vers l'exterieur"
  default     = "0.0.0.0/0"
}

variable "gateway_id" {
  type        = string
  description = "ID de la passerelle (internet gateway) pour la route extra_network_cidr"
}
