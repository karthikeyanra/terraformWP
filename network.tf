resource "aws_vpc" "MyDemoVPC" {
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    
    tags = {
      "Name" = "MyDemoVPC"
    }
}


resource "aws_internet_gateway" "MyDemoIG" {
 
  vpc_id = aws_vpc.MyDemoVPC.id
  tags = {
    Name = "MyDemoIG"
  }
}
  
resource "aws_subnet" "WebPublicSubnet" {
  vpc_id = aws_vpc.MyDemoVPC.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
      Name = "DemoSubnet_Public_South1a"
    }
  
}

resource "aws_subnet" "DBPrivateSubnet" {
  vpc_id = aws_vpc.MyDemoVPC.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1c"
  map_public_ip_on_launch = true
  tags = {
      Name = "DemoSubnet_Private_South1c"
    }
}

resource "aws_subnet" "DBPrivateSubnet1" {
  vpc_id = aws_vpc.MyDemoVPC.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
      Name = "DemoSubnet_Private_South1b"
    }
}

resource "aws_route_table" "DemoVPC_PublicSubnet_Route_to_IG" {
  vpc_id = aws_vpc.MyDemoVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyDemoIG.id
  }

  tags = {
    Name = "DemoVPC_PublicSubnet_Route_to_IG"
  }
}

resource "aws_route_table_association" "DemoVPC_RouteTableAssociate_Public" {
  subnet_id = aws_subnet.WebPublicSubnet.id
  route_table_id = aws_route_table.DemoVPC_PublicSubnet_Route_to_IG.id
  
}