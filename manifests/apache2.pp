class apache2 {
  class install { 
    file { 
      "/data": ensure => directory;
      "/data/www": ensure => directory, require => File['/data'];
      "/data/www/doc": owner => www-data, ensure => directory, require => File['/data/www'];
      "/data/www/log": ensure => directory, require => File["/data/www"];  

      "/etc/logrotate.d/apache2":
        owner => root,
        group => root,
        mode => 0644,
        source => "puppet:///apache/etc/logrotate.d/apache2";
    }
    package { 
      "apache2": ensure => installed;
    }
    apache::module { "rewrite": ensure => present } 
  }    

  service { "apache2":
      enable => true,
      ensure => running,
  } 

  exec {
    "apache2 reload": 
      command => "/etc/init.d/apache2 reload",
      refreshonly => true
  }
}
