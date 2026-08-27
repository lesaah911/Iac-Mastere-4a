data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

module "subnet_1" {
  source                     = "../../modules/subnet"
  username                   = var.username
  environment                = var.environment
  cidr                       = var.cidr
  vpc_id                     = var.vpc_id
  assign_public_ip_on_launch = var.assign_public_ip_on_launch
}

module "router" {
  source             = "../../modules/router"
  username           = var.username
  environment        = var.environment
  vpc_id             = var.vpc_id
  local_network_cidr = var.vpc_cidr
  extra_network_cidr = "0.0.0.0/0"
  gateway_id         = data.aws_internet_gateway.existing.id
}

module "route_assoc_1" {
  source         = "../../modules/route_table_association"
  subnet_id      = module.subnet_1.subnet_id
  route_table_id = module.router.route_table_id
}

module "sg_1" {
  source           = "../../modules/security_group"
  username         = var.username
  environment      = var.environment
  vpc_id           = var.vpc_id
  subnet_id        = module.subnet_1.subnet_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "vm" {
  source        = "../../modules/compute"
  username      = var.username
  environment   = var.environment
  instance_ami  = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = module.subnet_1.subnet_id
  sg_ids        = [module.sg_1.security_group_id]
  public_key    = file(pathexpand("C:/Users/Azriel/Downloads/yes.pub"))
  has_public_ip = var.has_public_ip
}
