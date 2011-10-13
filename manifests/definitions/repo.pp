define apt::repo($ensure, $path = false, $subdomain = 'repo.analytical-labs.com') {

	file { '/var/www/${subdomain}/htdocs/', '/var/www/${subdomain}/htdocs/.scratch', '/var/www/${subdomain}/htdocs/dists', '/var/www/${subdomain}/htdocs/dists/natty',
	'/var/www/${subdomain}/htdocs/dists/natty/main', '/var/www/${subdomain}/htdocs/dists/natty/contrib', '/var/www/${subdomain}/htdocs/dists/natty/non-free', '/var/www/${subdomain}/htdocs/dists/natty/main/binary-amd64',
	'/var/www/${subdomain}/htdocs/dists/natty/contrib/binary-amd64', '/var/www/${subdomain}/htdocs/dists/natty/non-free/binary-amd64', '/var/www/${subdomain}/htdocs/dists/packages', '/var/www/${subdomain}/htdocs/dists/pool/main',
	 '/var/www/${subdomain}/htdocs/dists/pool/':
	    ensure => directory,
	    require=> Package['apache2'], 
	}
	
	apache::vhost {"${subdomain}":
  		ensure => present,
	}
	
	
	
        # Overwrite puppet.conf from puppet module with template specific to master
        file { '/var/www/debian/apt-ftparchive.conf' :
            content => template('apt/apt-ftparchive.conf.erb'),
        }

        # Overwrite puppet.conf from puppet module with template specific to master
        file { '/var/www/debian/apt-release.conf' :
            content => template('apt/apt-release.conf.erb'),
        }

}