# encoding: utf-8

require 'spec_helper'

feature 'cesta de grãos' do

  unless ENV['INTEGRACAO_TIRE']
    before :all do
      # monkeypatch temporario para passar no teste sem o Elastic Search
      # TODO: remover depois que funcionarem buscas básicas com o ES fake

      class << Conteudo
        alias old_search search
        def search(param)
          where('upper(titulo) like ?', "%#{param.to_s.upcase}%")
        end
      end
    end

    after :all do
      class << Conteudo
        alias search old_search
      end
    end
  end

  before(:each) do
    Tire.criar_indices if ENV['INTEGRACAO_TIRE']
    @livro = create(:livro, titulo: 'Quantum Mechanics for Dummies')
    @grao1 = create(:grao_imagem, key: '12345', conteudo: @livro)
    @grao2 = create(:grao_arquivo, key: '67890', conteudo: @livro)
    Conteudo.tire.index.refresh if ENV['INTEGRACAO_TIRE']
  end

  def incluir_grao_na_cesta
    visit root_path
    fill_in "Busca", with: 'Mechanics'
    click_button "Buscar"

    within item_de_busca(resultado: 1, grao: 1) do
      click_link 'Adicionar à cesta'
    end
    within('#cesta') { page.should have_content representacao_grao(@grao1) }

    visit root_path
    fill_in "Busca", with: 'for Dummies'
    click_button "Buscar"

    within item_de_busca(resultado: 1, grao: 2) do
      click_link 'Adicionar à cesta'
    end

    within item_da_cesta(2) do
      page.should have_content representacao_grao(@grao2)
    end
  end

  def excluir_grao_da_cesta
    visit root_path
    fill_in "Busca", with: 'Mechanics'
    click_button "Buscar"

    within item_de_busca(resultado: 1, grao: 1) do
      click_link 'Adicionar à cesta'
      sleep(1)
    end
    within item_de_busca(resultado: 1, grao: 2) do
      click_link 'Adicionar à cesta'
    end
    #TODO: melhorar o meio de esperar o "javascript trabalhar" (2012-04-19, 14:56, ciberglo)`
    sleep(1) # esperar o javascript trabalhar

    visit root_path
    within '#cesta' do
      page.should have_content representacao_grao(@grao1)
      page.should have_content representacao_grao(@grao2)
    end

    within item_da_cesta(1) do
      page.should have_content representacao_grao(@grao1)
      click_link 'Remover'
    end
    within '#cesta' do
      page.should_not have_content representacao_grao(@grao1)
      page.should have_content representacao_grao(@grao2)
    end

    within '#cesta'  do
      click_link 'Remover'
    end
    within '#cesta' do
      page.should_not have_content representacao_grao(@grao1)
      page.should_not have_content representacao_grao(@grao2)
    end
  end

  def acessar_visao_da_cesta
    incluir_grao_na_cesta
    within('#cesta') { click_link 'Ver todos' }
    within '#visao_cesta' do
      page.should have_content representacao_grao(@grao1)
      page.should have_content representacao_grao(@grao2)
    end
  end

  def comparar_odt(tag, novo, grao)
    test = open_xml(grao).xpath(tag)
    tmp =  open_xml(novo).xpath(tag)
    test.children.count.should == tmp.children.count
  end

  def open_xml(file)
    doc = ZipFile.open(file)
    Nokogiri::XML(doc.read("content.xml"))
  end

  context 'usuário anônimo' do
    scenario 'incluir grão na cesta', js: true do
      incluir_grao_na_cesta
    end

    scenario 'excluir grão da cesta', js: true do
      excluir_grao_da_cesta
    end

    scenario 'cesta é zerada em nova sessão', js: true do
      incluir_grao_na_cesta
      page.should have_selector '#cesta #items'
      autenticar_usuario
      deslogar
      page.should_not have_selector '#cesta #items'
    end

    scenario 'acessar visão da cesta', js: true do
      acessar_visao_da_cesta
    end
  end

  context 'usuário logado' do
    before :each do
      Papel.criar_todos
      @usuario = autenticar_usuario(Papel.membro)
    end

    scenario 'incluir grão na cesta', js: true do
      incluir_grao_na_cesta
    end

    scenario 'excluir grão da cesta', js: true do
      excluir_grao_da_cesta
    end

    scenario 'cesta sobrevive de uma sessão para outra', js: true do
      incluir_grao_na_cesta
      within '#cesta' do
        [@grao1, @grao2].each {|g|
          page.should have_content representacao_grao(g)
        }
      end
      deslogar
      page.should_not have_selector '#cesta #items'
      autenticar(@usuario)
      within '#cesta' do
        [@grao1, @grao2].each {|g|
          page.should have_content representacao_grao(g)
        }
      end
    end

    scenario 'acessar visão da cesta', js: true do
      acessar_visao_da_cesta
    end

    scenario 'editar grão da cesta' do
      criar_cesta @usuario, create(:livro),
                            recurso('grao_teste_0.jpg'),
                            recurso('grao_teste_1.jpg'),
                            recurso('grao_tabela.odt')
      visit root_path
      within('#cesta') { click_link 'Editar' }
      within '#documento' do
        page.should have_selector "img[src^='data:image/xyz;base64']"
        ensure_table 'table',
          [%w(1 2 3),
           %w(4 5 6),
           %w(7 8 9)]
      end
    end

    scenario 'baixar conteudo da cesta', js: true do
      # TODO: consertar bug na geração da referência ABNT do livro
      Livro.any_instance.stub(:referencia_abnt).and_return("Referências ABNT")
      criar_cesta(@usuario, @livro, *%w(./spec/resources/tabela.odt))
      visit root_path
      click_link 'baixar conteudo da cesta'
      Zip::ZipFile.open(Dir["#{Rails.root}/tmp/cesta_tempo*"].last) { |zip_file|
        zip_file.each { |f|
          f_path=File.join("#{Rails.root}/spec/resources/downloads/", f.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(f, f_path) unless File.exist?(f_path)
        }
      }

      grao_armazenado = Digest::MD5.hexdigest(File.read('./spec/resources/tabela.odt'))
      grao_extraido = Digest::MD5.hexdigest(File.read("#{Rails.root}/spec/resources/downloads/grao_quantum_mechanics_for_dummies_0.odt"))
      grao_armazenado.should == grao_extraido
      referencia_abnt = File.read("#{Rails.root}/spec/resources/downloads/referencias_ABNT.txt")
      referencia_abnt.should match "grao_quantum_mechanics_for_dummies_0.odt: #{@livro.referencia_abnt}"
    end

    scenario 'baixar conteudo da cesta em odt', js: true do
      # TODO: consertar bug na geração da referência ABNT do livro
      Livro.any_instance.stub(:referencia_abnt).and_return("Referências ABNT")
      criar_cesta(@usuario, @livro, *%w(./spec/resources/tabela.odt
                                        ./spec/resources/biblioteca_digital.png
                                        ./spec/resources/grao_teste_0.jpg))
      visit root_path
      click_link 'baixar conteudo da cesta em odt'
      grao_armazenado = "./spec/resources/tabela_e_imagens.odt"
      grao_baixado = "tmp/graos.odt"
      File.delete('myfile.xml') if File.exists?('myfile.xml')
      comparar_odt('//office:text', grao_baixado, grao_armazenado)

      odt = Zip::ZipFile.open('tmp/graos.odt')
      doc = Document.new(odt.read("content.xml"))
      arquivo_odt = doc.to_s
      arquivo_odt.should match "Referências ABNT"
    end
  end
end
