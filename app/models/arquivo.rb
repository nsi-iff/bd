class Arquivo < ActiveRecord::Base
  belongs_to :conteudo

  attr_accessible :nome, :conteudo, :mime_type, :key

  def to_s
    self.nome
  end

  def odt?
    nome =~ /\.odt$/i
  end

  def video?
    mime_type.start_with? 'video'
  end
end

