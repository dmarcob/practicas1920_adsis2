class nfs::cliente_nfs {
	package { "nfs-utils":
                ensure => present,
        }


	service { "autofs":
                ensure => running,
                enable => true,
                require => Package["nfs-utils"],
        }

 	file {'/etc/auto.master':
                ensure=> file,
                content=>"
/misc   /etc/auto.misc
/net    -hosts
+dir:/etc/auto.master.d
+auto.master
/home   /etc/auto.home
",
        }

 	file {'/etc/auto.home':
                ensure=>file,
                content=>"*       -rw,fstype=nfs4,sec=krb5        nfs1.2.1.ff.es.eu.org:/&
",
                notify => Service["autofs"],
        }

}
