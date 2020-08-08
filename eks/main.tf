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


################################# eks-cluster ###############################


resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "aws_eks" {
  name     = "My-Eks-Cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = ["${aws_subnet.subnet1.id}","${aws_subnet.subnet2.id}","${aws_subnet.subnet5.id}","${aws_subnet.subnet6.id}"]
  }

  tags = {
    Name = "My-Eks-Cluster"
  }
}

resource "aws_iam_role" "eks_nodes" {
  name = "eks-node-group-tuto"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.aws_eks.name
  node_group_name = "Node-Group1"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids = ["${aws_subnet.subnet1.id}","${aws_subnet.subnet2.id}","${aws_subnet.subnet5.id}","${aws_subnet.subnet6.id}"]
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}



#########################eks-fsrgate profile ########################
resource "aws_iam_role" "fargate" {
  name = "eks-fargate-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate.name
}

resource "aws_eks_fargate_profile" "example" {
  cluster_name           = aws_eks_cluster.aws_eks.name
  fargate_profile_name   = "eks-fargate-prfl"
  pod_execution_role_arn = aws_iam_role.fargate.arn
  subnet_ids             = ["${aws_subnet.subnet1.id}","${aws_subnet.subnet2.id}","${aws_subnet.subnet5.id}","${aws_subnet.subnet6.id}"]

  selector {
    namespace = "eks-fargate-prfl"
  }
}
