# encoding: utf-8

require 'spec_helper'

feature 'adicionar artigo de evento' do
  scenario 'padrao' do
    submeter_conteudo :artigo_de_evento do
      within_fieldset 'Dados Complementares' do
        fill_in 'Subtítulo', with: 'Ruby Becomes The Flash'
        fill_in 'Nome', with: 'NSI Ruby Conf'
        fill_in 'Local do Evento', with: 'Campos dos Goytacazes, Rio de Janeiro, Brazil'
        fill_in 'Número', with: '1'
        fill_in 'Ano do Evento', with: '2012'
        fill_in 'Editora', with: 'Essentia'
        fill_in 'Ano da Publicação', with: '2013'
        fill_in 'Local da Publicação', with: 'Campos dos Goytacazes (RJ)'
        fill_in 'Título dos anais', with: 'Proceedings of the 1st NSI Ruby Conf'
        fill_in 'Página inicial do trabalho', with: '10'
        fill_in 'Página final do trabalho', with: '25'
      end
    end

    validar_conteudo
    page.should have_content 'Subtítulo: Ruby Becomes The Flash'
    page.should have_content 'Página inicial do trabalho: 10'
    page.should have_content 'Página final do trabalho: 25'
    within_fieldset 'Dados do evento' do
      page.should have_content 'Nome: NSI Ruby Conf'
      page.should have_content 'Local: Campos dos Goytacazes, Rio de Janeiro, Brazil'
      page.should have_content 'Número: 1'
      page.should have_content 'Ano: 2012'
    end
    within_fieldset 'Publicação' do
     page.should have_content 'Editora: Essentia'
     page.should have_content 'Ano: 2013'
     page.should have_content 'Local: Campos dos Goytacazes (RJ)'
     page.should have_content 'Título dos anais: Proceedings of the 1st NSI Ruby Conf'
    end
  end

  scenario 'editar artigo de evento' do
    criar_papeis
    usuario = autenticar_usuario(Papel.contribuidor)

    visit edit_conteudo_path(FactoryGirl.create :artigo_de_evento,
                                                 campus: usuario.campus)
    fill_in 'Nome', with: 'artigo de evento editado'
    click_button 'Salvar'

    page.should have_content 'Nome: artigo de evento editado'
  end
end
