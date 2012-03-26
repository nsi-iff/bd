# encoding: utf-8

require 'spec_helper'

feature 'Minhas Buscas' do
  before(:each) do
    criar_papeis
    @usuario = autenticar_usuario(Papel.membro)
  end

  scenario 'salvar busca' do
    livro = Factory.create(:livro, titulo: 'My book')
    livro2 = Factory.create(:livro, titulo: 'Outro book')

    visit buscas_path
    fill_in 'Busca', with: 'book'
    click_button 'Buscar'
    click_link 'Salvar Busca'
    fill_in 'Título', with: 'Buscas book'
    fill_in 'Descriçao', with: 'Primeira busca'
    click_button 'Salvar'

    page.should have_content 'Busca salva com sucesso'
    page.should have_link 'My book'
    page.should have_link 'Outro book'
    visit root_path
    page.should have_link 'Buscas book'
  end

  scenario 'nenhum busca salva' do
    visit root_path
    within '#minhas_buscas' do
      page.should have_content 'Não há buscas salvas.'
    end
  end
end
