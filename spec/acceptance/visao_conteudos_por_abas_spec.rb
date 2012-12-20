# encoding: utf-8

require 'spec_helper'
require 'base64'

feature 'apresentacao dos conteudos por abas' do
  before :each do
    Papel.criar_todos
    @usuario = autenticar_usuario(Papel.contribuidor)
  end

  scenario 'visao de conteudo sem graos deve mostrar somente aba padrao' do
    conteudo = create(:artigo_de_periodico, contribuidor: @usuario)

    visit conteudo_path(conteudo)

    page.should have_content 'Metadados'
    page.should_not have_content 'Imagens'
    page.should_not have_content 'Tabelas'
  end

  scenario 'conteudo com grao imagem deve ter aba imagens com visualizacao das imagens' do
    sam = ServiceRegistry.sam

    #submeter imagem
    conteudo_imagem = Base64.encode64(File.open('spec/resources/tela.png').read)
    result = sam.store file: conteudo_imagem, filename: 'tela.png'

    conteudo = create(:artigo_de_periodico, contribuidor: @usuario)
    grao = create(:grao, tipo: 'images', conteudo: conteudo, key: result.key)

    visit conteudo_path(conteudo)

    page.should have_content 'Metadados'
    page.should have_content 'Imagens'
    page.should_not have_content 'Tabelas'

    click_link 'Imagens'

    parte_conteudo = grao.conteudo_base64[0..10]
    page.find("img[src]")

    sam.delete grao.key
  end

  scenario 'conteudo com grao arquivo deve ter aba tabelas com visualizacao das tabelas' do
    sam = ServiceRegistry.sam

    conteudo_odt = Base64.encode64(File.open('spec/resources/grao_tabela.odt').read)
    result = sam.store(file: conteudo_odt, filename: 'grao.odt')

    conteudo = create(:artigo_de_periodico, contribuidor: @usuario)
    grao = create(:grao, tipo: 'files', conteudo: conteudo, key: result.key)

    visit conteudo_path(conteudo)

    page.should have_content 'Metadados'
    page.should_not have_content 'Imagens'
    page.should have_content 'Tabelas'

    click_link 'Tabelas'
    ensure_table '.grao_arquivo table',
      [%w(1 2 3),
       %w(4 5 6),
       %w(7 8 9)]
  end

  scenario 'imagens inseridas em tabelas devem ser mostradas' do
    sam = ServiceRegistry.sam

    conteudo_odt = Base64.encode64(File.open('spec/resources/imagem_em_tabela.odt').read)
    result = sam.store(file: conteudo_odt, filename: 'grao.odt')

    conteudo = create(:artigo_de_periodico, contribuidor: @usuario)
    grao = create(:grao, tipo: 'files', conteudo: conteudo, key: result.key)
    imagem = IO.read("#{Rails.root}/spec/resources/biblioteca_digital.png")

    visit conteudo_path(conteudo)

    page.should have_content 'Metadados'
    page.should_not have_content 'Imagens'
    page.should have_content 'Tabelas'

    click_link 'Tabelas'
    page.should have_xpath("//img[@src]")
    page.should_not have_content 'Pictures'
  end
end
