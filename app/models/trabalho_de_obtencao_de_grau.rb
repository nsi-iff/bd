# encoding: utf-8

class TrabalhoDeObtencaoDeGrau < Conteudo
  index_name 'conteudos'
  belongs_to :grau
  validates :numero_paginas, numericality: { greater_than: 0, allow_blank:true }
  flexible_date :data_defesa, suffix: 'br'
  
  attr_accessible :numero_paginas, :instituicao, :grau_id, :data_defesa_br, 
                  :local_defesa

  def self.nome_humanizado
    "Trabalho de Obtenção de Grau"
  end
end
