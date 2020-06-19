#!/bin/bash
##########################################################################
# Autor: Diego Marco Beisty, 755232
# Fichero: despliegue_zabbix.sh
# Fecha:
##########################################################################


#########
# zabbix #
#########

ssh $c1215 "sudo yum -y install mariadb-server"
ssh $c1215 "sudo yum -y install php"
ssh $c1215 "sudo systemctl start mariadb"
ssh $c1215 "sudo systemctl enable mariadb"
ssh $c1215 "sudo rpm -Uvh https://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-release-4.2-1.el7.noarch.rpm"
ssh $c1215 "sudo yum clean all"
ssh $c1215 "sudo yum -y install zabbix-server-mysql zabbix-web-mysql"
ssh $c1215 "sudo yum -y install zabbix-agent"

ssh $c1215 "mysql --user=root <<_EOF_
UPDATE mysql.user SET Password=PASSWORD('adminope1') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
_EOF_"
ssh $c1215 "echo \"create database zabbix character set utf8 collate utf8_bin;\" | mysql -uroot -padminope1"
ssh $c1215 "echo \"grant all privileges on zabbix.* to zabbix@localhost identified by 'adminope1';\" | mysql -uroot -padminope1"
ssh $c1215 "echo \"flush privileges;\" | mysql -uroot -padminope1"
ssh $c1215 "zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix zabbix -padminope1"
./u.rb 2001:470:736b:121::5 c zabbix1_zabbix.pp
ssh $c1215 "sudo systemctl restart httpd"
ssh $c1215 "sudo systemctl enable httpd"
ssh $c1215 "sudo systemctl start zabbix-server"
ssh $c1215 "sudo systemctl start zabbix-agent"
ssh $c1215 "sudo systemctl enable zabbix-server"
ssh $c1215 "sudo systemctl enable zabbix-agent"


./u.rb clientes_zabbix s "sudo rpm -Uvh https://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-release-4.2-1.el7.noarch.rpm"
./u.rb clientes_zabbix s "sudo yum -y clean all"
./u.rb clientes_zabbix s "sudo yum -y install zabbix-agent"
./u.rb clientes_zabbix c clientes_zabbix.pp
./u.rb clientes_zabbix s "sudo systemctl start zabbix-agent"
./u.rb clientes_zabbix s "sudo systemctl enable zabbix-agent"
