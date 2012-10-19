define apt::repo($ensure) {
  include apache
  notify{"Name is ${name}":}


  package { 'apt-utils':
    ensure => present,
  } ->
   apache::vhost {"${name}":
    ensure => present,
  }
  file { ["/var/www/${name}/htdocs/.scratch", "/var/www/${name}/htdocs/dists", "/var/www/${name}/htdocs/dists/natty",
  "/var/www/${name}/htdocs/dists/natty/main", "/var/www/${name}/htdocs/dists/natty/contrib", "/var/www/${name}/htdocs/dists/natty/non-free", "/var/www/${name}/htdocs/dists/natty/main/binary-amd64",
  "/var/www/${name}/htdocs/dists/natty/contrib/binary-amd64", "/var/www/${name}/htdocs/dists/natty/non-free/binary-amd64", "/var/www/${name}/htdocs/dists/packages"]:
    ensure => directory,
    require => Apache::Vhost["${name}"],
  }





  # Overwrite puppet.conf from puppet module with template specific to master
  file { "/var/www/${name}/htdocs/apt-ftparchive.conf" :
    content => template("apt/apt-ftparchive.conf.erb"),
  }

  # Overwrite puppet.conf from puppet module with template specific to master
  file { "/var/www/${name}/htdocs/apt-release.conf" :
    content => template("apt/apt-release.conf.erb"),
  }

  file { "/var/www/${name}/htdocs/create.sh" :
      content => template("apt/create.sh.erb"),
    }
  ##needs fixing
  file { ["/srv/apt", "/srv/apt/${name}/", "/srv/apt/${name}/pool", "/srv/apt/${name}/pool/main", "/srv/apt/${name}/pool/main/s", "/srv/apt/${name}/pool/main/p", "/srv/apt/${name}/pool/main/l"]:
    ensure => directory,
    owner  => "www-data",
    group  => "www-data",
    mode   => 760
  }

  file { "/var/www/${name}/htdocs/dists/pool":
    ensure => "/srv/apt/${name}/pool"
  }
}
