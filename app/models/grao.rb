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
    resposta = sam.get(key)
    resposta['data']['file']
  end
end
