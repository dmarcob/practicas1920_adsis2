#!/bin/bash
# Autor: Diego Marco, 755232
# Fichero: crear_dirhome.sh
# Coms: Crea los directorios de usuarios freeIPA a exportar en el servidro
# 	nfs1 del proyecto1 parte 1 de la asignatura Administracion de sistemas 2

if [ ! $# -eq 1 ];then
        echo "Usage: ./crear_dirhome.sh <nombre>"
        exit
fi

nfs1=2001:470:736b:121::4 #Servidor nfs

#configuracion servidor
uid=$(ssh $nfs1 "id -u $1" 2>/dev/null)

numero='^[0-9]+$'
if ! [[ $uid =~ $numero ]] ; then
   echo "Error: Cuenta de usuario $1 no existe"; exit 1
fi

if ssh $nfs1 "[ -d /srv/nfs4/home/$1 ]"; then
	echo "Error: Directorio de usuario $1 ya existe"; exit 1
fi

ssh $nfs1 "sudo mkdir /srv/nfs4/home/$1"
ssh $nfs1 "sudo cp -r /etc/skel/. /srv/nfs4/home/$1"
ssh $nfs1 "sudo touch /srv/nfs4/home/$1/cuenta_usuario_$1.txt"
ssh $nfs1 "sudo chown -R $uid:$uid /srv/nfs4/home/$1"
ssh $nfs1 "sudo exportfs -a"
