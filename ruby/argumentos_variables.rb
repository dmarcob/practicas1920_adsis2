#! /usr/bin/ruby

def foo(*mi_string)
	mi_string.each do |palabras|
		puts palabras
	end
end

foo('hola', 3)
foo()

#El asterisco indica que el nº de argumentos puede ser
#el que se quiera (0 tambien).
