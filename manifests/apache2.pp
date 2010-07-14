class apache2 {

  class install { 
    include apache2

    file { 
      "/data": ensure => directory;
      "/data/www": ensure => directory, require => File['/data'];
      $www_doc_dir: 
        owner => www-data,
        ensure => directory, 
        require => File['/data/www'];
      $www_log_dir: ensure => directory, require => File["/data/www"];  
      $www_rails_root: ensure => directory, require => File["/data/www"];  

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
