# encoding: utf-8

class ArtigoDePeriodico < Conteudo
  index_name 'conteudos'
  validates :volume_publicacao, :pagina_final, :pagina_inicial, numericality: { greater_than: 0, allow_blank: true}
  flexible_date :data_publicacao, suffix: 'br'

  attr_accessible :nome_periodico, :editora, :fasciculo, :volume_publicacao,
                  :data_publicacao_br, :local_publicacao, :pagina_inicial,
                  :pagina_final

  validate :verificar_paginas
  validate :verificar_data

  def self.nome_humanizado
    "Artigo de Periódico"
  end

  def permite_extracao_de_metadados?
    true
  end

  private

  def verificar_data
    unless self.data_publicacao_br.blank? || Date.parse(self.data_publicacao_br) < Date.today
        errors.add(:data_publicacao_br, "Data inválida")
    end
  end

  def verificar_paginas
    unless pagina_inicial.blank?
      if pagina_final < pagina_inicial
        errors.add(:pagina_final, "Página final deve ser maior que página inicial")
      end
    end
  end
end
