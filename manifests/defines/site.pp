
define apache::site ( $ensure = 'present',
  $require_package = 'apache2',
  $content = '',
  $source = '',
  $owner = 'www-data',
  $group = 'www-data',
  $prefix = 'www') {
  include apache

  exec {
    "/usr/sbin/a2ensite $prefix.$name":
    path => "/usr/bin:/usr/sbin:/bin",
    require => Package[$require_package],
    unless => "test -f /etc/apache2/sites-enabled/${name}"
  }

  file { "/data/www/doc/$name":
      ensure => directory,
      owner => $owner,
      group => $group,
      require => File["/data/www/doc"];
    
    "/etc/apache2/sites-available/${name}":
      ensure => $ensure,
      source => "puppet:///files/etc/apache2/sites-available/${name}",
      owner  => $owner,
      group  => $group,
      notify => Exec["apache2 reload"];
        
  }
}
