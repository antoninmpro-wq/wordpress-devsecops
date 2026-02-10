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
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Autorise entree HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
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
