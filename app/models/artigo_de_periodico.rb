class ArtigoDePeriodico < Conteudo
  validates :volume_publicacao, numericality: { greater_than: 0 }, allow_blank: true
end
