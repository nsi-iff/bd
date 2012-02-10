class ArtigoDePeriodico < Conteudo
  validates :volume_publicacao, numericality: { greater_than: 0 }, allow_blank: true
  flexible_date :data_publicacao, suffix: 'br'
end
