#!/bin/bash
if [ ! $# -eq 3 ];then
	echo "Usage: ./ldapuser.sh <nombre> <uid> <password>"
	exit
fi

nfsnis1=2001:470:736b:1ff::5 #Servidor ldap
encrypted=$(ssh longnombre@$nfsnis1 slappasswd -s $3)


ssh longnombre@$nfsnis1 "cat ldapuser.ldif | 
	sed -e "s/pepe/$1/g" -e "s/2000/$2/" -e "s/{.*$/$encrypted/" > ldap$1.ldif"

ssh longnombre@$nfsnis1 "ldapadd -x -D cn=admin,dc=1,dc=ff,dc=es,dc=eu,dc=org -W -f ldap$1.ldif"

#verificacion
ssh longnombre@$nfsnis1 'cat ldapunai.ldif'
echo "################################"
ssh longnombre@$nfsnis1 'sudo slapcat'

