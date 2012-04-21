# encoding: utf-8

require 'spec_helper'

feature 'adicionar objeto de aprendizagem', driver: :webkit do
  scenario 'selecionar um curso de um eixo', js: true do
    Capybara.current_driver = :webkit
    Idioma.create! descricao: 'Português (Brasil)'
    popular_eixos_tematicos_cursos
    popular_area_sub_area
  end

  scenario 'selecionar um curso de um eixo', javascript: true do
    submeter_conteudo :objeto_de_aprendizagem do
      fill_in 'Palavras-chave', with: 'programação, orientação a objetos, classe'
      fill_in 'Tempo de aprendizagem típico', with: '2 meses'

      select('Ambiente e Saúde', from: 'Eixos temáticos')
      select('Radiologia', from: 'Cursos')
      click_button '>'

      fill_in 'Novas tags', with: "Técnicas de programação\nOO\nTestes"
      select 'Português (Brasil)', on: 'Idioma'
    end

    validar_conteudo
    page.should have_content 'Palavras-chave: programação, orientação a objetos, classe'
    page.should have_content 'Tempo de aprendizagem típico: 2 meses'
    page.should have_content 'Eixos temáticos: Ambiente e Saúde'
    page.should have_content 'Cursos selecionados: Radiologia'
    page.should have_content 'Novas tags: Técnicas de programação, OO e Testes'
    page.should have_content 'Idioma: Português (Brasil)'
  end

  scenario 'selecionar um curso de um eixo', javascript: true do
    submeter_conteudo :objeto_de_aprendizagem do
      fill_in 'Palavras-chave', with: 'programação, orientação a objetos, classe'
      fill_in 'Tempo de aprendizagem típico', with: '2 meses'

      select('Ambiente e Saúde', from: 'Eixos temáticos')
      select('Radiologia', from: 'Cursos')
      click_button '>'

      fill_in 'Novas tags', with: "Técnicas de programação\nOO\nTestes"
      select 'Português (Brasil)', on: 'Idioma'
    end

    validar_conteudo
    page.should have_content 'Palavras-chave: programação, orientação a objetos, classe'
    page.should have_content 'Tempo de aprendizagem típico: 2 meses'
    page.should have_content 'Eixos temáticos: Ambiente e Saúde'
    page.should have_content 'Cursos selecionados: Radiologia'
    page.should have_content 'Novas tags: Técnicas de programação, OO e Testes'
    page.should have_content 'Idioma: Português (Brasil)'
  end

  scenario 'selecionar dois cursos de um mesmo eixo', js: true do
    submeter_conteudo :objeto_de_aprendizagem do
      fill_in 'Palavras-chave', with: 'programação, orientação a objetos, classe'
      fill_in 'Tempo de aprendizagem típico', with: '2 meses'

      select('Ambiente e Saúde', from: 'Eixos temáticos')
      select('Radiologia', from: 'Cursos')
      click_button '>'
      select('Saneamento Ambiental', from: 'Cursos')
      click_button '>'

      fill_in 'Novas tags', with: "Técnicas de programação\nOO\nTestes"
      select 'Português (Brasil)', on: 'Idioma'
    end

    validar_conteudo
    page.should have_content 'Palavras-chave: programação, orientação a objetos, classe'
    page.should have_content 'Tempo de aprendizagem típico: 2 meses'
    page.should have_content 'Eixos temáticos: Ambiente e Saúde'
    page.should have_content 'Cursos selecionados: Radiologia e Saneamento Ambiental'
    page.should have_content 'Novas tags: Técnicas de programação, OO e Testes'
    page.should have_content 'Idioma: Português (Brasil)'
  end

  scenario 'selecionar diversos cursos de eixos diferentes', js: true do
    submeter_conteudo :objeto_de_aprendizagem do
      fill_in 'Palavras-chave', with: 'programação, orientação a objetos, classe'
      fill_in 'Tempo de aprendizagem típico', with: '2 meses'

      select('Ambiente e Saúde', from: 'Eixos temáticos')
      select('Radiologia', from: 'Cursos')
      click_button '>'
      select('Gestão Ambiental', from: 'Cursos')
      click_button '>'

      select('Militar', from: 'Eixos temáticos')
      select('Fotointeligência', from: 'Cursos')
      click_button '>'
      select('Sistemas de Armas', from: 'Cursos')
      click_button '>'

      fill_in 'Novas tags', with: "Técnicas de programação\nOO\nTestes"
      select 'Português (Brasil)', on: 'Idioma'
    end
    validar_conteudo
    page.should have_content 'Palavras-chave: programação, orientação a objetos, classe'
    page.should have_content 'Tempo de aprendizagem típico: 2 meses'
    page.should have_content 'Eixos temáticos: Ambiente e Saúde e Militar'
    page.should have_content 'Cursos selecionados: Fotointeligência, Gestão Ambiental, Radiologia e Sistemas de Armas'
    page.should have_content 'Novas tags: Técnicas de programação, OO e Testes'
    page.should have_content 'Idioma: Português (Brasil)'
  end

  # TODO: Fazer esse teste funcionar
  #scenario 'editar objeto de aprendizagem' do
  #  criar_papeis
  #  autenticar_usuario(Papel.contribuidor)

  #  visit edit_conteudo_path(Factory.create :objeto_de_aprendizagem)
  #  fill_in 'Palavras-chave', with: 'palavras chave editadas'
  #  click_button 'Salvar'

  #  page.should have_content 'Palavras-chave: palavras chave editadas'
  #end
end
