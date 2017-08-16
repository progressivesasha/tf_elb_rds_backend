provider "aws" {
  profile = "default"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_acc_id}:role/terraform-test-role"
  }
}

data "aws_ami" "centos7" {
	most_recent = true
	filter {
		name   = "name"
		values = ["RHEL-7.3_HVM-20170613-x86_64*"]
	}
	filter {
		name   = "virtualization-type"
		values = ["hvm"]
	}
}

resource "aws_default_vpc" "default" {
	tags {
		Name = "DefaultVPC"
	}
}

data "template_file" "puppetserver_config" {
	template = "${file("${path.module}/configs/puppetserver_config.tpl")}"
	vars {
		git_username = "${var.git_username}"
		git_passwd = "${var.git_passwd}"
	}
}


data "template_file" "initial_config" {
	template = "${file("${path.module}/configs/initial_config.sh")}"
}

data "template_file" "backendnode_config" {
	template = "${file("${path.module}/configs/backendnode_config.tpl")}"
	vars {
		puppetserver_address = "${aws_instance.puppetserver.private_ip}"
		puppet_environment	 = "${var.puppet_environment}"
	}
}

data "template_cloudinit_config" "puppetserver_config" {
	gzip          	 = false
	base64_encode 	 = false
	part {
		filename	 	 = "initial.sh"
		content_type = "text/x-shellscript"
		content      = "${data.template_file.initial_config.rendered}"
	}
	part {
		filename     = "puppetserver_config.cfg"
		content_type = "text/cloud-config"
		content      = "${data.template_file.puppetserver_config.rendered}"
	}
}

data "template_cloudinit_config" "backendnode_config" {
	gzip          	 = false
	base64_encode 	 = false
	part {
		filename	 	 = "initial.sh"
		content_type = "text/x-shellscript"
		content      = "${data.template_file.initial_config.rendered}"
	}
	part {
		filename     = "backendnode_config.cfg"
		content_type = "text/cloud-config"
		content      = "${data.template_file.backendnode_config.rendered}"
	}
}
