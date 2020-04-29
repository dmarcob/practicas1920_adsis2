#!/bin/bash
if [ ! $# -eq 2 ];then
	echo "Usage: ./nfsuser.sh <nombre> <uid>"
	exit
fi

nfsnis1=2001:470:736b:1ff::5 #Servidor nfs
cliente="2001:470:736b:1fe:5054:ff:fe01:fe06" #cliente nfs

#configuracion servidor
ssh longnombre@$nfsnis1 "sudo mkdir /srv/nfs4/home/$1" &&
	ssh longnombre@$nfsnis1 "sudo cp -r /etc/skel/. /srv/nfs4/home/$1" &&
	ssh longnombre@$nfsnis1 "sudo touch /srv/nfs4/home/$1/cuenta_$1_cliente1.txt" &&
	ssh longnombre@$nfsnis1 "sudo chown $2:$2 -R /srv/nfs4/home/$1" &&
	ssh longnombre@$nfsnis1 "echo /srv/nfs4/home/$1 2001:470:736b:1fe::/64\(rw,nohide,insecure,no_subtree_check,async,root_squash\) >> /etc/exports" &&
	ssh longnombre@$nfsnis1 "sudo exportfs -a"

#configuracion cliente
ssh longnombre@$cliente "echo 'nfsnis1.1.ff.es.eu.org:$1 /home/$1 nfs4 rw,nolock,noauto,x-systemd.automount,x-systemd.device-timeout=30,retry=0,_netdev 0 0
' | sudo tee -a /etc/fstab"

echo "verificacion directorios exportados (vista desde el servidor)..."
ssh longnombre@$nfsnis1 "sudo exportfs -v"
echo "\n\nvereficacion directorio exportados (vista desde el cliente)..."
ssh longnombre@$cliente "sudo showmount -e nfsnis1.1.ff.es.eu.org"
