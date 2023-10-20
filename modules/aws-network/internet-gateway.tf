# Create IG for connection to the internet
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env_prefix}-terraform-eks-ig"
  }
}