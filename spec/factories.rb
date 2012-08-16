FactoryGirl.define do
  factory :autor do
    nome 'Jose das Couves'
  end

  factory :area do
    sequence(:nome) {|n| "Nome#{n}" }
  end

  factory :sub_area do
    sequence(:nome) {|n| "Nome#{n}" }
    area
  end

  factory :conteudo do
    titulo "Conteudo interessante"
    sub_area
    campus
    autores { [create(:autor)] }
    link 'http://something.com'
  end

  factory :grau do
    sequence(:nome) {|n| "Nome#{n}"}
  end

  factory :grao do
    tipo "images"
    key "key"
    association :conteudo, factory: :relatorio
  end

  factory :grao_imagem, :parent => :grao, :class => Grao do
    tipo 'images'
  end

  factory :grao_arquivo, :parent => :grao, :class => Grao do
    tipo 'files'
  end

  factory :pronatec, parent: :conteudo, class: ObjetoDeAprendizagem do
    pronatec true
  end

  factory :livro, :parent => :conteudo, :class => Livro do
    numero_paginas 200
    numero_edicao 1
  end

  factory :artigo_de_evento, :parent => :conteudo, :class => ArtigoDeEvento do
  end

  factory :relatorio, :parent => :conteudo, :class => Relatorio do
  end

  factory :trabalho_de_obtencao_de_grau, :parent => :conteudo, :class => TrabalhoDeObtencaoDeGrau do
    grau { create(:grau) }
  end

  factory :periodico_tecnico_cientifico, :parent => :conteudo, :class => PeriodicoTecnicoCientifico do
  end

  factory :artigo_de_periodico, :parent => :conteudo, :class => ArtigoDePeriodico do
  end

  factory :objeto_de_aprendizagem, :parent => :conteudo, :class => ObjetoDeAprendizagem do
  end

  factory :livro_recolhido, parent: :livro do
    after(:create) do |livro|
      livro.submeter!
      livro.recolher!
    end
  end

  factory :livro_publicado, parent: :livro do
    after(:create) do |livro|
      livro.submeter!
      livro.aprovar!
    end
  end

  factory :artigo_de_evento_pendente, parent: :artigo_de_evento do
    after(:create) {|artigo| artigo.submeter! }
  end
  
  factory :relatorio_pendente, parent: :relatorio do
    after(:create) {|relatorio| relatorio.submeter! }
  end

  factory :instituicao do
    sequence(:nome) {|n| "Nome#{n}"}
  end

  factory :campus do
    sequence(:nome) {|n| "Nome#{n}"}
    instituicao
  end

  factory :usuario do
    sequence(:email) {|n| "usuario%s@gmail.com" % n }
    password '12345678'
    password_confirmation '12345678'
    nome_completo 'Linus Torvalds'
    confirmed_at Time.now
    campus
  end

  factory :papel do
    sequence(:nome) {|n| "papel#{n}" }
    descricao 'um papel'
  end

  %w(contribuidor gestor admin instituicao_admin).each do |papel|
    factory "usuario_#{papel}".to_sym, :parent => :usuario do
      after :create do |u|
        hash = { nome: papel }
        u.papeis = [Papel.where(hash).first || Papel.create!(hash)]
        u.save!
      end
    end

    factory "papel_#{papel}".to_sym, :parent => :papel do
      nome papel
    end
  end

  factory :arquivo do
    nome 'arquivo.rtf'
    key { rand.to_s.split('.')[1] }
  end

  factory :acesso do
    data "2012-03-27"
    quantidade 1
  end

  factory :referencia do
    abnt "abnt"
    referenciavel { create(:artigo_de_evento) }
  end
end
