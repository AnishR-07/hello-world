provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "hello-world-eks"
  cluster_version = "1.29"

  subnet_ids = ["subnet-05ef67abd57814ae6", "subnet-00a89e0846cd5c0cb"]
  vpc_id     = "vpc-027f39b8517af70bc"

  eks_managed_node_groups = {
    node_group = {
      instance_types = ["t3.small"]
      desired_size   = 2
    }
  }
}
