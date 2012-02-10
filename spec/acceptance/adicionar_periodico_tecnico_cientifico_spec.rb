# encoding: utf-8

require 'spec_helper'

feature 'adicionar periodico tecnico cientifico' do
  scenario 'padrao', :javascript => true do
    submeter_conteudo :periodico_tecnico_cientifico do
      within_fieldset 'Publicação' do
        fill_in 'Editora', with: 'Bookmam'
        fill_in 'Local', with: 'Campos dos Goytacazes'
      end
      fill_in 'Ano do primeiro volume', with: '2007'
      fill_in 'Ano do último volume', with: '2011'
    end

    validar_conteudo
    within_fieldset 'Publicação' do
      page.should have_content 'Editora: Bookmam'
      page.should have_content 'Local: Campos dos Goytacazes'
    end
    page.should have_content 'Ano do primeiro volume: 2007'
    page.should have_content 'Ano do último volume: 2011'
  end
end
