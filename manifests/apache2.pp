class apache2 {
		
	file { 
		"/data": ensure => directory;
		"/data/www": ensure => directory, require => File['/data'];
		"/data/www/doc": owner => 'www-data', ensure => directory, require => File['/data/www'];
		"/data/www/log": ensure => directory, require => File["/data/www"];  
	}
		
	package { 
		"apache2": ensure => installed;
	}
	
	service { "apache2":
			enable => true,
			ensure => running,
			require => Package["apache2"]
	} 

	exec {
		"apache2 reload": 
		  require => Package["apache2"],
		  command => "/etc/init.d/apache2 reload",
		  refreshonly => true
	}
}
