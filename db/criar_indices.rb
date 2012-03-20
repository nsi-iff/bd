require "tire"

properties = {
  :id               => {:type => 'string', :index => :not_analyzed},
  :arquivo_base64   => { :type => 'attachment'},
}

Tire.index 'conteudos' do
  delete
  create :mappings => {
    :artigo_de_evento => {
      :properties => properties
    },
    :artigo_de_periodico => {
      :properties => properties
    },
    :livro => {
      :properties => properties
    },
    :objeto_de_aprendizagem => {
      :properties => properties
    },
    :periodico_tecnico_cientifico => {
      :properties => properties
    },
    :relatorio => {
      :properties => properties
    },
    :trabalho_de_obtencao_de_grau => {
      :properties => properties
    }
  }
end
