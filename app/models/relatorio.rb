# encoding: utf-8

class Relatorio < Conteudo
  validates :numero_paginas, numericality: { greater_than: 0, allow_blank: true }
  validates :ano_publicacao, 
    numericality: { less_than_or_equal_to: Time.now.year, allow_blank: true }
end
