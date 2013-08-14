class Grao < ActiveRecord::Base
  include Referenciavel

  belongs_to :conteudo
  delegate :referencia_abnt, :to => :conteudo

  before_destroy :deleta_do_sam

  def arquivo?
    tipo == 'files'
  end

  def link_download
    sam = ServiceRegistry.sam 
    sam.download_link_for_file key
  end
  
  def audio?
    tipo == 'audio'
  end

  def thumbnails?
    tipo == 'thumbnails'
  end

  def video_converted?
    tipo == 'converted_video'
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
    resposta.data['file']
  end

  def titulo
    #TODO inserir o número da página ao final da string abaixo
    conteudo = Conteudo.find(conteudo_id)
    "#{conteudo.titulo}_#{tipo_humanizado}_#{id}"
  end

  def deleta_do_sam
    resposta = sam.delete(key)
    resposta.deleted?
  end

  def pagina
    #TODO criar campo no SAM para armazenar numero da pagina
    return "X"
  end
 end
