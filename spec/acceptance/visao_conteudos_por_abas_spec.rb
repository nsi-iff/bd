# encoding: utf-8

require 'spec_helper'

feature 'apresentacao dos conteudos por abas' do
  scenario 'visao de conteudo sem graos deve mostrar somente aba padrao' do
    criar_papeis
    autenticar_usuario(Papel.contribuidor)

    conteudo = Factory.create(:artigo_de_periodico)

    visit conteudo_path(conteudo)

    page.should have_content 'Metadados'
    page.should_not have_content 'Imagens'
    page.should_not have_content 'Tabelas'
  end

  scenario 'conteudo com grao imagem deve ter aba imagens com visualizacao da chave do grao' do
    criar_papeis
    autenticar_usuario(Papel.contribuidor)

    conteudo = Factory.create(:artigo_de_periodico)
    grao = Factory.create(:grao, tipo: 'images', conteudo: conteudo)

    visit conteudo_path(conteudo)

    page.should have_content 'Metadados'
    page.should have_content 'Imagens'
    page.should_not have_content 'Tabelas'

    click_link 'Imagens'
    page.should have_content grao.key
  end

  scenario 'conteudo com grao arquivo deve ter aba tabelas com visualizacao da chave do grao' do
    criar_papeis
    autenticar_usuario(Papel.contribuidor)

    conteudo = Factory.create(:artigo_de_periodico)
    grao = Factory.create(:grao, tipo: 'files', conteudo: conteudo)

    visit conteudo_path(conteudo)

    page.should have_content 'Metadados'
    page.should_not have_content 'Imagens'
    page.should have_content 'Tabelas'

    click_link 'Tabelas'
    page.should have_content grao.key
  end
end