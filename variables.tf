variable "elbsg_name" {default = "ELBSG"}
variable "asgsg_name" {default = "ASGSG"}
variable "dbsg_name" {default = "DBSG"}
variable "puppetsg_name" {default = "PuppetSG"}
variable "lc_name" {default = "ASGLC"}
variable "asg_name" {default = "ASG"}
variable "elb_name" {default = "Balancer"}
variable "db_name" {default = "RDSDB"}
variable "healthcheck_type" {default = "ELB"}
variable "key_name" {default = "work_key"}
variable "instance_type" {default = "t2.micro"}
variable "av_zones" {default = "us-east-1"}
variable "minsize" {default = 1}
variable "maxsize" {default = 3}
variable "descap" {default = 1}
variable "hc_grace" {default = 5}
variable "db_username" {default = ""}
variable "db_passwd" {default = ""}
variable "puppet_environment" {default = ""}
variable "git_username" {default = ""}
variable "git_passwd" {default = ""}
variable "git_token" {default = ""}
variable "aws_acc_id" {default = ""}
