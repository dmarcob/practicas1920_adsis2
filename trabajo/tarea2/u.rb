#!/usr/bin/ruby -w
####################################################################
# File:   u.rb
# Author: Diego Marco Beisty 755232
# Date:   15/03/2020
# Coms:   Herramienta de ejecución remota, despliegue y configuracion 
# 	  automática
#####################################################################
require 'rubygems'
require 'net/ping/tcp'
require 'net/ssh'
require 'resolv'
require 'net/scp'

# <maquinas> := {"<domain>"|"<ip>"}
# Ejecuta ping TCP al puerto 22 con timeout de 0.1s a las máquinas especificadas
# en el array <maquinas>
def ping_tcp(maquinas)
	num_host = 1
	maquinas.each do |host|
		t = Net::Ping::TCP.new(host, 22, 0.3)
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
		puts res + "\n\n" 
	    rescue
		puts "máquina" + num_host.to_s + ": UNREACHABLE\n\n"
	    end
	    num_host = num_host + 1
	end
end


# Aplica un manifiesto puppet del directorio <f_manifiestos> en <maquinas>
def manif_puppet(maquinas, d_manifiestos, lista)
    	f = File.expand_path(d_manifiestos) # Expandir ~
	lista.each do |manifiesto|
	        if File.file?(f + "/" +  manifiesto)
		    begin
			maquinas.each do |host|
			      Net::SSH.start(host, "a755232",:timeout=> 7) do |ssh|
				   ssh.exec!("mkdir /tmp/.puppet")
				   scp = Net::SCP.start(host, "a755232")
				   scp.upload! f + "/" + manifiesto, "/tmp/.puppet"
				   os = ssh.exec!("uname")
				   if os.strip == "OpenBSD" #host tiene sistema operativo openBSD
			               res = ssh.exec!("doas puppet apply /tmp/.puppet/" + manifiesto)
		    		   else #host tiene sistema operativo ubuntu
				       res = ssh.exec!("sudo puppet apply /tmp/.puppet/" + manifiesto)
				   end
				   ssh.exec!("rm -rf /tmp/.puppet")
				   puts "máquina " + host + ": exito"
				   puts res
			      end
			end
	    	    rescue
			puts "máquina : UNREACHABLE\n\n"
	    	    end
		else
		    abort "Fichero " + manifiesto + " no existe"
		end
	end
end	

# Comprueba que el grupo especificado en <grupo> se incluye en f_config
# con formato +grupo. Por defecto identifica todos los grupos incluidos.
# Por cada grupo incluido añade en <maquinas> los hosts asociados a la 
# definicion del grupo con formato -grupo
def parse(maquinas, f_config, grupo="")
	gruposInc=[] #Guardo los grupos con formato +grupo de f_config
	File.foreach(f_config) do |line|
		line = line.strip
		if line[0] == "+"
		   line[0]=''
		   #Por defecto añado el grupo. Si <grupo> no es nulo, solo añado
		   #si coincide con <grupo>
		   (grupo == "") ? gruposInc << line : if line == grupo then gruposInc << line end
		end 
        end

	if grupo == ""
		abort "Ningun grupo incluido en " + f_config \
                unless !gruposInc.empty?
        else
		abort "El grupo " + grupo + " no esta incluido en " + f_config \
                unless !gruposInc.empty? 
	end

	incluir = false
	File.foreach(f_config) do |line|
		line = line.strip
		if incluir and !line.empty? and line[0] != "-" and line[0] != "+" 
		       	maquinas << line 
		end
		if line[0] == "-"
			line[0]=''
			(gruposInc.include? line) ? incluir = true : incluir = false
		elsif line[0] == "+"
			incluir = false
		end
	end
	maquinas = maquinas.uniq # Filtro los hosts que aparecen más de una vez.
end

# Lee y guarda @ips y dominios perteneciente al grupo <grupo> en <maquinas>
# Por defecto lee todos los grupos incluidos en <f_config>
def obtener(maquinas, f_config, grupo="")
    	f = File.expand_path(f_config) # Expandir ~
    	if File.file?(f)
	     parse(maquinas, f, grupo)
        else
            abort "Fichero " + f_config + " no existe"
        end
end




options = ["p", "s", "c"] 	#Comandos disponibles
first = ARGV[0] 		#Primer argumento introducido
second = ARGV[1] 		#Segundo argumento introducido (puede ser vacío)
maquinas=[]                	#Guarda ips y dominos host
f_config = "~/.u/hosts"    	#Fichero máquinas hosts 
d_manifiestos = "~/.u/manifiestos"	#Directorio manifiestos puppet


#Error checking
abort "Uso: u [p] [s \"comando\"]\n" +
      "  p		ping al puerto 22\n" +
      "  s \"command\" 	ejecucion comando remoto\n" +
      "  c \"manifiesto\" ejecucion manifiesto remoto"\
      unless options.include?(first) or options.include?(second)


#Guardar los hosts en <maquinas>
if options.include?(first)
	obtener(maquinas, f_config) #Caso: u p
elsif (first =~ Regexp.union([Resolv::IPv4::Regex, Resolv::IPv6::Regex]))
	maquinas << first #Caso: u ip p
else
	obtener(maquinas, f_config, first) #caso u grupo p
end

#Ejecución subcomando
if !(options.include?(first)) then ARGV.shift end
command = ARGV[0]
if command == "p"
       ping_tcp(maquinas)
elsif command == "s"
       ssh_command(maquinas, ARGV[1])
elsif command == "c"
	manif_puppet(maquinas, d_manifiestos, ARGV[1].split(","))
end   
