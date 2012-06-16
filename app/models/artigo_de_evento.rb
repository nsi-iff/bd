class ArtigoDeEvento < Conteudo
  index_name 'conteudos'
  
  attr_accessible :titulo, :link, :sub_area_id, :autores_attributes, :campus_id, 
                  :contribuidor_id, :subtitulo, :nome_evento, :numero_evento, 
                  :local_evento, :ano_evento, :editora, :ano_publicacao, 
                  :local_publicacao, :titulo_anais, :pagina_inicial, 
                  :pagina_final, :resumo, :direitos

  def self.nome_humanizado
    'Artigo de Evento'
  end
end
