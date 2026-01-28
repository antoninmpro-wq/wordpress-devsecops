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
