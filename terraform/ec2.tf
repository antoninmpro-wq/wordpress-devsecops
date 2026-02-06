data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "wp_server" {
  ami                         = data.aws_ami.ubuntu.id
  iam_instance_profile        = var.iam_instance_profile
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.wp_sg.id]
  associate_public_ip_address = false
  
  monitoring                  = true
  ebs_optimized               = true

  user_data = <<-EOF
              #!/bin/bash

              # Docker
              sudo apt-get update
              sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt-get update
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu

              # SWAP
              fallocate -l 2G /swapfile
              chmod 600 /swapfile
              mkswap /swapfile
              swapon /swapfile
              echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

              # Trivy
              wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
              echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
              sudo apt-get update
              sudo apt-get install -y trivy

              # CRÉATION DU FICHIER .ENV SUR L'INSTANCE
              cat <<EOT > /home/ubuntu/wordpress/.env
              WORDPRESS_DB_HOST=db
              WORDPRESS_DB_USER=${var.db_user}
              WORDPRESS_DB_PASSWORD=${var.db_password}
              WORDPRESS_DB_NAME=${var.db_name}
              MYSQL_ROOT_PASSWORD=${var.db_root_password}
              MYSQL_DATABASE=${var.db_name}
              MYSQL_USER=${var.db_user}
              MYSQL_PASSWORD=${var.db_password}
              EOT

              # Injection du docker-compose
              mkdir -p /home/ubuntu/wordpress
              
              cat <<EOT > /home/ubuntu/wordpress/docker-compose.yml
              ${file(var.docker_compose_path)}
              EOT

              # Lancement
              chown -R ubuntu:ubuntu /home/ubuntu/wordpress
              cd /home/ubuntu/wordpress
              docker compose up -d
              EOF

  tags = {
    Name = "WordPress-DevSecOps"
  }

  root_block_device {
    encrypted   = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
}