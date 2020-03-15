#! /usr/bin/ruby

#bloque: do...end o {...}
#Solo pueden aparecer depues de usar un metodo
#greet2("argumento") {puts 'hola'}


#######
# yield
#######
#Un metodo puede usar el bloque mediante la palabra yield

def metodo 
	puts 'Start'
	yield
	yield
	puts 'End'
end

metodo{puts 'Usado por yield'}

#Un bloque puede usar argumentos con |..|

def metodo
	yield('hola', 99)
end

metodo{|str, num| puts str + ' ' + num.to_s}

######
# proc
######
#Los bloques no son objetos, pero se pueden convertir gracias 
#a la clase Proc.
# Se hace gracias a: lambda
# La clase Pro tiene un metodo para llamar al bloque: call

prc = lambda {puts 'Hola'}
prc.call

prc2 = lambda{|x| puts x}
prc2.call 'Hola Mundo!'

#Los procs sirven para pasar metodos dentro de otros metodos
#Los procs siven para poder devolver metodos

def metodo proc1
	puts 'Start'
	proc1.call
	puts'Fin'
end

hola = lambda do #igual que hola = lambda{puts 'Hola'} 
	puts 'Hola'
end

metodo hola
