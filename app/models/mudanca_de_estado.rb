class MudancaDeEstado < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :conteudo

  def data_hora
    created_at
  end
end
