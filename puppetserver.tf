resource "aws_instance" "puppetserver" {
	depends_on             = ["aws_security_group.puppetserver"]
	count                  = 1
	key_name               = "${var.key_name}"
	ami                    = "${data.aws_ami.centos7.id}"
	instance_type          = "${var.instance_type}"
	user_data              = "${data.template_cloudinit_config.puppetserver_config.rendered}"
	security_groups        = ["${aws_security_group.puppetserver.name}"]
	tags {
		Name = "puppet"
	}
}
