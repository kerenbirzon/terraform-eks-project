# Create route table for inbound connection
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}

resource "aws_route_table_association" "rt-association" {
    count = 2
    subnet_id      = aws_subnet.subnet[count.index].id
    route_table_id = aws_route_table.rt.id
}