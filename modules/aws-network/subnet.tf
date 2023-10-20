# Create Subnet
resource "aws_subnet" "subnet" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = var.subnet_map_public_ip_on_launch
  vpc_id                  = aws_vpc.vpc.id

  tags = {  
    "Name" = "${var.env_prefix}-subnet${count.index}",
  }
}
