provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"
  cluster_name    = "hello-world-eks"
  cluster_version = "1.29"

  subnet_ids = ["subnet-0d02c4a1fe04ae6b1", "subnet-0afb4604798408faa"]
  vpc_id     = "vpc-0f5dd000fa0d85b84"

  eks_managed_node_groups = {
    node_group = {
      instance_types = ["t3.small"]
      desired_size   = 2
    }
  }
}
