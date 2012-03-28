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
    campus 'Campos-Centro'
    autores { [Factory.create(:autor)] }
    link 'http://something.com'
  end

  factory :grau do
    sequence(:nome) {|n| "Nome#{n}"}
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
    grau { Factory.create(:grau) }
  end

  factory :periodico_tecnico_cientifico, :parent => :conteudo, :class => PeriodicoTecnicoCientifico do
  end

  factory :artigo_de_periodico, :parent => :conteudo, :class => ArtigoDePeriodico do
  end

  factory :objeto_de_aprendizagem, :parent => :conteudo, :class => ObjetoDeAprendizagem do
  end

  factory :usuario do
    sequence(:email) {|n| "usuario%s@gmail.com" % n }
    password '12345678'
    password_confirmation '12345678'
    nome_completo 'Linus Torvalds'
    instituicao 'iff'
    campus 'centro'
  end

  factory :papel do
    sequence(:nome) {|n| "papel#{n}" }
    descricao 'um papel'
  end

  %w(contribuidor gestor admin).each do |papel|
    factory "usuario_#{papel}".to_sym, :parent => :usuario do
      after_create do |u|
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
    nome 'any name'
    key { rand.to_s.split('.')[1] }
  end
end

