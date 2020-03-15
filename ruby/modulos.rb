#! /usr/bin/ruby -w
				     ##################
#1) Los modulos actuan como libreria # require 'module'
				     ##################


# trig.rb  
module Trig  
  PI = 3.1416  
  # métodos 
  def Trig.sin(x)  
    # ...  
  end  
  def Trig.cos(x)  
    # ...  
  end  
end  
 
# moral.rb  
module Moral  
  MUY_MAL = 0  
  MAL     = 1  
  def Moral.sin(maldad)  
    # ...  
  end  
end  
 
# modulos.rb  
require 'trig'  
require 'moral'  
Trig.sin(Trig::PI/4)    # "::" -> PI/4 de la clas Trig 
Moral.sin(Moral::MUY_MAL)





				     			   ##################
#2) Los modulos aumentan las funcionalidades de las clases # include module
				     			   ##################
#   Si una clase usa un modulo, los metodos de este modulo estaran disponibles
#   en los objetos que procedan de esta clase

module D  
  def initialize(nombre)  
    @nombre =nombre  
  end  
  def to_s  
    @nombre  
  end  
end  
 
module Debug  
  include D  
  # Los métodos que actúan como preguntas,
  # se les añade una ?
  def quien_soy?
    "#{self.class.name} (\##{self.object_id}): #{self.to_s}"
  end
end
 
class Gramola
  # la instrucción 'include' hace referencia a un módulo.
  # Si el módulo está en otro fichero, hay que usar 'require'
  # antes de usar el 'include'. 
  include Debug  
  # ...  
end  
 
class OchoPistas 
  include Debug  
  # ...  
end  
 
gr = Gramola.new("West End Blues")
op = Ochopistas.new("Real Pillow")
puts gr.quien_soy?
puts op.quien_soy?

