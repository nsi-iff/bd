# encoding: utf-8

require 'spec_helper'

feature 'adicionar artigo de evento' do
  scenario 'padrao', :driver => :webkit do
    visit new_artigo_de_evento_path
    fill_in 'Título', with: 'A Proposal for Ruby Performance Improvements'
    fill_in 'Link', with: 'http://www.rubyconf.org/articles/1'
    fill_in 'Grande Área de Conhecimento', with: 'Ciência da Computação'
    fill_in 'Área de Conhecimento*', with: 'Linguagens de Programação'
    click_link 'Adicionar autor'
    fill_in 'Autor', with: 'Yukihiro Matsumoto'
    fill_in 'Curriculum Lattes', with: 'http://lattes.cnpq.br/1234567890'
    fill_in 'Campus da Instituição do Usuário', with: 'Campos Centro'
    fill_in 'Direitos', with: 'Direitos e esquerdos'
    fill_in 'Resumo', with: 'This work proposes an Ruby performance improvement'
    fill_in 'Subtítulo', with: 'Ruby Becomes The Flash'
    within_fieldset 'Dados do evento' do
      fill_in 'Nome', with: 'NSI Ruby Conf'
      fill_in 'Local', with: 'Campos dos Goytacazes, Rio de Janeiro, Brazil'
      fill_in 'Número', with: '1'
      fill_in 'Ano', with: '2012'
    end
    within_fieldset 'Publicação' do
      fill_in 'Editora', with: 'Essentia'
      fill_in 'Ano', with: '2013'
      fill_in 'Local', with: 'Campos dos Goytacazes (RJ)'
      fill_in 'Título dos anais', with: 'Proceedings of the 1st NSI Ruby Conf'
    end
    fill_in 'Página inicial do trabalho', with: '10'
    fill_in 'Página final do trabalho', with: '25'
    click_button 'Salvar'

    page.should have_content 'Título: A Proposal for Ruby Performance Improvements'
    page.should have_content 'Link: http://www.rubyconf.org/articles/1'
    page.should have_content 'Grande Área de Conhecimento: Ciência da Computação'
    page.should have_content 'Área de Conhecimento: Linguagens de Programação'
    page.should have_content 'Autor: Yukihiro Matsumoto'
    page.should have_content 'Curriculum Lattes: http://lattes.cnpq.br/1234567890'
    page.should have_content 'Campus: Campos Centro'
    page.should have_content 'Direitos: Direitos e esquerdos'
    page.should have_content 'Resumo: This work proposes an Ruby performance improvement'
    page.should have_content 'Subtítulo: Ruby Becomes The Flash'
    page.should have_content 'Página inicial do trabalho: 10'
    page.should have_content 'Página final do trabalho: 25'
    within_fieldset 'Dados do evento' do
      page.should have_content 'Nome: NSI Ruby Conf'
      page.should have_content 'Local: Campos dos Goytacazes, Rio de Janeiro, Brazil'
      page.should have_content 'Número: 1'
      page.should have_content 'Ano: 2012'
    end
    within_fieldset 'Publicação' do
     page.should have_content 'Editora: Essentia'
     page.should have_content 'Ano: 2013'
     page.should have_content 'Local: Campos dos Goytacazes (RJ)'
     page.should have_content 'Título dos anais: Proceedings of the 1st NSI Ruby Conf'
    end
  end
end
