  region = "ca-central-1"
  vpc_cidr = "10.0.0.0/16"
  azs = ["ca-central-1a", "ca-central-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"] #no route to the internet directly use NAT gateway to access internet
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"] # have route to the internet gateway directly to access the internet
  intra_subnets = ["10.0.3.0/24", "10.0.4.0/24"] #isolated subnet no internet access at all, no access to NAT Gateway