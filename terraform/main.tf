provider "aws" {
  region = "ap-south-1"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "hello-world-eks"
  cluster_version = "1.29"

  subnet_ids = ["subnet-xxx", "subnet-yyy"]
  vpc_id     = "vpc-xxx"

  eks_managed_node_groups = {
    node_group = {
      instance_types = ["t3.medium"]
      desired_size   = 2
    }
  }
}
