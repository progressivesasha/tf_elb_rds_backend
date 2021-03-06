#cloud-config

package_upgrade: true
runcmd:
  - "rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm"
  - "touch /tmp/reserve.conf"
  - "dd if=/dev/xvda2 of=/var/myswap bs=1M count=1024"
  - "mkswap /var/myswap"
  - "chmod 0600 /var/myswap"
  - "swapon /var/myswap"
  - "rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm"
  - "yum -y install puppetserver"
  - "yum -y install rubygems"
  - "yum -y install git"
  - "sed '/JAVA_ARGS/s/-Xms2g -Xmx2g/-Xms512m -Xmx512m/' /etc/sysconfig/puppetserver > /tmp/reserve.conf"
  - "echo 'y' | cp /tmp/reserve.conf /etc/sysconfig/puppetserver"
  - "systemctl restart puppetserver"
  - "systemctl enable puppetserver"
  - "mkdir /etc/puppetlabs/puppetserver/ssh/"
  - "ssh-keygen -t rsa -f /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa -N ''"
  - "gem install puppet_forge:2.2.6 r10k > /tmp/r10k-install"
  - "gem install r10k >> /tmp/r10k-install"
  - "mkdir -p /etc/puppetlabs/r10k/"
  - "curl -o /etc/puppetlabs/r10k/r10k.yaml https://s3.amazonaws.com/cf-templates-bbjiwikzqopr-us-east-1/configs/r10k.yaml"
  - "gem install hiera-eyaml"
  - "/opt/puppetlabs/server/bin/puppetserver gem install hiera-eyaml"
  - "ln -s /opt/puppetlabs/server/data/puppetserver/jruby-gems/gems/hiera-eyaml-2.1.0/lib/hiera/backend/eyaml_backend.rb /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/hiera/backend/eyaml_backend.rb"
  - "ln -s /opt/puppetlabs/server/data/puppetserver/jruby-gems/gems/hiera-eyaml-2.1.0/lib/hiera/backend/eyaml /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/hiera/backend/eyaml"
  - "ln -s /opt/puppetlabs/server/data/puppetserver/jruby-gems/gems/hiera-eyaml-2.1.0/lib/hiera/backend/eyaml.rb /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/hiera/backend/eyaml.rb"
  - "ln -s /opt/puppetlabs/server/data/puppetserver/jruby-gems/gems/highline-1.6.21/lib/highline.rb /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/highline.rb"
  - "ln -s /opt/puppetlabs/server/data/puppetserver/jruby-gems/gems/highline-1.6.21/lib/highline /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/highline"
  - "mkdir /etc/puppetlabs/keys"
  - "curl -o /etc/puppetlabs/puppet/hiera.yaml https://s3.amazonaws.com/cf-templates-bbjiwikzqopr-us-east-1/configs/hiera.yaml"
  - "curl -o /etc/puppetlabs/keys/dev_private_key.pkcs7.pem https://s3.amazonaws.com/cf-templates-bbjiwikzqopr-us-east-1/keys/dev_private_key.pkcs7.pem"
  - "curl -o /etc/puppetlabs/keys/dev_public_key.pkcs7.pem https://s3.amazonaws.com/cf-templates-bbjiwikzqopr-us-east-1/keys/dev_public_key.pkcs7.pem"
  - "curl -o /etc/puppetlabs/keys/production_private_key.pkcs7.pem https://s3.amazonaws.com/cf-templates-bbjiwikzqopr-us-east-1/keys/production_private_key.pkcs7.pem"
  - "curl -o /etc/puppetlabs/keys/production_public_key.pkcs7.pem https://s3.amazonaws.com/cf-templates-bbjiwikzqopr-us-east-1/keys/production_public_key.pkcs7.pem"
  - "chown puppet:puppet /etc/puppetlabs/keys/"
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
  all: "| tee -a /var/log/cloud-init-output.log"
