#cloud-config

write_files:
  -
    content: |
        Host *
          StrictHostKeyChecking no
        Host github.com
          IdentityFile /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa
          User progressivesasha
    path: /root/.ssh/config
    permissions: "0644"
    -
      content: |
          [main]
          environmentpath = $codedir/environments
          [master]
          vardir = /opt/puppetlabs/server/data/puppetserver
          logdir = /var/log/puppetlabs/puppetserver
          rundir = /var/run/puppetlabs/puppetserver
          pidfile = /var/run/puppetlabs/puppetserver/puppetserver.pid
          codedir = /etc/puppetlabs/code
          dns_alt_names = puppet-master.example.com,puppet,puppet-master
      path: /etc/puppetlabs/puppet/puppet.conf

output:
  all: "| tee -a /var/log/cloud-init-output1.log"
