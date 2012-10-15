# encoding: utf-8

class ArtigoDePeriodico < Conteudo
  index_name 'conteudos'
  validates :volume_publicacao, numericality: { greater_than: 0, allow_blank: true}
  flexible_date :data_publicacao, suffix: 'br'

  attr_accessible :nome_periodico, :editora, :fasciculo, :volume_publicacao,
                  :data_publicacao_br, :local_publicacao, :pagina_inicial,
                  :pagina_final
  validate :verificar_paginas

  def self.nome_humanizado
    "Artigo de Periódico"
  end


  private

  def verificar_paginas
    if !pagina_inicial.blank? && pagina_final < pagina_inicial
      errors.add(:pagina_final, "Página final deve ser maior que página inicial")
    end
  end
end
