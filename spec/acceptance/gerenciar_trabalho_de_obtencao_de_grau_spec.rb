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
    page.should have_content 'Adicionando trabalho de obtenção de grau'
    page.should have_content '20'
    page.should have_content 'IFF'
    page.should have_content 'Graduação'
    page.should have_content '02/10/2011'
    page.should have_content 'Campos dos Goytacazes (RJ)'
  end

  scenario 'editar trabalho de obtenção de grau' do
    Papel.criar_todos
    usuario = autenticar_usuario(Papel.contribuidor)

    visit edit_conteudo_path(
      create :trabalho_de_obtencao_de_grau, contribuidor: usuario)
    fill_in 'Subtítulo', with: 'trabalho de obtenção de grau editado'
    click_button 'Salvar'

    page.should have_content 'trabalho de obtenção de grau editado'
  end
end
