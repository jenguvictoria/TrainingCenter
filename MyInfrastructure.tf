provider "aws" {
  region = "${var.aws_region}"
}

# VPC
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags{
    Name = "VPC"
   }
}

#Subnets
resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_2a_cidr}"
  availability_zone = "${var.aws_region}"
  tags {
    Name = "Web Public Subnet 1"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_2b_cidr}"
  availability_zone = "${var.aws_regio2}"
  tags {
    Name = "App Private Subnet 1"
  }
}

resource "aws_subnet" "private-db-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_db_subnet_2a_cidr}"
  availability_zone = "${var.aws_region}"
  tags {
    Name = "DB Private Subnet 1"
  }
}

# SubnetGroup
resource "aws_db_subnet_group" "default" {
  name ="main-subnet-group"
  subnet_ids = "${aws_subnet.private-db-subnet.id}"
  tags {
    Name = "DB Subnet Group"
  }
}

#Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"
}

#RouteTables
resource "aws_route_table" "public_rt" {
  vpc_id = "$ {aws_vpc.default.id}"
    route {
      cide_block ="0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.gw.id}"
    tags {
      Name = "Public Subnet RT"
    }
  }
}

resource "aws_route_table_association" "public-rt1"{
  subnet_id="${aws_subnet.public-subnet.id}"
  route_table_id="${aws_route_table.public-rt.id}"
}

# SecurityGroups
resource "aws_security_group" "web_server" {
  name = "web_server"
  vpc_id = "${aws_vpc.default.id}"

    ingress {
      from_port = "${var.apacheport}"
      to_port   = "${var.apacheport}"
      protocol  = "tcp"
      cidr_blocks = ["${var.vpc_cidr}"]
    }
    ingress {
      from_port   = "${var.sshport}"
      to_port     = "${var.sshport}"
      protocol    = "tcp"
      cidr_blocks = ["${var.vpc_cidr}"]
    }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
      }
    tags {
        Name = "Web Server"
        }
  }


  resource "aws_security_group" "app_server" {
  name = "app_server"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = "${var.chefport}"
    to_port   = "${var.chefport}"
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port   = "${var.sshport}"
    to_port     = "${var.sshport}"
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
      }
      tags {
      Name = "APP Server"
      }
   }

   resource "aws_security_group" "db_server" {
   name = "db_server"
   vpc_id = "${aws_vpc.default.id}"

   ingress {
     from_port = "${var.chefport}"
     to_port   = "${var.chefport}"
     protocol  = "tcp"
     cidr_blocks = ["${var.vpc_cidr}"]
   }
     egress {
         from_port       = 0
         to_port         = 0
         protocol        = "-1"
         cidr_blocks     = ["0.0.0.0/0"]
       }
     tags {
       Name = "DB Server"
       }
    }

#Instances
  resource "aws_instance" "apache1" {
    ami           = "${var.aws_ami}"
    instance_type = "${var.instance_type}"
    key_name = "yes"
    vpc_id = "${aws_vpc.default.id}"
    vpc_security_group_ids = ["${var.aws_security_group.web_server.id}"]
    subnet_id = "${var.private_subnet_2b_cidr}"
    associate_public_ip_address = true
    source_dest_check = false
    tags {
      Name = "InstanciaAmazon"
    }
  }


  resource "aws_instance" "instance2" {
  ami           = "${var.aws_ami}"
  instance_type = "${var.instance_type}"
  key_name = "yes"
  vpc_id = "${aws_vpc.default.id}"
  vpc_security_group_ids = ["${var.aws_security_group.app_server.id}"]
  subnet_id = "${var.private_db_subnet_2a_cidr}"
  associate_public_ip_address = true
  source_dest_check = false
    tags {
      Name = "instance2"
    }
  }


  resource "aws_instance" "instance3" {
  ami           = "${var.aws_ami}"
  instance_type = "${var.instance_type}"
  key_name = "yes"
  vpc_id = "${aws_vpc.default.id}"
  vpc_security_group_ids = ["${var.aws_security_group.db_server.id}"]
  subnet_id = "${var.public_subnet_2a_cidr}"
  associate_public_ip_address = true
  source_dest_check = false
    tags {
      Name = "instance3"
    }
  }

#LoadBalancer
  resource "aws_elb" "balanceador1" {
    name               = "balanceador1"
    availability_zones = "[${var.aws_region},${var.aws_region2}]"

    listener {
      instance_port      = 80
      instance_protocol  = "http"
      lb_port            = 80
      lb_protocol        = "https"
    }

    tags = {
      Name = "balanceador1"
    }
  }

  resource "aws_load_balancer_policy" "balanceador1-policy" {
    load_balancer_name = "${aws_elb.balanceador1.name}"
    policy_name        = "balanceador1-policy"
    policy_type_name   = "PublicKeyPolicyType"
  }

  resource "aws_launch_template" "foobar" {
  name_prefix   = "ASGTerraform"
  image_id      = "${var.aws_ami}"
  instance_type = instance_type = ${var.instance_type}
  security_group = "$ {aws_security_group.web_server.id}"
}

#AutoscalingGroup
resource "aws_autoscaling_group" "bar" {
  name = "ASGGroup"
  vpc_cidr = "${aws_vpc.default.id}"
  subnet_ids = "${aws_subnet.private-subnet.id}"
  availability_zones = "${var.aws_region}"
  desired_capacity   = "${var.asg_desired}"
  max_size           = "${var.asg_max}"
  min_size           = "${var.asg_min}"
  force_delete = true
  load_balancers = ["${aws_elb.balanceador1.name}"]

  launch_template {
    id      = "${aws_launch_template.foobar.id}"
    version = "$Latest"
  }
}

#RDS
resource "aws_db_instance" "default" {
  allocated_storage    = "${var.a_storage}"
  storage_type         = "${var.storagetype}"
  engine               = "${var.engine1}"
  engine_version       = "${var.engineversion}"
  instance_class       = "${var.instanceclass}"
  name                 = "${var.db_name}"
  username             = "${var.us_name}"
  password             = "${var.pwd_name}"
  parameter_group_name = "${var.p_group_name}"
  vpc_cidr = "${aws_vpc.default.id}"
  availability_zones = "${var.aws_region}"
  port = "${var.dbport}"

}
