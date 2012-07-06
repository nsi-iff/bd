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
    scenario 'visualizar grao' do
      sam = ServiceRegistry.sam
      conteudo_odt = Base64.encode64(File.open('spec/resources/grao_tabela.odt').read)
      result = sam.store(file: conteudo_odt, filename: 'grao.odt')

      conteudo = create(:artigo_de_periodico, titulo: "Testando visualização de tabelas")
      grao = create(:grao, tipo: 'files', conteudo: conteudo, key: result['key'])
      visit grao_path(grao)

      page.should have_content 'Tabela originada da página X do conteúdo'
      page.should have_content "Testando visualização de tabelas"
      page.should have_content "Download"
    end
    scenario 'efetuar download do grao' do
      sam = ServiceRegistry.sam
      conteudo_odt = Base64.encode64(File.open('spec/resources/grao_tabela.odt').read)
      result = sam.store(file: conteudo_odt, filename: 'grao.odt')

      conteudo = create(:artigo_de_periodico, titulo: "Testando visualização de tabelas")
      grao = create(:grao, tipo: 'files', conteudo: conteudo, key: result['key'])

      visit grao_path(grao)
      
      click_link 'Download'
      grao_baixado = "#{Rails.root}/tmp/#{grao.titulo}.odt"
      grao_postado = "#{Rails.root}/spec/resources/grao_tabela.odt"
      comparar_odt('//office:text', grao_baixado, grao_postado)
      File.delete('myfile.xml') if File.exists?('myfile.xml')
    end
  end
end
   
