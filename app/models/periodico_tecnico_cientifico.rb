# encoding: utf-8

class PeriodicoTecnicoCientifico < Conteudo
  validates :ano_primeiro_volume, 
    numericality: { greater_than: 0, less_than_or_equal_to: Time.now.year,
                    allow_blank: true }
  validates :ano_ultimo_volume,
    numericality: { greater_than: 0, less_than_or_equal_to: Time.now.year,
                    allow_blank: true }
end
