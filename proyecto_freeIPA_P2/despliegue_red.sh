#!/bin/bash
##########################################################################
# Autor: Diego Marco Beisty, 755232
# Fichero: despliegue_red.sh
# Fecha:
##########################################################################


# Inicialmente las máquinas disponen de una ip dinámica y puppet instalado para 
# poder ser operables desde internet con la herramienta u

#######
# RED #
#######

#Testeo la conectividad con las máquinas
./u.rb maquinas_red_estado_inicial p
if [ $? -eq 1 ];then
	echo "Abortando despliegue..."
	exit 1
fi
#Instalo módulo puppet de red en todas las máquinas
./u.rb maquinas_red_estado_inicial m red.tar.gz
echo -e "-----Módulo RED instalado\n\n"

# Parámetros específicos de red máquina orouter12
./u.rb 2001:470:736b:f000:9cde:94ae:3860:2936 c router_red.pp
ssh 2001:470:736b:f000:9cde:94ae:3860:2936 'doas sh /etc/netstart'
echo -e "-----RED orouter12 OK\n\n"

# Parámetros específicos de red máquina c1212 (ipa1)
./u.rb  2001:470:736b:f000:5054:ff:fe01:2102 c ipa1_red.pp
echo -e "-----RED ipa1 OK\n\n"

# Parámetros específicos de red máquina c1213 (ipa2)
./u.rb  2001:470:736b:f000:5054:ff:fe01:2103 c ipa2_red.pp
echo -e "-----RED ipa2 OK\n\n"

# Parámetros específicos de red máquina c1214 (nfs1)
./u.rb  2001:470:736b:f000:5054:ff:fe01:2104 c nfs1_red.pp
echo -e "-----RED nfs1 OK\n\n"

# Parámetros específicos de red máquina c1215 (zabbix1)
./u.rb  2001:470:736b:f000:5054:ff:fe01:2105 c zabbix1_red.pp
echo -e "-----RED zabbix1 OK\n\n"

# Parámetros específicos de red máquina c1222 (cliente1)
./u.rb  2001:470:736b:f000:5054:ff:fe01:2202 c cliente1_red.pp
echo -e "-----RED cliente1 OK\n\n"

# Parámetros específicos de red máquina c1223 (cliente2)
./u.rb  2001:470:736b:f000:5054:ff:fe01:2203 c cliente2_red.pp
echo -e "-----RED cliente2 OK\n\n"
