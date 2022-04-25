module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "18.20.5"
  cluster_name = local.cluster_name
  cluster_version = "1.21"
  subnet_ids = module.vpc.private_subnets
  iam_role_permissions_boundary = "arn:aws:iam::${local.account_id}:policy/BoundaryForAdministratorAccess"

  vpc_id = module.vpc.vpc_id
  tags = {
        cstag-department = "Sales - 310000"
        cstag-owner = "jaime.franklin"
        cstag-accounting = "dev"
        cstag-business = "Sales"
        Purpose = "PreSales Demos"
      }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size = 50
    instance_types = [
      "t3.large"]
  }

  eks_managed_node_groups = {
    green = {
      tags = {
        cstag-department = "Sales - 310000"
        cstag-owner = "jaime.franklin"
        cstag-accounting = "dev"
        cstag-business = "Sales"
        Purpose = "PreSales Demos"
      }
      iam_role_permissions_boundary = "arn:aws:iam::${local.account_id}:policy/BoundaryForAdministratorAccess"
      min_size = 1
      max_size = 3
      desired_size = 1

      instance_types = [
        "t3.large"]
    }
  }
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${local.account_id}:user/wus-cloudshare"
      username = "wus-cloudshare"
      groups   = ["system:masters"]
    }
  ]
}

data "aws_caller_identity" "current" {}


locals {
    account_id = data.aws_caller_identity.current.account_id
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
