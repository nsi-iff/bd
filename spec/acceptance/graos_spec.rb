# encoding: utf-8

require 'spec_helper'

  def comparar_odt(tag, novo, grao)
    test = open_xml(grao).xpath(tag)
    tmp =  open_xml(novo).xpath(tag)
    test.children.count.should == tmp.children.count
  end

  def open_xml(file)
    doc = ZipFile.open(file)
    Nokogiri::XML(doc.read("content.xml"))
  end

feature 'Visualizar grão' do
  context 'tipo tabela' do
    def adicionar_grao
      sam = ServiceRegistry.sam
      conteudo_odt = Base64.encode64(File.open('spec/resources/grao_tabela.odt').read)
      result = sam.store(file: conteudo_odt, filename: 'grao.odt')

      conteudo = create(:artigo_de_periodico, titulo: "Testando visualização de tabelas")
      grao = create(:grao, tipo: 'files', conteudo: conteudo, key: result['key'])
    end
    scenario 'visualizar grao' do
      Papel.criar_todos
      user = autenticar_usuario(Papel.contribuidor)
      grao = adicionar_grao
      visit grao_path(grao)

      page.should have_content 'Tabela originada da página X do conteúdo'
      page.should have_content "Testando visualização de tabelas"
      page.should have_content "Download"
      page.should have_content "Adicionar à Cesta de Grãos"
      page.should have_content "Adicionar à Estante"
    end
    scenario 'efetuar download do grao' do
      grao = adicionar_grao
      visit grao_path(grao)

      click_link 'Download'
      grao_baixado = "#{Rails.root}/tmp/#{grao.titulo}.odt"
      grao_postado = "#{Rails.root}/spec/resources/grao_tabela.odt"
      comparar_odt('//office:text', grao_baixado, grao_postado)
      File.delete('myfile.xml') if File.exists?('myfile.xml')
    end
  end
  context 'tipo imagem' do
    def adicionar_grao
      sam = ServiceRegistry.sam
      conteudo_odt = Base64.encode64(File.open('spec/resources/grao_teste_1.jpg').read)
      result = sam.store(file: conteudo_odt, filename: 'grao.jpg')

      conteudo = create(:artigo_de_periodico, titulo: "Testando visualização de imagem")
      grao = create(:grao, tipo: 'images', conteudo: conteudo, key: result['key'])
    end
    scenario 'visualizar grao' do
      Papel.criar_todos
      user = autenticar_usuario(Papel.contribuidor)
      grao = adicionar_grao
      visit grao_path(grao)

      page.should have_content 'Imagem originada da página X do conteúdo'
      page.should have_content "Testando visualização de imagem"
      page.should have_content "Download"
      page.should have_content "Adicionar à Cesta de Grãos"
      page.should have_content "Adicionar à Estante"
    end
    scenario 'efetuar download do grao' do
      grao = adicionar_grao
      visit grao_path(grao)

      click_link 'Download'
      grao_baixado = "#{Rails.root}/tmp/#{grao.titulo}.jpg"
      grao_postado = "#{Rails.root}/spec/resources/grao_teste_1.jpg"
      FileUtils.compare_file(grao_postado, grao_baixado)
    end
  end
  context 'e manipulação' do
    def adicionar_grao
      sam = ServiceRegistry.sam
      conteudo_odt = Base64.encode64(File.open('spec/resources/grao_teste_1.jpg').read)
      result = sam.store(file: conteudo_odt, filename: 'grao.jpg')

      conteudo = create(:artigo_de_periodico, titulo: "Testando visualização de imagem")
      grao = create(:grao, tipo: 'images', conteudo: conteudo, key: result['key'])
    end

    scenario 'adiciondo-o à cesta de grão' do
      Papel.criar_todos
      user = autenticar_usuario(Papel.contribuidor)

      grao = adicionar_grao
      visit grao_path(grao)


      click_link "Adicionar à Cesta de Grãos"
      grao.id.should == user.cesta[0].referenciavel_id
    end

    scenario 'adiciondo-o à estante do usuario' do
      Papel.criar_todos
      user = autenticar_usuario(Papel.contribuidor)

      grao = adicionar_grao
      visit grao_path(grao)

      click_link 'Adicionar à Estante'
      grao.id.should == user.estante[0].referenciavel_id
    end

    scenario 'se usuario anônimo não aparecer link para adicionar à estante' do
      grao = adicionar_grao
      visit grao_path(grao)

      page.should_not have_content "Adicionar à estante"
    end

  end

end

