
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

# cluster info for control plane (Master Node)
  cluster_name    = "eks-resume-cluster"
  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

# We want to manage these by terraform although EKS auto-install these add-ons 
  cluster_addons = {  
    coredns = {                     #Acts as the DNS server inside the cluster
      most_recent = true  
    }
    kube-proxy = {                  #Handles network routing inside the Kubernetes cluster
      most_recent = true
    }
    vpc-cni = {                     #Give pods real IPs from our VPC
      most_recent = true
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets #subnet i want to use for EKS worker nodes
  control_plane_subnet_ids = module.vpc.intra_subnets #subnet i want to use for EKS control plane

  enable_irsa = true # for IAM roles for service accounts

  eks_managed_node_group_defaults = {
    instance_types = ["t2.medium"]
    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    eks-resume-cluster-ng = {
      instance_types = ["t2.medium"]

      min_size     = 2
      max_size     = 3
      desired_size = 2
      capacity_type = "SPOT"}
}
  tags = {
    Project = "eks-cloud-resume"
  }
}
