# encoding: utf-8

require 'spec_helper'

feature 'adicionar periodico tecnico cientifico' do
  scenario 'padrao' do
    submeter_conteudo :periodico_tecnico_cientifico do
      fill_in 'Editora', with: 'Bookmam'
      fill_in 'Local', with: 'Campos dos Goytacazes'
      fill_in 'Ano do primeiro volume', with: '2007'
      fill_in 'Ano do último volume', with: '2011'
    end

    validar_conteudo
    page.should have_content 'Bookmam'
    page.should have_content 'Campos dos Goytacazes'
    page.should have_content '2007'
    page.should have_content '2011'
  end

  scenario 'editar periodico técnico cientifico' do
    Papel.criar_todos
    usuario = autenticar_usuario(Papel.contribuidor)

    visit edit_conteudo_path(
      create :periodico_tecnico_cientifico, contribuidor: usuario)
    fill_in 'Editora', with: 'periodico tecnico cientifico editado'
    click_button 'Salvar'

    page.should have_content 'periodico tecnico cientifico editado'
  end
end
