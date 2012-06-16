class MudancaDeEstado < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :conteudo
  
  attr_accessible :de, :para, :motivo

  def data_hora
    created_at
  end
end
