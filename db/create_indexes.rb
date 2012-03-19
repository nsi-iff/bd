require "tire"

Tire.index 'conteudos' do
  delete
  create :mappings => {
    :artigo_de_evento => {
      :properties => {
        :id               => {:type => 'string', :index => :not_analyzed},
        :arquivo_base64   => { :type => 'attachment'},
      }
    },
    :artigo_de_periodico => {
      :properties => {
        :id               => {:type => 'string', :index => :not_analyzed},
        :arquivo_base64   => { :type => 'attachment'},
      }
    },
    :livro => {
      :properties => {
        :id               => {:type => 'string', :index => :not_analyzed},
        :arquivo_base64   => { :type => 'attachment'},
      }
    },
    :objeto_de_aprendizagem => {
      :properties => {
        :id               => {:type => 'string', :index => :not_analyzed},
        :arquivo_base64   => { :type => 'attachment'},
      }
    },
    :periodico_tecnico_cientifico => {
      :properties => {
        :id               => {:type => 'string', :index => :not_analyzed},
        :arquivo_base64   => { :type => 'attachment'},
      }
    },
    :relatorio => {
      :properties => {
        :id               => {:type => 'string', :index => :not_analyzed},
        :arquivo_base64   => { :type => 'attachment'},
      }
    },
    :trabalho_de_obtencao_de_grau => {
      :properties => {
        :id               => {:type => 'string', :index => :not_analyzed},
        :arquivo_base64   => { :type => 'attachment'},
      }
    }
  }
end
