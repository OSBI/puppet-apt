define apt::repo($ensure) {
	include apt::server
	include apache
	notify{"Name is ${name}":}
	file { ["/var/www/${name}/htdocs/"	, "/var/www/${name}/htdocs/.scratch", "/var/www/${name}/htdocs/dists", "/var/www/${name}/htdocs/dists/natty",
	"/var/www/${name}/htdocs/dists/natty/main", "/var/www/${name}/htdocs/dists/natty/contrib", "/var/www/${name}/htdocs/dists/natty/non-free", "/var/www/${name}/htdocs/dists/natty/main/binary-amd64",
	"/var/www/${name}/htdocs/dists/natty/contrib/binary-amd64", "/var/www/${name}/htdocs/dists/natty/non-free/binary-amd64", "/var/www/${name}/htdocs/dists/packages", "/var/www/${name}/htdocs/dists/pool/main",
	 "/var/www/${name}/htdocs/dists/pool/"]:
	    ensure => directory,
	    require=> Package["apache2"], 
	}
	
	apache::vhost {"${name}":
  		ensure => present,
	}
	
	
	
        # Overwrite puppet.conf from puppet module with template specific to master
        file { "/var/www/${name}/htdocs/apt-ftparchive.conf" :
            content => template("apt/apt-ftparchive.conf.erb"),
        }

        # Overwrite puppet.conf from puppet module with template specific to master
        file { "/var/www/${name}/htdocs/apt-release.conf" :
            content => template("apt/apt-release.conf.erb"),
        }

	file { ["/srv/repo", "/srv/repo/${name}/pool", "/srv/repo/${name}/pool/s"] }
	
	file { "/var/www/${name}/htdocs/dists/pool/main":
    ensure => "/srv/repo/${name}/pool"
	}
}