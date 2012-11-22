FactoryGirl.define do
  factory :autor do
    nome 'Jose das Couves'
  end

  factory :area do
    sequence(:nome) {|n| "Area#{n}" }
  end

  factory :sub_area do
    sequence(:nome) {|n| "Sub-area#{n}" }
    area
  end

  factory :conteudo do
    sequence(:titulo) {|n| "Conteudo interessante #{n}" }
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

  factory :grao_video, :parent => :grao, :class => Grao do
    tipo 'videos'
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

  ['artigo_de_evento', 'livro', 'relatorio', 'trabalho_de_obtencao_de_grau',
   'periodico_tecnico_cientifico', 'artigo_de_periodico', 'objeto_de_aprendizagem'].each do |tipo|
    factory "#{tipo}_editavel", parent: tipo

    factory("#{tipo}_pendente", parent: tipo) do
      after(:create) {|c| c.submeter! }
    end

    factory("#{tipo}_recolhido", parent: "#{tipo}_pendente") do
      after(:create) {|c| c.recolher! }
    end

    factory("#{tipo}_publicado", parent: "#{tipo}_pendente") do
      after(:create) {|c| c.aprovar! }
    end
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

  %w(contribuidor gestor admin instituicao_admin membro).each do |papel|
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
    thumbnail_key { rand.to_s.split('.')[1] }
    mime_type 'application/x-octet-stream'
  end

  factory :acesso do
    data "2012-03-27"
    quantidade 1
  end

  factory :referencia do
    abnt "abnt"
    referenciavel { create(:artigo_de_evento) }
  end

  factory :busca do
    busca "string"
    titulo "buscando"
    descricao "description"
    usuario
    mala_direta false
  end
end
