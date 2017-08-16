#cloud-config

package_upgrade: true
runcmd:
  - "rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm"
  - "yum -y install puppet-agent"
  - "/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true"
write_files:
  -
    content: "${puppetserver_address} puppet"
    path: /etc/hosts
  -
    content: |
        [main]
        certname = puppet-client.example.com
        server = puppet
        environment = ${puppet_environment}
        runinterval = 15m
    path: /etc/puppetlabs/puppet/puppet.conf
output:
  all: "| tee -a /var/log/cloud-init-output.log"
