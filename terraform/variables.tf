variable "aws_region" {
  default = "eu-west-3"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "my_ip" {
  description = "Mon IP publique pour le SSH"
  type        = string
}

variable "key_name" {
  description = "Le nom de ma clé SSH sur AWS"
  type        = string
}

variable "docker_compose_path" {
  default = "../docker-compose.yml"
}


variable "db_password" {
  description = "Mot de passe de la base de données"
  type        = string
  sensitive   = true
}

variable "db_root_password" {
  description = "Mot de passe root de MariaDB"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "Utilisateur de la base de données"
  type        = string
}

variable "db_name" {
  description = "Nom de la base de données"
  type        = string
}
