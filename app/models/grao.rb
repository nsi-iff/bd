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

  def video?
    tipo == 'videos'
  end

  def tipo_humanizado
    return 'tabela' if arquivo?
    return 'imagem' if imagem?
    return 'video' if video?
  end

  def conteudo_base64
    resposta = sam.get(key)
    resposta['data']['file']
  end

  def titulo
    conteudo = Conteudo.find(conteudo_id)
    "#{conteudo.titulo}_#{tipo_humanizado}_#{id}"
  end
 end
