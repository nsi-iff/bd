class Notificacao < ActiveRecord::Base
  belongs_to :conteudo
  belongs_to :usuario

  attr_accessible :mensagem, :conteudo_id, :usuario_id
end
