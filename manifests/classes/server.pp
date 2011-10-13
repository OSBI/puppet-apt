class apt::server {

    $root = '/etc/apt'
    $provider = '/usr/bin/apt-get'

    package { "python-software-properties": }

	file { "sources.list":
		name => "${root}/sources.list",
		ensure => present,
		owner => root,
		group => root,
		mode => 644,
	}

	file { "sources.list.d":
		name => "${root}/sources.list.d",
		ensure => directory,
		owner => root,
		group => root,
	}
	
	exec { "apt_update":
		command => "${provider} update",
		subscribe => [ File["sources.list"], File["sources.list.d"] ],
		refreshonly => true,
	}
	
	package { 'apache2':
	    ensure => present,
	}

	package { 'apt-utils':
	    ensure => present,
	}

	file { '/var/www/debian':
	    ensure => directory,
	    require=> Package['apache2'], 
	}

        file { '/var/www/debian/.scratch':
            ensure => directory,
            require=> File['/var/www/debian'],
        }

        file { '/var/www/debian/dists':
            ensure => directory,
            require=> File['/var/www/debian'],     
        }

	file { '/var/www/debian/dists/natty':
            ensure => directory,
            require=> File['/var/www/debian/dists'],
        }

	file { '/var/www/debian/dists/natty/main':
            ensure => directory,
            require=> File['/var/www/debian/dists/natty'],
        }

        file { '/var/www/debian/dists/natty/contrib':
            ensure => directory,
            require=> File['/var/www/debian/dists/natty'],
        }

        file { '/var/www/debian/dists/natty/non-free':
            ensure => directory,
            require=> File['/var/www/debian/dists/natty'],
        }


	file { '/var/www/debian/dists/natty/main/binary-amd64':
	    ensure => directory,
            require=> File['/var/www/debian/dists/natty/main'],
	}

	file { '/var/www/debian/dists/natty/contrib/binary-amd64':
	    ensure => directory,
            require=> File['/var/www/debian/dists/natty/contrib'],
	}

        file { '/var/www/debian/dists/natty/non-free/binary-amd64':
            ensure => directory,
            require=> File['/var/www/debian/dists/natty/non-free'],
        }

	file { '/var/www/debian/dists/packages':
            ensure => directory,
            require=> File['/var/www/debian/dists'],
        }

        file { '/var/www/debian/dists/pool/main':
            ensure => directory,
            require=> File['/var/www/debian/dists/pool'],

        }
        
	file { '/var/www/debian/dists/pool/':
            ensure => directory,
            require=> File['/var/www/debian/dists'],
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
