$mods = "/etc/apache2/mods"
define apache::module ( $ensure = 'present', $require_package = 'apache2' ) { 
        case $ensure {
                'present' : { 
                        exec { "/usr/sbin/a2enmod $name":
                                unless => "/bin/sh -c '[ -L ${mods}-enabled/${name}.load ] \\
                                        && [ ${mods}-enabled/${name}.load -ef ${mods}-available/${name}.load ]'",                                                        notify => Exec["force-reload-apache"],
                                require => Package[$require_package];
                        }           
                }           
                'absent': {
                        exec { "/usr/sbin/a2dismod $name":
                                onlyif => "/bin/sh -c '[ -L ${mods}-enabled/${name}.load ] \\
                                        && [ ${mods}-enabled/${name}.load -ef ${mods}-available/${name}.load ]'",
                                notify => Exec["force-reload-apache"],                                require => Package[$require_package];
                        }           
                }                   
        }                   
}

