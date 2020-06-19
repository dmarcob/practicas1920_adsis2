#!/bin/bash
##########################################################################
# Autor: Diego Marco Beisty, 755232
# Fichero: despliegue_nfs.sh
# Fecha:
##########################################################################


# Inicialmente las máquinas disponen de una ip dinámica y puppet instalado para 
# poder ser operables desde internet con la herramienta u

#########
# NFSV4 #
#########

#Instalo módulo puppet de nfs en sevidor y clientes nfs
./u.rb nfs m nfs.tar.gz
echo -e "-----Módulo nfs instalado\n\n"

# Parámetros específicos servidor nfs1
./u.rb 2001:470:736b:121::4 c nfs1_nfs.pp
echo -e "-----servidor nfsv4 OK\n\n"

# Parámetros específicos nfs clientes
./u.rb 2001:470:736b:122:5054:ff:fe01:2202 c cliente1_nfs.pp
./u.rb 2001:470:736b:122:5054:ff:fe01:2203 c cliente2_nfs.pp
echo -e "-----clientes nfsv4 OK\n\n"
