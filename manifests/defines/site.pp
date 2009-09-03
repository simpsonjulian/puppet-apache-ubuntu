
define apache::site ( $ensure = 'present',
  $require_package = 'apache2',
  $owner = 'www-data',
  $group = 'www-data',
  $prefix = 'www') {
  include apache2
  $fq_host="${prefix}.${name}"

  exec {
    "/usr/sbin/a2ensite $prefix.$name":
    path => "/usr/bin:/usr/sbin:/bin",
    require => Package[$require_package],
    require => File["/etc/apache2/sites-available/${fq_host}"],
    require => File["/data/www/doc/$name"],
    unless => "test -f /etc/apache2/sites-enabled/${fq_host}"
  }

  file { "/data/www/doc/$name":
      ensure => directory,
      owner => $owner,
      group => $group;
    
    "/etc/apache2/sites-available/${fq_host}":
      ensure => file,
      source => "file:///home/root/infrastructure/etc/puppet/files/etc/apache2/sites-available/${fq_host}",
      owner  => $owner,
      group  => $group,
      notify => Exec["apache2 reload"],
      require => File["/data/www/doc"];
        
  }
}
