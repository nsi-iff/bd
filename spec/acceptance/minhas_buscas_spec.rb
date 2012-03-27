# encoding: utf-8

require 'spec_helper'

feature 'Minhas Buscas' do
  before(:all) do
    require Rails.root + 'db/criar_indices'
    criar_papeis
  end

  scenario 'salvar busca' do
    usuario = autenticar_usuario(Papel.membro)
    livro = Factory.create(:livro, titulo: 'My book')
    livro2 = Factory.create(:livro, titulo: 'Outro book')
    sleep(3) if ENV['INTEGRACAO'] # espera indexar
    visit "/buscas"
    fill_in 'Busca', with: 'book'
    click_button 'Buscar'
    click_link 'Salvar Busca'
    fill_in 'Título', with: 'Buscas book'
    fill_in 'Descriçao', with: 'Primeira busca'
    click_button 'Salvar'

    page.should have_content 'Busca salva com sucesso'
    page.should have_content 'Outro book'
    page.should have_content 'My book'
    visit root_path
    page.should have_link 'Buscas book'
  end

  scenario 'nenhuma busca salva' do
    usuario = autenticar_usuario(Papel.membro)
    visit root_path
    within '#minhas_buscas' do
      page.should have_content 'Não há buscas salvas.'
    end
  end

  scenario 'usuario não autenticado não pode salvar buscas' do
    visit buscas_path
    page.should_not have_content "Salvar Busca"
  end
end
