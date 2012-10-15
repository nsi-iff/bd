class Autor < ActiveRecord::Base
  belongs_to :conteudo

  attr_accessible :nome, :lattes
end
