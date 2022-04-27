# vpc
resource "aws_vpc" "dev-env" {
    cidr_block = "172.32.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "false"
    tags = {
      Name = "dev-env"
    }
}

# subnet
## public
resource "aws_subnet" "public-web" {
    vpc_id = "${aws_vpc.dev-env.id}"
    cidr_block = "172.31.16.0/20"
    availability_zone = "us-east-1a"
    tags = {
      Name = "public-web"
    }
}

## praivate
resource "aws_subnet" "private-db1" {
    vpc_id = "${aws_vpc.dev-env.id}"
    cidr_block = "172.31.16.0/20"
    availability_zone = "us-east-1a"
    tags = {
      Name = "private-db1"
    }
}

resource "aws_subnet" "private-db2" {
    vpc_id = "${aws_vpc.dev-env.id}"
    cidr_block = "172.32.0.0/20"
    availability_zone = "us-east-1c"
    tags = {
      Name = "private-db2"
    }
}

# route table
resource "aws_route_table" "public-route" {
    vpc_id = "${aws_vpc.dev-env.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.dev-env-gw.id}"
    }
    tags = {
      Name = "public-route"
    }
}

resource "aws_route_table_association" "public-a" {
    subnet_id = "${aws_subnet.public-web.id}"
    route_table_id = "${aws_route_table.public-route.id}"
}

# internet gateway
resource "aws_internet_gateway" "dev-env-gw" {
    vpc_id = "${aws_vpc.dev-env.id}"
    depends_on = [aws_vpc.dev-env]
    tags = {
      Name = "dev-env-gw"
    }
}
