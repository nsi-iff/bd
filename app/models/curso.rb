class Curso < ActiveRecord::Base
  belongs_to :eixo_tematico
  
  attr_accessible :nome
end
