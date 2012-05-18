# encoding: utf-8
require 'base64'

def item_da_cesta(n)
  "#cesta #items div:nth-child(%s)" % n
end

def criar_cesta(usuario, conteudo, *grain_files)
  sam = ServiceRegistry.sam
  grain_files.each do |file|
    result = sam.store(Base64.encode64(File.read(file)))
    sleep(3)
    tipo_grao = file.downcase.end_with?('odt') ? :grao_arquivo : :grao_imagem
    grao = FactoryGirl.create(tipo_grao, key: result['key'], conteudo: conteudo)
    usuario.cesta << grao
  end
  usuario.cesta
end
