require 'spec_helper'

feature 'Busca PRONATEC' do
  scenario 'buscar pro conteudos com flag PRONTATEC=true' do
    prona = FactoryGirl.create(:pronatec, titulo: 'objeto pronatec')
    objeto = FactoryGirl.create(:objeto_de_aprendizagem, titulo: 'objeto aprendizagem')

    visit root_path
    click_link 'Busca PRONATEC'
    fill_in 'busca', with: 'objeto pronatec'
    click_button 'Buscar'

    page.should have_content 'objeto pronatec'
  end
end
