class Grao < ActiveRecord::Base
  def arquivo?
    tipo == 'files'
  end

  def imagem?
    tipo == 'images'
  end
end

