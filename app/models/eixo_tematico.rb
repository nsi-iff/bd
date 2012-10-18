class EixoTematico < ActiveRecord::Base
  has_many :cursos
  
  attr_accessible :nome
end
