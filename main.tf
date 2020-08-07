################ VPC #################
resource "aws_vpc" "Kube-VPC" {
  cidr_block       = "${var.main_vpc_cidr}"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "kube-VPC"
  }
}

 ################# Subnets #############
resource "aws_subnet" "subnet1" {
  vpc_id     = "${aws_vpc.Kube-VPC.id}"
  cidr_block = var.cidr-subnet1
  availability_zone = "${var.availability_zone1}"


  tags = {
    Name = "app-subnet-1"
    }
}
resource "aws_subnet" "subnet2" {
  vpc_id     = "${aws_vpc.Kube-VPC.id}"
  cidr_block = var.cidr-subnet2
  availability_zone = "${var.availability_zone2}"


  tags = {
    Name = "app-subnet-2"
  }
}
resource "aws_subnet" "subnet3" {
  vpc_id     = "${aws_vpc.Kube-VPC.id}"
  cidr_block = var.cidr-subnet3
  availability_zone = "${var.availability_zone1}"


  tags = {
    Name = "web-subnet-1"
  }
}
resource "aws_subnet" "subnet4" {
  vpc_id     = "${aws_vpc.Kube-VPC.id}"
  cidr_block = var.cidr-subnet4
  availability_zone = "${var.availability_zone2}"


  tags = {
    Name = "web-subnet-2"
  }
}
resource "aws_subnet" "subnet5" {
  vpc_id     = "${aws_vpc.Kube-VPC.id}"
  cidr_block = var.cidr-subnet5
  availability_zone = "${var.availability_zone1}"


  tags = {
    Name = "db-subnet-1"
  }
}
resource "aws_subnet" "subnet6" {
  vpc_id     = "${aws_vpc.Kube-VPC.id}"
  cidr_block = var.cidr-subnet6
  availability_zone = "${var.availability_zone2}"


  tags = {
    Name = "db-subnet-2"
  }
}
resource "aws_subnet" "subnet7" {
  vpc_id     = "${aws_vpc.Kube-VPC.id}"
  cidr_block = var.cidr-subnet7
  availability_zone = "${var.availability_zone1}"


  tags = {
    Name = "nat-subnet-1"
  }
}
resource "aws_subnet" "subnet8" {
  vpc_id     = "${aws_vpc.Kube-VPC.id}"
  cidr_block = var.cidr-subnet8
  availability_zone = "${var.availability_zone2}"


  tags = {
    Name = "nat-subnet-2"
  }
}

######## IGW ###############
resource "aws_internet_gateway" "main-igw" {
  vpc_id     = "${aws_vpc.Kube-VPC.id}"

  tags = {
    Name = "main-igw"
  }
}

########### NAT ##############
resource "aws_eip" "nat" {
}

resource "aws_nat_gateway" "main-natgw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.subnet8.id}"

  tags = {
    Name = "main-nat"
  }
}

############# Route Tables ##########

resource "aws_route_table" "main-public-rt" {
  vpc_id     = "${aws_vpc.Kube-VPC.id}"

  route {
    cidr_block = var.rt-cidr
    gateway_id = "${aws_internet_gateway.main-igw.id}"
  }

  tags = {
    Name = "main-public-rt"
  }
}

resource "aws_route_table" "main-private-rt" {
  vpc_id     = "${aws_vpc.Kube-VPC.id}"
  route {
    cidr_block = var.rt-cidr
    gateway_id = "${aws_nat_gateway.main-natgw.id}"
  }

  tags = {
    Name = "main-private-rt"
  }
}

######### PUBLIC Subnet assiosation with rotute table    ######
resource "aws_route_table_association" "public-assoc-1" {
  subnet_id      = "${aws_subnet.subnet3.id}"
  route_table_id = "${aws_route_table.main-public-rt.id}"
}
resource "aws_route_table_association" "public-assoc-2" {
  subnet_id      = "${aws_subnet.subnet4.id}"
  route_table_id = "${aws_route_table.main-public-rt.id}"
}
resource "aws_route_table_association" "public-assoc-3" {
  subnet_id      = "${aws_subnet.subnet7.id}"
  route_table_id = "${aws_route_table.main-public-rt.id}"
}
resource "aws_route_table_association" "public-assoc-4" {
  subnet_id      = "${aws_subnet.subnet8.id}"
  route_table_id = "${aws_route_table.main-public-rt.id}"
}

########## PRIVATE Subnets assiosation with rotute table ######
resource "aws_route_table_association" "private-assoc-1" {
  subnet_id      = "${aws_subnet.subnet1.id}"
  route_table_id = "${aws_route_table.main-private-rt.id}"
}
resource "aws_route_table_association" "private-assoc-2" {
  subnet_id      = "${aws_subnet.subnet2.id}"
  route_table_id = "${aws_route_table.main-private-rt.id}"
}
resource "aws_route_table_association" "private-assoc-3" {
  subnet_id      = "${aws_subnet.subnet5.id}"
  route_table_id = "${aws_route_table.main-private-rt.id}"
}
resource "aws_route_table_association" "private-assoc-4" {
  subnet_id      = "${aws_subnet.subnet6.id}"
  route_table_id = "${aws_route_table.main-private-rt.id}"
}
