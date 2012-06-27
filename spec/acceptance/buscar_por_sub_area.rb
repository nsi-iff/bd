require 'spec_helper'

feature 'buscar por subarea' do
  scenario 'buscar por subarea teste 1' do
    conteudo_1 = FactoryGirl.create(:conteudo)
    visit root_path
    click_link conteudo_1.sub_area.nome
    page.should have_content conteudo_1.titulo
  end

  scenario 'buscar por subarea teste 2' do
    conteudo_2 = FactoryGirl.create(:conteudo)
    visit root_path
    click_link conteudo_2.sub_area.nome
    page.should have_content conteudo_2.titulo
  end
end
