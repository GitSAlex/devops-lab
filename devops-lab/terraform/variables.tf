variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "key_name" {
  description = "ssh key pair"
  type = string
}