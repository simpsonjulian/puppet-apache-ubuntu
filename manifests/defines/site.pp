
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
    require => [Package[$require_package], File["/etc/apache2/sites-available/${fq_host}"], File["/data/www/doc/$name"], Class["apache2::install"]],
    unless => "test -f /etc/apache2/sites-enabled/${fq_host}"
  }

  file { 
    "/etc/apache2/sites-available/${fq_host}":
      ensure => file,
      source => "puppet:///site/etc/apache2/sites-available/${fq_host}",
      owner  => $owner,
      group  => $group,
      notify => Exec["apache2 reload"],
      require => [File["/data/www/doc"],Class["apache2::install"]];
        
  }
}
