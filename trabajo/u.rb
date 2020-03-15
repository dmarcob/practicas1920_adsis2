#!/usr/bin/ruby -w
####################################################################
# File:   u.rb
# Author: Diego Marco Beisty 755232
# Date:   15/03/2020
# Coms:   Herramienta de ejecución remota, despliegue y configuracion 
# 	  automática
#####################################################################
require 'net/ping/tcp'
require 'net/ssh'

# <maquinas> := {"<domain>"|"<ip>"}
# Ejecuta ping TCP al puerto 22 con timeout de 0.1s a las máquinas especificadas
# en el array <maquinas>
def ping_tcp(maquinas)
	num_host = 1
	maquinas.each do |host|
		t = Net::Ping::TCP.new(host, 22, 0.1)
		if t.ping?
			puts "máquina_" + num_host.to_s + ": FUNCIONA"
		else
			puts "máquina_" + num_host.to_s + ": falla"
		end
		num_host = num_host + 1
	end
end

# Ejecuta comando remoto <remote_comand> mediante ssh a todas las máquinas 
# del array <maquinas>
def ssh_command(maquinas, remote_command)
	num_host = 1
	maquinas.each do |host|
	    begin
		ssh = Net::SSH.start(host, "a755232",:timeout=> 7)
		res = ssh.exec!(remote_command)
		puts "máquina" + num_host.to_s + ": exito"
		puts res 
	    rescue
		puts "máquina" + num_host.to_s + ": UNREACHABLE"
	    end
	    num_host = num_host + 1
	end
end

# Lee una maquina (ip o dominio) por linea del fichero <f_config>
# y las almacena en el array <maquinas>
def obtener(maquinas, f_config) 
    f = File.expand_path(f_config) # Expandir ~
    if File.file?(f)
	File.foreach(f) {|host| maquinas.insert(-1, host.strip)} 
    end
end

#Analiza los argumentos del script.
#Si entrada correcta, ejecuta la funcion asociada al subcomando.
#Si entrada incorrecta, aborta ejecución.
def parse(maquinas)
    comando = ARGV[0]
    case comando
    when "p"
        ping_tcp(maquinas)
    when "s"
        ssh_command(maquinas, ARGV[1])
    else
        abort "Uso: u [p] [s \"comando\"]\n" +
              "  p		ping al puerto 22\n" +
              "  s \"command\" 	ejecucion comando remoto\n"
    end
end

f_config = "~/.u/hosts"   #Fichero de configuración por defecto
maquinas=[]	 	  #maquinas objetivo del script
obtener(maquinas, f_config)
parse(maquinas)
