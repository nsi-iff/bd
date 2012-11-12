# encoding: utf-8

class Relatorio < Conteudo
  index_name 'conteudos'
  validates :numero_paginas, numericality: { greater_than: 0, allow_blank: true }
  validates :ano_publicacao,
    numericality: { greater_than: 0, less_than_or_equal_to: Time.now.year, allow_blank: true }

  attr_accessible :local_publicacao, :ano_publicacao, :numero_paginas

  def self.nome_humanizado
    "Relatório"
  end
end
