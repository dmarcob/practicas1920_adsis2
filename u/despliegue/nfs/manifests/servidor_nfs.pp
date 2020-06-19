class nfs::servidor_nfs {
	package { "nfs-utils":
        	ensure => present,
    	}

	service {"nfslock":
		ensure => running,
        	enable => true,
        	require => Package["nfs-utils"],
    	}

	service { "nfs":
        	ensure => running,
        	enable => true,
        	require => Service["nfslock"],
    	}

	file {['/srv/nfs4',
       		'/srv/nfs4/home', ]:
		ensure=> directory,
	}

	file {'/etc/exports':
		ensure=>file,
		content=>"/srv/nfs4/home  2001:470:736b:122::0/64(rw,sync,fsid=0,sec=krb5,no_subtree_check)
",
		notify => Service["nfs"],
	}

}
