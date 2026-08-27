locals {
  prefix = "${var.username}-${var.environment}"
}

resource "aws_security_group" "this" {
  #checkov:skip=CKV2_AWS_5:Faux positif - ce SG est bien attache via var.sg_ids au module vm (aws_instance.this.vpc_security_group_ids)
  name        = "${local.prefix}-sg"
  description = "Security group pour la VM ${local.prefix} (HTTP, SSH, ICMP)"
  vpc_id      = var.vpc_id
}

# Regles entrantes pour le traffic web HTTP
resource "aws_vpc_security_group_ingress_rule" "http" {
  #checkov:skip=CKV_AWS_260:HTTP public volontaire (acces web du projet), aucune restriction demandee par le sujet
  security_group_id = aws_security_group.this.id
  description       = "autoriser le trafic http"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Regles entrantes pour le SSH
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.this.id
  description       = "Autoriser la connexion SSH depuis une adresse IP autorisee"
  cidr_ipv4         = var.allowed_ssh_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Regle entrante ICMP (ping) - demandee par le professeur pour verifier que l'infra est up
resource "aws_vpc_security_group_ingress_rule" "icmp" {
  #checkov:skip=CKV_AWS_277:ICMP ouvert a 0.0.0.0/0 volontairement - le professeur doit pouvoir ping depuis une IP inconnue a l'avance
  security_group_id = aws_security_group.this.id
  description       = "Autoriser le ping ICMP demande par le professeur pour verification de l infra"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "icmp"
  from_port         = -1
  to_port           = -1
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.this.id
  description       = "Autoriser le trafic sortant"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

#BONUS
resource "aws_network_acl" "this" {
  #checkov:skip=CKV_AWS_231:Plage 1024-65535 = ports ephemeres necessaires au trafic retour (NACL sans etat), inclut 3389 par recoupement de plage sans lien avec RDP
  #checkov:skip=CKV2_AWS_1:Faux positif - ce NACL est bien attache via var.subnet_id (subnet_ids = [var.subnet_id])
  count  = var.create_nacl ? 1 : 0
  vpc_id = var.vpc_id

  subnet_ids = [var.subnet_id]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = var.allowed_ssh_cidr
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "icmp"
    rule_no    = 115
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    icmp_type  = -1
    icmp_code  = -1
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  #-----REGLES SORTANTES-----

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1
    to_port    = 65535
  }

  # ICMP sortant requis (NACL sans etat) : sans cette regle, la reponse au ping
  # (echo reply) de la VM est bloquee en sortie meme si la requete entre bien.
  egress {
    protocol   = "icmp"
    rule_no    = 115
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    icmp_type  = -1
    icmp_code  = -1
  }

  tags = {
    Name = "${local.prefix}-nacl"
  }
}
