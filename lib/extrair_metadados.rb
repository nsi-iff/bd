#encoding: utf-8

def extrair_metadados(conteudo)
  tipo_conteudo = conteudo.nome_como_simbolo
  if tipo_conteudo.in? ['trabalho_de_obtencao_de_grau',
                        'artigo_de_evento', 
                        'artigo_de_periodico'] and conteudo.arquivo.present?
    metadados = JSON.parse(conteudo.arquivo.extrair_metadados)
    conteudo.resumo = metadados['abstract_metadata']
    metadados['author_metadata'].each do |nome|
      conteudo.autores << Autor.new(:nome => nome)
    end
    conteudo.titulo = metadados['title_metadata']
    conteudo.numero_paginas = metadados['number_pages']
    conteudo.save
    return true
  end
  return false
end
