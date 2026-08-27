variable "username" {
  type = string
}

variable "environment" {
  type        = string
  description = "dev|staging|prod"
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type        = string
  description = "id du sous reseaux associer a NACL"
  default     = null
}

# VARIABLES POUR LA PLAGE D'ADRESSE DESTINNER A SE CONNECTER EN SSH
variable "allowed_ssh_cidr" {
  type        = string
  description = "Adresse IP autoriser a faire le ssh"
}

variable "create_nacl" {
  type        = bool
  description = "Creer une Network ACL supplementaire sur le subnet (bonus)"
  default     = true
}
