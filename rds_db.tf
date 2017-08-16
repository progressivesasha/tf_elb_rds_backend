#resource "aws_db_instance" "rdsdb" {
#	depends_on			 	= ["aws_security_group.db_sg"]
#	name 				 	= "${var.db_name}"
#	instance_class       	= "db.${var.instance_type}"
#	engine               	= "mysql"
#	allocated_storage    	= 5
#	vpc_security_group_ids 	= ["${aws_security_group.db_sg.id}"]
#	username             	= "${var.db_username}"
#	password             	= "${var.db_passwd}"
#	multi_az			 	= true
#	skip_final_snapshot		= true
#}
