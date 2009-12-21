define available-apache-site ($template = "apache-site.erb") {
  file { 
    "$name":
      path => "/etc/apache2/sites-available/${name}",
      owner => root,
      group => root,
      mode => 644,
      content => template($template),
      notify => Service[apache2],
      require =>  Class["apache2::install"];

    "$www_doc_dir/$name":
      ensure => directory,
      owner => $owner,
      group => $group,
      require =>  Class["apache2::install"];

  }

}

define enabled_apache_site($owner = www-data, $group = root, $ensure = 'present') {
 case $ensure {
  'present' : { 
    exec {
      "/usr/sbin/a2ensite $name":
        path => "/usr/bin:/usr/sbin:/bin",
        unless => "test -l /etc/apache2/sites-enabled/$name",
        require => Class["apache2::install"];
      }
  }

  'absent': {
    exec {
      "/usr/sbin/a2dissite $name":
        path => "/usr/bin:/usr/sbin:/bin",
        unless => "test ! -l /etc/apache2/sites-enabled/$name",
        require => Class["apache2::install"];
      }

    }
  }
}

define static_website { 
  available-apache-site { "$name": }
  enabled-apache-site { "$name": ensure => present }
}
