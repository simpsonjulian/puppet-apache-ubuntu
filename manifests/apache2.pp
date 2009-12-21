class apache2 {
  class install { 
    file { 
      "/data": ensure => directory;
      "/data/www": ensure => directory, require => File['/data'];
      "/data/www/doc": owner => www-data, ensure => directory, require => File['/data/www'];
      "/data/www/log": ensure => directory, require => File["/data/www"];  
    }
    package { 
      "apache2": ensure => installed;
    }
    apache::module { "rewrite": ensure => present } 
  }    

  service { "apache2":
      enable => true,
      ensure => running,
      require => Class["apache2::install"]
  } 

  exec {
    "apache2 reload": 
      require => Class["apache2::install"],
      command => "/etc/init.d/apache2 reload",
      refreshonly => true
  }
}
