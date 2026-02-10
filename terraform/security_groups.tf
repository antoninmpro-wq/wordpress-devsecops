data "github_ip_ranges" "test" {}

resource "aws_security_group" "wp_sg" {
  name        = "wordpress-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.wp_vpc.id

  # ENTRÉE
  ingress {
    description = "Autorise entree SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip,
      "4.148.0.0/16",
      "4.149.0.0/18",
      "4.149.64.0/19",
      "4.149.96.0/19",
      "4.149.128.0/17",
      "4.150.0.0/18",
      "4.150.64.0/18",
      "4.150.128.0/18",
      "4.150.192.0/19",
      "4.150.224.0/19",
      "4.151.0.0/16",
      "4.152.0.0/15",
      "4.154.0.0/15",
      "4.156.0.0/15",
      "4.175.0.0/16",
      "4.180.0.0/16",
      "4.207.0.0/16",
      "4.208.0.0/15",
      "4.210.0.0/17",
      "4.210.128.0/17",
    ]
  }

  ingress {
    description = "Autorise entree HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip,
      "4.148.0.0/16",
      "4.149.0.0/18",
      "4.149.64.0/19",
      "4.149.96.0/19",
      "4.149.128.0/17",
      "4.150.0.0/18",
      "4.150.64.0/18",
      "4.150.128.0/18",
      "4.150.192.0/19",
      "4.150.224.0/19",
      "4.151.0.0/16",
      "4.152.0.0/15",
      "4.154.0.0/15",
      "4.156.0.0/15",
      "4.175.0.0/16",
      "4.180.0.0/16",
      "4.207.0.0/16",
      "4.208.0.0/15",
      "4.210.0.0/17",
      "4.210.128.0/17",
    ]
  }

  
  # SORTIE
  egress {
  description     = "Autorise sortie HTTPS"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
}

egress {
  description     = "Autorise sortie DNS"
  from_port       = 53
  to_port         = 53
  protocol        = "udp"
  cidr_blocks     = ["0.0.0.0/0"]
}

  tags = { Name = "wp-security-group" }
}
