# encoding: utf-8

require 'spec_helper'

feature 'adicionar artigo de evento' do
  scenario 'padrao' do
    submeter_conteudo :artigo_de_evento do
      fill_in 'Subtítulo', with: 'Ruby Becomes The Flash'
      fill_in 'Nome', with: 'NSI Ruby Conf'
      fill_in 'Local do Evento', with: 'Campos dos Goytacazes, Rio de Janeiro, Brazil'
      fill_in 'Número', with: '1'
      fill_in 'Ano do Evento', with: '2012'
      fill_in 'Editora', with: 'Essentia'
      fill_in 'Ano da Publicação', with: '2012'
      fill_in 'Local da Publicação', with: 'Campos dos Goytacazes (RJ)'
      fill_in 'Título dos anais', with: 'Proceedings of the 1st NSI Ruby Conf'
      fill_in 'Página inicial do trabalho', with: '10'
      fill_in 'Página final do trabalho', with: '25'
    end
    validar_conteudo
    page.should have_content 'Artigo de Evento'
    page.should have_content 'Ruby Becomes The Flash'
    page.should have_content '10'
    page.should have_content '25'
    page.should have_content 'NSI Ruby Conf'
    page.should have_content 'Campos dos Goytacazes, Rio de Janeiro, Brazil'
    page.should have_content '1'
    page.should have_content '2012'
    page.should have_content 'Essentia'
    page.should have_content '2012'
    page.should have_content 'Campos dos Goytacazes (RJ)'
    page.should have_content 'Proceedings of the 1st NSI Ruby Conf'
  end

  scenario 'editar artigo de evento' do
    Papel.criar_todos
    usuario = autenticar_usuario(Papel.contribuidor)

    visit edit_conteudo_path(create :artigo_de_evento, contribuidor: usuario)
    fill_in 'Nome', with: 'artigo de evento editado'
    click_button 'Salvar'

    page.should have_content 'artigo de evento editado'
  end
end
