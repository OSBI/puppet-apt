define apt::repo($ensure) {
  include apt::server
  include apache
  notify{"Name is ${name}":}
  file { ["/var/www/${name}/htdocs/"	, "/var/www/${name}/htdocs/.scratch", "/var/www/${name}/htdocs/dists", "/var/www/${name}/htdocs/dists/natty",
  "/var/www/${name}/htdocs/dists/natty/main", "/var/www/${name}/htdocs/dists/natty/contrib", "/var/www/${name}/htdocs/dists/natty/non-free", "/var/www/${name}/htdocs/dists/natty/main/binary-amd64",
  "/var/www/${name}/htdocs/dists/natty/contrib/binary-amd64", "/var/www/${name}/htdocs/dists/natty/non-free/binary-amd64", "/var/www/${name}/htdocs/dists/packages"]:
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

  ##needs fixing
  file { ["/srv/apt", "/srv/apt/${name}/", "/srv/apt/${name}/pool", "/srv/apt/${name}/pool/main", "/srv/apt/${name}/pool/main/s", "/srv/apt/${name}/pool/main/p", "/srv/apt/${name}/pool/main/l"]:
    ensure => directory,
    owner  => "jenkins",
    group  => "users",
    mode   => 750
  }

  file { "/var/www/${name}/htdocs/dists/pool":
    ensure => "/srv/apt/${name}/pool"
  }
}
