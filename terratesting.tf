resource "aws_vpc" "mvvpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames="true"
  
}

resource "aws_subnet" "mvprivsub" {
  vpc_id     = "${aws_vpc.mvvpc.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Private"
  }
}


resource "aws_subnet" "mvpubsub" {
  vpc_id     = "${aws_vpc.mvvpc.id}"
  cidr_block = "10.0.2.0/24"


  tags = {
    Name = "Public"
  }
}

output "private_subnet_ID" {
  value = "${aws_subnet.mvprivsub.id}"
}

output "public_subnet_ID" {
  value = "${aws_subnet.mvpubsub.id}"
}

resource "aws_internet_gateway" "mvgw" {
  vpc_id = "${aws_vpc.mvvpc.id}"

  tags = {
    Name = "Public Route"
  }
}

resource "aws_route" "PublicRoute" {
    route_table_id= "${aws_vpc.mvvpc.default_route_table_id}"
    destination_cidr_block= "0.0.0.0/0"
    gateway_id= "${aws_internet_gateway.mvgw.id}"
}

resource "aws_route_table_association" "route_association_public" {
  subnet_id      = "${aws_subnet.mvpubsub.id}"
  route_table_id = "${aws_vpc.mvvpc.default_route_table_id}"  

}

resource "aws_route_table" "PrivateRoute" {
  vpc_id = "${aws_vpc.mvvpc.id}"
    
  }

resource "aws_route_table_association" "route_association_private" {
  subnet_id      = "${aws_subnet.mvprivsub.id}"
  route_table_id = "${aws_route_table.PrivateRoute.id}"  
}

resource "aws_eip" "ElasticIP" {}

resource "aws_nat_gateway" "NatGW" {
  allocation_id = "${aws_eip.ElasticIP.id}"
  subnet_id     = "${aws_subnet.mvpubsub.id}"
}

resource "aws_route" "NATRoute" {
    route_table_id= "${aws_route_table.PrivateRoute.id}"
    destination_cidr_block= "0.0.0.0/0"
    gateway_id= "${aws_nat_gateway.NatGW.id}"
}