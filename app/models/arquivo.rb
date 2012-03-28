class Arquivo < ActiveRecord::Base
  belongs_to :conteudo

  def to_s
    self.nome
  end

  def odt?
    nome =~ /\.odt$/i
  end
end

