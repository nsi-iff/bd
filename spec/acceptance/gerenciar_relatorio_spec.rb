# encoding: utf-8

require 'spec_helper'

feature 'adicionar relatório' do
  scenario 'padrao' do
    Papel.criar_todos
    autenticar_usuario(Papel.contribuidor)
    submeter_conteudo :relatorio do
      fill_in 'Local da publicação', with: 'Rio de Janeiro'
      fill_in 'Ano', with: '1998'
      fill_in 'Número de páginas', with: '427'
    end

    validar_conteudo
    page.should have_content 'Relatório'
    page.should have_content 'Rio de Janeiro'
    page.should have_content '1998'
    page.should have_content '427'
  end

  scenario 'editar relatorio' do
    Papel.criar_todos
    usuario = autenticar_usuario(Papel.contribuidor)

    visit edit_conteudo_path(create :relatorio, contribuidor: usuario)
    fill_in 'Local da publicação', with: 'relatório editado'
    click_button 'Salvar'

    page.should have_content 'relatório editado'
  end
end
