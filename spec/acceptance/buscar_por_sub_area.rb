require 'spec_helper'

feature 'buscar por subarea' do
  scenario 'buscar por subarea' do
    conteudo1 = create(:conteudo)
    conteudo2 = create(:conteudo)
    visit root_path
    click_link conteudo1.sub_area.nome
    page.should_not have_content conteudo1.titulo
    page.should_not have_content conteudo2.titulo
    
    conteudo1.submeter!
    conteudo1.aprovar!
    
    visit root_path
    click_link conteudo1.sub_area.nome
    page.should have_content conteudo1.titulo
  end
end
