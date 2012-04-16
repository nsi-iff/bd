class Grao < ActiveRecord::Base
  belongs_to :conteudo

  def arquivo?
    tipo == 'files'
  end

  def imagem?
    tipo == 'images'
  end
end

