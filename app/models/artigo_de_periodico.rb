class ArtigoDePeriodico < Conteudo
  validates :volume_publicacao, numericality: { greater_than: 0 }, allow_blank: true
  validates_format_of :data_publicacao, with: /^(1[0-2]|0[1-9])\/(3[01]|[12][0-9]|0[1-9])\/[0-9]{4}$/,
                      allow_blank: true, message: 'Formato da data deve ser "dd/mm/aaaa"'
end
