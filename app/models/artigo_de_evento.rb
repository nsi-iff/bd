# encoding: utf-8

class ArtigoDeEvento < Conteudo
  index_name 'conteudos'
  
  attr_accessible :titulo, :link, :sub_area_id, :autores_attributes, :campus_id, 
                  :contribuidor_id, :subtitulo, :nome_evento, :numero_evento, 
                  :local_evento, :ano_evento, :editora, :ano_publicacao, 
                  :local_publicacao, :titulo_anais, :pagina_inicial, 
                  :pagina_final, :resumo, :direitos
  validate :verificar_paginas
  validate :verificar_ano

  def self.nome_humanizado
    'Artigo de Evento'
  end

  private

  def verificar_paginas
    unless pagina_inicial.blank?
      if pagina_final < pagina_inicial
        errors.add(:pagina_final, "Página final deve ser maior que página inicial")
      end
    end
  end

  def verificar_ano
    unless ano_publicacao.blank?
      if ano_publicacao < 1990 or ano_publicacao > Time.now.year
        errors.add(:ano_publicacao, "Insira um ano válido")
      end
    end
  end
end
