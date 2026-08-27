variable "username" {
  type = string
}

variable "cidr" {
  type = string

  validation {
    condition     = can(cidrhost(var.cidr, 0))
    error_message = "Le CIDR ne doit contenir que des chiffres, des points et un slash."
  }
}
variable "vpc_id" {
  type = string
}

variable "environment" {
  type        = string
  description = "dev|staging|prod"
}

variable "assign_public_ip_on_launch" {
  type    = bool
  default = false
}
