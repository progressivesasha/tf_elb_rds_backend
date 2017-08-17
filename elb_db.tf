resource "aws_elb" "balancer" {
	depends_on			= ["aws_security_group.elb_sg"]
	name 				= "${var.elb_name}"
	availability_zones 	= ["${var.av_zones}a", "${var.av_zones}b"]
	security_groups		= ["${aws_security_group.elb_sg.id}"]
	listener {
		instance_port 	  = 80
		instance_protocol = "http"
		lb_port		  	  = 80
		lb_protocol		  = "http"
	}
	listener {
		instance_port 	  = 80
		instance_protocol = "tcp"
		lb_port		  	  = 443
		lb_protocol		  = "tcp"
	}
	health_check {
		target 				= "HTTP:80/"
		healthy_threshold	= 3
		unhealthy_threshold = 5
		timeout				= 5
		interval			= 30
	}
}
