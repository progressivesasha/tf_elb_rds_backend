resource "aws_security_group" "elb_sg" {
	name 				= "${var.elbsg_name}"
	description = "ELB ports 80 and 443 are open"
	ingress {
		from_port 	= 80
		to_port			= 80
		protocol 		= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}
	ingress {
		from_port 	= 443
		to_port			= 443
		protocol 		= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}
	egress {
		from_port 	= 0
		to_port 		= 0
		protocol 		= "-1"
		cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "asg_sg" {
	name 				= "${var.asgsg_name}"
	description = "SSH is available from EPAM network only and port 8080 is open only for elb"
	ingress {
		from_port 	= 22
		to_port			= 22
		protocol 		= "tcp"
		cidr_blocks	= ["89.162.139.0/24"]
	}
	ingress {
		from_port 			= 8080
		to_port					= 8080
		protocol 				= "tcp"
		security_groups	= ["${aws_security_group.elb_sg.id}"]
	}
	egress {
		from_port 	= 0
		to_port 		= 0
		protocol 		= "-1"
		cidr_blocks = ["0.0.0.0/0"]
    }
}

#resource "aws_security_group" "db_sg" {
#	depends_on 	= ["aws_security_group.asg_sg"]
#	name 				= "${var.dbsg_name}"
#	description = "allow inbound traffic from ec2 instances"
#	ingress {
#		from_port 		  	= 0
#		to_port			  		= 0
#		protocol		  		= "-1"
#		security_groups   = ["${aws_security_group.asg_sg.id}"]
#	}
#	egress {
#		from_port 		  = 0
#		to_port			  	= 0
#		protocol		  	= "-1"
#		cidr_blocks		  = ["0.0.0.0/0"]
#	}
#}

resource "aws_security_group" "puppetserver" {
	name		  		= "${var.puppetsg_name}"
	depends_on 	  = ["aws_default_vpc.default"]
	vpc_id 		  	= "${aws_default_vpc.default.id}"
	description   = "Allow egress and ssh/puppet traffic"
	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["89.162.139.0/24"]
	}
	ingress {
		from_port   = 8140
		to_port     = 8140
		protocol    = "tcp"
		cidr_blocks = ["${aws_default_vpc.default.cidr_block}"]
	}
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["${aws_default_vpc.default.cidr_block}"]
	}
	ingress {
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["${aws_default_vpc.default.cidr_block}"]
	}
	ingress {
		from_port   = 443
		to_port     = 443
		protocol    = "tcp"
		cidr_blocks = ["${aws_default_vpc.default.cidr_block}"]
	}
}
