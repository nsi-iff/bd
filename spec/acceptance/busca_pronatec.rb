require 'spec_helper'

feature 'Busca PRONATEC', busca: true do
  scenario 'buscar pro conteudos com flag PRONTATEC=true' do
    Tire.criar_indices
    create(:pronatec, titulo: 'objeto pronatec')
    create(:objeto_de_aprendizagem, titulo: 'objeto aprendizagem')
    Conteudo.index.refresh
    visit root_path
    click_link 'Busca PRONATEC'
    fill_in 'busca', with: 'objeto pronatec'
    click_button 'Buscar'

    page.should have_content 'objeto pronatec'
    page.should_not have_content 'objeto aprendizagem'
  end
end
