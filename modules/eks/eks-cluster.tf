
# Define an AWS IAM role.
# The role is created with a specific assume_role_policy 
# that allows the Amazon EKS service to assume this role.
resource "aws_iam_role" "cluster-role" {
  name = "${var.env_prefix}-${var.cluster_role_name}"
  assume_role_policy = var.cluster_assume_role_policy
}

# Attach the policy to the IAM role 
resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = var.cluster_AmazonEKSClusterPolicy_arn
  role       = aws_iam_role.cluster-role.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSVPCResourceController" {
  policy_arn = var.cluster_AmazonEKSVPCResourceControllerPolicy_arn
  role       = aws_iam_role.cluster-role.name
}

#########
# Creates an AWS security group 
# It allows inbound and outbound traffic. 
# In this case, all outbound traffic (egress) is allowed, 
# and the security group will be used for cluster communication with worker nodes.
resource "aws_security_group" "cluster-security-group" {
  name        = "${var.env_prefix}-${var.cluster_security_group_name}"
  vpc_id      =  var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-${var.cluster_security_group_name}"
  }
}

# Allows inbound traffic from a specified source
# on port 443 (HTTPS) to communicate with the cluster API Server.
resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster-security-group.id
  to_port           = 443
  type              = "ingress"
}

# creates an Amazon EKS cluster.
resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.env_prefix}-${var.cluster_name}"
  role_arn = aws_iam_role.cluster-role.arn

  vpc_config {
    security_group_ids = [aws_security_group.cluster-security-group.id]
    subnet_ids         = var.subnet_id
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSVPCResourceController,
  ]
}