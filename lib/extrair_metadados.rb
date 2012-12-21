#encoding: utf-8

def extrair_metadados(conteudo)
  metadados = conteudo.arquivo.extrair_metadados
  if metadados
    conteudo.resumo = metadados['abstract_metadata']
    metadados['author_metadata'].each do |nome|
      conteudo.autores << Autor.new(:nome => nome)
    end
    conteudo.titulo = metadados['title_metadata']
    conteudo.numero_paginas = metadados['number_pages']
    conteudo.save
  end
end
