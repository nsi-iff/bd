class Livro < Conteudo
  index_name 'conteudos'
  
  attr_accessible :traducao, :numero_edicao, :local_publicacao, :editora, 
                  :ano_publicacao, :numero_paginas
  
  validates :numero_paginas, :numero_edicao,
    numericality: { greater_than: 0, allow_blank: true }

  def self.nome_humanizado
    'Livro'
  end
end
