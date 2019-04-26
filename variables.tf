variable "aws_region" {
  description = "AWS region"
  default     = "us-east-2a"
}

variable "aws_region2" {
  description = "AWS region"
  default     = "us-east-2b"
}

variable "aws_ami" {
  type = "string"
  description = "AWS Amazon Linux ami"
  default     = "ami-0cd3dfa4e37921605"
}

variable "instance_type" {
  description = "AWS instance type"
  default     = "t2.micro"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "1"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "8"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "1"
}

variable "vpc_cidr"{
  description = "CIDR for the whole VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_2a_cidr"{
  description = "CIDR Public 2a Subnet"
  default = "10.0.0.0/24"
}

variable "private_subnet_2b_cidr"{
  description = "CIDR Private 2b Subnet"
  default = "10.0.0.0/25"
}

variable "private_db_subnet_2a_cidr"{
  description = "CIDR Private 2a DB"
  default = "10.0.0.128/25"
}

variable "private_db_subnet_2a_cidr"{
  description = "CIDR Private 2a DB"
  default = "10.0.0.128/25"
}

variable "security_group"{
  description = "Permitir el trafico"
  default = "0.0.0.0/0"
}

variable "apacheport" {
  type = "string"
  description = "Puerto Apache"
  default = "8080"
}

variable "chefport" {
  type = "string"
  description = "Puerto Chef"
  default = "9043"
}

variable "sshport" {
  type = "string"
  description = "Puerto SSH"
  default = "22"
}

variable "dbport" {
  type = "string"
  description = "Puerto SSH"
  default = "3306"
}

variable "a_storage" {
  description = "allocated storage"
  default     = "20"
}

variable "storagetype" {
  description = "storage type"
  default     = "gp2"
}

variable "engine1" {
  description = "engine"
  default     = "mysql"
}

variable "engineversion" {
  description = "engine version"
  default     = "5.6.40"
}

variable "instanceclass" {
  description = "instance class"
  default     = "db.t2.micro"
}

variable "db_name" {
  description = "db name"
  default     = "mydb-rds"
}

variable "us_name" {
  description = "user name"
  default     = "terraform1"
}

variable "pwd_name" {
  description = "password name"
  default     = "12345678"
}

variable "p_group_name" {
  description = "group name parameter"
  default     = "default.mysql5.7"
}
