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
  #checkov:skip=CKV_AWS_88:IP publique volontaire - necessaire pour que le professeur puisse ping la VM depuis l'exterieur
  #checkov:skip=CKV_AWS_126:Monitoring detaille desactive volontairement (cout CloudWatch non justifie pour ce projet pedagogique)
  #checkov:skip=CKV_AWS_135:t2.micro ne supporte pas l'optimisation EBS (limitation materielle du type d'instance)
  #checkov:skip=CKV2_AWS_41:Aucun role IAM necessaire, la VM n'appelle aucune API AWS

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

  # =========  SECURITE : IMDSv2 obligatoire ==============================
  metadata_options {
    http_tokens = "required"
  }

  # =========  SECURITE : disque racine chiffre ==============================
  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "${local.prefix}-vm"
  }
}
