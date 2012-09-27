#encoding: utf-8
require 'rake'

namespace :conteudo do

  desc "Deleta todos os conteúdos e limpa o índice do Elastic Search"
  task :limpar_tudo => :environment do
    Rake::Task['conteudo:limpar'].invoke
    Rake::Task['conteudo:recriar_indice'].invoke
  end

  desc "Deleta todos os conteúdos, seus grãos, arquivos e dados armazenados no SAM"
  task :limpar => :environment do
    Conteudo.all.map(&:destroy)
  end

  desc "Deleta e recriar o índice do Elastic Search"
  task :recriar_indice => :environment do
    es = defined?(Rails) ? Rails.application.config.elasticsearch_config : {}
    es_host = es['host'] || 'localhost'
    es_port = es['port'] || '9200'

    Tire.configure do
      url "#{es_host}:#{es_port}"
    end
    [Arquivo, Conteudo].each { |tipo| tipo.tire.index.delete }
    Arquivo.tire.create_elasticsearch_index
    properties = {
      :id               => {:type => 'string', :index => :not_analyzed},
      :titulo           => { type: 'string' },
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
  end
end
