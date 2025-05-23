
# Cloud Resume Website on AWS EKS

[![Terraform](https://img.shields.io/badge/Terraform-%233967FA.svg?style=flat&logo=terraform&logoColor=white)](https://terraform.io)
[![Docker](https://img.shields.io/badge/Docker-%230db7ed.svg?style=flat&logo=docker&logoColor=white)](https://docker.com)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-%23326CE5.svg?style=flat&logo=kubernetes&logoColor=white)](https://kubernetes.io)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=flat&logo=amazon-aws&logoColor=white)](https://aws.amazon.com)

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Deployment](#deployment)
  - [1. Build and Push Docker Image](#1-build-and-push-docker-image)
  - [2. Provision Infrastructure with Terraform](#2-provision-infrastructure-with-terraform)
  - [3. Configure kubectl](#3-configure-kubectl)
  - [4. Install AWS Load Balancer Controller](#4-install-aws-load-balancer-controller)
  - [5. Apply Kubernetes Manifests](#5-apply-kubernetes-manifests)
- [Best Practices](#best-practices)
- [Security Considerations](#security-considerations)
- [Cleanup](#cleanup)
- [License](#license)

## Overview
This repository demonstrates a robust, production-ready deployment of a static resume website on AWS using Terraform, Docker, and Amazon EKS. It applies Infrastructure as Code principles, container orchestration, and secure, scalable networking practices.

## Architecture
```mermaid
graph TD
  subgraph DNS
    DNS[Route 53 Alias Record]
  end
  subgraph Networking
    ALB[ALB (Ingress Controller)]
    VPC[VPC (Public / Private / Intra)]
  end
  subgraph Compute
    EKS[EKS Cluster]
    Pods[Resume Website Pods]
  end
  DNS --> ALB
  ALB --> EKS
  EKS --> Pods
```

## Prerequisites
- **AWS Account** with permissions to create VPC, EKS, IAM, and Route 53 resources
- **AWS CLI** v2 configured with a user/role that has `eks:*`, `ec2:*`, `iam:*`, `route53:*` and `acm:*` permissions
- **Terraform** v1.3+
- **Docker** v20.10+
- **kubectl** v1.24+
- **Helm** v3.8+

## Project Structure
```
.
├── Dockerfile
├── manifests/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── terraform/
    ├── vpc.tf
    ├── eks.tf
    ├── alb_sg.tf
    ├── variables.tf
    ├── terraform.tfvars
    └── terraformawsprovider.tf
```

## Deployment

### 1. Build and Push Docker Image
```bash
docker build -t mrsinghdocker/myresumeimage:v1 .
docker push mrsinghdocker/myresumeimage:v1
```

### 2. Provision Infrastructure with Terraform
```bash
cd terraform
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

This will provision:
- A VPC with public, private, and intra subnets
- NAT Gateway and Internet Gateway
- Security Groups for ALB and worker nodes
- EKS Cluster with managed node group (spot instances)
- IAM OIDC provider associated with the EKS cluster 
(Enables our cluster to support IAM Roles for Service Accounts)

### 3. Configure kubectl
```bash
aws eks update-kubeconfig   --region ca-central-1   --name eks-resume-cluster
```

### 4. Install AWS Load Balancer Controller
Follow the [AWS Load Balancer Controller Helm installation guide](https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html) to: 
- Create the necessary IAM policy and IAM service account
- Install the AWS Load Balancer Controller using Helm

### 5. Apply Kubernetes Manifests
```bash
kubectl apply -f manifests/namespace.yaml
kubectl apply -f manifests/deployment.yaml
kubectl apply -f manifests/service.yaml
kubectl apply -f manifests/ingress.yaml
```

## Best Practices
- **Immutable Infrastructure**: Use Terraform modules and remote state for collaboration and versioning.
- **Resource Management**: Define CPU/memory requests and limits; configure readiness and liveness probes.
- **Cost Optimization**: Use spot instances for non-critical workloads and auto-scaling node groups.
- **Observability**: Can Integrate it with CloudWatch or Prometheus/Grafana for metrics and logs.

## Security Considerations
- **HTTPS Termination**: Terminate TLS at the ALB using ACM; backend traffic remains HTTP.
- **Least Privilege**: Use IRSA to scope IAM roles to service accounts (AWS Load Balancer Controller).
- **Network Isolation**: Separate public, private, and control-plane subnets to limit the impact if something goes wrong.

## Cleanup
To remove all resources:
```bash
cd terraform
terraform destroy -auto-approve
```