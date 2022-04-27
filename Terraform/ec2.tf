# Security Group
resource "aws_security_group" "public-web-sg" {
    name = "public-web-sg"
    vpc_id = "${aws_vpc.dev-env.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "public-web-sg"
    }
}

resource "aws_security_group" "praivate-db-sg" {
    name = "praivate-db-sg"
    vpc_id = "${aws_vpc.dev-env.id}"
    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        cidr_blocks = ["10.0.1.0/24"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "public-db-sg"
    }
}

# EC2 Key Pairs
resource "aws_key_pair" "common-ssh" {
  key_name   = "common-ssh"
  public_key = "<Coller le contenu de la clé publique>"
}

# EC2
resource "aws_instance" "webserver" {
    ami = "ami-011facbea5ec0363b"
    instance_type = "t2.micro"
    key_name   = "common-ssh"
    vpc_security_group_ids = [
      "${aws_security_group.public-web-sg.id}"
    ]
    subnet_id = "${aws_subnet.public-web.id}"
    associate_public_ip_address = "true"
    ebs_block_device {
      device_name    = "/dev/xvda"
      volume_type = "gp2"
      volume_size = 30
      }
    user_data          = "${file("./userdata/cloud-init.tpl")}"
    tags  = {
        Name = "webserver"
    }
}
# Output
output "public_ip_of_webserver" {
  value = "${aws_instance.webserver.public_ip}"
}
