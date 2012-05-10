class Grao < ActiveRecord::Base
  belongs_to :conteudo

  def arquivo?
    tipo == 'files'
  end

  def imagem?
    tipo == 'images'
  end

  def tipo_humanizado
    arquivo? ? "arquivo" : (imagem? ? "imagem" : nil)
  end

  def conteudo_base64
    conteudo_base64 = sam.get(key)
    conteudo_base64['data']
  end
end
