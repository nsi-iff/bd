# encoding: utf-8

require 'spec_helper'

feature 'adicionar objeto de aprendizagem' do
  scenario 'padrão', javascript: true do
    Idioma.create! descricao: 'Português (Brasil)'
    popular_eixos_tematicos_cursos
    submeter_conteudo :objeto_de_aprendizagem do
      fill_in 'Palavras-chave', with: 'programação, orientação a objetos, classe'
      fill_in 'Tempo de aprendizagem típico', with: '2 meses'
      select('Ambiente e Saúde', from: 'Eixos temáticos')
      select('Radiologia', from: 'Cursos')
      click_button '>'
      select('Saneamento Ambiental', from: 'Cursos')
      click_button '>'
      select('Oftálmica', from: 'Cursos')
      click_button '>'
      fill_in 'Novas tags', with: "Técnicas de programação\nOO\nTestes"
      select 'Português (Brasil)', on: 'Idioma'
    end

    validar_conteudo
    page.should have_content 'Palavras-chave: programação, orientação a objetos, classe'
    page.should have_content 'Tempo de aprendizagem típico: 2 meses'
    page.should have_content 'Eixos temáticos: Ambiente e Saúde'
    page.should have_content 'Cursos selecionados: Oftálmica, Radiologia e Saneamento Ambiental'
    page.should have_content 'Novas tags: Técnicas de programação, OO e Testes'
    page.should have_content 'Idioma: Português (Brasil)'
  end
end
