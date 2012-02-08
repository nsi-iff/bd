# encoding: utf-8
class Relatorio < Conteudo
  validates_numericality_of :ano_publicacao,
                            :less_than_or_equal_to => Time.now.year
end
