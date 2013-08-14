# encoding: utf-8

class Livro < Conteudo
  index_name 'conteudos'

  validate :verificar_ano
  validates :numero_paginas, :numero_edicao, :ano_publicacao,
    numericality: { greater_than: 0, allow_blank: true }

  def self.nome_humanizado
    'Livro'
  end

  private
  def verificar_ano
    unless ano_publicacao.blank?
      if ano_publicacao < 1900 or ano_publicacao > Time.now.year
        errors.add(:ano_publicacao, "Insira um ano válido")
      end
    end
  end
end
