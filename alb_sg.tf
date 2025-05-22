#Creating Security Group for my ALB Ingress Controller
resource "aws_security_group" "myalb_sg" {
    name        = "alb-ingress-sg"
    description = "Security group for Ingress Controller ALB"
    vpc_id      = module.vpc.vpc_id
  
    ingress {                          #FOR INBOUND TRAFFIC
        description = "Allow HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
        description = "Allow HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }

    egress {                            #FOR OUTBOUND TRAFFIC
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "eks-cloud-resume"
  }
}

# ADDING INBOUND RULE IN WORKER NODES SECURITY GROUP TO ALLOW TRAFFIC ON PORT 80 FROM SECURITY GROUP OF ALB Ingress Controller
resource "aws_security_group_rule" "alb_to_worker_nodes" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.myalb_sg.id
  security_group_id        = module.eks.node_security_group_id
  description              = "Allow ALB access to worker nodes"
}

