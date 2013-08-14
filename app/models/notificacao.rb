class Notificacao < ActiveRecord::Base
  belongs_to :conteudo
  belongs_to :usuario
end
