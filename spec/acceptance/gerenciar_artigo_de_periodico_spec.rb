# encoding: utf-8

require 'spec_helper'

feature 'adicionar artigo de periódico' do
  scenario 'padrao' do
    submeter_conteudo :artigo_de_periodico do
      fill_in 'Subtítulo', with: 'Adicionando artigo de periódico'
      fill_in 'Nome', with: 'Nome teste do periódico'
      fill_in 'Editora', with: 'Essentia'
      fill_in 'Fascículo', with: 'Fascículo do periódico'
      fill_in 'Volume', with: '2'
      fill_in 'Data', with: '02/10/2011'
      fill_in 'Local', with: 'Campos dos Goytacazes (RJ)'
      fill_in 'Página inicial da publicação', with: '10'
      fill_in 'Página final da publicação', with: '25'
    end

    validar_conteudo
    page.should have_content 'Artigo de Periódico'
    page.should have_content 'Adicionando artigo de periódico'
    page.should have_content '10'
    page.should have_content '25'
    page.should have_content 'Nome teste do periódico'
    page.should have_content 'Essentia'
    page.should have_content 'Fascículo do periódico'
    page.should have_content '2'
    page.should have_content '02/10/2011'
    page.should have_content 'Campos dos Goytacazes (RJ)'
  end

  scenario 'editar artigo de periodico' do
    Papel.criar_todos
    usuario = autenticar_usuario(Papel.contribuidor)

    visit edit_conteudo_path(create :artigo_de_periodico, contribuidor: usuario)
    fill_in 'Nome', with: 'artigo de periodico editado'
    click_button 'Salvar'

    page.should have_content 'artigo de periodico editado'
  end
end
