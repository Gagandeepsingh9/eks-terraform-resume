#this vpc module is from terraform modules 

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eks-resume-vpc"
  cidr = local.vpc_cidr
  azs             = local.azs
  private_subnets = local.private_subnets  #for our worker-nodes in eks to use the internet through NAT gateway.
  public_subnets  = local.public_subnets  #for our ALB Ingress Controller to access the internet directly using IGW.
  intra_subnets = local.intra_subnets #for our controlplane in eks to use the internal network
  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Project = "eks-cloud-resume"
  }
}