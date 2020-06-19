class nfs(
	$tipo_nodo,
){
	case $tipo_nodo {
	   'servidor_nfs': {
	   	class{'nfs::servidor_nfs':}
	   }
	   'cliente_nfs': {
		class{'nfs::cliente_nfs':}
	   }
	   
	}
}

