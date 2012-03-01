class Livro < Conteudo
  index_name 'conteudos'
  validates :numero_paginas, :numero_edicao, numericality: { greater_than: 0 }, allow_blank: true
end
