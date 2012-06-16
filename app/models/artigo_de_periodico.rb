# encoding: utf-8

class ArtigoDePeriodico < Conteudo
  index_name 'conteudos'
  validates :volume_publicacao, numericality: { greater_than: 0, allow_blank: true}
  flexible_date :data_publicacao, suffix: 'br'
  
  attr_accessible :nome_periodico, :editora, :fasciculo, :volume_publicacao, 
                  :data_publicacao_br, :local_publicacao, :pagina_inicial, 
                  :pagina_final

  def self.nome_humanizado
    "Artigo de Periódico"
  end
end
