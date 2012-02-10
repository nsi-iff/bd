# encoding: utf-8

require 'spec_helper'

feature 'adicionar artigo de periódico' do
  scenario 'padrao', :javascript => true do
    submeter_conteudo :artigo_de_periodico do
      fill_in 'Subtítulo', with: 'Adicionando artigo de periódico'
      within_fieldset 'Dados do periódico' do
        fill_in 'Nome', with: 'Nome teste do periódico'
      end
      within_fieldset 'Publicação' do
        fill_in 'Editora', with: 'Essentia'
        fill_in 'Fascículo', with: 'Fascículo do periódico'
        fill_in 'Volume', with: '2'
        fill_in 'Data', with: '02/10/2011'
        fill_in 'Local', with: 'Campos dos Goytacazes (RJ)'
      end
      fill_in 'Página inicial da publicação', with: '10'
      fill_in 'Página final da publicação', with: '25'
    end

    validar_conteudo
    page.should have_content 'Subtítulo: Adicionando artigo de periódico'
    page.should have_content 'Página inicial da publicação: 10'
    page.should have_content 'Página final da publicação: 25'
    within_fieldset 'Dados do periódico' do
      page.should have_content 'Nome: Nome teste do periódico'
    end
    within_fieldset 'Publicação' do
     page.should have_content 'Editora: Essentia'
     page.should have_content 'Fascículo: Fascículo do periódico'
     page.should have_content 'Volume: 2'
     page.should have_content 'Data: 02/10/2011'
     page.should have_content 'Local: Campos dos Goytacazes (RJ)'
    end
  end
end
