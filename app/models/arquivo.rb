class Arquivo < ActiveRecord::Base
  belongs_to :conteudo

  def to_s
    self.nome
  end
end