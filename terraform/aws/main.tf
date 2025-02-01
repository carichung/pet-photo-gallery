# main.tf
provider "aws" {
  region = var.aws_region
}

# Create a VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "pet-photo-gallery-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

# Create an EKS cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  cluster_name    = "pet-photo-gallery-cluster"
  cluster_version = "1.22"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      min_size     = 2
      max_size     = 3
      desired_size = 2
      instance_types = ["t3.medium"]
    }
  }
}

# Create an RDS MySQL database
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.0.0"

  identifier = "pet-photo-gallery-db"

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "pet_photo_gallery"
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_ids             = module.vpc.private_subnets

  family = "mysql8.0"
  major_engine_version = "8.0"

  deletion_protection = false
}

# Output the EKS cluster name and RDS endpoint
output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "rds_endpoint" {
  value = module.rds.db_instance_endpoint
}

