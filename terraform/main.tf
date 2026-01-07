provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"
  cluster_name    = "hello-world-eks"
  cluster_version = "1.29"

  subnet_ids = ["subnet-02614912b37d1664a", "subnet-0dc19f6e762c0c9b1"]
  vpc_id     = "vpc-080fd2ddd39d87fb1"

  eks_managed_node_groups = {
    node_group = {
      instance_types = ["t3.small"]
      desired_size   = 2
    }
  }
}
