# tf_elb_rds_backend
ELB, RDS, AutoScaling Group and Puppetserver for provisioning the nodes

TODO list:
1) add
```
curl -i -H "Authorization: token ${var.git_token}" -d '{"title":"puppetserver-key", "key":"`cat /etc/puppetlabs/puppetserver/ssh/id- control_repo.rsa.pub`"}' https://api.github.com/users/${git_username}/keys
```
