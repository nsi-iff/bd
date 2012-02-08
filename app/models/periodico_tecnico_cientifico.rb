# encoding: utf-8

class PeriodicoTecnicoCientifico < Conteudo
  validates_numericality_of :ano_primeiro_volume,
                            :greater_than => 0,
                            :less_than_or_equal_to => Time.now.year

  validates_numericality_of :ano_ultimo_volume,
                            :greater_than => 0,
                            :less_than_or_equal_to => Time.now.year
end
