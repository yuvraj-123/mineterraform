variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}
variable "availability_zone1" {
    description = "Avaialbility Zones"
    default = "us-east-1a"
}

variable "availability_zone2" {
    description = "Avaialbility Zones"
    default = "us-east-1b"
}
variable "main_vpc_cidr" {
    description = "CIDR of the VPC"
    default = "10.0.0.0/16"
}
variable "cidr-subnet1" {
    description = "CIDR of the subnet1"
    default = "10.0.1.0/24"
}

variable "cidr-subnet2" {
    description = "CIDR of the subnet2"
    default = "10.0.2.0/24"
}
variable "cidr-subnet3" {
    description = "CIDR of the subnet3"
    default = "10.0.3.0/24"
}
variable "cidr-subnet4" {
    description = "CIDR of the subnet4"
    default = "10.0.4.0/24"
}
variable "cidr-subnet5" {
  description = "CIDR of the subnet5"
    default = "10.0.5.0/24"
}
variable "cidr-subnet6" {
    description = "CIDR of the subnet6"
    default = "10.0.6.0/24"
}
variable "cidr-subnet7" {
    description = "CIDR of the subnet7"
    default = "10.0.7.0/24"
}
variable "cidr-subnet8" {
    description = "CIDR of the subnet8"
    default = "10.0.8.0/24"
}



variable "rt-cidr" {
    description = "CIDR of the routes"
    default = "0.0.0.0/0"
}

