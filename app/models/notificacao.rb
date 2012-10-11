class Notificacao < ActiveRecord::Base
  belongs_to :conteudo
  belongs_to :usuario

  attr_accessible :titulo_conteudo, :conteudo_id, :usuario_id
end
