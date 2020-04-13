case $operatingsystem {
        openbsd: { $file_name = '/etc/resolv.conf' }
        ubuntu:  { $file_name = '/etc/resolvconf/resolv.conf.d/tail' }
}

file { 'resolv.conf':
        ensure => file,
        path => $file_name,
        mode => '0644',
        content => "nameserver 2001:470:736b:1ff::2",
}

