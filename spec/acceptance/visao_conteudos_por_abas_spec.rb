# encoding: utf-8

require 'spec_helper'
require 'base64'

feature 'apresentacao dos conteudos por abas' do
  scenario 'visao de conteudo sem graos deve mostrar somente aba padrao' do
    Papel.criar_todos
    autenticar_usuario(Papel.contribuidor)

    conteudo = create(:artigo_de_periodico)

    visit conteudo_path(conteudo)

    page.should have_content 'Metadados'
    page.should_not have_content 'Imagens'
    page.should_not have_content 'Tabelas'
  end

  scenario 'conteudo com grao imagem deve ter aba imagens com visualizacao das imagens' do
    Papel.criar_todos
    autenticar_usuario(Papel.contribuidor)

    sam = ServiceRegistry.sam

    #submeter imagem
    conteudo_imagem = Base64.encode64(File.open('spec/resources/tela.png').read)
    result = sam.store file: conteudo_imagem, filename: 'tela.png'

    conteudo = create(:artigo_de_periodico)
    grao = create(:grao, tipo: 'images', conteudo: conteudo, key: result['key'])

    visit conteudo_path(conteudo)

    page.should have_content 'Metadados'
    page.should have_content 'Imagens'
    page.should_not have_content 'Tabelas'

    click_link 'Imagens'

    parte_conteudo = grao.conteudo_base64[0..10]
    page.find("img[src*='#{parte_conteudo}']")

    sam.delete grao.key
  end

  scenario 'conteudo com grao arquivo deve ter aba tabelas com visualizacao das tabelas' do
    Papel.criar_todos
    autenticar_usuario(Papel.contribuidor)

    sam = ServiceRegistry.sam

    conteudo_odt = Base64.encode64(File.open('spec/resources/grao_tabela.odt').read)
    result = sam.store(file: conteudo_odt, filename: 'grao.odt')

    conteudo = create(:artigo_de_periodico)
    grao = create(:grao, tipo: 'files', conteudo: conteudo, key: result['key'])

    visit conteudo_path(conteudo)

    page.should have_content 'Metadados'
    page.should_not have_content 'Imagens'
    page.should have_content 'Tabelas'

    click_link 'Tabelas'
    ensure_table '.grao_imagem table',
      [%w(1 2 3),
       %w(4 5 6),
       %w(7 8 9)]
  end
end
