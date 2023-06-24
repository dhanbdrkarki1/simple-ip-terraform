# variables

variable "region" {
  type = string
}

variable "env" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_cidr_blocks" {
  type = list(string)
}

variable "private_subnet_cidr_blocks" {
  type = list(string)
}

variable "db_subnet_cidr_blocks" {
  type = list(string)
}


# EC2
variable "instance_type" {
  type = string
}

variable "ami" {
  type = string
}



# Load Balancer
variable "load_balancer_name" {
  type = string
}