# encoding: utf-8

require 'spec_helper'

feature 'adicionar trabalho de obtençao de grau' do
  scenario 'padrao' do
    popular_graus
    submeter_conteudo :trabalho_de_obtencao_de_grau do
      fill_in 'Subtítulo', with: 'Adicionando trabalho de obtenção de grau'
      fill_in 'Número de páginas', with: '20'
      fill_in 'Instituição', with: 'IFF'
      select 'Graduação', from: 'Grau'
      fill_in 'Data da Defesa', with: '02/10/2011'
      fill_in 'Local de Defesa', with: 'Campos dos Goytacazes (RJ)'
    end

    validar_conteudo
    page.should have_content 'Subtítulo: Adicionando trabalho de obtenção de grau'
    within_fieldset 'Dados do trabalho' do
      page.should have_content 'Número de páginas: 20'
      page.should have_content 'Instituição: IFF'
      page.should have_content 'Grau: Graduação'
    end
    within_fieldset 'Defesa' do
     page.should have_content 'Data da Defesa: 02/10/2011'
     page.should have_content 'Local de Defesa: Campos dos Goytacazes (RJ)'
    end
  end
end
