class Grao < ActiveRecord::Base
  include Referenciavel

  belongs_to :conteudo
  delegate :referencia_abnt, :to => :conteudo

  attr_accessible :tipo, :key

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

  def titulo
    conteudo = Conteudo.find(conteudo_id)
    "#{conteudo.titulo}_grao_#{tipo}_#{id}"
  end
 end
