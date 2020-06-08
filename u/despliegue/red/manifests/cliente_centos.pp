class red::cliente_centos(
	$dns1,
	$dns2,
	$nombre_dns,

) {
	file {'/etc/sysconfig/network-scripts/ifcfg-eth0':
                ensure => file,
                mode => '0644',
                content =>"TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
NAME=eth0
UUID=7f2813c5-c37c-4b77-ac7c-3b0dc20651e7
DEVICE=eth0
ONBOOT=yes
IPV6_PRIVACY=no
",
        }

	file {'/etc/sysconfig/network-scripts/ifcfg-eth0.122':
                ensure => file,
                mode => '0644',
                content =>"VLAN=yes
TYPE=vlan
PHYSDEV=eth0
DEVICE=eth0.122
VLAN_ID=122
REORDER_HDR=yes
GVRP=no
MVRP=no
PROXY_METHOD=none
BROWSER_ONLY=no
IPV6_INIT=yes
IPV6_AUTOCONF=yes
DNS1=${dns1}
DNS2=${dns2}
DOMAIN=2.1.ff.es.eu.org
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=eth0.122
UUID=3031016a-4c31-4175-bf0d-55234790465e
ONBOOT=yes

",
        }

	file {'/etc/sysctl.conf':
                ensure => file,
                mode => '0644',
                content =>"net.ipv6.conf.eth0.use_tempaddr=0
net.ipv6.conf.eth0.autoconf=0
net.ipv6.conf.eth0.accept_ra=0
",
        }



	 file {'/etc/hostname':
                ensure => file,
                mode => '0644',
                content =>"${nombre_dns}
",
    	}

	
	service{'network':
		ensure=>running,
		subscribe => File["/etc/sysconfig/network-scripts/ifcfg-eth0.122"],
	}
}


