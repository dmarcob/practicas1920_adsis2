#!/bin/bash

# orouter12 : 2001:470:736b:f000:9cde:94ae:3860:2936
# c1212 : 2001:470:736b:f000:5054:ff:fe01:2102
# c1213 : 2001:470:736b:f000:5054:ff:fe01:2103
# c1214 : 2001:470:736b:f000:5054:ff:fe01:2104
# c1215 : 2001:470:736b:f000:5054:ff:fe01:2105
# c1222 : 2001:470:736b:f000:5054:ff:fe01:2202
# c1223 : 2001:470:736b:f000:5054:ff:fe01:2203

# Inicialmente las máquinas disponen de una ip dinámica y puppet instalado para 
# poder ser operables desde internet con la herramienta u

######################################
# RED máquina orouter12
######################################
echo "RED orouter12"
./u.rb 2001:470:736b:f000:9cde:94ae:3860:2936 m red.tar.gz    #Módulo puppet de red.
./u.rb 2001:470:736b:f000:9cde:94ae:3860:2936 c router_red.pp #Parámetros específicos para orouter12.
echo "-----RED orouter12 OK\n\n"

######################################
# RED máquina c1212 (ipa1)
######################################
echo "RED ipa1"
./u.rb  2001:470:736b:f000:5054:ff:fe01:2102 m red.tar.gz
./u.rb  2001:470:736b:f000:5054:ff:fe01:2102 c ipa1_red.pp
echo "-----RED ipa1 OK\n\n"

######################################
# RED máquina c1213 (ipa2)
######################################
echo "RED ipa2"
./u.rb  2001:470:736b:f000:5054:ff:fe01:2103 m red.tar.gz
./u.rb  2001:470:736b:f000:5054:ff:fe01:2103 c ipa2_red.pp
echo "-----RED ipa2 OK\n\n"


######################################
# RED máquina c1214 (nfs1)
######################################
echo "RED nfs1"
./u.rb  2001:470:736b:f000:5054:ff:fe01:2104 m red.tar.gz
./u.rb  2001:470:736b:f000:5054:ff:fe01:2104 c nfs1_red.pp
echo "-----RED nfs1 OK\n\n"


######################################
# RED máquina c1215 (zabbix1)
######################################
echo "RED zabbix1"
./u.rb  2001:470:736b:f000:5054:ff:fe01:2105 m red.tar.gz
./u.rb  2001:470:736b:f000:5054:ff:fe01:2105 c zabbix1_red.pp
echo "-----RED zabbix1 OK\n\n"
