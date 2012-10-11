# encoding: utf-8

require 'spec_helper'

feature 'buscar conteúdo por área' do
  scenario "buscar pela área" do
    conteudo1 = create(:conteudo)
    conteudo2 = create(:conteudo)
    visit root_path
    click_link conteudo1.sub_area.area.nome
    page.should_not have_content conteudo1.titulo
    
    conteudo1.submeter!
    conteudo1.aprovar!
    
    visit root_path
    click_link conteudo1.sub_area.nome
    page.should have_content "Resultados da Busca — 1 itens correspondentes aos termos da busca"
    page.should have_content conteudo1.titulo
  end

  scenario "mostra mensagem se não houver conteúdo" do
    sub_area = create(:sub_area)
    visit root_path
    click_link sub_area.area.nome
    page.should have_content 'Não há conteúdo para área selecionada.'
  end
end
