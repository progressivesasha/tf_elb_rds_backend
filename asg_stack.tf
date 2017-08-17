resource "aws_autoscaling_group" "asg" {
	depends_on			 					= ["aws_launch_configuration.asglc", "aws_elb.balancer"]
	name 				 							= "${var.asg_name}"
	min_size			 						= "${var.minsize}"
	max_size			 						= "${var.maxsize}"
	desired_capacity	 				= "${var.descap}"
	launch_configuration 			= "${aws_launch_configuration.asglc.name}"
	load_balancers		 				= ["${aws_elb.balancer.name}"]
	availability_zones			  = ["${var.av_zones}a", "${var.av_zones}b"]
	health_check_type	 				= "ELB"
	health_check_grace_period = "1200"
	tags = [
		{
			key   							= "Name"
			value 							= "machine"
			propagate_at_launch = true
		}
	]
}

resource "aws_launch_configuration" "asglc" {
	depends_on			= ["aws_security_group.asg_sg"]
	name 						= "${var.lc_name}"
	key_name				= "${var.key_name}"
	security_groups = ["${aws_security_group.asg_sg.id}"]
	image_id				= "${data.aws_ami.centos7.id}"
	instance_type		= "${var.instance_type}"
	user_data       = "${data.template_cloudinit_config.backendnode_config.rendered}"
}
