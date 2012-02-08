class Livro < Conteudo
  validates :numero_paginas, :numero_edicao, numericality: true, allow_blank: true
end
