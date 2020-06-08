class red::router_openbsd(
	$dns1,
	$nombre_dns,
){
	file {'/etc/hostname.vio0':
                ensure=> file,
                mode=>'0644',
                content=>"-inet6
up
-autoconfprivacy
",
        }

 	file{'/etc/hostname.vlan120':
                ensure=>file,
                mode=>'0644',
                content=>"inet6 alias 2001:470:736b:120::2 60 vlan 120 vlandev vio0
-autoconfprivacy
",
        }

	file{'/etc/mygate':
                ensure=>file,
                mode=>'0644',
                content=>"2001:470:736b:120::1
",
        }

	file{'/etc/myname':
                ensure=>file,
                mode=>'0644',
                content=>"${nombre_dns}
",
        }


  	file{'/etc/resolv.conf':
                ensure=>file,
                mode=>'0644',
                content=>"nameserver ${dns1}
",
        }


 	file{'/etc/ntpd.conf':
                ensure=>file,
                mode=>'0644',
                content=>"server ${dns1}
",
        }

	file{'/etc/hostname.vlan121':
                ensure=>file,
                mode=>'0644',
                content=>"inet6 alias 2001:470:736b:121::1 64 vlan 121 vlandev vio0
-autoconfprivacy
",
        }


	file{'/etc/hostname.vlan122':
                ensure=>file,
                mode=>'0644',
                content=>"inet6 alias 2001:470:736b:122::1 64 vlan 122 vlandev vio0
-autoconfprivacy
",
        }


	file{'/etc/rc.conf.local':
                ensure=>file,
                mode=>'0644',
                content=>"pflogd_flags=NO
sndiod_flags=NO
pf=NO
ntpd_flags=-s
rad_flags=\"\"
",
}


	file{'/etc/rad.conf':
                ensure=>file,
                mode=>'0644',
                content=>"interface vlan122
",
        }

	service { rad:
        	ensure=>running,
        	subscribe => File["/etc/rad.conf"],
	}

	exec { "restart-network":
            	command     => "/sbin/route delete default ; /bin/sh /etc/netstart &",
            	path        => "/bin:/usr/bin:/sbin:/usr/sbin",
      	}

	exec { "update-forwarding":
                command     => "sysctl net.inet6.ip6.forwarding=1",
                path        => "/bin:/usr/bin:/sbin:/usr/sbin",
        }
}
