# encoding: utf-8

require 'spec_helper'

feature 'acessos anônimos' do
  scenario 'busca por imagem' do
    visit root_path
    click_link 'Busca por Imagem'
    page.should have_css "div.busca_por_imagem_form"
  end

  scenario 'ver conteúdo publicado' do
    Papel.criar_todos
    livro = create(:livro_publicado)
    visit conteudo_path(livro)
    page.should have_content 'Metadados'
    page.should_not have_content acesso_negado
  end
end
