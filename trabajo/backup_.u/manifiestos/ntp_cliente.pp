case $operatingsystem {
        openbsd: { $service_name = 'ntpd'
		           $file_name = '/etc/ntpd.conf' }
        ubuntu:  { $service_name = 'ntp'
		           $file_name = '/etc/ntp.conf' }
}


service { 'ntp':
        ensure => running,
        name => $service_name,
        enable => true,
        subscribe => File['ntp.conf'],
}

file { 'ntp.conf':
        ensure => file,
        path => $file_name,
        mode => '0644',
        content => "#Sincronizacion NTP con:
server ntp1.1.ff.es.eu.org
",
}

