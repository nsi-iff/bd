# encoding: utf-8
class Relatorio < Conteudo
  validates :ano_publicacao, :numero_paginas, numericality: true

  validates :ano_publicacao, less_than_or_equal_to => Time.now.year

  validates :local_publicacao, :ano_publicacao, :numero_paginas,
            allow_blank: true

  validates :numero_paginas, greater_than => 0
end
