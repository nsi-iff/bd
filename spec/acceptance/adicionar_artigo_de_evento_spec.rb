# encoding: utf-8

require 'spec_helper'

feature 'adicionar artigo de evento' do
  scenario 'padrao', javascript: true do
    submeter_conteudo :artigo_de_evento do
      fill_in 'Subtítulo', with: 'Ruby Becomes The Flash'
      within_fieldset 'Dados do evento' do
        fill_in 'Nome', with: 'NSI Ruby Conf'
        fill_in 'Local', with: 'Campos dos Goytacazes, Rio de Janeiro, Brazil'
        fill_in 'Número', with: '1'
        fill_in 'Ano', with: '2012'
      end
      within_fieldset 'Publicação' do
        fill_in 'Editora', with: 'Essentia'
        fill_in 'Ano', with: '2013'
        fill_in 'Local', with: 'Campos dos Goytacazes (RJ)'
        fill_in 'Título dos anais', with: 'Proceedings of the 1st NSI Ruby Conf'
      end
      fill_in 'Página inicial do trabalho', with: '10'
      fill_in 'Página final do trabalho', with: '25'
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
end

