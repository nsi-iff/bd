# encoding: utf-8

require 'spec_helper'

feature 'adicionar objeto de aprendizagem' do
  scenario 'padrão', :javascript => true do
    Idioma.create! descricao: 'Português (Brasil)'
    %w(Algoritmos Objetos POO).each {|tema| EixoTematico.create! nome: tema }
    submeter_conteudo :objeto_de_aprendizagem do
      save_and_open_page
      fill_in 'Palavras-chave', with: 'programação, orientação a objetos, classe'
      fill_in 'Tempo de aprendizagem típico', with: '2 meses'
      select 'Objetos', on: 'Eixos temáticos'
      select 'POO', on: 'Eixos temáticos'
      fill_in 'Novas tags', with: "Técnicas de programação\nOO\nTestes"
      select 'Português (Brasil)', on: 'Idioma'
    end

    validar_conteudo
    page.should have_content 'Palavras-chave: programação, orientação a objetos, classe'
    page.should have_content 'Tempo de aprendizagem típico: 2 meses'
    page.should have_content 'Eixos temáticos: Objetos e POO'
    page.should have_content 'Novas tags: Técnicas de programação, OO e Testes'
    page.should have_content 'Idioma: Português (Brasil)'
  end
end
