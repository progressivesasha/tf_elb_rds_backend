define create_user::create ($user_name, $user_password, $ssh_public, $ssh_private) {

	user { $user_name:
		ensure           => present,
		managehome       => true,
		home             => "/home/${user_name}",
		password         => $user_password,
		password_max_age => '99999',
		password_min_age => '0',
		shell            => '/bin/bash',
		purge_ssh_keys   => true
    }
	
	file { "/home/${user_name}/.ssh/id_rsa":
		ensure  => file,
		content => $ssh_private,
		require => User[$user_name]
	}
	
	ssh_authorized_key { $user_name:
		ensure  => present,
		user    => $user_name,
		type    => 'ssh-rsa',
		key     => $ssh_public,
		require => User[$user_name],
		before  => File["/home/${user_name}/.ssh/id_rsa"]
	}
}
