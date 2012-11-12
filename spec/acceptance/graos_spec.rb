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

def adicionar_grao(options = {})
  tipo = options[:tipo] || 'imagem'
  arquivo = options[:arquivo] || 'grao_teste_1'
  extensao = tipo == 'tabela' ? 'odt' : 'jpg'
  tipo_grao = tipo == 'tabela' ? 'files' : 'images'
  sam = ServiceRegistry.sam
  conteudo_odt = Base64.encode64(File.open("spec/resources/#{arquivo}.#{extensao}").read)
  result = sam.store(file: conteudo_odt, filename: "grao.#{extensao}")

  conteudo = create(:artigo_de_periodico, titulo: "Testando visualização de grao #{options[:tipo]}")
  grao = create(:grao, tipo: tipo_grao, conteudo: conteudo, key: result.key)
end


feature 'Visualizar grão' do
  context 'tipo tabela' do
    scenario 'visualizar grao' do
      Papel.criar_todos
      user = autenticar_usuario(Papel.contribuidor)
      grao = adicionar_grao(tipo: 'tabela', arquivo: 'grao_tabela')
      visit grao_path(grao)

      page.should have_content 'Tabela originada da página X do conteúdo'
      page.should have_content "Testando visualização de grao tabela"
      page.should have_button  "Download"
      page.should have_button  "Adicionar à Cesta de Grãos"
      page.should have_button  "Adicionar à Estante"
    end
    
    scenario 'efetuar download do grao' do
      grao = adicionar_grao(tipo: 'tabela', arquivo: 'grao_tabela')
      visit grao_path(grao)

      click_button 'Download'
      grao_baixado = "#{Rails.root}/tmp/#{grao.titulo}.odt"
      grao_postado = "#{Rails.root}/spec/resources/grao_tabela.odt"
      comparar_odt('//office:text', grao_baixado, grao_postado)
      File.delete(grao_baixado)
    end
  end
  
  context 'tipo imagem' do
    scenario 'visualizar grao' do
      Papel.criar_todos
      user = autenticar_usuario(Papel.contribuidor)
      grao = adicionar_grao(tipo: 'imagem', arquivo: 'grao_teste_1')
      visit grao_path(grao)

      page.should have_content 'Imagem originada da página X do conteúdo'
      page.should have_content "Testando visualização de grao imagem"
      page.should have_button  "Download"
      page.should have_button  "Adicionar à Cesta de Grãos"
      page.should have_button  "Adicionar à Estante"
    end
    
    # scenario 'efetuar download do grao' do
    #   grao = adicionar_grao(tipo: 'imagem', arquivo: 'grao_teste_1')
    #   visit grao_path(grao)

    #   click_button 'Download'
    #   grao_baixado = "#{Rails.root}/tmp/#{grao.titulo}"
    #   grao_postado = "#{Rails.root}/spec/resources/grao_teste_1.jpg"
    #   FileUtils.compare_file(grao_postado, grao_baixado)
    #   File.delete(grao_baixado)
    # end
  end
  
  context 'e manipulação' do
    scenario 'adiciondo-o à cesta de grão' do
      Papel.criar_todos
      user = autenticar_usuario(Papel.contribuidor)

      grao = adicionar_grao
      visit grao_path(grao)

      click_button "Adicionar à Cesta de Grãos"
      grao.id.should == user.cesta[0].referenciavel_id
    end

    scenario 'adiciondo-o à estante do usuario' do
      Papel.criar_todos
      user = autenticar_usuario(Papel.contribuidor)

      grao = adicionar_grao
      visit grao_path(grao)

      click_button 'Adicionar à Estante'
      grao.id.should == user.estante[0].referenciavel_id
    end

    scenario 'se usuario anônimo não aparecer link para adicionar à estante' do
      grao = adicionar_grao
      visit grao_path(grao)

      page.should_not have_content "Adicionar à estante"
    end
  end
end
