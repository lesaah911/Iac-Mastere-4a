locals {
  prefix = "${var.username}-${var.environment}"
}


# ========= A MEANS TO COMMUNICATION WITH THE VM
resource "aws_key_pair" "vm_kp" {
  public_key = var.public_key
  key_name   = "${local.prefix}-key"
}

# we need a virtual machine so we must determiner some options :
# some optional
# some mandatory
resource "aws_instance" "this" {


  # ================= 🚀 OS  ===============================
  ami = var.instance_ami

  # =================🚀 PERF =========================
  instance_type = var.instance_type

  # ================= 🚨 NETWORK ZONE ====================
  subnet_id = var.subnet_id

  # ================ 🚨 FIREWALL =======================
  vpc_security_group_ids = var.sg_ids


  # =========  🚨 PUBLIC KEY ==============================
  key_name = aws_key_pair.vm_kp.key_name

  # =========  IS IP PUBLIC OR PRIVATE ==============================
  associate_public_ip_address = var.has_public_ip

  tags = {
    Name = "${local.prefix}-vm"
  }
}
