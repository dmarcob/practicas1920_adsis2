#!/bin/bash
# Define automaticamente las máquinas virtuales qemu/kvm del directorio
# /misc/alumnos/as2/as22019/a755232/ en libvirt
# Comprobar con virt-manager que estan definidas

path=/misc/alumnos/as2/as22019/a755232/
maquinas=$(ls $path | egrep -v '^o.xml' |egrep -v '^u1604.xml' | egrep -v 'c74.xml' | egrep '*.xml' | tr -d '.xml')

if [ $1 = d ];then
	for vm in $maquinas;do
		sudo virsh define $path${vm}.xml
	done
	sudo virsh list --all
	virt-manager
elif [ $1 = u ];then
	read -p "HAS APAGADO TODAS LAS MAQUINAS?? [yes|no]: " response
	if [ $response = "yes" ];then
		for vm in $maquinas;do
	    	sudo virsh undefine $vm
		done
	    pkill virt-manager
	    sudo virsh list --all
	else
	    echo "Abortando..."
	fi
else
	echo "Usage: . vir [d|u] define or undefine vms in virsh"
fi
