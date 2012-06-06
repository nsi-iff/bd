# encoding: utf-8
require 'base64'

def item_da_cesta(n)
  "#cesta #items div:nth-child(%s)" % n
end

def criar_cesta(usuario, conteudo, *grain_files)
  sam = ServiceRegistry.sam
  grain_files.each do |file|
    tipo_grao = file.downcase.end_with?('odt') ? :grao_arquivo : :grao_imagem
    extensao = tipo_grao == :grao_arquivo ? "odt" : "png"
    # TODO: refatorar
    result = if ENV["INTEGRACAO_SAM"]
      sam.store(file: Base64.encode64(File.read(file)))
    else
      sam.store('file' => Base64.encode64(File.read(file)), 'filename' => "filename.#{extensao}")
    end
    sleep(1)
    grao = create(tipo_grao, key: result['key'], conteudo: conteudo)
    usuario.cesta << grao
  end
  usuario.cesta
end

def representacao_grao(grao)
  "%s %s" % [grao.key, grao.tipo_humanizado]
end
