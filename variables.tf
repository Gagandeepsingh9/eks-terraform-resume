variable "region" {
    description = "AWS REGION"
    type = string
}  
variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type = string
}  
variable "azs" {
    description = "Availability zones"
    type = list(string)
}  
variable "private_subnets" {
    description = "Private (worker nodes) subnet CIDRs"
    type = list(string)
}  
variable "public_subnets" {
    description = "Public (alb ingress controller) subnet CIDRs"
    type = list(string)
}  
variable "intra_subnets" {
    description = "Intra (control plane) subnet CIDRs"
    type = list(string)
}  
   
