class red::servidor_centos(
	$ip,
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

	file {'/etc/sysconfig/network-scripts/ifcfg-eth0.121':
                ensure => file,
                mode => '0644',
                content =>"VLAN=yes
TYPE=vlan
PHYSDEV=eth0
DEVICE=eth0.121
VLAN_ID=121
GVRP=no
REORDER_HDR=yes
MVRP=no
PROXY_METHOD=none
BROWSER_ONLY=NO
IPV6INIT=yes
IPV6_AUTOCONF=no
IPV6ADDR=${ip}
IPV6_DEFAULTGW=2001:470:736B:121::1
DNS1=${dns1}
DNS2=${dns2}
DOMAIN=2.1.ff.es.eu.org
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=eth0.121
UUID=6dededc0-e86c-4a4f-9509-5e874ff851e2
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

	file {'/etc/hosts':
                ensure => file,
                mode => '0644',
                content =>"127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

2001:470:736b:121::2  ${nombre_dns}
",
        }
	
	service{'network':
		ensure=>running,
		subscribe => File["/etc/sysconfig/network-scripts/ifcfg-eth0.121"],
	}
}


