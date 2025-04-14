provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "tikah-eks-cluster"
  cluster_version = "1.31"

  # Optional
  cluster_endpoint_public_access = true

  # Adds the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Creates worker nodes
  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 3
      desired_size = 2
      instance_types = ["t3.medium"]
    }
  }
}

# Creates VPC Network
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "tikah-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

output "cluster_name" {
  value = module.eks.cluster_name
}



# IAM Role for CLI Access
# resource "aws_iam_role" "eks_admin" {
#   name = "eksAdminRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::985539759633:user/Abdulhakeem"
#         }
#       }
#     ]
#   })
# }

# #  Attach Admin Policy to Role
# resource "aws_iam_role_policy_attachment" "eks_admin_policy" {
#   role       = aws_iam_role.eks_admin.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }

# #  Allow the IAM Role to Access the Cluster
# resource "aws_eks_access_entry" "eks_admin_access" {
#   cluster_name  = module.eks.cluster_name
#   principal_arn = aws_iam_role.eks_admin.arn
#   type          = "STANDARD"
# }
