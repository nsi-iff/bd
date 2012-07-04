# encoding: utf-8

require 'spec_helper'

feature 'buscar conteúdo por área' do
  scenario "buscar pela área de teste 1" do
    conteudo1 = create(:conteudo)
    visit root_path
    click_link conteudo1.sub_area.area.nome
    page.should have_content "Resultados da Busca — 1 itens correspondentes aos termos da busca"
    page.should have_content conteudo1.titulo
  end

  scenario "buscar pela área de teste 2" do
    conteudo2 = create(:conteudo)
    visit root_path
    click_link conteudo2.sub_area.area.nome
    page.should have_content conteudo2.titulo
  end

  scenario "mostra mensagem se não houver conteúdo" do
    sub_area = create(:sub_area)
    visit root_path
    click_link sub_area.area.nome
    page.should have_content 'Não há conteúdo para área selecionada.'
  end
end
