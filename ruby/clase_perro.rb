#! /usr/bin/ruby

# d = Perro.new(...) , instanciar
# d.methods.sort , metodos clase Perro
# d.object_id , id objeto
# d.respond_to?("ladrar") , ¿tiene metodo ladrar?
# d.class , ¿de que clase es d? (Perro)
#
#
# Clase 		Constructor Literal 	Ejemplo
#String 		' ó " 			"nuevo string" o 'nuevo string'
#Símbolo 		: 			:símbolo ó :"símbolo con espacios"
#Array 			[ ] 			[1, 2, 3, 4, 5]
#Hash 			{ } 			{"Nueva Yor" => "NY", "Oregon" => "OR"}
#Rango 			.. ó … 			0…10 ó 0..9
#Expresiones regulares 	/ 			/([a-z]+)/

# define la clase Perro
class Perro

  # método inicializar clase
  def initialize(raza, nombre)
    # atributos
    @raza = raza
    @nombre = nombre
  end

  # método ladrar
  def ladrar
    puts 'Guau! Guau!'
  end

  # método saludar
  def saludar
    puts "Soy un perro de la raza #{@raza} y mi nombre es #{@nombre}"
  end
end

# para hacer nuevos objetos,
# se usa el método new
d = Perro.new('Labrador', 'Benzy')
# Motrar todos los metodos de la clase
puts d.methods.sort
puts "La id del ojbeto es #{d.object_id}."

# La clase perro tiene el metodo correr??
if d.respond_to?("correr")
  d.correr
else
  puts "Lo siento, el objeto no entiende el mensaje 'correr'"
end

d.ladrar
d.saludar

# con esta variable, apuntamos al mismo objeto
d1 = d
d1.saludar

d = nil
d1.saludar
