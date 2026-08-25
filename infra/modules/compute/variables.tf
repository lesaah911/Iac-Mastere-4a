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

variable "instance_ami" {
  type        = string
  description = "AMI of EC2 Instance"
  # default     = ""
}

variable "instance_type" {
  type        = string
  description = "default instance"
}

variable "subnet_id" {
  type = string
}

variable "sg_ids" {
  type = list(string)
}

variable "public_key" {
  type = string
}

variable "has_public_ip" {
  type    = bool
  default = false # fail-safe

}
