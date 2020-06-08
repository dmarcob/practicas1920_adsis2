
class red(
	$tipo_nodo,
	$ip_nodo="",
	$dns1_nodo,
	$dns2_nodo="",
	$nombre_dns_nodo,
){
	case $tipo_nodo {
	   'router_openbsd': {
	   	class{'red::router_openbsd':
		    dns1 => $dns1_nodo,
		    nombre_dns => $nombre_dns_nodo,
		}
	   }
	   'servidor_centos': {
		class{'red::servidor_centos':
		    ip=> $ip_nodo,
		    dns1=> $dns1_nodo,
		    dns2=> $dns2_nodo,
		    nombre_dns => $nombre_dns_nodo,
		}
	   }
	   
	   'cliente_centos': {
		class{'red::cliente_centos':
		    dns1=> $dns1_nodo,
		    dns2=> $dns2_nodo,
		    nombre_dns => $nombre_dns_nodo,
		}
	   }
	}
}
